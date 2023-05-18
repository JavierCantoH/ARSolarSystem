//
//  AuthDataSourceProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

protocol AuthDataSourceProtocol: AnyObject {
    func registerUser(user: UserCredentials) throws -> Single<UserResult>
}
