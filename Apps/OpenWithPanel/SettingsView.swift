import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
  var body: some View {
    TabView {
      Tab("General", systemImage: "gearshape") { GeneralSettings() }
      Tab("Folder Rules", systemImage: "folder") { FolderRulesSettings() }
      Tab("History", systemImage: "clock.arrow.circlepath") { HistorySettings() }
      Tab("What OpenWithPanel Wrote", systemImage: "list.bullet.rectangle") { FootprintSettings() }
    }
    .frame(width: 560, height: 440)
  }
}

struct GeneralSettings: View {
  @Environment(AppModel.self) private var model
  @AppStorage("developerMode") private var developerMode = false
  @State private var exporting = false
  @State private var importing = false

  var body: some View {
    @Bindable var model = model
    Form {
      LanguagePicker()
      Toggle("Developer mode", isOn: $developerMode)
      Text(
        "Shows file type identifiers, rules, the full decision chain and presets. It only changes what you see; nothing is applied until you press Apply."
      )
      .font(Typography.detail).foregroundStyle(.secondary)
      if developerMode {
        Picker("Files that are not text", selection: $model.staged.binaryAction) {
          ForEach(BinaryAction.allCases, id: \.self) { Text($0.title).tag($0) }
        }
        LabeledContent("Presets") {
          Button("Export…") { exporting = true }
          Button("Import…") { importing = true }
        }
      }
    }
    .formStyle(.grouped)
    .fileExporter(
      isPresented: $exporting, item: presetText, contentTypes: [.json],
      defaultFilename: "OpenWithPanel Preset.json"
    ) { _ in }
    .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { result in
      guard case .success(let url) = result else { return }
      let scoped = url.startAccessingSecurityScopedResource()
      defer { if scoped { url.stopAccessingSecurityScopedResource() } }
      do {
        model.importPreset(try Data(contentsOf: url))
      } catch {
        model.errorMessage = error.localizedDescription
      }
    }
  }

  private var presetText: String {
    model.exportPreset().map { String(decoding: $0, as: UTF8.self) } ?? ""
  }
}

struct FolderRulesSettings: View {
  @Environment(AppModel.self) private var model
  @State private var rules: [FolderRule] = []
  @State private var exclusions = ""

