import OpenWithPanelPlatform

// 一类链接可能对应几个网址协议：浏览器要同时接管 http 和 https
public struct LinkKind: Identifiable, Hashable, Sendable {
  public let id: String
  public let schemes: [String]

  public init(id: String, schemes: [String]) {
    self.id = id
    self.schemes = schemes
  }

  public var keys: [String] { schemes.map(HandlerKey.scheme) }
}

public enum LinkKinds {
  public static let all: [LinkKind] = [
    LinkKind(id: "web", schemes: ["http", "https"]),
    LinkKind(id: "mail", schemes: ["mailto"]),
    LinkKind(id: "calendar", schemes: ["webcal"]),
    LinkKind(id: "phone", schemes: ["tel"]),
    LinkKind(id: "messages", schemes: ["sms"]),
    LinkKind(id: "facetime", schemes: ["facetime"]),
    LinkKind(id: "ssh", schemes: ["ssh"]),
    LinkKind(id: "ftp", schemes: ["ftp"]),
    LinkKind(id: "screenSharing", schemes: ["vnc"]),
  ]

  public static var allKeys: [String] { all.flatMap(\.keys) }
}

// 快照、计划和应用把网址协议和文件类型放在同一张表里，协议加「scheme:」前缀区分；
// UTI 只由字母、数字、点和连字符组成，不会和它混淆
public enum HandlerKey {
  static let schemePrefix = "scheme:"

  public static func scheme(_ scheme: String) -> String { schemePrefix + scheme }

  public static func schemeName(of key: String) -> String? {
    key.hasPrefix(schemePrefix) ? String(key.dropFirst(schemePrefix.count)) : nil
  }
}

extension LaunchServicesClient {
  public func defaultApp(forKey key: String) -> AppInfo? {
    HandlerKey.schemeName(of: key).map(defaultApp(forScheme:)) ?? defaultApp(forType: key)
  }

  public func candidateApps(forKey key: String) -> [AppInfo] {
    HandlerKey.schemeName(of: key).map(candidateApps(forScheme:)) ?? candidateApps(forType: key)
  }

  public func setDefault(_ app: AppInfo, forKey key: String) async throws {
    if let scheme = HandlerKey.schemeName(of: key) {
      try await setDefault(app, forScheme: scheme)
    } else {
      try await setDefault(app, forType: key)
    }
  }
}
