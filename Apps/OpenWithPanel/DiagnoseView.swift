import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI
import UniformTypeIdentifiers

struct DiagnoseView: View {
  @Environment(AppModel.self) private var model
  @State private var item: DroppedItem?
  @State private var isTargeted = false
  @State private var report: String?
  @State private var preparingReport = false

  var body: some View {
    Form {
      Section { dropZone }
      switch item {
      case .file(let diagnosis):
        FileDiagnosisView(diagnosis: diagnosis) {
          item = .file(model.diagnose(URL(fileURLWithPath: diagnosis.path)))
        }
      case .folder(let url, let overrides):
        FolderOverridesView(folder: url, overrides: overrides) { reload(url) }
      case .scanning:
        Section { ProgressView().frame(maxWidth: .infinity) }
      case nil:
        EmptyView()
      }
      Section {
        HStack {
          Text(
            "A text report of your settings and this session’s log, for sending to the developer."
          )
          .foregroundStyle(.secondary)
          Spacer()
          if preparingReport { ProgressView().controlSize(.small) }
          Button("Export Diagnostic Report…") {
            preparingReport = true
            Task {
              report = await model.reportText(for: diagnoses)
              preparingReport = false
            }
          }
          .disabled(preparingReport)
        }
      }
    }
    .formStyle(.grouped)
    .fileExporter(
      isPresented: Binding(get: { report != nil }, set: { if !$0 { report = nil } }),
      item: report ?? "",
      contentTypes: [.plainText], defaultFilename: "OpenWithPanel Report.txt"
    ) { _ in }
  }

  private var dropZone: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(isTargeted ? Color.accentColor.opacity(0.1) : Color.clear)
      .strokeBorder(
        isTargeted ? Color.accentColor : Color.secondary.opacity(0.35),
        style: StrokeStyle(lineWidth: 1.5, dash: [6])
      )
      .overlay {
        VStack(spacing: 8) {
          Image(systemName: "arrow.down.doc").font(.system(size: 36)).foregroundStyle(.secondary)
          Text("Drop a file to see why it opens in a certain app").font(Typography.rowTitle)
          Text("Drop a folder to find files with their own “Open with” setting")
            .font(Typography.detail).foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
      }
      .frame(height: 180)
      .padding(.vertical, 4)
      .dropDestination(for: URL.self) { urls, _ in
        guard let url = urls.first else { return false }
        handle(url)
        return true
      } isTargeted: {
        isTargeted = $0
      }
  }

  private var diagnoses: [FileDiagnosis] {
    if case .file(let diagnosis) = item { return [diagnosis] }
    return []
  }

  private func handle(_ url: URL) {
    let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    let isPackage = (try? url.resourceValues(forKeys: [.isPackageKey]))?.isPackage ?? false
    if isDirectory && !isPackage { reload(url) } else { item = .file(model.diagnose(url)) }
  }

  private func reload(_ folder: URL) {
    item = .scanning
    Task { item = .folder(folder, await model.overrides(in: folder)) }
  }
}

enum DroppedItem {
  case file(FileDiagnosis)
  case folder(URL, [FileOverride])
  case scanning
}

struct FileDiagnosisView: View {
  @Environment(AppModel.self) private var model
  @AppStorage("developerMode") private var developerMode = false
  let diagnosis: FileDiagnosis
  let onChange: () -> Void

