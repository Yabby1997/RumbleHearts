// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RumbleHeartsSwift",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "RumbleHeartsSwift",
            type: .dynamic,
            targets: ["RumbleHeartsSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", branch: "main")
    ],
    targets: [
        .target(
            name: "RumbleHeartsSwift",
            dependencies: [
                "SwiftGodot",
            ]
        ),
    ]
)
