import AppKit
import OSLog
import Observation
import OpenWithPanelCore
import OpenWithPanelPlatform
import UniformTypeIdentifiers

@Observable
final class AppModel {
  let launchServices = SystemLaunchServices()
  let catalog = SystemTypeCatalog()
  let preferences = SystemHandlerPreferences()
  let openWith = SystemOpenWithAttribute()
  let reader = FileHeadReader()
  let layout = AppSupportLayout.standard()
  @ObservationIgnored private let logger = Logger(
    subsystem: "net.zhaojian.openwithpanel", category: "model")

  var configuration = Configuration()
  var staged = Configuration()
  var initial = Snapshot()
  var current = Snapshot()
  var records: [SnapshotRecord] = []
  var ledger = FolderLedger()
  var familyCandidates: [String: [AppInfo]] = [:]
  var typeCandidates: [String: [AppInfo]] = [:]
  var isLoaded = false
  var isBusy = false
  var lastResult: ApplyResult?
  var lastFolderReport: FolderRuleReport?
  var errorMessage: String?
  var resetByUninstall = false

  @ObservationIgnored private var universe: Set<String> = []
  @ObservationIgnored private var apps: [String: AppInfo] = [:]
  @ObservationIgnored private var icons: [String: NSImage] = [:]
  @ObservationIgnored private var typeIcons: [String: NSImage] = [:]
  @ObservationIgnored private var lazyCandidates: [String: [AppInfo]] = [:]

  var store: ConfigurationStore { ConfigurationStore(layout: layout) }
  var snapshots: SnapshotStore { SnapshotStore(directory: layout.snapshots) }
  var helperURL: URL {
    Bundle.main.bundleURL.appendingPathComponent("Contents/Helpers/\(HelperIdentity.appName)")
  }
  var homeDirectory: String { FileManager.default.homeDirectoryForCurrentUser.path }

  var families: [TypeFamily] {
    TypeFamilies.all.filter { !types(of: $0).isEmpty }
  }

  // 用 staged：刚添加、还没应用的扩展名也要显示在组里
  func types(of family: TypeFamily) -> [String] {
    FamilyState.activeTypes(
      of: family, catalog: catalog, custom: staged.customExtensions[family.id] ?? [])
  }

  var pendingChanges: [PlannedChange] {
    Planner.plan(
      configuration: withFallbacks(staged), previous: configuration, current: current,
      initial: initial, members: members)
  }

  // 不能直接用 family.types：系统不认识的类型设不了，只有扩展名的语言要换算成本机的临时类型
  var members: FamilyMembers {
    let catalog = catalog
    return { family, custom in FamilyState.activeTypes(of: family, catalog: catalog, custom: custom)
    }
  }

  var hasPendingEdits: Bool { staged != configuration }

  var managedTypes: [String] {
    Array(Planner.desiredHandlers(for: configuration, members: members).keys)
  }

  var preferenceEntryCount: Int {
    managedTypes.filter { Planner.method(for: $0) == .preferences }.count
  }

  var drift: [PlannedChange] {
    hasPendingEdits || !isLoaded
      ? []
      : DriftDetector.drift(
        configuration: configuration, current: current, initial: initial, members: members)
  }

  // 偏好条目已经指向辅助程序，系统却仍不把无扩展名文件交给它：说明这条路在当前系统上失效了
  var extensionlessRouteBroken: Bool {
    guard isLoaded, configuration.helperTypes.contains("public.data") else { return false }
    let written = current.preferenceHandlers["public.data"].map(isHelper) ?? false
    let routed = current.handlers["public.data"].map(isHelper) ?? false
    return (written && !routed) || lastResult?.rejected["public.data"] != nil
      || lastResult?.failed["public.data"] != nil
  }

