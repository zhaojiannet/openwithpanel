import Foundation
import OpenWithPanelPlatform
import Testing

@testable import OpenWithPanelCore

@Suite("变更计划")
struct PlannerTests {
  let initial = Snapshot(
    handlers: [
      "public.data": "com.apple.TextEdit", "public.png": "com.apple.Preview",
      "public.json": "com.apple.TextEdit",
    ],
    preferenceHandlers: [:])

  @Test("无扩展名文件经辅助程序，走偏好条目")
  func extensionlessRoutesThroughHelper() {
    var configuration = Configuration()
    configuration.assignments["public.data"] = "dev.zed.Zed"
    let plan = Planner.plan(
      configuration: configuration, previous: Configuration(), current: initial, initial: initial)
    #expect(
      plan == [
        PlannedChange(type: "public.data", bundleID: HelperIdentity.bundleID, method: .preferences)
      ])
  }

  @Test("普通类型直接登记给目标 App")
  func concreteTypeGoesDirect() {
    var configuration = Configuration()
    configuration.assignments["public.json"] = "dev.zed.Zed"
    let plan = Planner.plan(
      configuration: configuration, previous: Configuration(), current: initial, initial: initial)
    #expect(
      plan == [PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences)])
  }

  @Test("已经是目标状态的类型不重复设置，bundle id 大小写不敏感")
  func skipsUnchanged() {
    var configuration = Configuration()
    configuration.assignments["public.png"] = "COM.APPLE.PREVIEW"
    #expect(
      Planner.plan(
        configuration: configuration, previous: Configuration(), current: initial, initial: initial
      ).isEmpty)
  }

  @Test("被规则覆盖的普通类型改经辅助程序")
  func ruleCoveredTypeUsesHelper() {
    var configuration = Configuration()
    configuration.assignments["public.json"] = "dev.zed.Zed"
    configuration.rules = [
      Rule(name: "w", pathPrefix: "/w", contentTypes: ["public.json"], target: .app(bundleID: "x"))
    ]
    let plan = Planner.plan(
      configuration: configuration, previous: Configuration(), current: initial, initial: initial)
    #expect(
      plan == [
        PlannedChange(type: "public.json", bundleID: HelperIdentity.bundleID, method: .preferences)
      ])
  }

  @Test("取消分配时指回初始快照：偏好条目删除，普通类型改回原 App")
  func releasedTypesReturnToInitial() {
    var previous = Configuration()
    previous.assignments = ["public.data": "dev.zed.Zed", "public.json": "dev.zed.Zed"]
    let current = Snapshot(
      handlers: [
        "public.data": HelperIdentity.bundleID, "public.json": "dev.zed.Zed",
        "public.png": "com.apple.Preview",
      ],
      preferenceHandlers: ["public.data": HelperIdentity.bundleID])
    let plan = Planner.plan(
      configuration: Configuration(), previous: previous, current: current, initial: initial)
    #expect(
      plan == [
        PlannedChange(type: "public.data", bundleID: nil, method: .preferences),
        PlannedChange(type: "public.json", bundleID: "com.apple.TextEdit", method: .preferences),
      ])
  }

  @Test("恢复快照只改有差异的类型")
  func restoreOnlyDifferences() {
    let current = Snapshot(
      handlers: [
        "public.data": HelperIdentity.bundleID, "public.png": "com.apple.Preview",
        "public.json": "dev.zed.Zed",
      ],
      preferenceHandlers: ["public.data": HelperIdentity.bundleID])
    #expect(
      Planner.restore(to: initial, from: current) == [
        PlannedChange(type: "public.data", bundleID: nil, method: .preferences),
        PlannedChange(type: "public.json", bundleID: "com.apple.TextEdit", method: .preferences),
      ])
  }

  @Test("网页文件和网址协议一样走系统接口，让用户在系统确认框里确认")
  func webTypesUseWorkspace() {
    var configuration = Configuration()
    configuration.assignments["public.html"] = "dev.zed.Zed"
    configuration.assignments["public.json"] = "dev.zed.Zed"
    let plan = Planner.plan(
      configuration: configuration, previous: Configuration(), current: initial, initial: initial)
    #expect(
      plan == [
        PlannedChange(type: "public.html", bundleID: "dev.zed.Zed", method: .workspace),
        PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences),
      ])
  }

  @Test("漂移检测发现被其他 App 抢走的关联")
  func detectsDrift() {
    var configuration = Configuration()
    configuration.assignments["public.json"] = "dev.zed.Zed"
    let current = Snapshot(handlers: ["public.json": "com.apple.dt.Xcode"])
    #expect(
      DriftDetector.drift(configuration: configuration, current: current, initial: initial) == [
        PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences)
      ])
  }
}

