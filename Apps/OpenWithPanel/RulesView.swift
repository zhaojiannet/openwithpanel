import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI

struct RulesView: View {
  @Environment(AppModel.self) private var model
  @State private var editing: Rule?

  var body: some View {
    @Bindable var model = model
    Form {
      Section {
        ForEach($model.staged.rules) { $rule in
          HStack(spacing: 12) {
            Toggle("", isOn: $rule.isEnabled).labelsHidden()
            VStack(alignment: .leading, spacing: 2) {
              Text(rule.name.isEmpty ? String(localized: "Untitled Rule") : rule.name)
                .font(Typography.rowTitle)
              Text(summary(rule)).font(Typography.detail).foregroundStyle(.secondary)
            }
            Spacer()
            Button("Edit") { editing = rule }
          }
          .padding(.vertical, 4)
        }
        .onMove { model.staged.rules.move(fromOffsets: $0, toOffset: $1) }
        .onDelete { model.staged.rules.remove(atOffsets: $0) }
        Button("Add Rule", systemImage: "plus") {
          let rule = Rule(name: "", target: .revealInFinder)
          model.staged.rules.append(rule)
          editing = rule
        }
      } header: {
        Text("Rules for files sent to OpenWithPanel").font(Typography.sectionTitle)
      } footer: {
        Text(
          "Rules are checked from top to bottom. The first rule that matches decides where the file goes. Drag to reorder."
        )
        .foregroundStyle(.secondary)
      }
    }
    .formStyle(.grouped)
    .sheet(item: $editing) { rule in
      RuleEditor(rule: rule) { updated in
        if let index = model.staged.rules.firstIndex(where: { $0.id == updated.id }) {
          model.staged.rules[index] = updated
        }
      }
    }
  }

  private func summary(_ rule: Rule) -> String {
    var parts: [String] = []
    if let pattern = rule.namePattern, !pattern.isEmpty {
      parts.append(String(localized: "name \(pattern)"))
    }
    if let prefix = rule.pathPrefix, !prefix.isEmpty {
      parts.append(String(localized: "in \(prefix)"))
    }
    if let kind = rule.contentKind {
      parts.append(
        kind == .text ? String(localized: "text only") : String(localized: "binary only"))
    }
    let target: String
    switch rule.target {
    case .app(let bundleID): target = model.appName(bundleID)
    case .revealInFinder: target = String(localized: "Show in Finder")
    case .system: target = String(localized: "Original app")
    }
    return
      (parts.isEmpty
      ? String(localized: "No conditions, never matches") : parts.joined(separator: ", ")) + " → "
      + target
  }
}

struct RuleEditor: View {
  @Environment(AppModel.self) private var model
  @Environment(\.dismiss) private var dismiss
  @State var rule: Rule
  let onSave: (Rule) -> Void
  @State private var typesText = ""

  var body: some View {
    Form {
      TextField("Name", text: $rule.name)
      TextField("File name pattern", text: binding(\.namePattern), prompt: Text("Dockerfile*"))
      HStack {
        TextField("Inside folder", text: binding(\.pathPrefix), prompt: Text("~/Projects"))
        Button("Choose…") { chooseFolder() }
      }
      Picker("Content", selection: $rule.contentKind) {
        Text("Any").tag(ContentKind?.none)
        ForEach(ContentKind.allCases, id: \.self) { Text($0.title).tag(ContentKind?.some($0)) }
      }
      TextField("Applies to types", text: $typesText, prompt: Text("public.data"))
        .help(
          "Comma-separated type identifiers. Files of these types are sent to OpenWithPanel so this rule can see them."
        )
      Picker("Send to", selection: targetKind) {
        Text("An app").tag(TargetKind.app)
        Text("Show in Finder").tag(TargetKind.reveal)
        Text("Original app").tag(TargetKind.system)
      }
      if case .app(let bundleID) = rule.target {
        LabeledContent("App") {
          AppPickerMenu(
            selection: bundleID.isEmpty ? .none : .app(bundleID),
            candidates: model.typeCandidates["public.plain-text"] ?? []
          ) { rule.target = .app(bundleID: $0) }
        }
      }
      HStack {
        Spacer()
        Button("Cancel", role: .cancel) { dismiss() }
        Button("Done") {
          rule.contentTypes = typesText.split(separator: ",").map {
            $0.trimmingCharacters(in: .whitespaces)
          }.filter { !$0.isEmpty }
          if rule.contentTypes.isEmpty { rule.contentTypes = ["public.data"] }
          onSave(rule)
          dismiss()
        }
        .buttonStyle(.borderedProminent)
      }
    }
    .formStyle(.grouped)
    .frame(width: 480)
    .onAppear { typesText = rule.contentTypes.joined(separator: ", ") }
  }

  private enum TargetKind { case app, reveal, system }

  private var targetKind: Binding<TargetKind> {
    Binding {
      switch rule.target {
      case .app: .app
      case .revealInFinder: .reveal
      case .system: .system
      }
    } set: { kind in
      switch kind {
      case .app: if case .app = rule.target {} else { rule.target = .app(bundleID: "") }
      case .reveal: rule.target = .revealInFinder
      case .system: rule.target = .system
      }
    }
  }

  private func binding(_ keyPath: WritableKeyPath<Rule, String?>) -> Binding<String> {
    Binding {
      rule[keyPath: keyPath] ?? ""
    } set: {
      rule[keyPath: keyPath] = $0.isEmpty ? nil : $0
    }
  }

  private func chooseFolder() {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    guard panel.runModal() == .OK, let url = panel.url else { return }
    rule.pathPrefix = url.path.replacingOccurrences(
      of: model.homeDirectory, with: "~", options: .anchored)
  }
}
