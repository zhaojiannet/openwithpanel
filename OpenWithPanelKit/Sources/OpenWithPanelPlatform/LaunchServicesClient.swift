import AppKit
import CoreServices
import Foundation
import UniformTypeIdentifiers

public protocol LaunchServicesClient: Sendable {
  func defaultApp(forType type: String) -> AppInfo?
  func candidateApps(forType type: String) -> [AppInfo]
  func defaultApp(forFile url: URL) -> AppInfo?
  func app(bundleID: String) -> AppInfo?
  func app(at url: URL) -> AppInfo?
  func setDefault(_ app: AppInfo, forType type: String) async throws
  func setDefault(_ app: AppInfo, forFile url: URL) async throws
  func defaultApp(forScheme scheme: String) -> AppInfo?
  func candidateApps(forScheme scheme: String) -> [AppInfo]
  func setDefault(_ app: AppInfo, forScheme scheme: String) async throws
  func register(appAt url: URL) -> Bool
}

public struct SystemLaunchServices: LaunchServicesClient {
  public init() {}

  public func defaultApp(forType type: String) -> AppInfo? {
    guard let uttype = UTType(type) else { return nil }
    return NSWorkspace.shared.urlForApplication(toOpen: uttype).flatMap(app(at:))
  }

  public func candidateApps(forType type: String) -> [AppInfo] {
    guard let uttype = UTType(type) else { return [] }
    return Self.unique(NSWorkspace.shared.urlsForApplications(toOpen: uttype).compactMap(app(at:)))
  }

  public func defaultApp(forFile url: URL) -> AppInfo? {
    NSWorkspace.shared.urlForApplication(toOpen: url).flatMap(app(at:))
  }

  public func app(bundleID: String) -> AppInfo? {
    NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID).flatMap(app(at:))
  }

  public func app(at url: URL) -> AppInfo? {
    guard let bundle = Bundle(url: url), let id = bundle.bundleIdentifier else { return nil }
    let name = FileManager.default.displayName(atPath: url.path)
    return AppInfo(
      bundleID: id, name: name.hasSuffix(".app") ? String(name.dropLast(4)) : name, path: url.path)
  }

  public func setDefault(_ app: AppInfo, forType type: String) async throws {
    guard let uttype = UTType(type) else { throw LaunchServicesError.unknownType(type) }
    try await NSWorkspace.shared.setDefaultApplication(at: app.url, toOpen: uttype)
  }

  public func setDefault(_ app: AppInfo, forFile url: URL) async throws {
    try await NSWorkspace.shared.setDefaultApplication(at: app.url, toOpenFileAt: url)
  }

  public func defaultApp(forScheme scheme: String) -> AppInfo? {
    guard let url = URL(string: scheme + ":") else { return nil }
    return NSWorkspace.shared.urlForApplication(toOpen: url).flatMap(app(at:))
  }

  public func candidateApps(forScheme scheme: String) -> [AppInfo] {
    guard let url = URL(string: scheme + ":") else { return [] }
    return Self.unique(NSWorkspace.shared.urlsForApplications(toOpen: url).compactMap(app(at:)))
  }

  public func setDefault(_ app: AppInfo, forScheme scheme: String) async throws {
    try await NSWorkspace.shared.setDefaultApplication(at: app.url, toOpenURLsWithScheme: scheme)
  }

  public func register(appAt url: URL) -> Bool {
    LSRegisterURL(url as CFURL, true) == noErr
  }

  // 同一个 App 可能在多个位置（挂载的 DMG、备份盘）各登记一份，候选里只留第一份
  private static func unique(_ apps: [AppInfo]) -> [AppInfo] {
    var seen = Set<String>()
    return apps.filter { seen.insert($0.bundleID.lowercased()).inserted }
  }
}

public enum LaunchServicesError: Error, Equatable {
  case unknownType(String)
}
