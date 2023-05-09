//
//  RegisterDataSource.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift
import Alamofire
import SwiftJWT

class RegisterDataSource: RegisterDataSourceProtocol {
    
    func registerUser(user: UserCredentials) throws -> Single<UserResult> {
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
    
    private func requestRegister(user: UserCredentials) -> Single<UserResult> {
        return Single.create { observable in
            let issuer = "ARSolarSystem"
            let subject = user.email
            let expirationTime = Date().addingTimeInterval(3600) // expira en 1 hora
            let claims = MyClaims(issuer: issuer, subject: subject, expirationTime: expirationTime)
            var jwt = JWT(claims: claims)
            let privateKey = "mysecretkey".data(using: .utf8)!
            let signer = JWTSigner.hs256(key: privateKey)
            let jwtString = try! jwt.sign(using: signer)
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(jwtString)"
            ]
            AF.request("localhost:3000/auth/regsiter", headers: headers)
                .validate()
                .responseDecodable(of: UserResult.self) { response in
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
