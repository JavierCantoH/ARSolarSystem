//
//  LoginRouter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 18/05/23.
//

import Foundation
import UIKit

class LoginRouter: LoginRouterProtocol {
    
    static func launch(onLoginSuccess: @escaping(UserResult) -> Void) -> UIViewController {
        let dataSource: AuthDataSourceProtocol = AuthDataSource()
        let repository: AuthRepositoryProtocol = AuthRepository(userDataSource: dataSource)
        let loginUseCase: UseCase<UserLoginCredentials, UserResult> = LoginUseCase(userRepository: repository)
        let presenter: LoginPresenterProtocol = LoginPresenter(loginUseCase: loginUseCase)
        let viewController = LoginViewController()
        viewController.presenter = presenter
        viewController.loginSucceed = onLoginSuccess
        return viewController
    }
}