  func load() async {
    do {
      try layout.prepare()
      let catalog = catalog
      let installed = await Task.detached { SystemAppCatalog().installedApps() }.value
      universe = SnapshotCapturer.typeUniverse(installedApps: installed, catalog: catalog)
      for app in installed { apps[app.info.bundleID.lowercased()] = app.info }
      // 初始快照必须在动任何东西之前取，并且只取一次
      if !snapshots.hasInitial {
        let snapshot = await capture()
        _ = try snapshots.saveInitial(snapshot, at: .now)
        try preferences.backup(to: snapshots.preferencesBackupURL(SnapshotStore.initialID))
      }
      initial = try snapshots.load(SnapshotStore.initialID).0
      configuration = try store.load()
      staged = configuration
      ledger = try FolderLedger.load(from: layout.folderLedger)
      registerHelperIfNeeded()
      await refresh()
      // 本 App 正在管理的类型不补记，否则会把自己改过的结果当成原状
      let managed = Planner.desiredHandlers(for: configuration, members: members).keys
      var unmanaged = current
      for type in managed { unmanaged.handlers[type] = nil }
      if try !snapshots.supplementInitial(with: unmanaged).isEmpty {
        initial = try snapshots.load(SnapshotStore.initialID).0
      }
      isLoaded = true
      resetByUninstall = FileManager.default.fileExists(atPath: layout.uninstalledMarker.path)
      if resetByUninstall && drift.isEmpty { clearUninstallMarker() }
      // 卸载时保留的文件夹规则要等用户确认恢复后再执行，不在启动时悄悄改文件
      if !resetByUninstall, configuration.folderRules.contains(where: \.isEnabled) {
        await applyFolderRules()
      }
    } catch {
      report(error)
    }
  }

  func refresh() async {
    current = await capture()
    records = snapshots.records()
    let launchServices = launchServices
    let families = families.map { ($0.id, FamilyState.activeTypes(of: $0, catalog: catalog)) }
    let universe = universe
    let (byFamily, byType) = await Task.detached {
      var byType: [String: [AppInfo]] = [:]
      for type in universe.union(["public.plain-text"]) {
        byType[type] = launchServices.candidateApps(forKey: type)
      }
      var byFamily: [String: [AppInfo]] = [:]
      for (id, types) in families {
        // 无扩展名文件经辅助程序转交，任何能打开纯文本的 App 都可以作为目标
        let sources = id == "extensionless" ? types + ["public.plain-text"] : types
        var seen = Set<String>()
        byFamily[id] = sources.flatMap { byType[$0] ?? [] }.filter {
          !$0.matches(bundleID: HelperIdentity.bundleID)
            && seen.insert($0.bundleID.lowercased()).inserted
        }
      }
      return (byFamily, byType)
    }.value
    familyCandidates = byFamily
    typeCandidates = byType
  }

  private func capture() async -> Snapshot {
    let capturer = SnapshotCapturer(launchServices: launchServices, preferences: preferences)
    let universe = universe
    return await Task.detached { capturer.capture(types: universe) }.value
  }

  private func registerHelperIfNeeded() {
    let listed = launchServices.candidateApps(forType: "public.data").contains {
      $0.matches(bundleID: HelperIdentity.bundleID)
    }
    if !listed, !launchServices.register(appAt: helperURL) {
      logger.error("helper registration failed")
    }
  }

  func assign(_ bundleID: String, toFamily family: TypeFamily) {
    staged.familyAssignments[family.id] = bundleID
  }

  func assign(_ bundleID: String, toType type: String) {
    staged.assignments[type] = bundleID
  }

  func assign(_ bundleID: String, toLink kind: LinkKind) {
    staged.linkAssignments[kind.id] = bundleID
  }

  func selection(forLink kind: LinkKind) -> FamilySelection {
    FamilyState.selection(ofLink: kind, configuration: staged, current: current)
  }

  // 「不打开」没有单独的字段，记成指向辅助程序
  func blockLink(_ kind: LinkKind) {
    staged.linkAssignments[kind.id] = HelperIdentity.bundleID
  }

