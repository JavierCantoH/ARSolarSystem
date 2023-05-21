//
//  LoginUseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 18/05/23.
//

import Foundation
import RxSwift

class LoginUseCase: UseCase<UserLoginCredentials, UserResult> {
    
    var userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }

    override func execute(params: UserLoginCredentials) throws -> Single<UserResult> {
        return try userRepository.loginUser(user: params)
    }
}
