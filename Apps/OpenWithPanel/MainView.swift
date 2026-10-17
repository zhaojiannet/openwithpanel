import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI

enum Screen: Hashable {
  case types
  case diagnose
  case rules
}

struct MainView: View {
  static let contentWidth: CGFloat = 720

  @Environment(AppModel.self) private var model
  @Environment(\.undoManager) private var undoManager
  @AppStorage("developerMode") private var developerMode = false
  @State private var screen = Screen.types
  @State private var restoreTarget: RestoreTarget?

  var body: some View {
    GeometryReader { proxy in
      Group {
        switch screen {
        case .types: TypesView()
        case .diagnose: DiagnoseView()
        case .rules: RulesView()
        }
      }
      // 窗口拉宽时内容最多 720 宽并居中，标签和右侧菜单不会隔得太远；用内容边距而不是限制宽度，
      // 滚动区域仍铺满窗口
      .contentMargins(
        .horizontal, max(0, (proxy.size.width - Self.contentWidth) / 2), for: .scrollContent)
    }
    .safeAreaBar(edge: .top) { Banners(restoreTarget: $restoreTarget) }
    .safeAreaBar(edge: .bottom) {
      if model.hasPendingEdits { ApplyBar(undoManager: undoManager) }
    }
    .frame(minWidth: 620, minHeight: 480)
    .toolbar {
      ToolbarItem(placement: .principal) {
        Picker("Screen", selection: $screen) {
          Text("File Types").tag(Screen.types)
          Text("Diagnose").tag(Screen.diagnose)
          if developerMode { Text("Rules").tag(Screen.rules) }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
      }
      ToolbarItem(placement: .primaryAction) {
        Button("Restore Initial", systemImage: "arrow.uturn.backward.circle") {
          restoreTarget = RestoreTarget(id: SnapshotStore.initialID)
        }
        .help("Point every changed file type back to the app it used before OpenWithPanel")
        .disabled(!model.isLoaded || model.isBusy)
      }
    }
    .onChange(of: developerMode) { _, enabled in
      if !enabled, screen == .rules { screen = .types }
    }
    .sheet(item: $restoreTarget) { target in
      RestoreSheet(target: target)
    }
    .overlay {
      if !model.isLoaded { ProgressView("Reading your file associations…") }
    }
    .alert(
      "Something went wrong",
      isPresented: Binding(
        get: { model.errorMessage != nil }, set: { if !$0 { model.errorMessage = nil } })
    ) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(model.errorMessage ?? "")
    }
  }
}

struct Banners: View {
  @Environment(AppModel.self) private var model
  @Environment(\.openSettings) private var openSettings
  @Binding var restoreTarget: RestoreTarget?

  var body: some View {
    VStack(spacing: 8) {
      if !model.drift.isEmpty, model.resetByUninstall {
        Banner(
          symbol: "arrow.uturn.backward.circle",
          text:
            "Uninstalling OpenWithPanel put your file types and links back to their original apps. Restore your OpenWithPanel settings?",
          action: "Restore"
        ) {
          Task { await model.restoreAfterUninstall() }
        }
      } else if !model.drift.isEmpty {
        Banner(
          symbol: "exclamationmark.triangle",
          text: "\(model.drift.count) settings were taken over by other apps.",
          action: "Restore"
        ) {
          Task { await model.apply(undoManager: nil) }
        }
      }
      if let result = model.lastResult, !result.rejected.isEmpty {
        Banner(
          symbol: "hand.raised",
          text:
            "\(result.rejected.count) changes were declined in the system dialog and kept their previous app.",
          action: "Dismiss"
        ) {
          model.lastResult = nil
        }
      }
      if model.extensionlessRouteBroken {
        Banner(
          symbol: "folder.badge.gearshape",
          text:
            "This version of macOS no longer lets OpenWithPanel route files without an extension. Folder rules can set them file by file instead.",
          action: "Set Up Folder Rules"
        ) {
          openSettings()
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, hasBanner ? 12 : 0)
  }

  private var hasBanner: Bool {
    !model.drift.isEmpty || model.lastResult?.rejected.isEmpty == false
      || model.extensionlessRouteBroken
  }
}

struct Banner: View {
  let symbol: String
  let text: LocalizedStringKey
  let action: LocalizedStringKey
  let perform: () -> Void

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: symbol).font(.title3).foregroundStyle(.orange)
      Text(text).frame(maxWidth: .infinity, alignment: .leading)
      Button(action, action: perform).buttonStyle(.glass)
    }
    .controlSize(.large)
    .padding(14)
    .glassEffect(.regular.tint(.orange.opacity(0.15)), in: .rect(cornerRadius: 16))
  }
}

struct ApplyBar: View {
  @Environment(AppModel.self) private var model
  let undoManager: UndoManager?

  var body: some View {
    let changes = model.pendingChanges
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 2) {
        Text("\(changes.count) changes").font(.headline)
        if changes.confirmationCount > 0 {
          Text("macOS will ask you to confirm \(changes.confirmationCount) of them.")
            .font(Typography.detail).foregroundStyle(.secondary)
        }
      }
      Spacer()
      if model.isBusy { ProgressView().controlSize(.small) }
      Button("Discard") { model.discardEdits() }
        .buttonStyle(.glass)
      Button("Apply") {
        Task { await model.apply(undoManager: undoManager) }
      }
      .buttonStyle(.glassProminent)
      .keyboardShortcut(.defaultAction)
      .disabled(model.isBusy)
    }
    .controlSize(.large)
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
  }
}

struct RestoreTarget: Identifiable {
  let id: String
}
