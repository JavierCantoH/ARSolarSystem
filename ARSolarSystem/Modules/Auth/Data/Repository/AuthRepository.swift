//
//  AuthRepository.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

class AuthRepository: AuthRepositoryProtocol {
    
    private var userDataSource: AuthDataSourceProtocol
    
    init(userDataSource: AuthDataSourceProtocol) {
        self.userDataSource = userDataSource
    }
    
    func registerUser(user: UserRegisterCredentials) throws -> Single<UserResult> {
        return try userDataSource.registerUser(user: user)
    }
    
    func loginUser(user: UserLoginCredentials) throws -> Single<UserResult> {
        return try userDataSource.loginUser(user: user)
    }
}
