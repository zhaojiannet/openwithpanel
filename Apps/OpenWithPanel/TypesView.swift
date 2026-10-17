import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI

struct TypesView: View {
  @Environment(AppModel.self) private var model
  @State private var search = ""
  @State private var expanded: Set<String> = []
  @State private var showingAll: Set<String> = []
  @State private var adding: AddExtensionRequest?

  var body: some View {
    let families = visibleFamilies
    Form {
      if let unmatched = unmatchedQuery {
        Section("Search Result") {
          HStack {
            Text("“.\(unmatched)” isn’t in any group yet.")
            Spacer()
            Button("Add…") { adding = AddExtensionRequest(text: unmatched) }
          }
        }
      }
      ForEach(families) { family in
        Section {
          FamilyRow(family: family, isExpanded: isExpanded(family)) { toggle(family) }
          if isExpanded(family) { members(of: family) }
        } header: {
          if family.id == families.first?.id {
            Text("Choose the app that opens each kind of file").font(Typography.sectionTitle)
          }
        } footer: {
          if family.id == families.last?.id {
            Text("Changes take effect after you press Apply.").font(Typography.detail)
              .foregroundStyle(.secondary)
          }
        }
      }
      Section {
        Button("Add Extension…", systemImage: "plus") { adding = AddExtensionRequest(text: "") }
      } footer: {
        Text(
          "Add a file extension that isn’t listed, then choose an app for it like any other format."
        )
        .font(Typography.detail).foregroundStyle(.secondary)
      }
      let links = visibleLinks
      if !links.isEmpty {
        Section {
          ForEach(links) { LinkRow(kind: $0) }
        } header: {
          Text("Choose the app that opens each kind of link").font(Typography.sectionTitle)
        }
      }
    }
    .formStyle(.grouped)
    .searchable(text: $search, prompt: "Extension, such as py or env")
    .sheet(item: $adding) { request in
      AddExtensionSheet(text: request.text) { family in
        expanded.insert(family.id)
        search = ""
      }
    }
    .animation(.default, value: expanded)
    .animation(.default, value: showingAll)
  }

  // 搜到的格式往往没单独设置过，只列例外会把它藏起来，所以它所在的组要全部列出
  @ViewBuilder
  private func members(of family: TypeFamily) -> some View {
    let all = model.sortedTypes(of: family)
    let collapsible = all.count > Self.compactLimit
    let showsAll =
      !collapsible || showingAll.contains(family.id) || queryType.map(all.contains) == true
    if showsAll, family.id == "code", all.count > Self.compactLimit {
      ForEach(model.codeSections(all), id: \.section) { group in
        SubheaderRow(title: group.section.title)
        ForEach(group.types, id: \.self) { row($0, family) }
      }
    } else {
      ForEach(
        showsAll
          ? all : all.filter { model.staged.isOverridden($0) || model.isCustom($0, in: family) },
        id: \.self
      ) {
        row($0, family)
      }
    }
    if collapsible {
      ShowAllRow(count: all.count, showsAll: showsAll) {
        if showingAll.contains(family.id) {
          showingAll.remove(family.id)
        } else {
          showingAll.insert(family.id)
        }
      }
    }
  }

  private func row(_ type: String, _ family: TypeFamily) -> some View {
    TypeRow(type: type, family: family)
      .listRowBackground(type == queryType ? Color.accentColor.opacity(0.12) : nil)
  }

  private static let compactLimit = 8

  private func isExpanded(_ family: TypeFamily) -> Bool {
    if expanded.contains(family.id) { return true }
    guard let queryType else { return false }
    return model.types(of: family).contains(queryType)
  }

  private func toggle(_ family: TypeFamily) {
    if expanded.contains(family.id) {
      expanded.remove(family.id)
    } else {
      expanded.insert(family.id)
    }
  }

  private var query: String {
    search.trimmingCharacters(in: .whitespaces).trimmingCharacters(
      in: CharacterSet(charactersIn: ".")
    )
    .lowercased()
  }

  private var queryType: String? {
    query.isEmpty ? nil : model.catalog.type(forExtension: query)
  }

  private var visibleFamilies: [TypeFamily] {
    guard !query.isEmpty else { return model.families }
    return model.families.filter { family in
      let types = model.types(of: family)
      if let queryType, types.contains(where: { model.catalog.conforms(queryType, to: $0) }) {
        return true
      }
      return types.contains { model.catalog.extensions(of: $0).contains(query) }
        || String(localized: family.title).localizedCaseInsensitiveContains(query)
    }
  }

  private var visibleLinks: [LinkKind] {
    guard !query.isEmpty else { return model.links }
    return model.links.filter { kind in
      kind.schemes.contains { $0.hasPrefix(query) }
        || String(localized: kind.title).localizedCaseInsensitiveContains(query)
    }
  }

  private var unmatchedQuery: String? {
    let ext = FamilyState.normalizedExtension(search)
    guard !ext.isEmpty, let type = queryType,
      !model.families.contains(where: { model.types(of: $0).contains(type) })
    else { return nil }
    return ext
  }
}

