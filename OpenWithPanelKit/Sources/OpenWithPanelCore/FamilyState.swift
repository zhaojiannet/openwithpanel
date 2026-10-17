import Foundation
import OpenWithPanelPlatform

public enum FamilySelection: Equatable, Sendable {
  case app(String)
  case mixed
  case none
}

public enum FamilyState {
  public static func activeTypes(
    of family: TypeFamily, catalog: any TypeCatalog, custom: [String] = []
  ) -> [String] {
    var seen = Set<String>()
    let declared = family.types.filter {
      catalog.isDeclared($0) || Planner.lockedTypes.contains($0)
    }
    let byExtension = (family.extensions + custom).compactMap(catalog.type(forExtension:))
    return (declared + byExtension).filter { seen.insert($0).inserted }
  }

  public static func normalizedExtension(_ input: String) -> String {
    input.trimmingCharacters(in: .whitespacesAndNewlines)
      .trimmingCharacters(in: CharacterSet(charactersIn: ".*"))
      .lowercased()
  }

  public static func suggestedFamily(
    forExtension ext: String, catalog: any TypeCatalog, members: (TypeFamily) -> [String]
  ) -> (family: TypeFamily, alreadyIncluded: Bool)? {
    guard !ext.isEmpty, let type = catalog.type(forExtension: ext) else { return nil }
    if let family = TypeFamilies.all.first(where: { members($0).contains(type) }) {
      return (family, true)
    }
    let byConformance: [(String, String)] = [
      ("public.source-code", "code"), ("public.script", "code"), ("public.image", "images"),
      ("public.movie", "video"), ("public.audio", "audio"), ("public.archive", "archives"),
      ("public.composite-content", "documents"), ("public.text", "text"),
    ]
    let id = byConformance.first { catalog.conforms(type, to: $0.0) }?.1 ?? "custom"
    return TypeFamilies.all.first { $0.id == id }.map { ($0, false) }
  }

  // 单独设过的格式不参与：它们代表的是例外，不是整组的 App
  public static func selection(
    of family: TypeFamily, types: [String], configuration: Configuration, current: Snapshot
  ) -> FamilySelection {
    if let bundleID = configuration.familyAssignments[family.id] {
      return .app(bundleID.lowercased())
    }
    return actual(types.filter { !configuration.isOverridden($0) }, current: current)
  }

  public static func selection(
    ofType type: String, in family: TypeFamily?, configuration: Configuration, current: Snapshot
  ) -> FamilySelection {
    if let bundleID = configuration.assignment(for: type, in: family) {
      return .app(bundleID.lowercased())
    }
    return actual([type], current: current)
  }

  public static func selection(
    ofLink kind: LinkKind, configuration: Configuration, current: Snapshot
  ) -> FamilySelection {
    if let bundleID = configuration.linkAssignments[kind.id] { return .app(bundleID.lowercased()) }
    return actual(kind.keys, current: current)
  }

  // 指向辅助程序的类型不算某个 App，辅助程序只做中转，真正的目标记在分配里
  private static func actual(_ types: [String], current: Snapshot) -> FamilySelection {
    let apps = Set(
      types.compactMap { type -> String? in
        guard let handler = current.handlers[type],
          handler.caseInsensitiveCompare(HelperIdentity.bundleID) != .orderedSame
        else { return nil }
        return handler.lowercased()
      })
    switch apps.count {
    case 0: return .none
    case 1: return .app(apps.first!)
    default: return .mixed
    }
  }
}

extension Array where Element == PlannedChange {
  // 只有工作区方式会触发系统确认框；偏好条目方式不弹框
  public var confirmationCount: Int { filter { $0.method == .workspace }.count }
}
