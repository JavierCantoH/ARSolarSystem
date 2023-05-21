//
//  AuthDataSource.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift
import Alamofire
import SwiftJWT

class AuthDataSource: AuthDataSourceProtocol {
    
    func registerUser(user: UserRegisterCredentials) throws -> Single<UserResult> {
        return requestRegister(user: user)
            .do(onSuccess: { user in
                print("Register user success: \(user)")
        }, afterSuccess: nil, onError: { error in
            throw MyError.error(error.localizedDescription)
        }, afterError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
                .map { response in
                    return response
                }
    }
    
    func loginUser(user: UserLoginCredentials) throws -> Single<UserResult> {
        return requestLogin(user: user)
            .do(onSuccess: { [weak self] response in
                print("Login user success: \(response)")
                self?.storeUserData(response.user, token: response.token)
        }, afterSuccess: nil, onError: { error in
            throw MyError.error(error.localizedDescription)
        }, afterError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
                .map { response in
                    return response.user
                }
    }
    
    func getUserData() -> (UserResult?, String?) {
        let defaults = UserDefaults.standard
        guard let email = defaults.string(forKey: "userEmail"),
              let firstName = defaults.string(forKey: "userFirstName"),
              let lastName = defaults.string(forKey: "userLastName"),
              let alias = defaults.string(forKey: "userAlias"),
              let token = defaults.string(forKey: "userToken") else {
            return (nil, nil)
        }
        let id = defaults.string(forKey: "userId")
        let user = UserResult(email: email, firstName: firstName, lastName: lastName, alias: alias, id: id)
        return (user, token)
    }
    
    private func requestRegister(user: UserRegisterCredentials) -> Single<UserResult> {
        return Single.create { observable in
            let parameters = [
                "FirstName": user.firstName,
                "LastName": user.lastName,
                "Alias": user.alias,
                "Email": user.email,
                "Password": user.password
            ]
            AF.request("http://localhost:3000/auth/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseDecodable(of: UserResult.self) { response in
                    print(response)
                    switch response.result {
                    case .success(let user):
                        observable(.success(user))
                    case .failure(let error):
                        debugPrint("Error: \(error)")
                        observable(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    private func requestLogin(user: UserLoginCredentials) -> Single<LoginResponse> {
        return Single.create { observable in
            let parameters = [
                "Email": user.email,
                "Password": user.password
            ]
            AF.request("http://localhost:3000/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseDecodable(of: LoginResponse.self) { response in
                    print(response)
                    switch response.result {
                    case .success(let user):
                        observable(.success(user))
                    case .failure(let error):
                        debugPrint("Error: \(error)")
                        observable(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    private func storeUserData(_ user: UserResult, token: String) {
        let defaults = UserDefaults.standard
        defaults.set(user.email, forKey: "userEmail")
        defaults.set(user.firstName, forKey: "userFirstName")
        defaults.set(user.lastName, forKey: "userLastName")
        defaults.set(user.alias, forKey: "userAlias")
        defaults.set(user.id, forKey: "userId")
        defaults.set(token, forKey: "userToken")
    }
}

enum MyError: Error {
    case error(String)
}