struct FamilyRow: View {
  @Environment(AppModel.self) private var model
  let family: TypeFamily
  let isExpanded: Bool
  let toggle: () -> Void

  var body: some View {
    HStack(spacing: 0) {
      HStack(spacing: Layout.spacing) {
        Image(systemName: "chevron.right")
          .font(.callout.weight(.semibold))
          .foregroundStyle(.secondary)
          .rotationEffect(.degrees(isExpanded ? 90 : 0))
          .frame(width: Layout.chevron)
        Image(systemName: family.symbol)
          .font(.title3)
          .foregroundStyle(.white)
          .frame(width: Layout.icon, height: Layout.icon)
          .background(family.tint.gradient, in: .rect(cornerRadius: 8))
        VStack(alignment: .leading, spacing: 2) {
          HStack(spacing: 6) {
            Text(family.title).font(Typography.rowTitle)
            if model.types(of: family).contains(
              where: model.staged.isControlledByRule)
            {
              Badge("Controlled by rules", tint: .secondary)
                .help("Some files of this kind are routed by rules in developer mode.")
            }
            if overrideCount > 0 {
              Badge("\(overrideCount) set separately", tint: .accentColor)
            }
          }
          Text(examples).font(Typography.detail).foregroundStyle(.secondary).lineLimit(1)
        }
        Spacer(minLength: 12)
      }
      .contentShape(.rect)
      .onTapGesture(perform: toggle)
      .accessibilityAddTraits(.isButton)
      .accessibilityAction(named: isExpanded ? "Collapse" : "Expand", toggle)
      AppPickerMenu(
        selection: model.selection(for: family),
        candidates: model.familyCandidates[family.id] ?? []
      ) { model.assign($0, toFamily: family) }
    }
    .padding(.vertical, 6)
  }

  private var overrideCount: Int {
    model.types(of: family).filter(model.staged.isOverridden)
      .count
  }

  private var examples: String {
    if family.id == "extensionless" { return ".env  Dockerfile  .gitignore  .npmrc" }
    if family.id == "code" { return ".py  .js  .go  .rs  .swift  .java  …" }
    if family.id == "custom" {
      return (model.staged.customExtensions["custom"] ?? []).map { "." + $0 }.joined(
        separator: "  ")
    }
    let extensions = model.types(of: family)
      .compactMap { model.catalog.extensions(of: $0).first }
    return extensions.prefix(6).map { "." + $0 }.joined(separator: "  ")
  }
}

struct LinkRow: View {
  @Environment(AppModel.self) private var model
  let kind: LinkKind
  @State private var confirmingBlock = false

  var body: some View {
    HStack(spacing: Layout.spacing) {
      Image(systemName: kind.symbol)
        .font(.title3)
        .foregroundStyle(.white)
        .frame(width: Layout.icon, height: Layout.icon)
        .background(kind.tint.gradient, in: .rect(cornerRadius: 8))
      VStack(alignment: .leading, spacing: 2) {
        Text(kind.title).font(Typography.rowTitle)
        Text(verbatim: kind.schemes.map { $0 + ":" }.joined(separator: "  "))
          .font(Typography.detail).foregroundStyle(.secondary)
      }
      Spacer(minLength: 12)
      AppPickerMenu(
        selection: model.selection(forLink: kind), candidates: model.candidates(forLink: kind),
        isBlocked: model.isLinkBlocked(kind),
        dontOpen: {
          // 网页链接影响面最大：任何 App 里点链接都不会有反应，先确认
          if kind.id == "web" { confirmingBlock = true } else { model.blockLink(kind) }
        }
      ) { model.assign($0, toLink: kind) }
    }
    .padding(.leading, Layout.chevron + Layout.spacing)
    .padding(.vertical, 6)
    .confirmationDialog("Stop opening web links?", isPresented: $confirmingBlock) {
      Button("Don’t Open Web Links", role: .destructive) { model.blockLink(kind) }
    } message: {
      Text("Clicking a web link in any app will do nothing until you choose a browser again.")
    }
  }
}

struct TypeRow: View {
  @Environment(AppModel.self) private var model
  @AppStorage("developerMode") private var developerMode = false
  let type: String
  let family: TypeFamily?

  var body: some View {
    HStack(spacing: 10) {
      Image(nsImage: model.icon(forType: type))
        .resizable()
        .frame(width: Layout.typeIcon, height: Layout.typeIcon)
      VStack(alignment: .leading, spacing: 1) {
        HStack(spacing: 6) {
          Text(verbatim: extensions.isEmpty ? model.formatName(type) : extensions)
            .font(Typography.itemTitle)
          if let family, model.isCustom(type, in: family) {
            Badge("Custom", tint: .orange)
          }
          if family != nil, model.staged.isOverridden(type) {
            Badge("Set separately", tint: .accentColor)
          }
          if developerMode, model.staged.helperTypes.contains(type) {
            Badge("Helper", tint: .blue)
          }
        }
        HStack(spacing: 8) {
          if let subtitle { Text(verbatim: subtitle) }
          if developerMode { Text(type).font(Typography.identifier).foregroundStyle(.tertiary) }
        }
        .font(Typography.detail)
        .foregroundStyle(.secondary)
      }
      Spacer()
      if let family, model.isCustom(type, in: family) {
        Button("Remove", systemImage: "minus.circle") {
          model.removeCustomExtension(of: type, from: family)
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderless)
        .foregroundStyle(.secondary)
        .help("Remove this extension you added")
      }
      AppPickerMenu(
        selection: model.selection(forType: type, in: family),
        candidates: candidates,
        inheritsFromGroup: family.map {
          !model.staged.isOverridden(type) && model.staged.familyAssignments[$0.id] != nil
        } ?? false,
        followFamily: family != nil && model.staged.isOverridden(type)
          ? { model.followFamily(type) } : nil,
        controlSize: .regular
      ) { model.assign($0, toType: type) }
    }
    .padding(.leading, family == nil ? 0 : Layout.childIndent - Layout.typeIcon - 10)
    .padding(.vertical, 3)
  }

