import Foundation
import OpenWithPanelPlatform

@testable import OpenWithPanelCore

final class FakeLaunchServices: LaunchServicesClient, @unchecked Sendable {
  private let lock = NSLock()
  var apps: [String: AppInfo]
  var defaults: [String: String]
  var fileDefaults: [String: String] = [:]
  var candidates: [String: [String]] = [:]
  // 模拟用户在系统确认框里点了「保留原来的」
  var declined: Set<String> = []
  var setCalls: [String] = []

  init(apps: [AppInfo], defaults: [String: String] = [:]) {
    self.apps = Dictionary(uniqueKeysWithValues: apps.map { ($0.bundleID.lowercased(), $0) })
    self.defaults = defaults
  }

  func defaultApp(forType type: String) -> AppInfo? {
    lock.withLock { defaults[type].flatMap { apps[$0.lowercased()] } }
  }

  func candidateApps(forType type: String) -> [AppInfo] {
    lock.withLock { (candidates[type] ?? []).compactMap { apps[$0.lowercased()] } }
  }

  func defaultApp(forFile url: URL) -> AppInfo? {
    lock.withLock { fileDefaults[url.path].flatMap { apps[$0.lowercased()] } }
  }

  func app(bundleID: String) -> AppInfo? { lock.withLock { apps[bundleID.lowercased()] } }
  func app(at url: URL) -> AppInfo? { lock.withLock { apps.values.first { $0.url == url } } }

  func setDefault(_ app: AppInfo, forType type: String) async throws {
    lock.withLock {
      setCalls.append(type)
      if !declined.contains(type) { defaults[type] = app.bundleID }
    }
  }

  func setDefault(_ app: AppInfo, forFile url: URL) async throws {
    lock.withLock { fileDefaults[url.path] = app.bundleID }
  }

  // 协议和类型共用 defaults，键按 HandlerKey 的写法；linked 模拟系统改一个协议时连带改另一个
  var linked: [String: String] = [:]

  func defaultApp(forScheme scheme: String) -> AppInfo? {
    defaultApp(forType: HandlerKey.scheme(scheme))
  }

  func candidateApps(forScheme scheme: String) -> [AppInfo] {
    candidateApps(forType: HandlerKey.scheme(scheme))
  }

  func setDefault(_ app: AppInfo, forScheme scheme: String) async throws {
    try await setDefault(app, forType: HandlerKey.scheme(scheme))
    if let other = linked[scheme] {
      lock.withLock { defaults[HandlerKey.scheme(other)] = app.bundleID }
    }
  }

  func register(appAt url: URL) -> Bool { true }
}

final class FakePreferences: HandlerPreferencesStore, @unchecked Sendable {
  private let lock = NSLock()
  var entries: [String: String] = [:]
  var reloads = 0
  // 偏好条目生效要等 lsd 重新读取，写入后在 reload 时才同步到 LaunchServices
  weak var launchServices: FakeLaunchServices?
  var pending: [String: String?] = [:]
  // 模拟偏好条目写了却没生效（比如系统更新后这条路失效）
  var ignored: Set<String> = []
  // 模拟偏好文件写不进去（比如没有权限）
  var failsToWrite = false

  func contentTypeHandlers() -> [String: String] { lock.withLock { entries } }

  func setHandler(_ bundleID: String?, forContentType type: String) throws {
    if failsToWrite { throw HandlerPreferencesError.synchronizeFailed }
    lock.withLock {
      entries[type.lowercased()] = bundleID?.lowercased()
      pending[type] = .some(bundleID)
    }
  }

  func backup(to url: URL) throws {}

  func reloadLaunchServices() throws {
    lock.withLock {
      reloads += 1
      for (type, bundleID) in pending where !ignored.contains(type) {
        launchServices?.defaults[type] = bundleID ?? "com.apple.TextEdit"
      }
      pending = [:]
    }
  }
}

final class FakeOpenWith: OpenWithAttributeStore, @unchecked Sendable {
  private let lock = NSLock()
  var values: [String: Data] = [:]

  func read(_ url: URL) -> Data? { lock.withLock { values[url.path] } }
  func write(_ data: Data, to url: URL) throws { lock.withLock { values[url.path] = data } }
  func remove(from url: URL) throws { lock.withLock { values[url.path] = nil } }

  static func encode(_ bundleID: String) -> Data {
    try! PropertyListSerialization.data(
      fromPropertyList: [
        "bundleidentifier": bundleID, "path": "/Applications/X.app", "version": 0,
      ],
      format: .binary, options: 0)
  }
}

struct FakeCatalog: TypeCatalog {
  var fileTypes: [String: String] = [:]
  var parents: [String: [String]] = [:]
  var declared: Set<String> = []
  var byExtension: [String: String] = [:]

  func contentType(ofFile url: URL) -> String? { fileTypes[url.lastPathComponent] }
  func isDeclared(_ type: String) -> Bool { declared.contains(type) }
  func supertypes(of type: String) -> [String] { parents[type] ?? [] }
  func conforms(_ type: String, to parent: String) -> Bool {
    type == parent || supertypes(of: type).contains(parent)
  }
  func type(forExtension ext: String) -> String? { byExtension[ext] }
  func localizedDescription(of type: String) -> String? { nil }
  func extensions(of type: String) -> [String] { [] }
}

struct FakeAppCatalog: AppCatalog {
  var apps: [InstalledApp] = []

  func installedApps() -> [InstalledApp] { apps }
  func app(at url: URL) -> InstalledApp? { apps.first { $0.info.url == url } }
}

struct FileReader: FileHeadReading {
  func head(of url: URL, maxLength: Int) throws -> Data {
    try FileHeadReader().head(of: url, maxLength: maxLength)
  }
}

enum TestApps {
  static let zed = AppInfo(bundleID: "dev.zed.Zed", name: "Zed", path: "/Applications/Zed.app")
  static let textEdit = AppInfo(
    bundleID: "com.apple.TextEdit", name: "TextEdit", path: "/System/Applications/TextEdit.app")
  static let preview = AppInfo(
    bundleID: "com.apple.Preview", name: "Preview", path: "/System/Applications/Preview.app")
  static let helper = AppInfo(
    bundleID: "net.zhaojian.openwithpanel.helper", name: "OpenWithPanel Helper",
    path: "/Applications/OpenWithPanel.app/Contents/Helpers/OpenWithPanel Helper.app")
  static let all = [zed, textEdit, preview, helper]
}

func temporaryDirectory() throws -> URL {
  let url = FileManager.default.temporaryDirectory.appendingPathComponent(
    "openwithpanel-tests-\(UUID().uuidString)")
  try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
  // 临时目录在 /var 下，是 /private/var 的符号链接；目录遍历返回 /private/var，
  // 而 resolvingSymlinksInPath 会保留 /var，只能用 realpath 取真实路径
  return URL(fileURLWithPath: String(cString: realpath(url.path, nil)))
}
