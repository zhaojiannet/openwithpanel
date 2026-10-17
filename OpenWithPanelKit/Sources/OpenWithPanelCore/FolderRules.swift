import Foundation
import OpenWithPanelPlatform

public struct FolderScanner: Sendable {
  public let exclusions: Set<String>
  public let limit: Int

  public init(exclusions: [String], limit: Int = 50_000) {
    self.exclusions = Set(exclusions)
    self.limit = limit
  }

  // 点文件正是要处理的对象，所以不跳过隐藏文件；App 包和排除目录整个跳过，不跟随符号链接
  public func files(in directory: URL) -> [URL] {
    let keys: [URLResourceKey] = [.isRegularFileKey, .isDirectoryKey, .isPackageKey]
    guard
      let enumerator = FileManager.default.enumerator(
        at: directory, includingPropertiesForKeys: keys, options: [])
    else { return [] }
    var result: [URL] = []
    for case let url as URL in enumerator {
      let values = try? url.resourceValues(forKeys: Set(keys))
      if values?.isDirectory == true {
        if exclusions.contains(url.lastPathComponent) || values?.isPackage == true {
          enumerator.skipDescendants()
        }
        continue
      }
      guard values?.isRegularFile == true else { continue }
      result.append(url)
      if result.count >= limit { break }
    }
    return result
  }
}

public struct FileOverride: Equatable, Sendable, Identifiable {
  public var url: URL
  public var bundleID: String
  public var id: URL { url }

  public init(url: URL, bundleID: String) {
    self.url = url
    self.bundleID = bundleID
  }
}

public struct FolderLedger: Codable, Equatable, Sendable {
  // 本 App 写过绑定的文件 → 写之前的原始属性值，nil 表示原来没有
  public var previous: [String: Data?] = [:]

  public init() {}

  public static func load(from url: URL) throws -> FolderLedger {
    guard FileManager.default.fileExists(atPath: url.path) else { return FolderLedger() }
    return try JSONDecoder().decode(FolderLedger.self, from: Data(contentsOf: url))
  }

  public func save(to url: URL) throws {
    try JSONEncoder().encode(self).write(to: url, options: .atomic)
  }
}

public struct FolderRuleReport: Equatable, Sendable {
  public var written = 0
  public var skippedBinary = 0
  public var skippedUserOverride = 0
  public var failed = 0

  public init() {}
}

public struct FolderRuleEngine: Sendable {
  let launchServices: any LaunchServicesClient
  let catalog: any TypeCatalog
  let openWith: any OpenWithAttributeStore
  let reader: any FileHeadReading

  public init(
    launchServices: any LaunchServicesClient, catalog: any TypeCatalog,
    openWith: any OpenWithAttributeStore, reader: any FileHeadReading
  ) {
    self.launchServices = launchServices
    self.catalog = catalog
    self.openWith = openWith
    self.reader = reader
  }

  public func overrides(in directory: URL, scanner: FolderScanner) -> [FileOverride] {
    scanner.files(in: directory).compactMap { url in
      openWith.overrideBundleID(of: url).map { FileOverride(url: url, bundleID: $0) }
    }
  }

  public func clear(_ overrides: [FileOverride]) -> [URL] {
    overrides.compactMap { override in
      (try? openWith.remove(from: override.url)) == nil ? override.url : nil
    }
  }

  public func apply(
    _ rule: FolderRule, scanner: FolderScanner, ledger: inout FolderLedger
  ) async -> FolderRuleReport {
    var report = FolderRuleReport()
    guard let app = launchServices.app(bundleID: rule.targetBundleID) else {
      report.failed = 1
      return report
    }
    for url in scanner.files(in: URL(fileURLWithPath: rule.path)) {
      guard let type = catalog.contentType(ofFile: url), Planner.lockedTypes.contains(type) else {
        continue
      }
      let existing = openWith.read(url)
      let ours = ledger.previous.keys.contains(url.path)
      if existing != nil, !ours {
        if !(openWith.overrideBundleID(of: url).map(app.matches(bundleID:)) ?? false) {
          report.skippedUserOverride += 1
        }
        continue
      }
      guard (try? ContentClassifier.classify(fileAt: url, reader: reader)) == .text else {
        report.skippedBinary += 1
        continue
      }
      if ours, openWith.overrideBundleID(of: url).map(app.matches(bundleID:)) ?? false { continue }
      do {
        try await launchServices.setDefault(app, forFile: url)
        if !ours { ledger.previous[url.path] = .some(existing) }
        report.written += 1
      } catch {
        report.failed += 1
      }
    }
    return report
  }

  public func undo(_ ledger: inout FolderLedger) -> [String] {
    var failures: [String] = []
    for (path, previous) in ledger.previous {
      let url = URL(fileURLWithPath: path)
      do {
        if let previous {
          try openWith.write(previous, to: url)
        } else {
          try openWith.remove(from: url)
        }
        ledger.previous[path] = nil
      } catch {
        if FileManager.default.fileExists(atPath: path) {
          failures.append(path)
        } else {
          ledger.previous[path] = nil
        }
      }
    }
    return failures
  }
}