  func isLinkBlocked(_ kind: LinkKind) -> Bool {
    staged.linkAssignments[kind.id].map(isHelper) ?? false
  }

  // 浏览器要同时接管 http 和 https，只能开其中一个的 App 排在后面
  func candidates(forLink kind: LinkKind) -> [AppInfo] {
    let lists = kind.keys.map { candidates(for: $0).filter { !isHelper($0.bundleID) } }
    var seen = Set<String>()
    let all = lists.flatMap { $0 }.filter { seen.insert($0.bundleID.lowercased()).inserted }
    return all.sorted { a, b in
      let countA = lists.filter { $0.contains(a) }.count
      let countB = lists.filter { $0.contains(b) }.count
      return countA > countB
    }
  }

  // 只有一个 App 能处理的链接也列出：还可以选「不打开」
  var links: [LinkKind] {
    LinkKinds.all.filter {
      staged.linkAssignments[$0.id] != nil || !candidates(forLink: $0).isEmpty
    }
  }

  func followFamily(_ type: String) {
    staged.assignments[type] = nil
  }

  func selection(for family: TypeFamily) -> FamilySelection {
    FamilyState.selection(
      of: family, types: FamilyState.activeTypes(of: family, catalog: catalog),
      configuration: staged, current: current)
  }

  func selection(forType type: String, in family: TypeFamily?) -> FamilySelection {
    FamilyState.selection(ofType: type, in: family, configuration: staged, current: current)
  }

  // 临时类型的系统名称分不出是哪种语言，改用扩展名对应的语言名；正式类型用系统的本地化名称
  func formatName(_ type: String) -> String {
    if let scheme = HandlerKey.schemeName(of: type) { return scheme + ":" }
    if let name = catalog.localizedDescription(of: type), !type.hasPrefix("dyn.") { return name }
    let ext = catalog.extensions(of: type).first ?? type
    return languageNames[ext] ?? ext.uppercased()
  }

  func sortedTypes(of family: TypeFamily) -> [String] {
    let types = types(of: family)
    guard family.id == "code" || family.id == "custom" else { return types }
    return types.sorted {
      formatName($0).localizedStandardCompare(formatName($1)) == .orderedAscending
    }
  }

  // 代码组成员太多，按语言族分小节，每节内仍按名称排序
  func codeSections(_ types: [String]) -> [(section: CodeSection, types: [String])] {
    let grouped = Dictionary(grouping: types) { type in
      CodeSection.of(extension: catalog.extensions(of: type).first ?? "")
    }
    return CodeSection.allCases.compactMap { section in
      grouped[section].map { (section, $0) }
    }
  }

  private let languageNames = [
    "go": "Go", "rs": "Rust", "kt": "Kotlin", "kts": "Kotlin Script", "cs": "C#", "dart": "Dart",
    "scala": "Scala", "lua": "Lua", "jsx": "JSX", "cjs": "CommonJS", "vue": "Vue",
    "svelte": "Svelte", "scss": "SCSS", "sass": "Sass", "less": "Less", "ex": "Elixir",
    "erl": "Erlang", "hs": "Haskell", "clj": "Clojure", "zig": "Zig", "jl": "Julia",
    "groovy": "Groovy", "gradle": "Gradle", "ps1": "PowerShell", "fish": "Fish",
    "tf": "Terraform", "graphql": "GraphQL", "sol": "Solidity", "nim": "Nim", "elm": "Elm",
    "coffee": "CoffeeScript",
  ]

  func discardEdits() {
    staged = configuration
  }

