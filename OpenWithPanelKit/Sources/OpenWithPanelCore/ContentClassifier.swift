import Foundation
import OpenWithPanelPlatform

public enum ContentKind: String, Codable, Sendable, Equatable, CaseIterable {
  case text
  case binary
}

public enum ContentClassifier {
  public static let sniffLength = 8192

  public static func classify(_ head: Data) -> ContentKind {
    if head.contains(0) { return .binary }
    // 读满 sniffLength 时末尾可能切开一个多字节 UTF-8 字符，最多去掉 3 字节再校验
    let maxTrim = head.count >= sniffLength ? 3 : 0
    for trim in 0...maxTrim where String(data: head.dropLast(trim), encoding: .utf8) != nil {
      return .text
    }
    return .binary
  }

  public static func classify(fileAt url: URL, reader: some FileHeadReading) throws -> ContentKind {
    try classify(reader.head(of: url, maxLength: sniffLength))
  }
}
