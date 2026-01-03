//
//  SceneDelegate.swift
//  KarendaExampleApp
//
//  Created by Yefga on 2026-01-03.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        
        // Vertical scrolling example
        let verticalVC = VerticalCalendarViewController()
        verticalVC.tabBarItem = UITabBarItem(
            title: "Vertical",
            image: UIImage(systemName: "arrow.up.arrow.down"),
            tag: 0
        )
        
        // Horizontal scrolling example
        let horizontalVC = HorizontalCalendarViewController()
        horizontalVC.tabBarItem = UITabBarItem(
            title: "Horizontal",
            image: UIImage(systemName: "arrow.left.arrow.right"),
            tag: 1
        )
        
        // Single selection example
        let singleSelectVC = SingleSelectViewController()
        singleSelectVC.tabBarItem = UITabBarItem(
            title: "Single",
            image: UIImage(systemName: "1.circle"),
            tag: 2
        )
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: verticalVC),
            UINavigationController(rootViewController: horizontalVC),
            UINavigationController(rootViewController: singleSelectVC)
        ]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
