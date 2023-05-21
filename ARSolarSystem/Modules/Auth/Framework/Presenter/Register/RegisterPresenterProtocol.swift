//
//  RegisterPresenterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation

protocol RegisterPresenterProtocol: AnyObject {
    func attachView(view: RegisterViewProtocol)
    func registerUser(user: UserRegisterCredentials)
}
