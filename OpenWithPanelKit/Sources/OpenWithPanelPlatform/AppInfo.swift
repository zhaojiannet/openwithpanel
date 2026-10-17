import Foundation

public struct AppInfo: Hashable, Sendable, Codable {
  public var bundleID: String
  public var name: String
  public var path: String

  public init(bundleID: String, name: String, path: String) {
    self.bundleID = bundleID
    self.name = name
    self.path = path
  }

  public var url: URL { URL(fileURLWithPath: path) }

  // LaunchServices 存的 bundle id 一律小写，比较时不能区分大小写
  public func matches(bundleID other: String) -> Bool {
    bundleID.caseInsensitiveCompare(other) == .orderedSame
  }
}

public struct InstalledApp: Hashable, Sendable {
  public var info: AppInfo
  public var documentTypes: [DocumentTypeDeclaration]

  public init(info: AppInfo, documentTypes: [DocumentTypeDeclaration]) {
    self.info = info
    self.documentTypes = documentTypes
  }

  public var declaredTypes: [String] {
    Array(Set(documentTypes.flatMap(\.contentTypes))).sorted()
  }

  public var declaredExtensions: [String] {
    Array(Set(documentTypes.flatMap(\.extensions))).sorted()
  }
}

// Info.plist 里 CFBundleDocumentTypes 的一项。role、rank 没写就是 nil，不替系统补默认值
public struct DocumentTypeDeclaration: Hashable, Sendable {
  public var contentTypes: [String]
  public var extensions: [String]
  public var role: String?
  public var rank: String?

  public init(contentTypes: [String], extensions: [String], role: String?, rank: String?) {
    self.contentTypes = contentTypes
    self.extensions = extensions
    self.role = role
    self.rank = rank
  }
}
