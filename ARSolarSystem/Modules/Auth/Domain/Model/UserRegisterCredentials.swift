//
//  UserRegisterCredentials.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 08/05/23.
//

import Foundation

struct UserRegisterCredentials: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let alias: String
    let password: String
}
