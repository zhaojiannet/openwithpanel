import Foundation

public protocol FileHeadReading: Sendable {
  func head(of url: URL, maxLength: Int) throws -> Data
}

public struct FileHeadReader: FileHeadReading {
  public init() {}

  public func head(of url: URL, maxLength: Int) throws -> Data {
    let handle = try FileHandle(forReadingFrom: url)
    defer { try? handle.close() }
    return try handle.read(upToCount: maxLength) ?? Data()
  }
}
