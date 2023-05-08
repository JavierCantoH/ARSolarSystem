//
//  RegisterUseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

class RegisterUseCase: UseCase<UserCredentials, UserResult> {
    
    var userRepository: RegisterRepositoryProtocol
    
    init(userRepository: RegisterRepositoryProtocol) {
        self.userRepository = userRepository
    }

    override func execute(params: UserCredentials) throws -> Single<UserResult> {
        return try userRepository.registerUser(user: params)
    }
}
