import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI

struct RestoreSheet: View {
  @Environment(AppModel.self) private var model
  @Environment(\.dismiss) private var dismiss
  let target: RestoreTarget
  @State private var changes: [HandlerChange] = []

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(target.id == SnapshotStore.initialID ? "Restore Initial" : "Restore Snapshot")
        .font(.title2)
      Text(
        "macOS has no way to remove a file association, only to point it at another app. Restoring points each changed type back to the app recorded in the snapshot."
      )
      .foregroundStyle(.secondary)
      .fixedSize(horizontal: false, vertical: true)
      if changes.isEmpty {
        Text("Nothing to restore. Everything already matches.")
      } else {
        List(changes) { change in
          HStack {
            Text(verbatim: model.formatName(change.type))
            Spacer()
            Text(model.appName(change.from)).foregroundStyle(.secondary)
            Image(systemName: "arrow.right").foregroundStyle(.secondary)
            Text(model.appName(change.to))
          }
        }
        .frame(minHeight: 200)
      }
      HStack {
        Spacer()
        Button("Cancel", role: .cancel) { dismiss() }
        Button("Restore") {
          Task {
            await model.restore(target.id)
            dismiss()
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(changes.isEmpty || model.isBusy)
      }
    }
    .padding()
    .frame(width: 520)
    .onAppear { changes = model.restorePreview(target.id) }
  }
}