@Suite("执行与核对")
struct ApplierTests {
  func make() -> (FakeLaunchServices, FakePreferences, Applier) {
    let ls = FakeLaunchServices(
      apps: TestApps.all,
      defaults: [
        "public.json": "com.apple.TextEdit", "public.data": "com.apple.TextEdit",
        "scheme:mailto": "com.apple.TextEdit",
      ])
    let prefs = FakePreferences()
    prefs.launchServices = ls
    return (ls, prefs, Applier(launchServices: ls, preferences: prefs))
  }

  @Test("文件类型一次写完偏好条目、只重启一次 lsd，不调系统接口；网址协议走系统接口")
  func preferencesFirstThenWorkspace() async {
    let (ls, prefs, applier) = make()
    let result = await applier.apply([
      PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences),
      PlannedChange(type: "public.data", bundleID: HelperIdentity.bundleID, method: .preferences),
      PlannedChange(type: "scheme:mailto", bundleID: "dev.zed.Zed", method: .workspace),
    ])
    #expect(result.isComplete)
    #expect(Set(result.applied) == ["public.json", "public.data", "scheme:mailto"])
    #expect(prefs.reloads == 1)
    #expect(ls.setCalls == ["scheme:mailto"])
    #expect(prefs.entries["public.json"] == "dev.zed.zed")
  }

  @Test("偏好条目没生效的普通类型改用系统接口再设")
  func fallsBackToWorkspace() async {
    let (ls, prefs, applier) = make()
    prefs.ignored = ["public.json"]
    let result = await applier.apply([
      PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences)
    ])
    #expect(ls.setCalls == ["public.json"])
    #expect(result.applied == ["public.json"])
    #expect(ls.defaults["public.json"] == "dev.zed.Zed")
  }

  @Test("偏好文件写不进去时，普通类型改用系统接口，被锁定的类型记为失败")
  func writeFailureFallsBack() async {
    let (ls, prefs, applier) = make()
    prefs.failsToWrite = true
    let result = await applier.apply([
      PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences),
      PlannedChange(type: "public.data", bundleID: HelperIdentity.bundleID, method: .preferences),
    ])
    #expect(ls.setCalls == ["public.json"])
    #expect(result.applied == ["public.json"])
    #expect(result.failed.keys.sorted() == ["public.data"])
    #expect(prefs.reloads == 0)
  }

  @Test("退回系统接口后用户在确认框里拒绝，记为未生效并给出实际 App")
  func declinedIsReported() async {
    let (ls, prefs, applier) = make()
    prefs.ignored = ["public.json"]
    ls.declined = ["public.json"]
    let result = await applier.apply([
      PlannedChange(type: "public.json", bundleID: "dev.zed.Zed", method: .preferences)
    ])
    #expect(result.rejected == ["public.json": "com.apple.TextEdit"])
    #expect(result.applied.isEmpty)
  }

  @Test("被锁定的类型没有退路，偏好条目没生效就记为未生效")
  func lockedTypeHasNoFallback() async {
    let (ls, prefs, applier) = make()
    prefs.ignored = ["public.data"]
    let result = await applier.apply([
      PlannedChange(type: "public.data", bundleID: HelperIdentity.bundleID, method: .preferences)
    ])
    #expect(ls.setCalls.isEmpty)
    #expect(result.rejected == ["public.data": "com.apple.TextEdit"])
  }

  @Test("找不到目标 App 时记为失败，不调用系统接口")
  func missingAppFails() async {
    let (ls, _, applier) = make()
    let result = await applier.apply([
      PlannedChange(type: "scheme:mailto", bundleID: "no.such.App", method: .workspace)
    ])
    #expect(result.failed.keys.contains("scheme:mailto"))
    #expect(ls.setCalls.isEmpty)
  }
}

