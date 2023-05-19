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
                    if user.email.isEmpty {
                        throw MyError.error("User without email")
                    }
                })
                .map { response in
                    return response
                }
    }
    
    func loginUser(user: UserLoginCredentials) throws -> Single<UserResult> {
        return requestLogin(user: user)
            .do(onSuccess: { response in
                print(response.message)
                print(response.token)
                print(response.user)
        }, afterSuccess: nil, onError: { error in
            throw MyError.error(error.localizedDescription)
        }, afterError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
                .map { response in
                    return response.user
                }
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
}

enum MyError: Error {
    case error(String)
}
