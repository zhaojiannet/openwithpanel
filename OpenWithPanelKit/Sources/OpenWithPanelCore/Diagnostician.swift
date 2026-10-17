import Foundation
import OpenWithPanelPlatform

public struct FileDiagnosis: Equatable, Sendable {
  public enum Reason: Equatable, Sendable {
    case perFileOverride(bundleID: String)
    case helper(RouteDecision)
    case userPreference(type: String)
    case systemChoice(type: String)
    case unknown
  }

  public var path: String
  public var contentType: String?
  public var supertypes: [String]
  public var kind: ContentKind?
  public var effectiveApp: AppInfo?
  public var reason: Reason
  public var candidates: [AppInfo]
  public var declarations: [AppDeclaration]
}

public struct AppDeclaration: Equatable, Sendable {
  public var app: AppInfo
  public var matched: String?
  public var role: String?
  public var rank: String?

  public init(app: AppInfo, matched: String?, role: String?, rank: String?) {
    self.app = app
    self.matched = matched
    self.role = role
    self.rank = rank
  }
}

public struct Diagnostician: Sendable {
  let launchServices: any LaunchServicesClient
  let catalog: any TypeCatalog
  let preferences: any HandlerPreferencesStore
  let openWith: any OpenWithAttributeStore
  let reader: any FileHeadReading
  let apps: any AppCatalog
  let homeDirectory: String

  public init(
    launchServices: any LaunchServicesClient, catalog: any TypeCatalog,
    preferences: any HandlerPreferencesStore, openWith: any OpenWithAttributeStore,
    reader: any FileHeadReading, apps: any AppCatalog, homeDirectory: String
  ) {
    self.launchServices = launchServices
    self.catalog = catalog
    self.preferences = preferences
    self.openWith = openWith
    self.reader = reader
    self.apps = apps
    self.homeDirectory = homeDirectory
  }

  public func diagnose(_ url: URL, configuration: Configuration) -> FileDiagnosis {
    let facts = FileInspector(catalog: catalog, reader: reader).facts(for: url)
    let effective = launchServices.defaultApp(forFile: url)
    let candidates = facts.contentType.map(launchServices.candidateApps(forType:)) ?? []
    let reason: FileDiagnosis.Reason
    if let override = openWith.overrideBundleID(of: url),
      effective?.matches(bundleID: override) ?? false
    {
      reason = .perFileOverride(bundleID: override)
    } else if effective?.matches(bundleID: HelperIdentity.bundleID) ?? false {
      let router = HelperRouter(configuration: configuration, homeDirectory: homeDirectory)
      reason = .helper(router.decide(facts))
    } else if let type = userChoice(in: facts.typeChain, effective: effective) {
      reason = .userPreference(type: type)
    } else if let type = facts.contentType {
      reason = .systemChoice(type: type)
    } else {
      reason = .unknown
    }
    return FileDiagnosis(
      path: url.path, contentType: facts.contentType, supertypes: facts.supertypes,
      kind: facts.kind, effectiveApp: effective, reason: reason, candidates: candidates,
      declarations: candidates.map { declaration(of: $0, for: facts) })
  }

  // 上级类型的偏好条目不决定下级类型：.swift 继承 public.data，public.data 指给辅助程序，
  // .swift 照样由 Xcode 打开。所以只有条目指向的正是实际打开它的 App，才算用户选的
  func userChoice(in typeChain: [String], effective: AppInfo?) -> String? {
    guard let effective else { return nil }
    let handlers = preferences.contentTypeHandlers()
    return typeChain.first { handlers[$0.lowercased()].map(effective.matches(bundleID:)) ?? false }
  }

  // 一个 App 可能在多项里都声明到这个文件，取最具体的一项：扩展名，其次文件本身的类型，
  // 最后是它继承的类型（系统给的上级类型没有远近顺序）。候选里有、声明里找不到的，matched 为 nil
  func declaration(of app: AppInfo, for facts: FileFacts) -> AppDeclaration {
    let ext = (facts.path as NSString).pathExtension.lowercased()
    let documentTypes = apps.app(at: app.url)?.documentTypes ?? []
    var best: (score: Int, AppDeclaration)?
    for documentType in documentTypes {
      let match: (Int, String)?
      if !ext.isEmpty, documentType.extensions.contains(where: { $0.lowercased() == ext }) {
        match = (0, "." + ext)
      } else if let type = facts.contentType, documentType.contentTypes.contains(type) {
        match = (1, type)
      } else if let type = facts.supertypes.first(where: documentType.contentTypes.contains) {
        match = (2, type)
      } else {
        match = nil
      }
      guard let (score, matched) = match, score < (best?.score ?? .max) else { continue }
      best = (
        score,
        AppDeclaration(
          app: app, matched: matched, role: documentType.role, rank: documentType.rank)
      )
    }
    return best?.1 ?? AppDeclaration(app: app, matched: nil, role: nil, rank: nil)
  }
}
