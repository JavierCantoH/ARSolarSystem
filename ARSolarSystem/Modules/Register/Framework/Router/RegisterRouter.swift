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
        let dataSource: RegisterDataSourceProtocol = RegisterDataSource()
        let repository: RegisterRepositoryProtocol = RegisterRepository(userDataSource: dataSource)
        let registerUseCase: UseCase<UserCredentials, UserResult> = RegisterUseCase(userRepository: repository)
        let presenter: RegisterPresenterProtocol = RegisterPresenter(registerUseCase: registerUseCase)
        let viewController = RegisterViewController()
        viewController.presenter = presenter
        viewController.registerSuccess = onRegisterSuccess
        return viewController
    }
}
