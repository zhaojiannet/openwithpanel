import Foundation

public protocol AppCatalog: Sendable {
  func installedApps() -> [InstalledApp]
  func app(at url: URL) -> InstalledApp?
}

public struct SystemAppCatalog: AppCatalog {
  private let roots: [URL]

  public init(roots: [URL]? = nil) {
    let home = FileManager.default.homeDirectoryForCurrentUser
    self.roots =
      roots ?? [
        URL(fileURLWithPath: "/Applications"),
        home.appendingPathComponent("Applications"),
        URL(fileURLWithPath: "/System/Applications"),
        URL(fileURLWithPath: "/System/Library/CoreServices/Applications"),
      ]
  }

  public func installedApps() -> [InstalledApp] {
    roots.flatMap { appBundles(in: $0, depth: 2) }.compactMap(app(at:))
  }

  // Utilities 这类子文件夹里也放 App，往下多看一层；App 包本身不展开
  private func appBundles(in directory: URL, depth: Int) -> [URL] {
    guard depth > 0,
      let items = try? FileManager.default.contentsOfDirectory(
        at: directory, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
    else { return [] }
    return items.flatMap { item -> [URL] in
      if item.pathExtension == "app" { return [item] }
      let isDirectory = (try? item.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
      return isDirectory ? appBundles(in: item, depth: depth - 1) : []
    }
  }

  public func app(at url: URL) -> InstalledApp? {
    guard let bundle = Bundle(url: url), let id = bundle.bundleIdentifier,
      let info = bundle.infoDictionary
    else { return nil }
    let documentTypes = (info["CFBundleDocumentTypes"] as? [[String: Any]] ?? []).map {
      DocumentTypeDeclaration(
        contentTypes: $0["LSItemContentTypes"] as? [String] ?? [],
        extensions: $0["CFBundleTypeExtensions"] as? [String] ?? [],
        role: $0["CFBundleTypeRole"] as? String, rank: $0["LSHandlerRank"] as? String)
    }
    let name = url.deletingPathExtension().lastPathComponent
    return InstalledApp(
      info: AppInfo(bundleID: id, name: name, path: url.path), documentTypes: documentTypes)
  }
}
