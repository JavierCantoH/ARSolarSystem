//
//  ProfilePresenterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 21/05/23.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func attachView(view: ProfileViewProtocol)
    func getUserData()
    func logoutUser(token: String)
}