  func apply(undoManager: UndoManager?) async {
    let target = withFallbacks(staged)
    let changes = Planner.plan(
      configuration: target, previous: configuration, current: current, initial: initial,
      members: members)
    isBusy = true
    defer { isBusy = false }
    do {
      let record = try snapshots.saveHistory(current, configuration: configuration, at: .now)
      try preferences.backup(to: snapshots.preferencesBackupURL(record.id))
      if changes.contains(where: { $0.bundleID.map(isHelper) ?? false }) {
        registerHelperIfNeeded()
      }
      try supplementInitial(for: changes.map(\.type))
      // 先存配置：登记一生效辅助程序就可能被调起，它读的是磁盘上的配置
      try store.save(target)
      let result = await run(changes)
      // 用户在系统确认框里选了保留原来的 App：把这个格式记成单独设置为原来的 App，
      // 以后改整组也不再碰它，也不会被当成「被抢走」反复提示
      var accepted = target
      for (type, actual) in result.rejected {
        accepted.assignments[type] = actual.isEmpty ? nil : actual
      }
      if accepted != target { try store.save(accepted) }
      configuration = accepted
      staged = accepted
      lastResult = result
      await refresh()
      undoManager?.registerUndo(withTarget: self) { model in
        Task { await model.restore(record.id, keepHistory: false) }
      }
      undoManager?.setActionName(String(localized: "Apply"))
      clearUninstallMarker()
    } catch {
      report(error)
    }
  }

  func restorePreview(_ id: String) -> [HandlerChange] {
    do {
      let snapshot = try snapshots.load(id).0
      return current.changes(to: snapshot).filter { universe.contains($0.type) }
    } catch {
      report(error)
      return []
    }
  }

  // keepHistory 为 false 用于撤销：恢复后删掉这份快照，再撤销就继续往前走。
  // keepConfiguration 用于卸载：只把关联指回去，配置原样留着，失败时 App 还能照常用
  @discardableResult
  func restore(_ id: String, keepHistory: Bool = true, keepConfiguration: Bool = false) async
    -> Bool
  {
    isBusy = true
    defer { isBusy = false }
    do {
      let (snapshot, saved) = try snapshots.load(id)
      if keepHistory {
        let record = try snapshots.saveHistory(current, configuration: configuration, at: .now)
        try preferences.backup(to: snapshots.preferencesBackupURL(record.id))
      }
      let restored = saved ?? Configuration()
      if !keepConfiguration { try store.save(restored) }
      let result = await run(Planner.restore(to: snapshot, from: current))
      if !keepConfiguration {
        configuration = restored
        staged = restored
      }
      if !keepHistory { try snapshots.delete(id) }
      lastResult = result
      await refresh()
      return result.isComplete
    } catch {
      report(error)
      return false
    }
  }

  // 重启 lsd 后要等它就绪，放到后台执行，免得卡住界面
  private func run(_ changes: [PlannedChange]) async -> ApplyResult {
    let applier = Applier(launchServices: launchServices, preferences: preferences)
    return await Task.detached { await applier.apply(changes) }.value
  }

  private func withFallbacks(_ configuration: Configuration) -> Configuration {
    var updated = configuration
    for type in configuration.helperTypes {
      if let original = initial.handlers[type], !isHelper(original) {
        updated.fallbacks[type] = original
      }
    }
    return updated
  }

  var diagnostician: Diagnostician {
    Diagnostician(
      launchServices: launchServices, catalog: catalog, preferences: preferences,
      openWith: openWith, reader: reader, apps: SystemAppCatalog(), homeDirectory: homeDirectory)
  }

  var folderEngine: FolderRuleEngine {
    FolderRuleEngine(
      launchServices: launchServices, catalog: catalog, openWith: openWith, reader: reader)
  }

  var scanner: FolderScanner { FolderScanner(exclusions: configuration.folderExclusions) }

  func diagnose(_ url: URL) -> FileDiagnosis {
    diagnostician.diagnose(url, configuration: configuration)
  }

  func overrides(in directory: URL) async -> [FileOverride] {
    let engine = folderEngine
    let scanner = scanner
    return await Task.detached { engine.overrides(in: directory, scanner: scanner) }.value
  }

  func clearOverrides(_ overrides: [FileOverride]) -> [URL] {
    folderEngine.clear(overrides)
  }

