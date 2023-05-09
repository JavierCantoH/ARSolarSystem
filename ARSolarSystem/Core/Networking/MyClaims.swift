//
//  MyClaims.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 08/05/23.
//

import Foundation
import SwiftJWT

class MyClaims: Claims {
    let issuer: String
    let subject: String
    let expirationTime: Date
    
    init(issuer: String, subject: String, expirationTime: Date) {
        self.issuer = issuer
        self.subject = subject
        self.expirationTime = expirationTime
    }
}
