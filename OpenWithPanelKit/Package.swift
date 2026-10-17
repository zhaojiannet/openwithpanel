// swift-tools-version: 6.4
import PackageDescription

let concurrency: [SwiftSetting] = [.enableUpcomingFeature("ApproachableConcurrency")]

let package = Package(
  name: "OpenWithPanelKit",
  platforms: [.macOS(.v26)],
  products: [
    .library(name: "OpenWithPanelCore", targets: ["OpenWithPanelCore"]),
    .library(name: "OpenWithPanelPlatform", targets: ["OpenWithPanelPlatform"]),
  ],
  targets: [
    .target(name: "OpenWithPanelPlatform", swiftSettings: concurrency),
    .target(
      name: "OpenWithPanelCore", dependencies: ["OpenWithPanelPlatform"], swiftSettings: concurrency
    ),
    .testTarget(
      name: "OpenWithPanelCoreTests", dependencies: ["OpenWithPanelCore"],
      swiftSettings: concurrency),
  ]
)
