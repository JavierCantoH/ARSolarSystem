//
//  GetUserDataUseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 21/05/23.
//

import Foundation
import RxSwift

class GetUserDataUseCase: UseCase<Void, (UserResult?, String?)> {
    
    var userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }

    override func execute(params: Void) throws -> Single<(UserResult?, String?)> {
        return userRepository.getUserData()
    }
}
