import Foundation

// bundle id 不能改：用户的关联按 bundle id 指向它，改了就指向一个不存在的 App
public enum HelperIdentity {
  public static let bundleID = "net.zhaojian.openwithpanel.helper"
  public static let displayName = "OpenWithPanel Helper"
  public static let appName = "OpenWithPanel Helper.app"
}

public enum BinaryAction: String, Codable, Sendable, CaseIterable {
  case revealInFinder
  case openWithTarget
  case handBackToSystem
}

public enum RouteTarget: Codable, Hashable, Sendable {
  case app(bundleID: String)
  case revealInFinder
  case system
}

public struct Rule: Codable, Hashable, Sendable, Identifiable {
  public var id: UUID
  public var name: String
  public var namePattern: String?
  public var pathPrefix: String?
  public var contentKind: ContentKind?
  public var contentTypes: [String]
  public var target: RouteTarget
  public var isEnabled: Bool

  public init(
    id: UUID = UUID(), name: String, namePattern: String? = nil, pathPrefix: String? = nil,
    contentKind: ContentKind? = nil, contentTypes: [String] = ["public.data"],
    target: RouteTarget, isEnabled: Bool = true
  ) {
    self.id = id
    self.name = name
    self.namePattern = namePattern
    self.pathPrefix = pathPrefix
    self.contentKind = contentKind
    self.contentTypes = contentTypes
    self.target = target
    self.isEnabled = isEnabled
  }

  public var hasConditions: Bool {
    namePattern?.isEmpty == false || pathPrefix?.isEmpty == false || contentKind != nil
  }
}

public struct FolderRule: Codable, Hashable, Sendable, Identifiable {
  public var id: UUID
  public var path: String
  public var targetBundleID: String
  public var isEnabled: Bool

  public init(id: UUID = UUID(), path: String, targetBundleID: String, isEnabled: Bool = true) {
    self.id = id
    self.path = path
    self.targetBundleID = targetBundleID
    self.isEnabled = isEnabled
  }
}

public struct Configuration: Codable, Equatable, Sendable {
  public static let defaultExclusions = [
    ".git", "node_modules", ".build", "DerivedData", "Pods", "vendor", ".venv", "__pycache__",
  ]

  public var version: Int = 1
  // 整组的默认 App：类型族 id → bundle id
  public var familyAssignments: [String: String] = [:]
  // 单独设置的格式：类型 → bundle id，优先于整组
  public var assignments: [String: String] = [:]
  // 用户自己添加的扩展名：类型族 id → 扩展名（不带点、小写）
  public var customExtensions: [String: [String]] = [:]
  // 链接的默认 App：链接类别 id → bundle id
  public var linkAssignments: [String: String] = [:]
  public var rules: [Rule] = []
  public var binaryAction: BinaryAction = .revealInFinder
  // 辅助程序遇到「交还系统」时用的 App，取自初始快照，应用时写入
  public var fallbacks: [String: String] = [:]
  public var folderRules: [FolderRule] = []
  public var folderExclusions: [String] = Configuration.defaultExclusions

  public init() {}

  // 预设和手改的配置文件不一定写全，缺的字段一律取默认值
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 1
    familyAssignments =
      try container.decodeIfPresent([String: String].self, forKey: .familyAssignments) ?? [:]
    assignments = try container.decodeIfPresent([String: String].self, forKey: .assignments) ?? [:]
    customExtensions =
      try container.decodeIfPresent([String: [String]].self, forKey: .customExtensions) ?? [:]
    linkAssignments =
      try container.decodeIfPresent([String: String].self, forKey: .linkAssignments) ?? [:]
    rules = try container.decodeIfPresent([Rule].self, forKey: .rules) ?? []
    binaryAction =
      try container.decodeIfPresent(BinaryAction.self, forKey: .binaryAction) ?? .revealInFinder
    fallbacks = try container.decodeIfPresent([String: String].self, forKey: .fallbacks) ?? [:]
    folderRules = try container.decodeIfPresent([FolderRule].self, forKey: .folderRules) ?? []
    folderExclusions =
      try container.decodeIfPresent([String].self, forKey: .folderExclusions)
      ?? Configuration.defaultExclusions
  }

  public func assignment(for type: String) -> String? {
    assignment(for: type, in: TypeFamilies.family(containing: type))
  }

  public func assignment(for type: String, in family: TypeFamily?) -> String? {
    assignments[type] ?? family.flatMap { familyAssignments[$0.id] }
  }

  public func isOverridden(_ type: String) -> Bool {
    assignments[type] != nil
  }

  // members 给出每个类型族在本机实际可设的类型：去掉系统不认识的，加上按扩展名换算出的
  public func effectiveAssignments(members: FamilyMembers = { family, _ in family.types })
    -> [String: String]
  {
    var result: [String: String] = [:]
    for family in TypeFamilies.all {
      guard let bundleID = familyAssignments[family.id] else { continue }
      for type in members(family, customExtensions[family.id] ?? []) { result[type] = bundleID }
    }
    result.merge(assignments) { _, override in override }
    return result
  }

  public var helperTypes: Set<String> {
    let ruleTypes = rules.filter { $0.isEnabled && $0.hasConditions }.flatMap(\.contentTypes)
    let locked = effectiveAssignments().keys.filter { Planner.lockedTypes.contains($0) }
    return Set(ruleTypes).union(locked)
  }

  public func isControlledByRule(_ type: String) -> Bool {
    rules.contains { $0.isEnabled && $0.hasConditions && $0.contentTypes.contains(type) }
  }
}
