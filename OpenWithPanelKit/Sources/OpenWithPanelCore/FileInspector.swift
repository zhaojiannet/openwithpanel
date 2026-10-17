import Foundation
import OpenWithPanelPlatform

public struct FileInspector: Sendable {
  let catalog: any TypeCatalog
  let reader: any FileHeadReading

  public init(catalog: any TypeCatalog, reader: any FileHeadReading) {
    self.catalog = catalog
    self.reader = reader
  }

  // 目录交给目标 App（编辑器打开项目文件夹），读不了的文件按二进制处理，交给 Finder 高亮最稳妥
  public func facts(for url: URL) -> FileFacts {
    let type = catalog.contentType(ofFile: url)
    let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    let kind: ContentKind =
      isDirectory
      ? .text : (try? ContentClassifier.classify(fileAt: url, reader: reader)) ?? .binary
    return FileFacts(
      path: url.path, contentType: type, supertypes: type.map(catalog.supertypes(of:)) ?? [],
      kind: kind)
  }
}
