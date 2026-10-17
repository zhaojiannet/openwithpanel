import Foundation
import OpenWithPanelPlatform
import Testing

@testable import OpenWithPanelCore

@Suite("类型族状态")
struct FamilyStateTests {
  let config = TypeFamilies.all.first { $0.id == "config" }!
  let types = ["public.json", "public.xml", "public.yaml"]

  @Test("没设整组时，各格式实际的 App 相同就显示该 App，没有 App 的格式不参与比较")
  func uniform() {
    let current = Snapshot(handlers: [
      "public.json": "com.apple.TextEdit", "public.xml": "COM.APPLE.TEXTEDIT",
    ])
    #expect(
      FamilyState.selection(
        of: config, types: types, configuration: Configuration(), current: current)
        == .app("com.apple.textedit"))
  }

  @Test("整组 App 优先显示；单独设过的格式不影响整组的显示")
  func familyAssignmentShown() {
    var configuration = Configuration()
    configuration.familyAssignments["config"] = "dev.zed.Zed"
    configuration.assignments["public.json"] = "com.apple.TextEdit"
    let current = Snapshot(handlers: ["public.xml": "com.apple.dt.Xcode"])
    #expect(
      FamilyState.selection(
        of: config, types: types, configuration: configuration, current: current)
        == .app("dev.zed.zed"))
  }

  @Test("单个格式：单独设置优先，其次跟随整组，都没有时看实际")
  func typeSelection() {
    var configuration = Configuration()
    configuration.familyAssignments["config"] = "dev.zed.Zed"
    configuration.assignments["public.json"] = "com.apple.TextEdit"
    let current = Snapshot(handlers: ["public.png": "com.apple.Preview"])
    #expect(
      FamilyState.selection(
        ofType: "public.json", in: config, configuration: configuration, current: current)
        == .app("com.apple.textedit"))
    #expect(
      FamilyState.selection(
        ofType: "public.xml", in: config, configuration: configuration, current: current)
        == .app("dev.zed.zed"))
    #expect(
      FamilyState.selection(
        ofType: "public.png", in: nil, configuration: configuration, current: current)
        == .app("com.apple.preview"))
    #expect(configuration.isOverridden("public.json"))
    #expect(!configuration.isOverridden("public.xml"))
  }

  @Test("没设整组且各格式实际的 App 不同时显示混合")
  func mixed() {
    let current = Snapshot(handlers: [
      "public.json": "com.apple.TextEdit", "public.xml": "com.apple.dt.Xcode",
    ])
    #expect(
      FamilyState.selection(
        of: config, types: types, configuration: Configuration(), current: current)
        == .mixed)
  }

  @Test("辅助程序不作为可见的 App，没有分配时视为无")
  func helperHidden() {
    let current = Snapshot(handlers: ["public.data": HelperIdentity.bundleID])
    #expect(
      FamilyState.selection(
        ofType: "public.data", in: nil, configuration: Configuration(), current: current)
        == .none)
  }

  @Test("合并后的分配：整组覆盖组内全部可用格式，单独设置覆盖整组，不可用的格式跳过")
  func effectiveAssignments() {
    var configuration = Configuration()
    configuration.familyAssignments["config"] = "dev.zed.Zed"
    configuration.assignments["public.json"] = "com.apple.TextEdit"
    let effective = configuration.effectiveAssignments { family, _ in
      family.types.filter { $0 != "public.toml" }
    }
    #expect(effective["public.json"] == "com.apple.TextEdit")
    #expect(effective["public.xml"] == "dev.zed.Zed")
    #expect(effective["public.toml"] == nil)
  }

  @Test("改整组 App 时单独设过的格式不受影响，清掉例外后回到跟随整组")
  func overrideSurvivesFamilyChange() {
    var configuration = Configuration()
    configuration.familyAssignments["config"] = "dev.zed.Zed"
    configuration.assignments["public.json"] = "com.apple.TextEdit"
    configuration.familyAssignments["config"] = "com.microsoft.VSCode"
    #expect(configuration.assignment(for: "public.json") == "com.apple.TextEdit")
    #expect(configuration.assignment(for: "public.xml") == "com.microsoft.VSCode")
    configuration.assignments["public.json"] = nil
    #expect(configuration.assignment(for: "public.json") == "com.microsoft.VSCode")
  }

  @Test("按扩展名列出的成员换算成本机类型，未登记的正式类型被去掉，重复的只留一份")
  func activeTypesResolveExtensions() {
    let code = TypeFamilies.all.first { $0.id == "code" }!
    let catalog = FakeCatalog(
      declared: ["public.swift-source"],
      byExtension: ["go": "dyn.go", "rs": "dyn.rs", "kt": "public.swift-source"])
    let types = FamilyState.activeTypes(of: code, catalog: catalog)
    #expect(types.first == "public.swift-source")
    #expect(types.contains("dyn.go") && types.contains("dyn.rs"))
    #expect(types.filter { $0 == "public.swift-source" }.count == 1)
    #expect(!types.contains("public.python-script"))
  }

  @Test("整组分配按实际成员覆盖临时类型，计划为它们写偏好条目")
  func familyAssignmentCoversDynamicTypes() {
    var configuration = Configuration()
    configuration.familyAssignments["code"] = "dev.zed.Zed"
    let members: FamilyMembers = { family, _ in family.id == "code" ? ["dyn.go"] : [] }
    let plan = Planner.plan(
      configuration: configuration, previous: Configuration(), current: Snapshot(),
      initial: Snapshot(), members: members)
    #expect(plan == [PlannedChange(type: "dyn.go", bundleID: "dev.zed.Zed", method: .preferences)])
    #expect(
      FamilyState.selection(
        ofType: "dyn.go", in: TypeFamilies.all.first { $0.id == "code" },
        configuration: configuration,
        current: Snapshot()) == .app("dev.zed.zed"))
  }

  @Test("自定义扩展名并入所选组的成员，已有的不重复")
  func customExtensionsJoinFamily() {
    let code = TypeFamilies.all.first { $0.id == "code" }!
    let catalog = FakeCatalog(
      declared: ["public.swift-source"],
      byExtension: ["nim": "dyn.nim", "swift": "public.swift-source"])
    let types = FamilyState.activeTypes(of: code, catalog: catalog, custom: ["nim", "swift"])
    #expect(types.contains("dyn.nim"))
    #expect(types.filter { $0 == "public.swift-source" }.count == 1)
  }

  @Test("删掉的自定义扩展名会被释放回初始快照的 App")
  func removedCustomExtensionIsReleased() {
    var previous = Configuration()
    previous.familyAssignments["code"] = "dev.zed.Zed"
    previous.customExtensions["code"] = ["nim"]
    var target = previous
    target.customExtensions["code"] = []
    let members: FamilyMembers = { family, custom in
      family.id == "code" ? custom.map { "dyn." + $0 } : []
    }
    let current = Snapshot(handlers: ["dyn.nim": "dev.zed.Zed"])
    let initial = Snapshot(handlers: ["dyn.nim": "com.apple.TextEdit"])
    let plan = Planner.plan(
      configuration: target, previous: previous, current: current, initial: initial,
      members: members)
    #expect(
      plan == [PlannedChange(type: "dyn.nim", bundleID: "com.apple.TextEdit", method: .preferences)]
    )
  }

  @Test("扩展名去掉点号、星号和空白并转小写")
  func normalizesExtension() {
    #expect(FamilyState.normalizedExtension(" *.NIM ") == "nim")
    #expect(FamilyState.normalizedExtension(".env") == "env")
  }

  @Test("推荐分组：已在某组的返回那组，源代码推荐代码组，认不出的推荐自定义")
  func suggestsFamily() {
    let catalog = FakeCatalog(
      parents: [
        "dyn.nim": ["public.data"], "org.nim.source": ["public.source-code", "public.text"],
      ],
      declared: ["public.swift-source"],
      byExtension: ["swift": "public.swift-source", "nim": "org.nim.source", "xyz": "dyn.xyz"])
    let members: (TypeFamily) -> [String] = { FamilyState.activeTypes(of: $0, catalog: catalog) }
    let swift = FamilyState.suggestedFamily(
      forExtension: "swift", catalog: catalog, members: members)
    #expect(swift?.family.id == "code" && swift?.alreadyIncluded == true)
    let nim = FamilyState.suggestedFamily(forExtension: "nim", catalog: catalog, members: members)
    #expect(nim?.family.id == "code" && nim?.alreadyIncluded == false)
    let xyz = FamilyState.suggestedFamily(forExtension: "xyz", catalog: catalog, members: members)
    #expect(xyz?.family.id == "custom")
    #expect(
      FamilyState.suggestedFamily(forExtension: "", catalog: catalog, members: members) == nil)
  }

  @Test("缺少整组字段的旧配置文件照常读取")
  func decodesOlderConfiguration() throws {
    let json = Data(#"{"assignments":{"public.data":"dev.zed.Zed"},"rules":[]}"#.utf8)
    let configuration = try JSONDecoder().decode(Configuration.self, from: json)
    #expect(configuration.customExtensions.isEmpty)
    #expect(configuration.assignments == ["public.data": "dev.zed.Zed"])
    #expect(configuration.familyAssignments.isEmpty)
    #expect(configuration.folderExclusions == Configuration.defaultExclusions)
  }

  @Test("辅助程序路由按单独设置、整组的顺序找目标")
  func routerUsesFamilyAssignment() {
    var configuration = Configuration()
    configuration.familyAssignments["extensionless"] = "dev.zed.Zed"
    let router = HelperRouter(configuration: configuration, homeDirectory: "/Users/u")
    let facts = FileFacts(path: "/x/.env", contentType: "public.data", supertypes: [], kind: .text)
    #expect(
      router.decide(facts)
        == .open(bundleID: "dev.zed.Zed", reason: .assignment(type: "public.data")))
    #expect(configuration.helperTypes == ["public.data"])
  }

  @Test("只统计工作区方式的确认框次数")
  func confirmationCount() {
    let changes = [
      PlannedChange(type: "a", bundleID: "x", method: .workspace),
      PlannedChange(type: "public.data", bundleID: "y", method: .preferences),
      PlannedChange(type: "b", bundleID: "x", method: .workspace),
    ]
    #expect(changes.confirmationCount == 2)
  }

  @Test("目录按文本处理，读不了的文件按二进制处理")
  func inspectorKinds() throws {
    let dir = try temporaryDirectory()
    let inspector = FileInspector(catalog: FakeCatalog(), reader: FileReader())
    #expect(inspector.facts(for: dir).kind == .text)
    #expect(inspector.facts(for: dir.appendingPathComponent("missing")).kind == .binary)
  }

  @Test("诊断报告包含配置、受管类型和日志")
  func report() throws {
    var configuration = Configuration()
    configuration.assignments["public.data"] = "dev.zed.Zed"
    let text = try DiagnosticReport.build(
      date: Date(timeIntervalSince1970: 0), systemVersion: "27.0", appVersion: "0.1.0",
      configuration: configuration,
      current: Snapshot(handlers: [
        "public.data": HelperIdentity.bundleID, "public.png": "com.apple.Preview",
      ]),
      diagnoses: [], logLines: ["line one"])
    #expect(text.contains("\"public.data\" : \"dev.zed.Zed\""))
    #expect(text.contains("net.zhaojian.openwithpanel.helper\tpublic.data\tall"))
    #expect(!text.contains("public.png"))
    #expect(text.contains("line one"))
  }
}
