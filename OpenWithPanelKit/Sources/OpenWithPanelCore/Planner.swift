import OpenWithPanelPlatform

public struct PlannedChange: Equatable, Sendable, Identifiable {
  public enum Method: Equatable, Sendable {
    case workspace
    case preferences
  }

  public var type: String
  // nil 只出现在 preferences：删除偏好条目，交回系统自己选
  public var bundleID: String?
  public var method: Method
  public var id: String { type }

  public init(type: String, bundleID: String?, method: Method) {
    self.type = type
    self.bundleID = bundleID
    self.method = method
  }
}

public enum Planner {
  // 实测这些类型用 NSWorkspace 设默认一律返回 -50，只能走偏好条目
  public static let lockedTypes: Set<String> = ["public.data", "public.content", "public.item"]
  static let webTypes: Set<String> = ["public.html", "public.xhtml"]

  public static func desiredHandlers(
    for configuration: Configuration, members: FamilyMembers = { family, _ in family.types }
  ) -> [String: String] {
    let helperTypes = configuration.helperTypes
    var desired: [String: String] = [:]
    for (type, bundleID) in configuration.effectiveAssignments(members: members) {
      desired[type] = helperTypes.contains(type) ? HelperIdentity.bundleID : bundleID
    }
    for type in helperTypes where desired[type] == nil {
      desired[type] = HelperIdentity.bundleID
    }
    for kind in LinkKinds.all {
      guard let bundleID = configuration.linkAssignments[kind.id] else { continue }
      for key in kind.keys { desired[key] = bundleID }
    }
    return desired
  }

  public static func plan(
    configuration: Configuration, previous: Configuration, current: Snapshot, initial: Snapshot,
    members: FamilyMembers = { family, _ in family.types }
  ) -> [PlannedChange] {
    let desired = desiredHandlers(for: configuration, members: members)
    let released = Set(desiredHandlers(for: previous, members: members).keys)
      .subtracting(desired.keys)
    var changes: [PlannedChange] = []

    for type in desired.keys.sorted() {
      if let change = change(type: type, to: desired[type], current: current) {
        changes.append(change)
      }
    }
    for type in released.sorted() {
      let target =
        lockedTypes.contains(type) ? initial.preferenceHandlers[type] : initial.handlers[type]
      if let change = change(type: type, to: target, current: current) {
        changes.append(change)
      }
    }
    return changes
  }

  public static func restore(to target: Snapshot, from current: Snapshot) -> [PlannedChange] {
    var changes: [PlannedChange] = []
    for type in Set(target.handlers.keys).union(current.handlers.keys).sorted() {
      let destination =
        lockedTypes.contains(type) ? target.preferenceHandlers[type] : target.handlers[type]
      if let change = change(type: type, to: destination, current: current) {
        changes.append(change)
      }
    }
    return changes
  }

  // 文件类型写偏好条目：macOS 26.4 起系统接口每改一个类型弹一次确认框，偏好条目一次写完、
  // 重启一次 lsd 就生效，不弹框。网址协议和网页文件走系统接口、照常弹确认框：
  // 不声不响改掉浏览器正是劫持浏览器的软件的做法，这类改动必须让用户在系统界面里亲自确认
  private static func change(type: String, to bundleID: String?, current: Snapshot)
    -> PlannedChange?
  {
    if lockedTypes.contains(type) {
      return sameBundle(current.preferenceHandlers[type], bundleID)
        ? nil : PlannedChange(type: type, bundleID: bundleID, method: .preferences)
    }
    // 普通类型的目标为空时保持现状，不删条目，免得落到系统随意选的 App 上
    guard let bundleID, !sameBundle(current.handlers[type], bundleID) else { return nil }
    return PlannedChange(type: type, bundleID: bundleID, method: method(for: type))
  }

  public static func method(for type: String) -> PlannedChange.Method {
    HandlerKey.schemeName(of: type) == nil && !webTypes.contains(type) ? .preferences : .workspace
  }
}

public struct SnapshotCapturer: Sendable {
  let launchServices: any LaunchServicesClient
  let preferences: any HandlerPreferencesStore

  public init(launchServices: any LaunchServicesClient, preferences: any HandlerPreferencesStore) {
    self.launchServices = launchServices
    self.preferences = preferences
  }

