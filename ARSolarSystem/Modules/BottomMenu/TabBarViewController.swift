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
            createNavController(for: SolarSystemViewController(), title: "Discover", imageName: "globe.americas"),
            createNavController(for: ProfileViewController(), title: "Profile", imageName: "person.circle"),
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.tintColor = .white
    }
    
    private func createTabBarItem(title: String, imageName: String) -> UITabBarItem {
        let image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        return tabBarItem
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = createTabBarItem(title: title, imageName: imageName)
        navController.tabBarItem.accessibilityIdentifier = title
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        tabBar.backgroundColor = .blue
        tabBar.unselectedItemTintColor = .lightGray
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
