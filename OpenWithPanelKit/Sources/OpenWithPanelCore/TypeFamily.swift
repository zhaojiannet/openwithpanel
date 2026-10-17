public struct TypeFamily: Identifiable, Hashable, Sendable {
  public let id: String
  public let types: [String]
  // 没有正式登记类型的扩展名（如 go、rs），运行时换算成本机的类型，多半是 dyn.* 临时类型
  public let extensions: [String]

  public init(id: String, types: [String], extensions: [String] = []) {
    self.id = id
    self.types = types
    self.extensions = extensions
  }
}

// 第二个参数是该配置里用户给这一组添加的扩展名；新旧两份配置各传各的，删掉的扩展名才能被释放
public typealias FamilyMembers = (TypeFamily, [String]) -> [String]

public enum TypeFamilies {
  // 只列具体类型。public.content、public.source-code 这类父类型改默认会被系统拒绝或波及面过大
  public static let all: [TypeFamily] = [
    TypeFamily(id: "text", types: ["public.plain-text", "com.apple.log"]),
    TypeFamily(id: "markdown", types: ["net.daringfireball.markdown"]),
    TypeFamily(
      id: "code",
      // 只列 Stack Overflow 2025 开发者调查中使用率 5% 以上的语言，其余由用户自己添加扩展名
      types: [
        "com.netscape.javascript-source", "com.microsoft.typescript", "public.python-script",
        "com.sun.java-source", "public.c-source", "public.c-header", "public.c-plus-plus-source",
        "public.c-plus-plus-header", "public.php-script", "public.ruby-script",
        "public.swift-source", "public.shell-script", "public.bash-script", "public.zsh-script",
        "org.iso.sql", "public.css", "public.assembly-source", "public.make-source",
      ],
      // .ts 在 macOS 上是 public.mpeg-2-transport-stream（视频），只能覆盖 .tsx
      extensions: ["go", "rs", "kt", "cs", "dart", "lua", "jsx", "ps1"]),
    TypeFamily(
      id: "config",
      types: [
        "public.json", "public.yaml", "public.toml", "public.xml", "com.microsoft.ini",
        "com.apple.property-list", "public.comma-separated-values-text",
      ]),
    TypeFamily(id: "extensionless", types: ["public.data"]),
    TypeFamily(id: "pdf", types: ["com.adobe.pdf"]),
    TypeFamily(
      id: "documents",
      types: [
        "public.rtf", "org.openxmlformats.wordprocessingml.document", "com.microsoft.word.doc",
        "com.apple.iwork.pages.sffpages", "org.oasis-open.opendocument.text",
      ]),
    TypeFamily(
      id: "images",
      types: [
        "public.png", "public.jpeg", "public.heic", "com.compuserve.gif", "public.tiff",
        "org.webmproject.webp", "public.svg-image", "com.microsoft.bmp",
      ]),
    TypeFamily(
      id: "video",
      types: [
        "public.mpeg-4", "com.apple.quicktime-movie", "com.apple.m4v-video", "public.avi",
        "org.matroska.mkv", "org.webmproject.webm",
      ]),
    TypeFamily(
      id: "audio",
      types: [
        "public.mp3", "public.mpeg-4-audio", "com.microsoft.waveform-audio", "public.aiff-audio",
        "org.xiph.flac",
      ]),
    TypeFamily(
      id: "archives",
      types: [
        "public.zip-archive", "org.gnu.gnu-zip-archive", "public.tar-archive",
        "public.bzip2-archive", "org.7-zip.7-zip-archive", "com.rarlab.rar-archive",
      ]),
    // 用户自己添加、又不属于任何现有分组的扩展名
    TypeFamily(id: "custom", types: []),
  ]

  public static func family(containing type: String) -> TypeFamily? {
    all.first { $0.types.contains(type) }
  }
}
