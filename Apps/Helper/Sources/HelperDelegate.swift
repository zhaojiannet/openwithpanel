import AppKit
import OpenWithPanelCore
import OpenWithPanelPlatform
import os

@main
final class HelperDelegate: NSObject, NSApplicationDelegate {
  private let logger = Logger(subsystem: "net.zhaojian.openwithpanel.helper", category: "route")
  private let launchServices = SystemLaunchServices()
  private let inspector = FileInspector(catalog: SystemTypeCatalog(), reader: FileHeadReader())
  private var receivedFiles = false
  private var pending = 0
  private var exitTask: Task<Void, Never>?

  static func main() {
    let app = NSApplication.shared
    let delegate = HelperDelegate()
    app.delegate = delegate
    app.run()
  }

  func application(_ application: NSApplication, open urls: [URL]) {
    receivedFiles = true
    pending += 1
    exitTask?.cancel()
    let router = HelperRouter(
      configuration: loadConfiguration(),
      homeDirectory: FileManager.default.homeDirectoryForCurrentUser.path)
    var byApp: [String: [URL]] = [:]
    var reveal: [URL] = []
    // 链接只有在用户选了「不打开」时才会指到这里
    for url in urls where !url.isFileURL {
      logger.info("link ignored: \(url.scheme ?? "-", privacy: .public)")
    }
    for url in urls where url.isFileURL {
      let decision = router.decide(inspector.facts(for: url))
      logger.info(
        "\(url.lastPathComponent, privacy: .private): \(Self.publicDescription(decision), privacy: .public)"
      )
      switch decision {
      // 配置被改成指向辅助程序自己会无限转交，按无路可走处理
      case .open(let bundleID, _)
      where bundleID.caseInsensitiveCompare(HelperIdentity.bundleID) != .orderedSame:
        byApp[bundleID, default: []].append(url)
      case .open, .reveal:
        reveal.append(url)
      }
    }
    Task {
      for (bundleID, files) in byApp {
        guard let app = launchServices.app(bundleID: bundleID) else {
          logger.error("target app not found: \(bundleID, privacy: .public)")
          reveal += files
          continue
        }
        do {
          _ = try await NSWorkspace.shared.open(
            files, withApplicationAt: app.url, configuration: NSWorkspace.OpenConfiguration())
        } catch {
          logger.error("open failed: \(error.localizedDescription, privacy: .public)")
          reveal += files
        }
      }
      if !reveal.isEmpty { NSWorkspace.shared.activateFileViewerSelecting(reveal) }
      pending -= 1
      scheduleExit()
    }
  }

  // 规则名是用户自己写的，可能含项目名或路径，日志里只留规则 id；其余字段只有 bundle id 和类型标识
  private static func publicDescription(_ decision: RouteDecision) -> String {
    switch decision {
    case .open(let bundleID, .rule(let id, _)): "open(bundleID: \(bundleID), rule: \(id))"
    case .reveal(.rule(let id, _)): "reveal(rule: \(id))"
    default: String(describing: decision)
    }
  }

  // 处理完不马上退出：连续打开几个文件时，后到的请求会发给正在退出的进程，
  // 系统报 -600，文件就丢了。空闲一小段时间、确认没有新文件再退出
  private func scheduleExit() {
    exitTask?.cancel()
    exitTask = Task {
      try? await Task.sleep(for: .milliseconds(800))
      guard !Task.isCancelled, pending == 0 else { return }
      NSApp.terminate(nil)
    }
  }

  // 启动时带的文件会在这之前送达；直接双击辅助程序本身时没有文件，不能一直挂着
  func applicationDidFinishLaunching(_ notification: Notification) {
    if !receivedFiles { NSApp.terminate(nil) }
  }

  // 配置读不到时用空配置，所有文件都在 Finder 中高亮，至少不会丢
  private func loadConfiguration() -> Configuration {
    do {
      return try ConfigurationStore(layout: .standard()).load()
    } catch {
      logger.error("configuration unreadable: \(error.localizedDescription, privacy: .public)")
      return Configuration()
    }
  }
}
