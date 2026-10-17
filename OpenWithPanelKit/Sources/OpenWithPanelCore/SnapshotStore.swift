import Foundation

public struct SnapshotRecord: Identifiable, Hashable, Sendable {
  public enum Kind: Sendable, Hashable {
    case initial
    case history
  }

  public var id: String
  public var date: Date
  public var kind: Kind
}

public struct SnapshotStore: Sendable {
  public static let initialID = "initial"
  public let directory: URL
  public let historyLimit: Int

  public init(directory: URL, historyLimit: Int = 20) {
    self.directory = directory
    self.historyLimit = historyLimit
  }

  public var hasInitial: Bool {
    FileManager.default.fileExists(
      atPath: folder(Self.initialID).appendingPathComponent(Files.handlers).path)
  }

  public func saveInitial(_ snapshot: Snapshot, at date: Date) throws -> SnapshotRecord? {
    guard !hasInitial else { return nil }
    try write(snapshot, configuration: nil, id: Self.initialID, date: date)
    return SnapshotRecord(id: Self.initialID, date: date, kind: .initial)
  }

  // 初始快照之后才纳入管理的类型（新装的 App、新增的类型族成员），在动它们之前把当时的默认 App
  // 补记进初始快照；已有的记录一条不改
  @discardableResult
  public func supplementInitial(with snapshot: Snapshot) throws -> [String] {
    guard hasInitial else { return [] }
    var (initial, _) = try load(Self.initialID)
    let added = snapshot.handlers.keys.filter { initial.handlers[$0] == nil }.sorted()
    guard !added.isEmpty else { return [] }
    for type in added { initial.handlers[type] = snapshot.handlers[type] }
    let url = folder(Self.initialID).appendingPathComponent(Files.handlers)
    let header = (try String(contentsOf: url, encoding: .utf8)).split(separator: "\n").first
      .map(String.init)?.dropFirst(2)
    try DutiFormat.encode(initial.handlers, header: header.map(String.init))
      .write(to: url, atomically: true, encoding: .utf8)
    return added
  }

  public func saveHistory(_ snapshot: Snapshot, configuration: Configuration, at date: Date) throws
    -> SnapshotRecord
  {
    let id = Self.formatter.string(from: date)
    try write(snapshot, configuration: configuration, id: id, date: date)
    try prune()
    return SnapshotRecord(id: id, date: date, kind: .history)
  }

  public func folder(_ id: String) -> URL { directory.appendingPathComponent(id) }

  public func records() -> [SnapshotRecord] {
    let names =
      (try? FileManager.default.contentsOfDirectory(atPath: directory.path)) ?? []
    let records = names.compactMap { name -> SnapshotRecord? in
      guard
        FileManager.default.fileExists(
          atPath: folder(name).appendingPathComponent(Files.handlers).path)
      else { return nil }
      if name == Self.initialID {
        let date =
          (try? FileManager.default.attributesOfItem(atPath: folder(name).path)[.creationDate])
          as? Date
        return SnapshotRecord(id: name, date: date ?? .distantPast, kind: .initial)
      }
      guard let date = Self.formatter.date(from: name) else { return nil }
      return SnapshotRecord(id: name, date: date, kind: .history)
    }
    return records.sorted { $0.date > $1.date }
  }

  public func latestHistory() -> SnapshotRecord? {
    records().first { $0.kind == .history }
  }

  public func load(_ id: String) throws -> (Snapshot, Configuration?) {
    let base = folder(id)
    let handlers = DutiFormat.decode(
      try String(contentsOf: base.appendingPathComponent(Files.handlers), encoding: .utf8))
    let preferencesURL = base.appendingPathComponent(Files.preferences)
    let preferences =
      FileManager.default.fileExists(atPath: preferencesURL.path)
      ? DutiFormat.decode(try String(contentsOf: preferencesURL, encoding: .utf8)) : [:]
    let configurationURL = base.appendingPathComponent(Files.configuration)
    let configuration =
      FileManager.default.fileExists(atPath: configurationURL.path)
      ? try JSONDecoder().decode(Configuration.self, from: Data(contentsOf: configurationURL))
      : nil
    return (Snapshot(handlers: handlers, preferenceHandlers: preferences), configuration)
  }

  public func delete(_ id: String) throws {
    guard id != Self.initialID else { return }
    try FileManager.default.removeItem(at: folder(id))
  }

  enum Files {
    static let handlers = "handlers.duti"
    static let preferences = "preferences.duti"
    static let configuration = "configuration.json"
    static let preferencesBackup = "LSHandlers.plist"
  }

  public func preferencesBackupURL(_ id: String) -> URL {
    folder(id).appendingPathComponent(Files.preferencesBackup)
  }

  private func write(_ snapshot: Snapshot, configuration: Configuration?, id: String, date: Date)
    throws
  {
    let base = folder(id)
    try FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
    let header = "OpenWithPanel snapshot \(ISO8601DateFormatter().string(from: date))"
    try DutiFormat.encode(snapshot.handlers, header: header)
      .write(to: base.appendingPathComponent(Files.handlers), atomically: true, encoding: .utf8)
    try DutiFormat.encode(snapshot.preferenceHandlers, header: header)
      .write(to: base.appendingPathComponent(Files.preferences), atomically: true, encoding: .utf8)
    if let configuration {
      try ConfigurationStore.encode(configuration)
        .write(to: base.appendingPathComponent(Files.configuration), options: .atomic)
    }
  }

  private func prune() throws {
    for record in records().filter({ $0.kind == .history }).dropFirst(historyLimit) {
      try delete(record.id)
    }
  }

  private static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyyMMdd'T'HHmmss.SSS'Z'"
    return formatter
  }()
}
