//
//  AuthRepositoryProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

protocol AuthRepositoryProtocol: AnyObject {
    func registerUser(user: UserRegisterCredentials) throws -> Single<UserResult>
    func loginUser(user: UserLoginCredentials) throws -> Single<UserResult>
    func logoutUser(token: String) throws -> Single<LogoutResponse>
    func getUserData() -> Single<(UserResult?, String?)>
}
