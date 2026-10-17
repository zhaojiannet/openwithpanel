import SwiftUI

@main
struct OpenWithPanelApp: App {
  @State private var model = AppModel()

  var body: some Scene {
    Window("OpenWithPanel", id: "main") {
      MainView()
        .environment(model)
        .task { await model.load() }
    }
    .defaultSize(width: 760, height: 680)
    .windowResizability(.contentMinSize)
    .commands {
      CommandGroup(replacing: .appInfo) {
        Button("About OpenWithPanel") { AboutPanel.show() }
      }
    }

    Settings {
      SettingsView()
        .environment(model)
    }
  }
}
