import AppKit
import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI
import UniformTypeIdentifiers

struct AppLabel: View {
  @Environment(AppModel.self) private var model
  let bundleID: String?
  var placeholder: LocalizedStringKey = "System Default"

  var body: some View {
    if let bundleID, let app = model.app(bundleID) {
      Label {
        Text(app.name)
      } icon: {
        Image(nsImage: model.icon(for: app)).resizable().frame(width: 20, height: 20)
      }
    } else if let bundleID {
      Text(bundleID)
    } else {
      Text(placeholder).foregroundStyle(.secondary)
    }
  }
}

struct AppPickerMenu: View {
  @Environment(AppModel.self) private var model
  let selection: FamilySelection
  let candidates: [AppInfo]
  var inheritsFromGroup = false
  var followFamily: (() -> Void)? = nil
  var controlSize: ControlSize = .large
  var isBlocked = false
  var dontOpen: (() -> Void)? = nil
  let onPick: (String) -> Void

  var body: some View {
    Menu {
      if let followFamily {
        Button("Follow Group", action: followFamily)
        Divider()
      }
      ForEach(candidates, id: \.bundleID) { app in
        Button {
          onPick(app.bundleID)
        } label: {
          Label {
            Text(app.name)
          } icon: {
            Image(nsImage: model.icon(for: app))
          }
        }
      }
      if !candidates.isEmpty { Divider() }
      Button("Other…") { chooseOther() }
      if let dontOpen {
        Divider()
        Button("Don’t Open", systemImage: "nosign", action: dontOpen)
      }
    } label: {
      switch selection {
      case _ where isBlocked:
        Label("Don’t Open", systemImage: "nosign").foregroundStyle(.secondary)
      case .app(let bundleID) where inheritsFromGroup:
        Label {
          Text("Same as Group")
        } icon: {
          if let app = model.app(bundleID) {
            Image(nsImage: model.icon(for: app)).resizable().frame(width: 16, height: 16)
          }
        }
        .foregroundStyle(.secondary)
      case .app(let bundleID): AppLabel(bundleID: bundleID)
      case .mixed: Text("Mixed").foregroundStyle(.secondary)
      case .none: AppLabel(bundleID: nil)
      }
    }
    .controlSize(controlSize)
    .fixedSize()
  }

  private func chooseOther() {
    let panel = NSOpenPanel()
    panel.allowedContentTypes = [.application]
    panel.directoryURL = URL(fileURLWithPath: "/Applications")
    guard panel.runModal() == .OK, let url = panel.url,
      let app = model.launchServices.app(at: url)
    else { return }
    onPick(app.bundleID)
  }
}