  public func capture(types: some Sequence<String>) -> Snapshot {
    var handlers: [String: String] = [:]
    for type in types {
      if let app = launchServices.defaultApp(forKey: type) { handlers[type] = app.bundleID }
    }
    let entries = preferences.contentTypeHandlers()
    var locked: [String: String] = [:]
    for type in Planner.lockedTypes {
      if let bundleID = entries[type.lowercased()] { locked[type] = bundleID }
    }
    return Snapshot(handlers: handlers, preferenceHandlers: locked)
  }

  public static func typeUniverse(installedApps: [InstalledApp], catalog: any TypeCatalog)
    -> Set<String>
  {
    var types = Set(TypeFamilies.all.flatMap(\.types))
    for app in installedApps {
      types.formUnion(app.declaredTypes)
      types.formUnion(app.declaredExtensions.compactMap(catalog.type(forExtension:)))
    }
    // 类型族按扩展名换算出的临时类型也要进快照，否则恢复时不知道它们原来由谁打开
    let familyMembers = TypeFamilies.all.flatMap {
      FamilyState.activeTypes(of: $0, catalog: catalog)
    }
    return types.filter(catalog.isDeclared).union(familyMembers).union(Planner.lockedTypes)
      .union(LinkKinds.allKeys)
  }
}

public struct ApplyResult: Equatable, Sendable {
  public var applied: [String] = []
  // 系统确认框里被用户拒绝，或被系统静默忽略：值是核对时实际的默认 App
  public var rejected: [String: String] = [:]
  public var failed: [String: String] = [:]

  public init() {}

  public var isComplete: Bool { rejected.isEmpty && failed.isEmpty }
}

public struct Applier: Sendable {
  let launchServices: any LaunchServicesClient
  let preferences: any HandlerPreferencesStore

  public init(launchServices: any LaunchServicesClient, preferences: any HandlerPreferencesStore) {
    self.launchServices = launchServices
    self.preferences = preferences
  }

  public func apply(_ changes: [PlannedChange]) async -> ApplyResult {
    var result = ApplyResult()
    // 偏好条目先写，系统接口后调：系统接口改过的关联 lsd 会晚些写回文件，先重启 lsd 就不会互相覆盖
    let preferenceChanges = changes.filter { $0.method == .preferences }
    var writeFailed = false
    if !preferenceChanges.isEmpty {
      do {
        for change in preferenceChanges {
          try preferences.setHandler(change.bundleID, forContentType: change.type)
        }
        try preferences.reloadLaunchServices()
      } catch {
        writeFailed = true
        for change in preferenceChanges where Planner.lockedTypes.contains(change.type) {
          result.failed[change.type] = String(describing: error)
        }
      }
    }

    // 偏好条目写不进或写了没生效的普通类型，改用系统接口再设一次，代价是弹确认框；
    // 被锁定的类型系统接口也设不了，没有这条退路
    let fallback = preferenceChanges.filter { change in
      guard let bundleID = change.bundleID, !Planner.lockedTypes.contains(change.type) else {
        return false
      }
      return writeFailed
        || !sameBundle(launchServices.defaultApp(forKey: change.type)?.bundleID, bundleID)
    }
    for change in changes.filter({ $0.method == .workspace }) + fallback {
      guard let bundleID = change.bundleID, let app = launchServices.app(bundleID: bundleID) else {
        result.failed[change.type] = "app not found: \(change.bundleID ?? "-")"
        continue
      }
      // 前一项可能已经连带改好这一项（比如系统改 http 时一并改了 https），再设一次只会多弹一次确认框
      if sameBundle(launchServices.defaultApp(forKey: change.type)?.bundleID, bundleID) {
        continue
      }
      do {
        try await launchServices.setDefault(app, forKey: change.type)
        result.failed[change.type] = nil
      } catch {
        result.failed[change.type] = String(describing: error)
      }
    }

    for change in changes where result.failed[change.type] == nil {
      guard let expected = change.bundleID else {
        result.applied.append(change.type)
        continue
      }
      let actual = launchServices.defaultApp(forKey: change.type)?.bundleID
      if sameBundle(actual, expected) {
        result.applied.append(change.type)
      } else {
        result.rejected[change.type] = actual ?? ""
      }
    }
    return result
  }
}
