import SwiftUI

// 字号层级取自 HIG 的 macOS 文字样式：正文默认 13pt，最小 10pt。中文在 10pt 下难以辨认，
// 说明文字最小用到 12pt，标签 11pt
enum Typography {
  static let sectionTitle = Font.title3.weight(.semibold)
  static let rowTitle = Font.title3
  static let itemTitle = Font.body
  static let detail = Font.callout
  static let badge = Font.subheadline.weight(.medium)
  static let subheader = Font.subheadline.weight(.semibold)
  static let identifier = Font.subheadline.monospaced()
}