  private var extensions: String {
    model.catalog.extensions(of: type).prefix(4).map { "." + $0 }.joined(separator: "  ")
  }

  // 扩展名作主标题，普通用户最认得；系统名称与组名相同时（比如 .txt 和 .log 都叫「文本」）不显示副标题
  private var subtitle: String? {
    guard !extensions.isEmpty else { return nil }
    let name = model.formatName(type)
    let familyTitle = family.map { String(localized: $0.title) }
    return name == familyTitle ? nil : name
  }

  private var candidates: [AppInfo] {
    model.candidates(for: type).filter { !model.isHelper($0.bundleID) }
  }
}

struct SubheaderRow: View {
  let title: LocalizedStringKey

  var body: some View {
    Text(title)
      .font(Typography.subheader)
      .foregroundStyle(.secondary)
      .padding(.leading, Layout.childIndent)
      .padding(.top, 4)
  }
}

struct ShowAllRow: View {
  let count: Int
  let showsAll: Bool
  let toggle: () -> Void

  var body: some View {
    Button(action: toggle) {
      Text(showsAll ? "Show Fewer" : "Show All \(count) Formats")
    }
    .buttonStyle(.link)
    .padding(.leading, Layout.childIndent)
  }
}

struct Badge: View {
  let text: LocalizedStringKey
  let tint: Color

  init(_ text: LocalizedStringKey, tint: Color) {
    self.text = text
    self.tint = tint
  }

  var body: some View {
    Text(text)
      .font(Typography.badge)
      .padding(.horizontal, 6).padding(.vertical, 1)
      .background(tint.opacity(0.15), in: .capsule)
  }
}

// 格式行的文字与组名左对齐：展开箭头 + 间距 + 图标 + 间距；格式图标放进这段缩进里
enum Layout {
  static let chevron: CGFloat = 14
  static let icon: CGFloat = 32
  static let spacing: CGFloat = 12
  static let childIndent = chevron + spacing + icon + spacing
  static let typeIcon: CGFloat = 20
}

struct AddExtensionRequest: Identifiable {
  let id = UUID()
  let text: String
}

struct AddExtensionSheet: View {
  @Environment(AppModel.self) private var model
  @Environment(\.dismiss) private var dismiss
  @State var text: String
  let onAdd: (TypeFamily) -> Void
  @State private var familyID = ""

  var body: some View {
    let ext = FamilyState.normalizedExtension(text)
    let suggestion = FamilyState.suggestedFamily(
      forExtension: ext, catalog: model.catalog, members: model.types(of:))
    Form {
      Section {
        TextField("Extension", text: $text, prompt: Text(verbatim: "nim"))
        if let type = model.catalog.type(forExtension: ext), !ext.isEmpty {
          LabeledContent("Recognized as") {
            Label {
              Text(verbatim: model.formatName(type))
            } icon: {
              Image(nsImage: model.icon(forType: type)).resizable().frame(width: 16, height: 16)
            }
          }
        }
        if let suggestion, suggestion.alreadyIncluded {
          Text("“.\(ext)” is already in \(String(localized: suggestion.family.title)).")
            .foregroundStyle(.secondary)
        } else {
          Picker("Group", selection: $familyID) {
            ForEach(TypeFamilies.all.filter { $0.id != "extensionless" }) { family in
              Text(family.title).tag(family.id)
            }
          }
          Text("It follows the group’s app unless you choose one for it separately.")
            .font(Typography.detail).foregroundStyle(.secondary)
        }
      } header: {
        Text("Add Extension").font(Typography.sectionTitle)
      }
      HStack {
        Spacer()
        Button("Cancel", role: .cancel) { dismiss() }
        Button("Add") {
          guard let family = TypeFamilies.all.first(where: { $0.id == familyID }) else { return }
          model.addCustomExtension(ext, to: family)
          onAdd(family)
          dismiss()
        }
        .buttonStyle(.borderedProminent)
        .keyboardShortcut(.defaultAction)
        .disabled(ext.isEmpty || suggestion == nil || suggestion?.alreadyIncluded == true)
      }
    }
    .formStyle(.grouped)
    .frame(width: 440)
    .onChange(of: ext, initial: true) {
      if let suggestion, !suggestion.alreadyIncluded { familyID = suggestion.family.id }
    }
  }
}
