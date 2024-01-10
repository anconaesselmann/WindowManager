// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WindowManager",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "WindowManager",
            targets: ["WindowManager"]),
    ],
    dependencies: [
        .package(url: "https://github.com/anconaesselmann/ToolbarManager", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "WindowManager",
            dependencies: ["ToolbarManager"]
        ),
    ]
)
