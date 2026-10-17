import Foundation

public struct Release: Equatable, Sendable {
  public let version: String
  public let page: URL

  public init(version: String, page: URL) {
    self.version = version
    self.page = page
  }
}

public enum UpdateStatus: Equatable, Sendable {
  case upToDate
  case available(Release)
}

// 只在用户点「检查更新」时请求。这个接口只返回已发布的正式版，草稿和预发布版不会出现
public enum UpdateCheck {
  public static let latestRelease = URL(
    string: "https://api.github.com/repos/zhaojiannet/openwithpanel/releases/latest")!

  private struct Payload: Decodable {
    let tag: String

    enum CodingKeys: String, CodingKey {
      case tag = "tag_name"
    }
  }

  // 发布页按标签自己拼，不用返回里的 html_url：点「下载」会直接打开这个地址，
  // 不能让返回内容决定打开什么
  public static func release(from data: Data) throws -> Release {
    let tag = try JSONDecoder().decode(Payload.self, from: data).tag
    guard components(tag) != nil,
      let page = URL(string: "https://github.com/zhaojiannet/openwithpanel/releases/tag/\(tag)")
    else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: [], debugDescription: "unexpected tag \(tag)"))
    }
    return Release(version: tag.hasPrefix("v") ? String(tag.dropFirst()) : tag, page: page)
  }

  public static func status(of latest: Release, current: String) -> UpdateStatus {
    guard let new = components(latest.version), let old = components(current) else {
      return .upToDate
    }
    // 段数不同时缺的段按 0 算，0.2 和 0.2.0 是同一版
    let width = max(new.count, old.count)
    let padded = { (parts: [Int]) in parts + Array(repeating: 0, count: width - parts.count) }
    return padded(old).lexicographicallyPrecedes(padded(new)) ? .available(latest) : .upToDate
  }

  // 发布流程只接受 v1.2.3 形式的标签，带后缀的版本号不认
  static func components(_ version: String) -> [Int]? {
    let trimmed = version.hasPrefix("v") ? version.dropFirst() : Substring(version)
    let parts = trimmed.split(separator: ".", omittingEmptySubsequences: false)
    let numbers = parts.compactMap { part in
      part.allSatisfy { ("0"..."9").contains($0) } ? Int(part) : nil
    }
    return numbers.count == parts.count ? numbers : nil
  }
}
