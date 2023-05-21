//
//  ProfileViewProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 21/05/23.
//

import Foundation

protocol ProfileViewProtocol: BaseView {
    func getUserData(result: UserResult?, token: String?)
    func logoutSuccess(message: String)
}

