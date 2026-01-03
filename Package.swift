// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Karenda",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Karenda",
            type: .dynamic,
            targets: ["Karenda"]
        )
    ],
    targets: [
        .target(
            name: "Karenda",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "KarendaTests",
            dependencies: ["Karenda"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
