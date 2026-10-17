import Foundation

public enum DiagnosticReport {
  public static func build(
    date: Date, systemVersion: String, appVersion: String, configuration: Configuration,
    current: Snapshot, diagnoses: [FileDiagnosis], logLines: [String]
  ) throws -> String {
    var sections: [String] = [
      "OpenWithPanel diagnostic report",
      "Date: \(ISO8601DateFormatter().string(from: date))",
      "System: \(systemVersion)",
      "App: \(appVersion)",
    ]
    let configurationJSON = String(
      decoding: try ConfigurationStore.encode(configuration), as: UTF8.self)
    sections.append("## Configuration\n\(configurationJSON)")
    let managed = Set(Planner.desiredHandlers(for: configuration).keys)
    let handlers = current.handlers.filter { managed.contains($0.key) }
    sections.append("## Current handlers (managed types)\n" + DutiFormat.encode(handlers))
    sections.append(
      "## Preference entries (locked types)\n" + DutiFormat.encode(current.preferenceHandlers))
    for diagnosis in diagnoses {
      sections.append(
        """
        ## File
        type: \(diagnosis.contentType ?? "-")
        supertypes: \(diagnosis.supertypes.joined(separator: ", "))
        kind: \(diagnosis.kind?.rawValue ?? "-")
        opens with: \(diagnosis.effectiveApp?.bundleID ?? "-")
        reason: \(diagnosis.reason)
        declarations:
        """ + diagnosis.declarations.map(Self.line).joined())
    }
    sections.append("## Log\n" + logLines.joined(separator: "\n"))
    return sections.joined(separator: "\n\n") + "\n"
  }

  private static func line(_ declaration: AppDeclaration) -> String {
    let fields = [declaration.matched, declaration.role, declaration.rank].map { $0 ?? "-" }
    return "\n  \(declaration.app.bundleID)\t" + fields.joined(separator: "\t")
  }
}
