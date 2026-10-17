import Foundation
import UniformTypeIdentifiers

public protocol HandlerPreferencesStore: Sendable {
  func contentTypeHandlers() -> [String: String]
  func setHandler(_ bundleID: String?, forContentType type: String) throws
  func backup(to url: URL) throws
  func reloadLaunchServices() throws
}

public enum HandlerPreferencesError: Error, Equatable {
  case synchronizeFailed
  case unreadable
  case reloadFailed(Int32)
}

// CUSTOM: public.data 这类抽象类型用 NSWorkspace 和 LSSetDefaultRoleHandlerForContentType 设置都返回 -50，
// 只有直接写 LaunchServices 的偏好条目再让 lsd 重新读取才生效，系统没有对应的公开接口
public struct SystemHandlerPreferences: HandlerPreferencesStore {
  private static let domain = "com.apple.LaunchServices/com.apple.launchservices.secure"
  private static let key = "LSHandlers"
  private static let extensionClass = "public.filename-extension"

  public init() {}

  // 临时类型（dyn.*）在偏好文件里按扩展名记录，读出时换算回类型
  public func contentTypeHandlers() -> [String: String] {
    var result: [String: String] = [:]
    for entry in Self.entries() {
      guard let role = entry["LSHandlerRoleAll"] as? String else { continue }
      if let type = entry["LSHandlerContentType"] as? String {
        result[type.lowercased()] = role
      } else if let tag = entry["LSHandlerContentTag"] as? String,
        entry["LSHandlerContentTagClass"] as? String == Self.extensionClass,
        let type = UTType(filenameExtension: tag)?.identifier
      {
        result[type.lowercased()] = role
      }
    }
    return result
  }

  // 系统接口设临时类型时写的就是扩展名条目，这里照同样的格式写
  public func setHandler(_ bundleID: String?, forContentType type: String) throws {
    let ext = type.hasPrefix("dyn.") ? UTType(type)?.tags[.filenameExtension]?.first : nil
    var entries = try Self.loadEntries().filter { entry in
      if (entry["LSHandlerContentType"] as? String)?.caseInsensitiveCompare(type) == .orderedSame {
        return false
      }
      guard let ext, entry["LSHandlerContentTagClass"] as? String == Self.extensionClass else {
        return true
      }
      return (entry["LSHandlerContentTag"] as? String)?.caseInsensitiveCompare(ext) != .orderedSame
    }
    if let bundleID {
      if let ext {
        entries.append([
          "LSHandlerContentTag": ext,
          "LSHandlerContentTagClass": Self.extensionClass,
          "LSHandlerRoleAll": bundleID.lowercased(),
        ])
      } else {
        entries.append([
          "LSHandlerContentType": type,
          "LSHandlerRoleAll": bundleID.lowercased(),
        ])
      }
    }
    CFPreferencesSetAppValue(Self.key as CFString, entries as CFArray, Self.domain as CFString)
    guard CFPreferencesAppSynchronize(Self.domain as CFString) else {
      throw HandlerPreferencesError.synchronizeFailed
    }
  }

  public func backup(to url: URL) throws {
    let data = try PropertyListSerialization.data(
      fromPropertyList: Self.entries(), format: .xml, options: 0)
    try data.write(to: url, options: .atomic)
  }

  // lsd 只在启动时读取偏好文件；launchd 会立刻把它重新拉起
  public func reloadLaunchServices() throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
    process.arguments = ["lsd"]
    try process.run()
    process.waitUntilExit()
    guard process.terminationStatus == 0 else {
      throw HandlerPreferencesError.reloadFailed(process.terminationStatus)
    }
    Thread.sleep(forTimeInterval: 2)
  }

  // 直接读磁盘上的文件，不用 CFPreferencesCopyAppValue：普通类型的关联由 lsd 直接写进这个文件，
  // cfprefsd 的缓存可能还是旧内容（实测出现过），按缓存改完写回会把 lsd 新写的条目整批覆盖掉。
  // 文件在却读不出来时报错，不能当成空的，否则写回时会清掉所有条目
  private static func loadEntries() throws -> [[String: Any]] {
    guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
    let data = try Data(contentsOf: fileURL)
    guard
      let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
        as? [String: Any]
    else { throw HandlerPreferencesError.unreadable }
    return plist[key] as? [[String: Any]] ?? []
  }

  private static func entries() -> [[String: Any]] {
    (try? loadEntries()) ?? []
  }

  private static var fileURL: URL {
    FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(
      "Library/Preferences/\(domain).plist")
  }
}
