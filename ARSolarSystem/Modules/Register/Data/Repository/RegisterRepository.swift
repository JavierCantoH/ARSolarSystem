//
//  RegisterRepository.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

class RegisterRepository: RegisterRepositoryProtocol {
    
    private var userDataSource: RegisterDataSourceProtocol
    
    init(userDataSource: RegisterDataSourceProtocol) {
        self.userDataSource = userDataSource
    }
    
    func registerUser(user: UserCredentials) throws -> Single<UserResult> {
        return try userDataSource.registerUser(user: user)
    }
}
