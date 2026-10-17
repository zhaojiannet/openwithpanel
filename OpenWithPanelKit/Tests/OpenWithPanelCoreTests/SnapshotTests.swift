import Foundation
import OpenWithPanelPlatform
import Testing

@testable import OpenWithPanelCore

@Suite("快照")
struct SnapshotTests {
  @Test("duti 格式往返一致，注释和空行被忽略")
  func dutiRoundTrip() {
    let handlers = ["public.data": "com.apple.TextEdit", "public.png": "com.apple.Preview"]
    let text = DutiFormat.encode(handlers, header: "hello")
    #expect(text.hasPrefix("# hello\n"))
    #expect(text.contains("com.apple.Preview\tpublic.png\tall"))
    #expect(DutiFormat.decode(text + "\n\n# c\n") == handlers)
  }

  @Test("初始快照只写一次，之后不覆盖")
  func initialWrittenOnce() throws {
    let store = SnapshotStore(directory: try temporaryDirectory())
    #expect(try store.saveInitial(Snapshot(handlers: ["a": "x"]), at: Date()) != nil)
    #expect(try store.saveInitial(Snapshot(handlers: ["a": "y"]), at: Date()) == nil)
    #expect(try store.load(SnapshotStore.initialID).0.handlers == ["a": "x"])
  }

  @Test("初始快照只追加缺少的类型，已有记录不改，表头保留")
  func supplementInitialAddsOnly() throws {
    let store = SnapshotStore(directory: try temporaryDirectory())
    _ = try store.saveInitial(Snapshot(handlers: ["a": "x"]), at: Date(timeIntervalSince1970: 0))
    let added = try store.supplementInitial(with: Snapshot(handlers: ["a": "CHANGED", "b": "y"]))
    #expect(added == ["b"])
    #expect(try store.load(SnapshotStore.initialID).0.handlers == ["a": "x", "b": "y"])
    let text = try String(
      contentsOf: store.folder(SnapshotStore.initialID).appendingPathComponent("handlers.duti"),
      encoding: .utf8)
    #expect(text.hasPrefix("# OpenWithPanel snapshot 1970-01-01T00:00:00Z\n"))
    #expect(try store.supplementInitial(with: Snapshot(handlers: ["b": "z"])).isEmpty)
  }

  @Test("历史快照按时间倒序，超过上限删最旧的，初始快照不受影响")
  func historyPruned() throws {
    let store = SnapshotStore(directory: try temporaryDirectory(), historyLimit: 2)
    _ = try store.saveInitial(Snapshot(handlers: ["a": "i"]), at: Date(timeIntervalSince1970: 0))
    for i in 1...3 {
      var configuration = Configuration()
      configuration.assignments["a"] = "c\(i)"
      _ = try store.saveHistory(
        Snapshot(handlers: ["a": "h\(i)"], preferenceHandlers: ["public.data": "p\(i)"]),
        configuration: configuration, at: Date(timeIntervalSince1970: Double(i) * 100))
    }
    let history = store.records().filter { $0.kind == .history }
    #expect(history.count == 2)
    let (snapshot, configuration) = try store.load(store.latestHistory()!.id)
    #expect(snapshot == Snapshot(handlers: ["a": "h3"], preferenceHandlers: ["public.data": "p3"]))
    #expect(configuration?.assignments["a"] == "c3")
    #expect(store.hasInitial)
  }

  @Test("差异列表只含变化的类型")
  func changes() {
    let a = Snapshot(handlers: ["x": "A", "y": "B"])
    let b = Snapshot(handlers: ["x": "a", "y": "C", "z": "D"])
    #expect(
      a.changes(to: b) == [
        HandlerChange(type: "y", from: "B", to: "C"), HandlerChange(type: "z", from: nil, to: "D"),
      ])
  }

  @Test("采集快照只记录被锁定类型的偏好条目")
  func captureLockedPreferences() {
    let ls = FakeLaunchServices(
      apps: TestApps.all,
      defaults: ["public.png": "com.apple.Preview", "public.data": "com.apple.TextEdit"])
    let prefs = FakePreferences()
    prefs.entries = [
      "public.data": "net.zhaojian.openwithpanel.helper", "public.png": "com.apple.preview",
    ]
    let snapshot = SnapshotCapturer(launchServices: ls, preferences: prefs).capture(types: [
      "public.png", "public.data", "public.json",
    ])
    #expect(
      snapshot.handlers == ["public.png": "com.apple.Preview", "public.data": "com.apple.TextEdit"])
    #expect(snapshot.preferenceHandlers == ["public.data": "net.zhaojian.openwithpanel.helper"])
  }
}

@Suite("配置存储")
struct ConfigurationStoreTests {
  @Test("保存后读回一致，缺文件时返回默认配置")
  func roundTrip() throws {
    let store = ConfigurationStore(
      layout: AppSupportLayout(root: try temporaryDirectory().appendingPathComponent("app")))
    #expect(try store.load() == Configuration())
    var configuration = Configuration()
    configuration.assignments["public.data"] = "dev.zed.Zed"
    configuration.rules = [Rule(name: "r", namePattern: "*.env", target: .app(bundleID: "x"))]
    try store.save(configuration)
    #expect(try store.load() == configuration)
    #expect(FileManager.default.fileExists(atPath: store.layout.uninstallNote.path))
  }

  @Test("预设不带交还目标和文件夹规则，导入时保留本机的")
  func presetsKeepLocalSettings() throws {
    var exported = Configuration()
    exported.assignments["public.data"] = "dev.zed.Zed"
    exported.fallbacks["public.data"] = "other.machine"
    exported.folderRules = [FolderRule(path: "/elsewhere", targetBundleID: "x")]
    let data = try ConfigurationStore.exportPreset(exported)
    #expect(try JSONDecoder().decode(Configuration.self, from: data).folderRules.isEmpty)

    var local = Configuration()
    local.fallbacks["public.data"] = "com.apple.TextEdit"
    local.folderRules = [FolderRule(path: "/mine", targetBundleID: "y")]
    let imported = try ConfigurationStore.importPreset(
      ConfigurationStore.encode(exported), keepingLocalSettingsOf: local)
    #expect(imported.assignments == exported.assignments)
    #expect(imported.fallbacks == local.fallbacks)
    #expect(imported.folderRules == local.folderRules)
  }
}
