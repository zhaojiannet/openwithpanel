public enum DriftDetector {
  // 已应用的配置与当前实际状态的差异，典型情况是装了 Xcode 之类的 App 抢走了关联
  public static func drift(
    configuration: Configuration, current: Snapshot, initial: Snapshot,
    members: FamilyMembers = { family, _ in family.types }
  ) -> [PlannedChange] {
    Planner.plan(
      configuration: configuration, previous: configuration, current: current, initial: initial,
      members: members)
  }
}
