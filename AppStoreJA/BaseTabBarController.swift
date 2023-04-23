//
//  BaseTabBarController.swift
//  AppStoreJA
//
//  Created by joe on 2023/04/23.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .systemBackground
        redViewController.navigationItem.title = "Apps"
        let redNavController = UINavigationController(rootViewController: redViewController)
        redNavController.tabBarItem.title = "Apps"
        redNavController.tabBarItem.image = #imageLiteral(resourceName: "apps")
        redNavController.navigationBar.prefersLargeTitles = true
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .systemBackground
        blueViewController.navigationItem.title = "Search"
        let blueNavController = UINavigationController(rootViewController: blueViewController)
        blueNavController.tabBarItem.title = "Search"
        blueNavController.tabBarItem.image = #imageLiteral(resourceName: "search")
        blueNavController.navigationBar.prefersLargeTitles = true
        
//        tabBar.tintColor = .black
        
        viewControllers = [
            redNavController,
            blueNavController
        ]
    }
}
