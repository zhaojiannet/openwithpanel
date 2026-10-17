import Foundation
import OpenWithPanelPlatform
import Testing

@testable import OpenWithPanelCore

@Suite("诊断与文件夹规则")
struct DiagnosticsAndFolderTests {
  func write(_ name: String, _ data: Data, in dir: URL) throws -> URL {
    let url = dir.appendingPathComponent(name)
    try FileManager.default.createDirectory(
      at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    try data.write(to: url)
    return url
  }

  @Test("诊断区分单文件覆盖、经辅助程序和系统选择")
  func diagnosisReasons() throws {
    let dir = try temporaryDirectory()
    let env = try write(".env", Data("A=1\n".utf8), in: dir)
    let png = try write("a.png", Data([0x89, 0x50, 0x00]), in: dir)
    let pinned = try write("Dockerfile", Data("FROM x\n".utf8), in: dir)
    let ls = FakeLaunchServices(apps: TestApps.all)
    ls.fileDefaults = [
      env.path: HelperIdentity.bundleID, png.path: "com.apple.Preview", pinned.path: "dev.zed.Zed",
    ]
    let openWith = FakeOpenWith()
    openWith.values[pinned.path] = FakeOpenWith.encode("dev.zed.Zed")
    let catalog = FakeCatalog(fileTypes: [
      ".env": "public.data", "a.png": "public.png", "Dockerfile": "public.data",
    ])
    let d = Diagnostician(
      launchServices: ls, catalog: catalog, preferences: FakePreferences(), openWith: openWith,
      reader: FileReader(), apps: FakeAppCatalog(), homeDirectory: "/Users/u")
    var configuration = Configuration()
    configuration.assignments["public.data"] = "dev.zed.Zed"

    #expect(
      d.diagnose(env, configuration: configuration).reason
        == .helper(.open(bundleID: "dev.zed.Zed", reason: .assignment(type: "public.data"))))
    #expect(
      d.diagnose(png, configuration: configuration).reason == .systemChoice(type: "public.png"))
    #expect(
      d.diagnose(pinned, configuration: configuration).reason
        == .perFileOverride(bundleID: "dev.zed.Zed"))
  }

  @Test("上级类型的偏好条目指向别的 App 时，不算用户选的")
  func parentPreferenceDoesNotExplainChild() throws {
    let dir = try temporaryDirectory()
    let swift = try write("a.swift", Data("let a = 1\n".utf8), in: dir)
    let ls = FakeLaunchServices(apps: TestApps.all)
    ls.fileDefaults = [swift.path: "com.apple.TextEdit"]
    let prefs = FakePreferences()
    prefs.entries = ["public.data": "net.zhaojian.openwithpanel.helper"]
    let catalog = FakeCatalog(
      fileTypes: ["a.swift": "public.swift-source"],
      parents: ["public.swift-source": ["public.data", "public.text"]])
    let d = Diagnostician(
      launchServices: ls, catalog: catalog, preferences: prefs, openWith: FakeOpenWith(),
      reader: FileReader(), apps: FakeAppCatalog(), homeDirectory: "/Users/u")
    #expect(
      d.diagnose(swift, configuration: Configuration()).reason
        == .systemChoice(type: "public.swift-source"))
    prefs.entries["public.text"] = "com.apple.textedit"
    #expect(
      d.diagnose(swift, configuration: Configuration()).reason
        == .userPreference(type: "public.text"))
  }

  @Test("列出候选 App 的声明：扩展名优先于类型，找不到声明的标为空")
  func declarationsOfCandidates() throws {
    let dir = try temporaryDirectory()
    let md = try write("a.md", Data("# a\n".utf8), in: dir)
    let ls = FakeLaunchServices(apps: TestApps.all)
    ls.candidates["net.daringfireball.markdown"] = [
      "dev.zed.Zed", "com.apple.TextEdit", "com.apple.Preview",
    ]
    let apps = FakeAppCatalog(apps: [
      InstalledApp(
        info: TestApps.zed,
        documentTypes: [
          DocumentTypeDeclaration(
            contentTypes: ["public.text"], extensions: [], role: "Editor", rank: "Alternate"),
          DocumentTypeDeclaration(
            contentTypes: [], extensions: ["MD"], role: "Editor", rank: nil),
        ]),
      InstalledApp(
        info: TestApps.textEdit,
        documentTypes: [
          DocumentTypeDeclaration(
            contentTypes: ["net.daringfireball.markdown"], extensions: [], role: "Viewer",
            rank: "Default")
        ]),
    ])
    let catalog = FakeCatalog(
      fileTypes: ["a.md": "net.daringfireball.markdown"],
      parents: ["net.daringfireball.markdown": ["public.plain-text", "public.text"]])
    let d = Diagnostician(
      launchServices: ls, catalog: catalog, preferences: FakePreferences(),
      openWith: FakeOpenWith(), reader: FileReader(), apps: apps, homeDirectory: "/Users/u")
    #expect(
      d.diagnose(md, configuration: Configuration()).declarations == [
        AppDeclaration(app: TestApps.zed, matched: ".md", role: "Editor", rank: nil),
        AppDeclaration(
          app: TestApps.textEdit, matched: "net.daringfireball.markdown", role: "Viewer",
          rank: "Default"),
        AppDeclaration(app: TestApps.preview, matched: nil, role: nil, rank: nil),
      ])
  }

  @Test("扫描包含点文件，跳过排除目录")
  func scannerSkipsExcluded() throws {
    let dir = try temporaryDirectory()
    _ = try write(".env", Data(), in: dir)
    _ = try write("src/Makefile", Data(), in: dir)
    _ = try write("node_modules/x/LICENSE", Data(), in: dir)
    _ = try write(".git/HEAD", Data(), in: dir)
    let names = FolderScanner(exclusions: Configuration.defaultExclusions).files(in: dir).map(
      \.lastPathComponent
    ).sorted()
    #expect(names == [".env", "Makefile"])
  }

  @Test("文件夹规则只写无扩展名的文本文件，不动用户自己设过的，可完整撤销")
  func folderRuleWritesAndUndoes() async throws {
    let dir = try temporaryDirectory()
    let env = try write(".env", Data("A=1\n".utf8), in: dir)
    let blob = try write("blob", Data([0x00, 0x01]), in: dir)
    let mine = try write("Procfile", Data("web: x\n".utf8), in: dir)
    let swift = try write("a.swift", Data("let a = 1\n".utf8), in: dir)
    let ls = FakeLaunchServices(apps: TestApps.all)
    let openWith = FakeOpenWith()
    let userValue = FakeOpenWith.encode("com.apple.TextEdit")
    openWith.values[mine.path] = userValue
    let catalog = FakeCatalog(fileTypes: [
      ".env": "public.data", "blob": "public.data", "Procfile": "public.data",
      "a.swift": "public.swift-source",
    ])
    let engine = FolderRuleEngine(
      launchServices: ls, catalog: catalog, openWith: openWith, reader: FileReader())
    var ledger = FolderLedger()
    let rule = FolderRule(path: dir.path, targetBundleID: "dev.zed.Zed")

    let report = await engine.apply(rule, scanner: FolderScanner(exclusions: []), ledger: &ledger)
    #expect(report.written == 1)
    #expect(report.skippedBinary == 1)
    #expect(report.skippedUserOverride == 1)
    #expect(ls.fileDefaults[env.path] == "dev.zed.Zed")
    #expect(ls.fileDefaults[blob.path] == nil)
    #expect(ls.fileDefaults[swift.path] == nil)
    #expect(ledger.previous.keys.sorted() == [env.path])

    openWith.values[env.path] = FakeOpenWith.encode("dev.zed.Zed")
    #expect(engine.undo(&ledger).isEmpty)
    #expect(openWith.values[env.path] == nil)
    #expect(openWith.values[mine.path] == userValue)
    #expect(ledger.previous.isEmpty)
  }

  @Test("列出并清除文件夹里的单文件覆盖")
  func overridesListedAndCleared() throws {
    let dir = try temporaryDirectory()
    let a = try write("a.txt", Data(), in: dir)
    _ = try write("b.txt", Data(), in: dir)
    let openWith = FakeOpenWith()
    openWith.values[a.path] = FakeOpenWith.encode("dev.zed.Zed")
    let engine = FolderRuleEngine(
      launchServices: FakeLaunchServices(apps: []), catalog: FakeCatalog(), openWith: openWith,
      reader: FileReader())
    let overrides = engine.overrides(in: dir, scanner: FolderScanner(exclusions: []))
    #expect(overrides.map(\.bundleID) == ["dev.zed.Zed"])
    #expect(engine.clear(overrides).isEmpty)
    #expect(openWith.values.isEmpty)
  }
}