@Suite("链接")
struct LinkTests {
  let safari = AppInfo(
    bundleID: "com.apple.Safari", name: "Safari", path: "/Applications/Safari.app")
  let brave = AppInfo(
    bundleID: "com.brave.Browser", name: "Brave", path: "/Applications/Brave Browser.app")

  @Test("浏览器一项同时计划 http 和 https，走系统接口")
  func webPlansBothSchemes() {
    var configuration = Configuration()
    configuration.linkAssignments["web"] = "com.brave.Browser"
    let current = Snapshot(handlers: ["scheme:http": "com.apple.Safari"])
    #expect(
      Planner.plan(
        configuration: configuration, previous: Configuration(), current: current,
        initial: current) == [
          PlannedChange(type: "scheme:http", bundleID: "com.brave.Browser", method: .workspace),
          PlannedChange(type: "scheme:https", bundleID: "com.brave.Browser", method: .workspace),
        ])
  }

  @Test("「不打开」把这类链接的协议指给辅助程序，界面按设置显示")
  func blockedLinkPointsAtHelper() {
    var configuration = Configuration()
    configuration.linkAssignments["phone"] = HelperIdentity.bundleID
    let current = Snapshot(handlers: ["scheme:tel": "com.apple.mobilephone"])
    #expect(
      Planner.plan(
        configuration: configuration, previous: Configuration(), current: current,
        initial: current) == [
          PlannedChange(type: "scheme:tel", bundleID: HelperIdentity.bundleID, method: .workspace)
        ])
    let phone = LinkKinds.all.first { $0.id == "phone" }!
    let blocked = Snapshot(handlers: ["scheme:tel": HelperIdentity.bundleID])
    #expect(
      FamilyState.selection(ofLink: phone, configuration: configuration, current: blocked)
        == .app(HelperIdentity.bundleID.lowercased()))
  }

  @Test("系统改 http 时连带改了 https，就不再设第二次")
  func linkedSchemeNotSetTwice() async {
    let ls = FakeLaunchServices(
      apps: [safari, brave],
      defaults: ["scheme:http": "com.apple.Safari", "scheme:https": "com.apple.Safari"])
    ls.linked = ["http": "https"]
    let result = await Applier(launchServices: ls, preferences: FakePreferences()).apply([
      PlannedChange(type: "scheme:http", bundleID: "com.brave.Browser", method: .workspace),
      PlannedChange(type: "scheme:https", bundleID: "com.brave.Browser", method: .workspace),
    ])
    #expect(ls.setCalls == ["scheme:http"])
    #expect(result.applied == ["scheme:http", "scheme:https"])
    #expect(result.isComplete)
  }

  @Test("快照采集协议的默认 App，duti 格式写成两列并能读回")
  func snapshotsSchemes() {
    let ls = FakeLaunchServices(apps: [safari], defaults: ["scheme:http": "com.apple.Safari"])
    let snapshot = SnapshotCapturer(launchServices: ls, preferences: FakePreferences())
      .capture(types: ["scheme:http", "scheme:mailto"])
    #expect(snapshot.handlers == ["scheme:http": "com.apple.Safari"])
    let text = DutiFormat.encode(snapshot.handlers)
    #expect(text == "com.apple.Safari\thttp\n")
    #expect(DutiFormat.decode(text) == snapshot.handlers)
  }

  @Test("没设过时按两个协议当前的 App 显示，不一致显示为混合")
  func selectionFollowsCurrent() {
    let web = LinkKinds.all.first { $0.id == "web" }!
    let same = Snapshot(handlers: ["scheme:http": "a", "scheme:https": "A"])
    let mixed = Snapshot(handlers: ["scheme:http": "a", "scheme:https": "b"])
    #expect(
      FamilyState.selection(ofLink: web, configuration: Configuration(), current: same)
        == .app("a"))
    #expect(
      FamilyState.selection(ofLink: web, configuration: Configuration(), current: mixed) == .mixed)
  }

  @Test("旧配置文件没有 linkAssignments 也能读")
  func decodesOldConfiguration() throws {
    let data = Data(#"{"version":1,"assignments":{"public.json":"x"}}"#.utf8)
    let configuration = try JSONDecoder().decode(Configuration.self, from: data)
    #expect(configuration.linkAssignments.isEmpty)
    #expect(configuration.assignments == ["public.json": "x"])
  }
}
