import Foundation
import Testing

@testable import OpenWithPanelCore

@Suite("检查更新")
struct UpdateCheckTests {
  private let page = URL(
    string: "https://github.com/zhaojiannet/openwithpanel/releases/tag/v0.2.0")!

  @Test("从标签读出版本号，发布页按标签拼，不用返回里的 html_url")
  func decodesLatestRelease() throws {
    let json = Data(
      """
      {"tag_name": "v0.2.0", "name": "OpenWithPanel 0.2.0",
       "html_url": "file:///Applications/Calculator.app"}
      """.utf8)
    #expect(try UpdateCheck.release(from: json) == Release(version: "0.2.0", page: page))
  }

  @Test("标签不是数字版本号时报错")
  func rejectsUnexpectedTag() {
    let json = Data(#"{"tag_name": "nightly", "html_url": "https://example.com"}"#.utf8)
    #expect(throws: DecodingError.self) { try UpdateCheck.release(from: json) }
  }

  @Test(
    "只有发布的版本更高才算有新版",
    arguments: [
      ("0.2.0", "0.1.0", true),
      ("0.1.1", "0.1.0", true),
      ("1.0.0", "0.9.9", true),
      ("0.10.0", "0.9.0", true),
      ("0.1.0", "0.1.0", false),
      ("0.1.0", "0.2.0", false),
      ("0.2", "0.2.0", false),
      ("0.2.1", "0.2", true),
    ])
  func comparesVersions(latest: String, current: String, isNewer: Bool) {
    let release = Release(version: latest, page: page)
    let expected: UpdateStatus = isNewer ? .available(release) : .upToDate
    #expect(UpdateCheck.status(of: release, current: current) == expected)
  }

  @Test("本机版本号读不懂时不提示更新")
  func unreadableCurrentVersionIsUpToDate() {
    let release = Release(version: "0.2.0", page: page)
    #expect(UpdateCheck.status(of: release, current: "") == .upToDate)
  }

  @Test(
    "只认纯数字的版本段",
    arguments: [
      ("v1.2.3", [1, 2, 3] as [Int]?),
      ("1.2", [1, 2]),
      ("1.2.3-beta", nil),
      ("1..3", nil),
      ("+1.0", nil),
      ("", nil),
    ])
  func parsesComponents(version: String, expected: [Int]?) {
    #expect(UpdateCheck.components(version) == expected)
  }
}
