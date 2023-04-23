//
//  SceneDelegate.swift
//  AppStoreJA
//
//  Created by joe on 2023/04/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    @available(iOS 13.0, *)
    func setupNewNavBarAppearance() {
        let newNavBarAppearance = UINavigationBarAppearance()
        newNavBarAppearance.configureWithDefaultBackground()
        newNavBarAppearance.backgroundColor = .clear
        newNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        newNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().scrollEdgeAppearance = newNavBarAppearance
        UINavigationBar.appearance().compactAppearance = newNavBarAppearance
        UINavigationBar.appearance().standardAppearance = newNavBarAppearance
    }
    
    @available(iOS 13.0, *)
    func setupNewTabBarAppearance() {
        let newTabBarAppearance = UITabBarAppearance()
        newTabBarAppearance.configureWithDefaultBackground()
        newTabBarAppearance.backgroundColor = .clear
        
        UITabBar.appearance().standardAppearance = newTabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = newTabBarAppearance
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupNewNavBarAppearance()
        setupNewTabBarAppearance()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = BaseTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