  var body: some View {
    Form {
      Section {
        Text(
          "For files without an extension inside these folders, OpenWithPanel sets “Open with” on each text file. Binary files and files you set yourself are left alone. New files are picked up each time you open OpenWithPanel."
        )
        .font(Typography.detail).foregroundStyle(.secondary)
        ForEach($rules) { $rule in
          HStack {
            Toggle("", isOn: $rule.isEnabled).labelsHidden()
            Text(
              rule.path.replacingOccurrences(of: model.homeDirectory, with: "~", options: .anchored)
            )
            Spacer()
            AppPickerMenu(
              selection: rule.targetBundleID.isEmpty ? .none : .app(rule.targetBundleID),
              candidates: model.typeCandidates["public.plain-text"] ?? []
            ) { rule.targetBundleID = $0 }
            Button("Remove", systemImage: "minus.circle") { rules.removeAll { $0.id == rule.id } }
              .labelStyle(.iconOnly).buttonStyle(.borderless)
          }
        }
        Button("Add Folder…") { addFolder() }
      }
      Section("Skip folders named") {
        TextField("Skip", text: $exclusions, axis: .vertical).labelsHidden()
      }
      Section {
        HStack {
          if let report = model.lastFolderReport {
            Text(
              "Last run — set: \(report.written), binary skipped: \(report.skippedBinary), kept as you set them: \(report.skippedUserOverride)"
            )
            .font(Typography.detail).foregroundStyle(.secondary)
          }
          Spacer()
          Button("Undo All Folder Settings") { model.undoFolderRules() }
            .disabled(model.ledger.previous.isEmpty)
          Button("Apply Now") {
            save()
            Task { await model.applyFolderRules() }
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
    .formStyle(.grouped)
    .onAppear {
      rules = model.configuration.folderRules
      exclusions = model.configuration.folderExclusions.joined(separator: ", ")
    }
    .onDisappear(perform: save)
  }

  private func save() {
    let names = exclusions.split(separator: ",").map {
      $0.trimmingCharacters(in: .whitespacesAndNewlines)
    }.filter { !$0.isEmpty }
    model.saveFolderRules(rules.filter { !$0.targetBundleID.isEmpty }, exclusions: names)
  }

  private func addFolder() {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    guard panel.runModal() == .OK, let url = panel.url else { return }
    let target = model.configuration.assignments["public.data"] ?? ""
    rules.append(FolderRule(path: url.path, targetBundleID: target))
  }
}

struct HistorySettings: View {
  @Environment(AppModel.self) private var model
  @State private var restoreTarget: RestoreTarget?

  var body: some View {
    List(model.records) { record in
      HStack {
        VStack(alignment: .leading) {
          Text(
            record.kind == .initial
              ? String(localized: "Initial (before OpenWithPanel changed anything)")
              : record.date.formatted(date: .abbreviated, time: .standard))
        }
        Spacer()
        Button("Restore…") { restoreTarget = RestoreTarget(id: record.id) }
      }
    }
    .sheet(item: $restoreTarget) { RestoreSheet(target: $0) }
  }
}

struct FootprintSettings: View {
  @Environment(AppModel.self) private var model
  @State private var confirmingUninstall = false

  var body: some View {
    Form {
      Section {
        LabeledContent("File associations") {
          Text("\(model.managedTypes.count) types")
        }
        LabeledContent("LaunchServices preference entries") {
          HStack {
            Text("\(model.preferenceEntryCount)")
            reveal(
              URL(fileURLWithPath: model.homeDirectory).appendingPathComponent(
                "Library/Preferences/com.apple.LaunchServices"))
          }
        }
        LabeledContent {
          reveal(model.helperURL)
        } label: {
          Text(verbatim: HelperIdentity.displayName)
        }
        LabeledContent("Rules and snapshots") { reveal(model.layout.root) }
        LabeledContent("Per-file “Open with” settings") {
          Text("\(model.ledger.previous.count) files")
        }
      } footer: {
        Text(
          "OpenWithPanel writes nothing else: no background process, no login item. It connects to the internet only when you choose Check for Updates."
        )
      }
      Section {
        Button("Uninstall OpenWithPanel…", role: .destructive) { confirmingUninstall = true }
      }
    }
    .formStyle(.grouped)
    .confirmationDialog("Uninstall OpenWithPanel?", isPresented: $confirmingUninstall) {
      Button("Uninstall and Delete Rules and Snapshots", role: .destructive) {
        Task { await model.uninstall(deleteData: true) }
      }
      Button("Uninstall and Keep Rules and Snapshots") {
        Task { await model.uninstall(deleteData: false) }
      }
    } message: {
      Text(
        "Every changed file type and link is pointed back to the app it used before OpenWithPanel, per-file settings are undone, and OpenWithPanel moves to the Trash."
      )
    }
  }

  private func reveal(_ url: URL) -> some View {
    Button("Show in Finder") { NSWorkspace.shared.activateFileViewerSelecting([url]) }
  }
}

struct LanguagePicker: View {
  @Environment(AppModel.self) private var model
  @State private var selection = AppLanguage.chosen
  private let launched = AppLanguage.chosen

  var body: some View {
    Picker("Language", selection: $selection) {
      Text("Follow System").tag("")
      Divider()
      ForEach(AppLanguage.all, id: \.code) { language in
        Text(verbatim: language.name).tag(language.code)
      }
    }
    .onChange(of: selection) { _, code in AppLanguage.choose(code) }
    if selection != launched {
      HStack {
        Text(
          model.hasPendingEdits
            ? "Apply or discard your changes first, then relaunch to use the new language."
            : "Relaunch OpenWithPanel to use the new language."
        )
        .font(Typography.detail).foregroundStyle(.secondary)
        Spacer()
        Button("Relaunch Now", action: AppLanguage.relaunch)
          .disabled(model.hasPendingEdits)
      }
    }
  }
}

// 界面语言写进本 App 自己的 AppleLanguages，系统在启动时据此选用语言包；菜单栏和系统对话框
// 也跟着变，所以要重新打开才完整生效
enum AppLanguage {
  static let all: [(code: String, name: String)] = [
    ("en", "English"), ("zh-Hans", "简体中文"), ("zh-Hant", "繁體中文"), ("ja", "日本語"),
    ("ko", "한국어"), ("de", "Deutsch"), ("fr", "Français"), ("es", "Español"),
    ("pt", "Português"), ("id", "Bahasa Indonesia"), ("th", "ไทย"), ("vi", "Tiếng Việt"),
    ("ar", "العربية"), ("ru", "Русский"), ("hi", "हिन्दी"),
  ]

  private static let key = "AppleLanguages"

  // 只读本 App 自己的设置；UserDefaults.standard 会把系统全局的语言列表也带进来
  static var chosen: String {
    guard let id = Bundle.main.bundleIdentifier,
      let languages = UserDefaults.standard.persistentDomain(forName: id)?[key] as? [String]
    else { return "" }
    return languages.first ?? ""
  }

  static func choose(_ code: String) {
    if code.isEmpty {
      UserDefaults.standard.removeObject(forKey: key)
    } else {
      UserDefaults.standard.set([code], forKey: key)
    }
  }

  static func relaunch() {
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.createsNewApplicationInstance = true
    NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: configuration) {
      _, _ in
      DispatchQueue.main.async { NSApp.terminate(nil) }
    }
  }
}
