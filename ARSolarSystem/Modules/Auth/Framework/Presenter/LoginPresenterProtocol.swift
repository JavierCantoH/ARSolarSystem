//
//  LoginPresenterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 18/05/23.
//

import Foundation

protocol LoginPresenterProtocol: AnyObject {
    func attachView(view: LoginViewProtocol)
    func loginUser(user: UserLoginCredentials)
}
