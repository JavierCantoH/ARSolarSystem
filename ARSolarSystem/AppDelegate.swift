//
//  AppDelegate.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 25/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let authDataSource = AuthDataSource()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let result = authDataSource.getUserData()
        // Check if user is logged in
        if let user = result.0, let token = result.1 {
            // Both user and token are non-nil
            print("User login: \(user)")
            print("User token: \(token)")
            // User is logged in, handle the session
            presentTabBarVC()
        } else {
            // Either user or token (or both) are nil
            presentLoginScreen()
        }
        return true
    }
    
    func presentTabBarVC() {
        let viewController = TabBarViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func presentLoginScreen() {
        let viewController = LoginRouter.launch { [weak self] userResult in
            print("User login success: \(userResult)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.presentTabBarVC()
            }
        }
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
