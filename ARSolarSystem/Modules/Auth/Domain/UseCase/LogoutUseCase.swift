//
//  LogoutUseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 21/05/23.
//

import Foundation
import RxSwift

class LogoutUseCase: UseCase<String, LogoutResponse> {
    
    var userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }

    override func execute(params: String) throws -> Single<LogoutResponse> {
        return try userRepository.logoutUser(token: params)
    }
}
