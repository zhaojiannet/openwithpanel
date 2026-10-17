import Foundation

public protocol OpenWithAttributeStore: Sendable {
  func read(_ url: URL) -> Data?
  func write(_ data: Data, to url: URL) throws
  func remove(from url: URL) throws
}

extension OpenWithAttributeStore {
  public func overrideBundleID(of url: URL) -> String? {
    guard let data = read(url),
      let plist = try? PropertyListSerialization.propertyList(from: data, format: nil)
        as? [String: Any]
    else { return nil }
    return plist["bundleidentifier"] as? String
  }
}

public struct POSIXError: Error, Equatable {
  public let code: Int32
}

public struct SystemOpenWithAttribute: OpenWithAttributeStore {
  private static let name = "com.apple.LaunchServices.OpenWith"

  public init() {}

  public func read(_ url: URL) -> Data? {
    url.withUnsafeFileSystemRepresentation { path -> Data? in
      guard let path else { return nil }
      let size = getxattr(path, Self.name, nil, 0, 0, XATTR_NOFOLLOW)
      guard size > 0 else { return nil }
      var buffer = Data(count: size)
      let read = buffer.withUnsafeMutableBytes {
        getxattr(path, Self.name, $0.baseAddress, size, 0, XATTR_NOFOLLOW)
      }
      return read == size ? buffer : nil
    }
  }

  public func write(_ data: Data, to url: URL) throws {
    let result = url.withUnsafeFileSystemRepresentation { path -> Int32 in
      guard let path else { return -1 }
      return data.withUnsafeBytes {
        setxattr(path, Self.name, $0.baseAddress, data.count, 0, XATTR_NOFOLLOW)
      }
    }
    if result != 0 { throw POSIXError(code: errno) }
  }

  public func remove(from url: URL) throws {
    let result = url.withUnsafeFileSystemRepresentation { path -> Int32 in
      guard let path else { return -1 }
      return removexattr(path, Self.name, XATTR_NOFOLLOW)
    }
    if result != 0 && errno != ENOATTR { throw POSIXError(code: errno) }
  }
}
