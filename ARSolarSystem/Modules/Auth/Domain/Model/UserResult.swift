//
//  User.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation

struct UserResult: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let alias: String
    let id: String?

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case alias = "Alias"
        case id = "_id"
    }
}

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: UserResult
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case token = "Token"
        case user = "User"
    }
}