  var body: some View {
    Section {
      LabeledContent("File", value: (diagnosis.path as NSString).lastPathComponent)
      LabeledContent("Opens with") {
        AppLabel(bundleID: diagnosis.effectiveApp?.bundleID, placeholder: "No app")
      }
      LabeledContent("Why") { Text(reasonText).multilineTextAlignment(.trailing) }
      if let type = diagnosis.contentType {
        LabeledContent("Kind", value: model.catalog.localizedDescription(of: type) ?? type)
        if case .perFileOverride = diagnosis.reason {
          Button("Remove This File’s Own Setting") {
            _ = model.clearOverrides([
              FileOverride(url: URL(fileURLWithPath: diagnosis.path), bundleID: "")
            ])
            onChange()
          }
        } else {
          LabeledContent("Use instead") {
            AppPickerMenu(selection: .none, candidates: candidates) { bundleID in
              model.assign(bundleID, toType: type)
            }
          }
        }
      }
    } header: {
      Text("Result").font(Typography.sectionTitle)
    }
    if developerMode {
      Section("Decision Chain") {
        LabeledContent("Type", value: diagnosis.contentType ?? "-")
        LabeledContent("Conforms to", value: diagnosis.supertypes.joined(separator: ", "))
        LabeledContent("Content", value: diagnosis.kind?.rawValue ?? "-")
        LabeledContent("Decision", value: String(describing: diagnosis.reason))
      }
      // 角色和优先级是 Info.plist 里的原值（Editor、Alternate 等），照原样显示
      Section {
        ForEach(diagnosis.declarations, id: \.app.path) { declaration in
          LabeledContent {
            Text(declarationText(declaration)).monospaced().textSelection(.enabled)
          } label: {
            AppLabel(bundleID: declaration.app.bundleID)
          }
        }
      } header: {
        Text("Apps that can open it")
      } footer: {
        Text("Declared type · role · rank, as written in each app’s Info.plist.")
          .font(Typography.detail).foregroundStyle(.secondary)
      }
    }
  }

  private func declarationText(_ declaration: AppDeclaration) -> String {
    guard let matched = declaration.matched else {
      return String(localized: "Not declared directly")
    }
    return [matched, declaration.role ?? "–", declaration.rank ?? "–"].joined(separator: " · ")
  }

  private var candidates: [AppInfo] {
    let source = diagnosis.contentType.map {
      Planner.lockedTypes.contains($0) ? "public.plain-text" : $0
    }
    return (source.flatMap { model.typeCandidates[$0] } ?? diagnosis.candidates).filter {
      !model.isHelper($0.bundleID)
    }
  }

  private var reasonText: String {
    switch diagnosis.reason {
    case .perFileOverride(let bundleID):
      String(localized: "This file has its own “Open with” setting: \(model.appName(bundleID)).")
    case .helper(let decision):
      switch decision {
      case .open(let bundleID, .rule(_, let name)):
        String(localized: "Rule “\(name)” sends it to \(model.appName(bundleID)).")
      case .open(let bundleID, _):
        String(localized: "OpenWithPanel sends files like this to \(model.appName(bundleID)).")
      case .reveal(.binary):
        String(localized: "It is not a text file, so OpenWithPanel shows it in Finder.")
      case .reveal:
        String(localized: "No app is set for it, so OpenWithPanel shows it in Finder.")
      }
    case .userPreference:
      String(localized: "You chose this app for this kind of file.")
    case .systemChoice:
      String(localized: "macOS picked this app because no default was set.")
    case .unknown:
      String(localized: "macOS could not tell what kind of file this is.")
    }
  }
}

struct FolderOverridesView: View {
  @Environment(AppModel.self) private var model
  let folder: URL
  let overrides: [FileOverride]
  let onChange: () -> Void
  @State private var selected: Set<URL> = []
  @State private var confirming = false

  var body: some View {
    Section {
      if overrides.isEmpty {
        Text("No file in “\(folder.lastPathComponent)” has its own “Open with” setting.")
      } else {
        ForEach(overrides) { override in
          Toggle(isOn: isSelected(override.url)) {
            HStack {
              Text(override.url.path.replacingOccurrences(of: folder.path + "/", with: ""))
              Spacer()
              AppLabel(bundleID: override.bundleID)
            }
          }
          .toggleStyle(.checkbox)
        }
        HStack {
          Button("Select All") { selected = Set(overrides.map(\.url)) }
          Spacer()
          Button("Remove Their Own Settings") { confirming = true }
            .disabled(selected.isEmpty)
        }
      }
    } header: {
      if !overrides.isEmpty {
        Text(
          "Files in “\(folder.lastPathComponent)” with their own “Open with” setting: \(overrides.count)"
        )
        .font(Typography.sectionTitle)
      }
    }
    .confirmationDialog(
      "Remove the “Open with” setting from \(selected.count) files?", isPresented: $confirming
    ) {
      Button("Remove", role: .destructive) {
        _ = model.clearOverrides(overrides.filter { selected.contains($0.url) })
        selected = []
        onChange()
      }
    } message: {
      Text("These files will open with the app set for their kind.")
    }
  }

  private func isSelected(_ url: URL) -> Binding<Bool> {
    Binding {
      selected.contains(url)
    } set: {
      if $0 { selected.insert(url) } else { selected.remove(url) }
    }
  }
}
