//
//  TabBarViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 14/04/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createNavController(for: SolarSystemViewController(), title: "Discover", image: UIImage(named: "planet")!),
            createNavController(for: ProfileViewController(), title: "Profile", image: UIImage(named: "user")!),
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.accessibilityIdentifier = title
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        setToolbarAppereance(navController: navController)
        return navController
    }
    
    private func setToolbarAppereance(backgroundColor: UIColor = .blue, navController: UINavigationController?) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = backgroundColor
        navController?.navigationBar.standardAppearance = navBarAppearance
        navController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navController?.navigationBar.tintColor = .white
    }
}
