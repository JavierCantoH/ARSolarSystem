//
//  AppDelegate.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 25/03/23.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let authDataSource = AuthDataSource.shared
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        checkIfLogin()
        return true
    }
    
    private func checkIfLogin() {
        let result = authDataSource.getUserData()
        
        result.subscribe(onSuccess: { [weak self] userResult, tokenResult in
            if let user = userResult, let token = tokenResult {
                print("User login: \(user)")
                print("User token: \(token)")
                // User is logged in, handle the session
                self?.loginSuccess()
            } else {
                // Either user or token (or both) are nil
                self?.logout()
            }
        }, onFailure: { error in
            print("Error checkIfLogin: \(error)")
        }).disposed(by: disposeBag)
    }
    
    private func performAction(completion: (() -> Void)? = nil) {
        completion?()
    }
    
    private func presentTabBarVC() {
        let viewController = TabBarViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    private func presentLoginScreen() {
        let viewController = LoginRouter.launch { [weak self] userResult in
            print("User login success: \(userResult)")
            self?.loginSuccess()
        }
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func loginSuccess() {
        performAction { [weak self] in
            self?.presentTabBarVC()
        }
    }
    
    func logout() {
        performAction { [weak self] in
            self?.presentLoginScreen()
        }
    }
}
