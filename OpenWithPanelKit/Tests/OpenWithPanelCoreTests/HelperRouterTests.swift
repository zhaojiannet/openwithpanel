import Foundation
import Testing

@testable import OpenWithPanelCore

@Suite("辅助程序路由")
struct HelperRouterTests {
  let home = "/Users/u"

  func facts(_ path: String, type: String? = "public.data", kind: ContentKind = .text) -> FileFacts
  {
    FileFacts(path: path, contentType: type, supertypes: ["public.item"], kind: kind)
  }

  func router(_ configure: (inout Configuration) -> Void) -> HelperRouter {
    var configuration = Configuration()
    configure(&configuration)
    return HelperRouter(configuration: configuration, homeDirectory: home)
  }

  @Test("文本文件按类型分配转交目标 App")
  func textGoesToAssignment() {
    let decision = router { $0.assignments["public.data"] = "dev.zed.Zed" }
      .decide(facts("/Users/u/p/.env"))
    #expect(decision == .open(bundleID: "dev.zed.Zed", reason: .assignment(type: "public.data")))
  }

  @Test("二进制默认在 Finder 中高亮")
  func binaryRevealsByDefault() {
    let decision = router { $0.assignments["public.data"] = "dev.zed.Zed" }
      .decide(facts("/Users/u/blob", kind: .binary))
    #expect(decision == .reveal(reason: .binary))
  }

  @Test("二进制选「交还系统」时用初始快照的 App")
  func binaryHandsBack() {
    let decision = router {
      $0.assignments["public.data"] = "dev.zed.Zed"
      $0.binaryAction = .handBackToSystem
      $0.fallbacks["public.data"] = "com.apple.TextEdit"
    }.decide(facts("/Users/u/blob", kind: .binary))
    #expect(
      decision == .open(bundleID: "com.apple.TextEdit", reason: .fallback(type: "public.data")))
  }

  @Test("规则按顺序匹配，首条命中生效")
  func firstMatchingRuleWins() {
    let first = Rule(
      name: "docker", namePattern: "Dockerfile*", target: .app(bundleID: "a.b.First"))
    let second = Rule(name: "all", namePattern: "*", target: .app(bundleID: "a.b.Second"))
    let decision = router { $0.rules = [first, second] }.decide(facts("/x/Dockerfile.dev"))
    #expect(decision == .open(bundleID: "a.b.First", reason: .rule(id: first.id, name: "docker")))
  }

  @Test("文件名匹配不区分大小写")
  func patternIsCaseInsensitive() {
    let rule = Rule(name: "make", namePattern: "makefile", target: .revealInFinder)
    #expect(
      router { $0.rules = [rule] }.decide(facts("/x/Makefile"))
        == .reveal(reason: .rule(id: rule.id, name: "make")))
  }

  @Test("路径前缀支持 ~ 并按目录边界匹配")
  func pathPrefixRespectsDirectoryBoundary() {
    let rule = Rule(name: "work", pathPrefix: "~/Work", target: .app(bundleID: "a.b.Work"))
    let r = router { $0.rules = [rule] }
    #expect(
      r.decide(facts("/Users/u/Work/x/.env"))
        == .open(bundleID: "a.b.Work", reason: .rule(id: rule.id, name: "work")))
    #expect(r.decide(facts("/Users/u/Workshop/.env")) == .reveal(reason: .noRoute))
  }

  @Test("规则只作用于自己声明的类型")
  func ruleLimitedToContentTypes() {
    let rule = Rule(
      name: "md", pathPrefix: "/notes", contentTypes: ["net.daringfireball.markdown"],
      target: .app(bundleID: "a.b.Notes"))
    let r = router { $0.rules = [rule] }
    #expect(r.decide(facts("/notes/a.env")) == .reveal(reason: .noRoute))
    #expect(
      r.decide(facts("/notes/a.md", type: "net.daringfireball.markdown"))
        == .open(bundleID: "a.b.Notes", reason: .rule(id: rule.id, name: "md")))
  }

  @Test("没有任何条件的规则不生效，停用的规则也不生效")
  func emptyOrDisabledRulesNeverMatch() {
    let empty = Rule(name: "empty", target: .revealInFinder)
    let disabled = Rule(name: "off", namePattern: "*", target: .revealInFinder, isEnabled: false)
    #expect(
      router { $0.rules = [empty, disabled] }.decide(facts("/x/.env")) == .reveal(reason: .noRoute))
  }

  @Test("按内容类型匹配")
  func matchesContentKind() {
    let rule = Rule(name: "bin", contentKind: .binary, target: .app(bundleID: "a.b.Hex"))
    let r = router { $0.rules = [rule] }
    #expect(
      r.decide(facts("/x/blob", kind: .binary))
        == .open(bundleID: "a.b.Hex", reason: .rule(id: rule.id, name: "bin")))
    #expect(r.decide(facts("/x/.env")) == .reveal(reason: .noRoute))
  }
}
