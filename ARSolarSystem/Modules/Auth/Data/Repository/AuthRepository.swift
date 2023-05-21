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
    
    func logoutUser(token: String) throws -> Single<LogoutResponse> {
        return try userDataSource.logoutUser(token: token)
    }
    
    func getUserData() -> Single<(UserResult?, String?)> {
        return userDataSource.getUserData()
    }
}
