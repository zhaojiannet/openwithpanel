import Foundation
import UniformTypeIdentifiers

public protocol TypeCatalog: Sendable {
  func contentType(ofFile url: URL) -> String?
  func isDeclared(_ type: String) -> Bool
  func supertypes(of type: String) -> [String]
  func conforms(_ type: String, to parent: String) -> Bool
  func type(forExtension ext: String) -> String?
  func localizedDescription(of type: String) -> String?
  func extensions(of type: String) -> [String]
}

public struct SystemTypeCatalog: TypeCatalog {
  public init() {}

  public func contentType(ofFile url: URL) -> String? {
    (try? url.resourceValues(forKeys: [.contentTypeKey]))?.contentType?.identifier
  }

  public func isDeclared(_ type: String) -> Bool {
    UTType(type)?.isDeclared ?? false
  }

  public func supertypes(of type: String) -> [String] {
    guard let uttype = UTType(type) else { return [] }
    return uttype.supertypes.map(\.identifier).sorted()
  }

  public func conforms(_ type: String, to parent: String) -> Bool {
    guard let child = UTType(type), let parent = UTType(parent) else { return false }
    return child.conforms(to: parent)
  }

  public func type(forExtension ext: String) -> String? {
    UTType(filenameExtension: ext)?.identifier
  }

  public func localizedDescription(of type: String) -> String? {
    UTType(type)?.localizedDescription
  }

  public func extensions(of type: String) -> [String] {
    UTType(type)?.tags[.filenameExtension] ?? []
  }
}
