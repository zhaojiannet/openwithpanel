import AppKit
import OSLog
import OpenWithPanelCore

// 本 App 唯一联网的地方，只在用户从菜单点「检查更新」时运行，不在后台自动检查
enum UpdateChecker {
  private static let logger = Logger(subsystem: "net.zhaojian.openwithpanel", category: "update")
  private static var isChecking = false

  static func check() async {
    guard !isChecking else { return }
    isChecking = true
    defer { isChecking = false }
    let current =
      Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    let alert = NSAlert()
    do {
      // 检查期间再点菜单不会有反应，超时不能用默认的 60 秒
      var request = URLRequest(url: UpdateCheck.latestRelease, timeoutInterval: 15)
      request.cachePolicy = .reloadIgnoringLocalCacheData
      request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
      let (data, response) = try await URLSession.shared.data(for: request)
      let code = (response as? HTTPURLResponse)?.statusCode ?? 0
      guard code == 200 else { throw ServerStatus(code: code) }
      switch UpdateCheck.status(of: try UpdateCheck.release(from: data), current: current) {
      case .upToDate:
        alert.messageText = String(localized: "OpenWithPanel is up to date")
        alert.informativeText = String(localized: "Version \(current) is the latest version.")
      case .available(let release):
        alert.messageText = String(localized: "OpenWithPanel \(release.version) is available")
        alert.informativeText = String(localized: "You have version \(current).")
        alert.addButton(withTitle: String(localized: "Download"))
        alert.addButton(withTitle: String(localized: "Later"))
        NSApp.activate()
        if alert.runModal() == .alertFirstButtonReturn { NSWorkspace.shared.open(release.page) }
        return
      }
    } catch {
      // 错误描述里可能带网址等细节，日志只记域和错误码
      let nsError = error as NSError
      logger.error(
        "update check failed: \(nsError.domain, privacy: .public) \(nsError.code, privacy: .public)"
      )
      alert.alertStyle = .warning
      alert.messageText = String(localized: "Couldn’t check for updates")
      alert.informativeText = error.localizedDescription
    }
    NSApp.activate()
    alert.runModal()
  }

  // 匿名请求每小时限 60 次，超了 GitHub 返回 403；系统自带的描述只有错误码，用户看不懂。
  // errorCode 用状态码，日志里记的就是它
  private nonisolated struct ServerStatus: LocalizedError, CustomNSError {
    let code: Int

    var errorCode: Int { code }
    var errorDescription: String? {
      String(localized: "GitHub didn’t respond as expected (status \(code)). Try again later.")
    }
  }
}
