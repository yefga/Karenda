import ProjectDescription

let project = Project(
    name: "KarendaExample",
    organizationName: "Example",
    options: .options(
        automaticSchemesOptions: .enabled(
            targetSchemesGrouping: .byNameSuffix(build: ["App"], test: [], run: ["App"])
        )
    ),
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "",
            "CODE_SIGN_IDENTITY": "-",
            "CODE_SIGNING_REQUIRED": "NO",
            "CODE_SIGNING_ALLOWED": "NO"
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "KarendaExampleApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.karenda.example",
            deploymentTargets: .iOS("13.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "LaunchScreen",
                "UIApplicationSupportsIndirectInputEvents": true,
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [
                            [
                                "UISceneConfigurationName": "Default Configuration",
                                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                            ]
                        ]
                    ]
                ],
                "UISupportedInterfaceOrientations": [
                    "UIInterfaceOrientationPortrait",
                    "UIInterfaceOrientationLandscapeLeft",
                    "UIInterfaceOrientationLandscapeRight"
                ]
            ]),
            sources: ["KarendaExampleApp/Sources/**"],
            resources: ["KarendaExampleApp/Resources/**"],
            dependencies: [
                .project(target: "Karenda", path: "../")
            ]
        )
    ]
)