  // OSLogStore 读日志要几秒，不能占主线程
  func reportText(for diagnoses: [FileDiagnosis]) async -> String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    let logLines = await Task.detached { Self.recentLogLines() }.value
    do {
      return try DiagnosticReport.build(
        date: .now, systemVersion: ProcessInfo.processInfo.operatingSystemVersionString,
        appVersion: version, configuration: configuration, current: current,
        diagnoses: diagnoses, logLines: logLines)
    } catch {
      return String(describing: error)
    }
  }

  // 系统只允许 App 读自己这个进程的日志，辅助程序的日志要在「控制台」里按 net.zhaojian.openwithpanel 筛选
  nonisolated private static func recentLogLines() -> [String] {
    do {
      let store = try OSLogStore(scope: .currentProcessIdentifier)
      return try store.getEntries()
        .compactMap { $0 as? OSLogEntryLog }
        .filter { $0.subsystem.hasPrefix("net.zhaojian.openwithpanel") }
        .map { "\($0.date.ISO8601Format()) [\($0.category)] \($0.composedMessage)" }
    } catch {
      return ["log unavailable: \(error.localizedDescription)"]
    }
  }

  func applyFolderRules() async {
    var ledger = ledger
    var total = FolderRuleReport()
    let engine = folderEngine
    let scanner = scanner
    for rule in configuration.folderRules where rule.isEnabled {
      let report = await engine.apply(rule, scanner: scanner, ledger: &ledger)
      total.written += report.written
      total.skippedBinary += report.skippedBinary
      total.skippedUserOverride += report.skippedUserOverride
      total.failed += report.failed
    }
    self.ledger = ledger
    lastFolderReport = total
    saveLedger()
  }

  func undoFolderRules() {
    var ledger = ledger
    let failures = folderEngine.undo(&ledger)
    self.ledger = ledger
    saveLedger()
    if !failures.isEmpty { logger.error("folder undo failed for \(failures.count) files") }
  }

  func saveFolderRules(_ rules: [FolderRule], exclusions: [String]) {
    configuration.folderRules = rules
    configuration.folderExclusions = exclusions
    staged.folderRules = rules
    staged.folderExclusions = exclusions
    do { try store.save(configuration) } catch { report(error) }
  }

  private func saveLedger() {
    do { try ledger.save(to: layout.folderLedger) } catch { report(error) }
  }

  func exportPreset() -> Data? {
    do { return try ConfigurationStore.exportPreset(staged) } catch {
      report(error)
      return nil
    }
  }

  func importPreset(_ data: Data) {
    do {
      staged = try ConfigurationStore.importPreset(data, keepingLocalSettingsOf: configuration)
    } catch {
      report(error)
    }
  }

  // 有类型没恢复成功（被拒绝或出错）就停下，什么都不删：那些类型还指着辅助程序，把 App 移走后就打不开了
  func uninstall(deleteData: Bool) async {
    guard await restore(SnapshotStore.initialID, keepHistory: false, keepConfiguration: true) else {
      errorMessage = String(
        localized:
          "Uninstall stopped because some file types or links couldn’t be restored. Nothing was removed."
      )
      return
    }
    undoFolderRules()
    do {
      if deleteData {
        try FileManager.default.removeItem(at: layout.root)
      } else {
        try Data().write(to: layout.uninstalledMarker)
      }
      try await NSWorkspace.shared.recycle([Bundle.main.bundleURL])
      NSApp.terminate(nil)
    } catch {
      report(error)
    }
  }

  func restoreAfterUninstall() async {
    await apply(undoManager: nil)
    if configuration.folderRules.contains(where: \.isEnabled) {
      await applyFolderRules()
    }
  }

  private func clearUninstallMarker() {
    guard resetByUninstall else { return }
    try? FileManager.default.removeItem(at: layout.uninstalledMarker)
    resetByUninstall = false
  }

  func app(_ bundleID: String) -> AppInfo? {
    let key = bundleID.lowercased()
    if let cached = apps[key] { return cached }
    let found = launchServices.app(bundleID: bundleID)
    apps[key] = found
    return found
  }

  // 用户新加的扩展名第一次被改动前，把它当时的默认 App 补记进初始快照，恢复时才有去处
  private func supplementInitial(for types: [String]) throws {
    var snapshot = Snapshot()
    for type in types where initial.handlers[type] == nil {
      if let app = launchServices.defaultApp(forKey: type) {
        snapshot.handlers[type] = app.bundleID
      }
    }
    if try !snapshots.supplementInitial(with: snapshot).isEmpty {
      initial = try snapshots.load(SnapshotStore.initialID).0
    }
  }

  func addCustomExtension(_ ext: String, to family: TypeFamily) {
    var list = staged.customExtensions[family.id] ?? []
    guard !list.contains(ext) else { return }
    list.append(ext)
    staged.customExtensions[family.id] = list
  }

  func removeCustomExtension(of type: String, from family: TypeFamily) {
    let extensions = Set(catalog.extensions(of: type))
    staged.customExtensions[family.id]?.removeAll { extensions.contains($0) }
    if staged.customExtensions[family.id]?.isEmpty == true {
      staged.customExtensions[family.id] = nil
    }
    staged.assignments[type] = nil
  }

  func isCustom(_ type: String, in family: TypeFamily) -> Bool {
    let custom = staged.customExtensions[family.id] ?? []
    return catalog.extensions(of: type).contains(where: custom.contains)
      && !FamilyState.activeTypes(of: family, catalog: catalog).contains(type)
  }

  func candidates(for type: String) -> [AppInfo] {
    if let cached = typeCandidates[type] ?? lazyCandidates[type] { return cached }
    let found = launchServices.candidateApps(forKey: type)
    lazyCandidates[type] = found
    return found
  }

  func icon(forType type: String) -> NSImage {
    if let cached = typeIcons[type] { return cached }
    let image = UTType(type).map { NSWorkspace.shared.icon(for: $0) } ?? NSImage()
    typeIcons[type] = image
    return image
  }

  func icon(for app: AppInfo) -> NSImage {
    if let cached = icons[app.path] { return cached }
    let image = NSWorkspace.shared.icon(forFile: app.path)
    icons[app.path] = image
    return image
  }

  func appName(_ bundleID: String?) -> String {
    guard let bundleID else { return String(localized: "None") }
    if isHelper(bundleID) { return HelperIdentity.displayName }
    return app(bundleID)?.name ?? bundleID
  }

  func isHelper(_ bundleID: String) -> Bool {
    bundleID.caseInsensitiveCompare(HelperIdentity.bundleID) == .orderedSame
  }

  private func report(_ error: Error) {
    logger.error("\(error.localizedDescription, privacy: .public)")
    errorMessage = error.localizedDescription
  }
}

enum CodeSection: CaseIterable {
  case web
  case systems
  case jvm
  case scripting
  case functional
  case other

  private static let byExtension: [String: CodeSection] = {
    let table: [CodeSection: [String]] = [
      .web: [
        "js", "mjs", "cjs", "jsx", "tsx", "css", "scss", "sass", "less", "vue", "svelte",
        "graphql", "coffee", "elm",
      ],
      .systems: [
        "c", "h", "cpp", "cc", "cxx", "hpp", "hh", "m", "mm", "swift", "rs", "go", "zig", "nim",
        "s", "cs", "dart",
      ],
      .jvm: ["java", "kt", "kts", "scala", "groovy", "gradle", "clj"],
      .scripting: [
        "py", "rb", "pl", "pm", "php", "lua", "sh", "bash", "command", "zsh", "fish", "ps1", "jl",
      ],
      .functional: ["hs", "ex", "erl"],
    ]
    var result: [String: CodeSection] = [:]
    for (section, extensions) in table { for ext in extensions { result[ext] = section } }
    return result
  }()

  static func of(extension ext: String) -> CodeSection { byExtension[ext] ?? .other }
}
