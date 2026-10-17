import OpenWithPanelCore
import OpenWithPanelPlatform
import SwiftUI

extension TypeFamily {
  var title: LocalizedStringResource {
    switch id {
    case "text": "Text"
    case "markdown": "Markdown"
    case "code": "Code"
    case "config": "Config & Data"
    case "extensionless": "Files Without Extension"
    case "pdf": "PDF"
    case "documents": "Documents"
    case "images": "Images"
    case "video": "Video"
    case "audio": "Audio"
    case "archives": "Archives"
    case "custom": "Custom"
    default: LocalizedStringResource(stringLiteral: id)
    }
  }

  var tint: Color {
    switch id {
    case "text": .gray
    case "markdown": .teal
    case "code": .indigo
    case "config": .mint
    case "extensionless": .orange
    case "pdf": .red
    case "documents": .blue
    case "images": .green
    case "video": .purple
    case "audio": .pink
    case "archives": .brown
    case "custom": .secondary
    default: .gray
    }
  }

  var symbol: String {
    switch id {
    case "text": "doc.plaintext"
    case "markdown": "text.alignleft"
    case "code": "chevron.left.forwardslash.chevron.right"
    case "config": "curlybraces"
    case "extensionless": "doc"
    case "pdf": "doc.richtext"
    case "documents": "doc.text"
    case "images": "photo"
    case "video": "film"
    case "audio": "waveform"
    case "archives": "archivebox"
    case "custom": "square.dashed"
    default: "doc"
    }
  }
}

extension LinkKind {
  var title: LocalizedStringResource {
    switch id {
    case "web": "Web Browser"
    case "mail": "Email"
    case "calendar": "Calendar Subscriptions"
    case "phone": "Phone Calls"
    case "messages": "Text Messages"
    case "facetime": "FaceTime"
    case "ssh": "SSH"
    case "ftp": "FTP"
    case "screenSharing": "Screen Sharing"
    default: LocalizedStringResource(stringLiteral: id)
    }
  }

  var symbol: String {
    switch id {
    case "web": "globe"
    case "mail": "envelope"
    case "calendar": "calendar"
    case "phone": "phone"
    case "messages": "message"
    case "facetime": "video"
    case "ssh": "terminal"
    case "ftp": "externaldrive.connected.to.line.below"
    case "screenSharing": "rectangle.on.rectangle"
    default: "link"
    }
  }

  var tint: Color {
    switch id {
    case "web": .blue
    case "mail": .cyan
    case "calendar": .red
    case "phone", "messages", "facetime": .green
    default: .gray
    }
  }
}

extension BinaryAction {
  var title: LocalizedStringKey {
    switch self {
    case .revealInFinder: "Show in Finder"
    case .openWithTarget: "Open with the same app"
    case .handBackToSystem: "Open with the original app"
    }
  }
}

extension ContentKind {
  var title: LocalizedStringKey {
    switch self {
    case .text: "Text"
    case .binary: "Binary"
    }
  }
}

extension CodeSection {
  var title: LocalizedStringKey {
    switch self {
    case .web: "Web"
    case .systems: "Systems & Apps"
    case .jvm: "JVM"
    case .scripting: "Scripting & Shell"
    case .functional: "Functional"
    case .other: "Other Languages & Formats"
    }
  }
}
