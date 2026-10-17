import Foundation
import OpenWithPanelPlatform
import Testing

@testable import OpenWithPanelCore

struct FakeHeadReader: FileHeadReading {
  let data: Data

  func head(of url: URL, maxLength: Int) throws -> Data {
    data.prefix(maxLength)
  }
}

@Suite("内容分类")
struct ContentClassifierTests {
  @Test(
    "按前缀字节判断文本或二进制",
    arguments: [
      (Data(), ContentKind.text),
      (Data("FOO=1\n".utf8), .text),
      (Data("中文内容".utf8), .text),
      (Data([0x41, 0x00, 0x42]), .binary),
      (Data([0xFF, 0xFE, 0x41]), .binary),
    ])
  func classifiesPrefix(head: Data, expected: ContentKind) {
    #expect(ContentClassifier.classify(head) == expected)
  }

  @Test("读满长度时被截断的多字节字符仍算文本")
  func truncatedMultibyteAtBoundaryIsText() {
    var head = Data(repeating: UInt8(ascii: "a"), count: ContentClassifier.sniffLength - 1)
    head.append(0xE4)
    #expect(ContentClassifier.classify(head) == .text)
  }

  @Test("未读满时末尾的残缺字节算二进制")
  func shortInvalidTailIsBinary() {
    #expect(ContentClassifier.classify(Data([0x61, 0xE4])) == .binary)
  }

  @Test("通过读取器只取前 sniffLength 字节")
  func classifiesThroughReader() throws {
    var data = Data(repeating: UInt8(ascii: "a"), count: ContentClassifier.sniffLength)
    data.append(0x00)
    let kind = try ContentClassifier.classify(
      fileAt: URL(fileURLWithPath: "/dev/null"), reader: FakeHeadReader(data: data))
    #expect(kind == .text)
  }
}
