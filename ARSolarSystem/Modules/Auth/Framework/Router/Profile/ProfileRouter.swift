//
//  ProfileRouter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 21/05/23.
//

import Foundation
import UIKit

class ProfileRouter: ProfileRouterProtocol {
    
    static func launch() -> UIViewController {
        let dataSource = AuthDataSource.shared
        let repository: AuthRepositoryProtocol = AuthRepository(userDataSource: dataSource)
        let logoutUseCase: UseCase<String, LogoutResponse> = LogoutUseCase(userRepository: repository)
        let getUserDataUseCase: UseCase<Void, (UserResult?, String?)> = GetUserDataUseCase(userRepository: repository)
        let presenter: ProfilePresenterProtocol = ProfilePresenter(logoutUseCase: logoutUseCase, getUserDataUseCase: getUserDataUseCase)
        let viewController = ProfileViewController()
        viewController.presenter = presenter
        return viewController
    }
}
