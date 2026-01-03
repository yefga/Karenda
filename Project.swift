import ProjectDescription

let project = Project(
    name: "Karenda",
    organizationName: "Example",
    settings: .settings(
        base: [
            "BUILD_LIBRARY_FOR_DISTRIBUTION": "YES",
            "SKIP_INSTALL": "NO",
            "DEVELOPMENT_TEAM": "",
            "CODE_SIGN_IDENTITY": "-"
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "Karenda",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.example.karenda",
            deploymentTargets: .iOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Sources/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "KarendaTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.example.karenda.tests",
            deploymentTargets: .iOS("13.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Karenda")
            ]
        )
    ]
)
