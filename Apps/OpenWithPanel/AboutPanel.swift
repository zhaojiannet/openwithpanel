import AppKit

// 标准关于窗口已经显示图标、名称、版本和 Info.plist 里的版权行，credits 里不要重复
enum AboutPanel {
  static let repository = URL(string: "https://github.com/zhaojiannet/openwithpanel")!
  static let website = URL(string: "https://www.zhaojian.net")!

  static func show() {
    NSApp.orderFrontStandardAboutPanel(options: [.credits: credits])
    NSApp.activate()
  }

  private static var credits: NSAttributedString {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    paragraph.paragraphSpacing = 6
    let base: [NSAttributedString.Key: Any] = [
      .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
      .foregroundColor: NSColor.secondaryLabelColor,
      .paragraphStyle: paragraph,
    ]
    let text = NSMutableAttributedString()
    func append(_ string: String, link: URL? = nil) {
      var attributes = base
      if let link { attributes[.link] = link }
      text.append(NSAttributedString(string: string, attributes: attributes))
    }
    append(
      String(
        localized:
          "Set which app opens what on your Mac — including the files macOS won’t let you.")
        + "\n")
    append("github.com/zhaojiannet/openwithpanel", link: repository)
    append("\n")
    append("zhaojian.net", link: website)
    return text
  }
}
