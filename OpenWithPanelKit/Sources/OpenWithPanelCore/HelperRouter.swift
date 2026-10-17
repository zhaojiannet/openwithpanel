import Foundation

public enum RouteDecision: Equatable, Sendable {
  case open(bundleID: String, reason: Reason)
  case reveal(reason: Reason)

  public enum Reason: Equatable, Sendable {
    case rule(id: UUID, name: String)
    case binary
    case assignment(type: String)
    case fallback(type: String)
    case noRoute
  }
}

public struct FileFacts: Sendable, Equatable {
  public var path: String
  public var contentType: String?
  public var supertypes: [String]
  public var kind: ContentKind

  public init(path: String, contentType: String?, supertypes: [String], kind: ContentKind) {
    self.path = path
    self.contentType = contentType
    self.supertypes = supertypes
    self.kind = kind
  }

  var fileName: String { (path as NSString).lastPathComponent }
  var typeChain: [String] { (contentType.map { [$0] } ?? []) + supertypes }
}

public struct HelperRouter: Sendable {
  public let configuration: Configuration
  public let homeDirectory: String

  public init(configuration: Configuration, homeDirectory: String) {
    self.configuration = configuration
    self.homeDirectory = homeDirectory
  }

  public func decide(_ file: FileFacts) -> RouteDecision {
    if let rule = configuration.rules.first(where: { matches($0, file) }) {
      let reason = RouteDecision.Reason.rule(id: rule.id, name: rule.name)
      switch rule.target {
      case .app(let bundleID): return .open(bundleID: bundleID, reason: reason)
      case .revealInFinder: return .reveal(reason: reason)
      case .system: return fallback(for: file)
      }
    }
    if file.kind == .binary {
      switch configuration.binaryAction {
      case .revealInFinder: return .reveal(reason: .binary)
      case .handBackToSystem: return fallback(for: file)
      case .openWithTarget: break
      }
    }
    for type in file.typeChain {
      if let bundleID = configuration.assignment(for: type) {
        return .open(bundleID: bundleID, reason: .assignment(type: type))
      }
    }
    return fallback(for: file)
  }

  func matches(_ rule: Rule, _ file: FileFacts) -> Bool {
    guard rule.isEnabled, rule.hasConditions else { return false }
    if !rule.contentTypes.isEmpty, !file.typeChain.contains(where: rule.contentTypes.contains) {
      return false
    }
    if let pattern = rule.namePattern, !pattern.isEmpty,
      fnmatch(pattern, file.fileName, FNM_CASEFOLD) != 0
    {
      return false
    }
    if let prefix = rule.pathPrefix, !prefix.isEmpty, !isInside(file.path, prefix) {
      return false
    }
    if let kind = rule.contentKind, kind != file.kind { return false }
    return true
  }

  private func isInside(_ path: String, _ prefix: String) -> Bool {
    var directory = prefix.hasPrefix("~") ? homeDirectory + prefix.dropFirst() : prefix
    if !directory.hasSuffix("/") { directory += "/" }
    return path.hasPrefix(directory)
  }

  private func fallback(for file: FileFacts) -> RouteDecision {
    for type in file.typeChain {
      if let bundleID = configuration.fallbacks[type] {
        return .open(bundleID: bundleID, reason: .fallback(type: type))
      }
    }
    return .reveal(reason: .noRoute)
  }
}
