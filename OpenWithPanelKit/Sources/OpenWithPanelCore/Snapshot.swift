import Foundation

public struct Snapshot: Equatable, Sendable {
  public var handlers: [String: String]
  // 只记录被锁定类型在偏好文件里的条目；恢复时据此决定写回还是删除
  public var preferenceHandlers: [String: String]

  public init(handlers: [String: String] = [:], preferenceHandlers: [String: String] = [:]) {
    self.handlers = handlers
    self.preferenceHandlers = preferenceHandlers
  }
}

public struct HandlerChange: Equatable, Sendable, Identifiable {
  public var type: String
  public var from: String?
  public var to: String?
  public var id: String { type }

  public init(type: String, from: String?, to: String?) {
    self.type = type
    self.from = from
    self.to = to
  }
}

extension Snapshot {
  public func changes(to target: Snapshot) -> [HandlerChange] {
    let types = Set(handlers.keys).union(target.handlers.keys)
    return types.sorted().compactMap { type in
      let from = handlers[type]
      let to = target.handlers[type]
      return sameBundle(from, to) ? nil : HandlerChange(type: type, from: from, to: to)
    }
  }
}

func sameBundle(_ a: String?, _ b: String?) -> Bool {
  switch (a, b) {
  case (nil, nil): return true
  case (let a?, let b?): return a.caseInsensitiveCompare(b) == .orderedSame
  default: return false
  }
}

// duti 的设置文件格式，# 开头为注释，列以制表符分隔：
// 文件类型三列「bundle id、UTI、角色」，网址协议两列「bundle id、协议」
public enum DutiFormat {
  public static func encode(_ handlers: [String: String], header: String? = nil) -> String {
    var lines = header.map { ["# \($0)"] } ?? []
    lines += handlers.keys.sorted().map { key in
      if let scheme = HandlerKey.schemeName(of: key) { return "\(handlers[key]!)\t\(scheme)" }
      return "\(handlers[key]!)\t\(key)\tall"
    }
    return lines.joined(separator: "\n") + "\n"
  }

  public static func decode(_ text: String) -> [String: String] {
    var result: [String: String] = [:]
    for line in text.split(whereSeparator: \.isNewline) {
      let trimmed = line.trimmingCharacters(in: .whitespaces)
      if trimmed.isEmpty || trimmed.hasPrefix("#") { continue }
      let columns = trimmed.split(whereSeparator: { $0 == "\t" || $0 == " " }).map(String.init)
      switch columns.count {
      case 2: result[HandlerKey.scheme(columns[1])] = columns[0]
      case 3...: result[columns[1]] = columns[0]
      default: continue
      }
    }
    return result
  }
}
