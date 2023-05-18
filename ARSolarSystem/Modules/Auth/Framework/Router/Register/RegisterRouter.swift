//
//  RegisterRouter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import UIKit

class RegisterRouter: RegisterRouterProtocol {
    
    static func launch(onRegisterSuccess: @escaping(UserResult) -> Void) -> UIViewController {
        let dataSource: AuthDataSourceProtocol = AuthDataSource()
        let repository: AuthRepositoryProtocol = AuthRepository(userDataSource: dataSource)
        let registerUseCase: UseCase<UserRegisterCredentials, UserResult> = RegisterUseCase(userRepository: repository)
        let presenter: RegisterPresenterProtocol = RegisterPresenter(registerUseCase: registerUseCase)
        let viewController = RegisterViewController()
        viewController.presenter = presenter
        viewController.registerSucceed = onRegisterSuccess
        return viewController
    }
}
