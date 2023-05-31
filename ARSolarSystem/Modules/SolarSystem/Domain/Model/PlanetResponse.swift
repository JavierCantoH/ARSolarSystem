//
//  PlanetResponse.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation

struct PlanetResponse: Codable {
    var id: String
    var name: String
    var facts: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "Name"
        case facts = "Description"
    }
}
