//
//  SolarSystemRepositoryProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation
import RxSwift

protocol SolarSystemRepositoryProtocol: AnyObject {
    func getPlanetInfo(planetName: String) throws -> Single<PlanetResponse>
}
