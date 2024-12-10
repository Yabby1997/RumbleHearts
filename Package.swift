// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RumbleHearts",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "RumbleHearts",
            type: .dynamic,
            targets: ["RumbleHearts"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", branch: "main")
    ],
    targets: [
        .target(
            name: "RumbleHearts",
            dependencies: [
                "SwiftGodot",
            ]
        ),
    ]
)
