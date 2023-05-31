//
//  SolarSystemRepository.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation
import RxSwift

class SolarSystemRepository: SolarSystemRepositoryProtocol {
    
    private var dataSource: SolarSystemDataSourceProtocol
    
    init(dataSource: SolarSystemDataSourceProtocol) {
        self.dataSource = dataSource
    }
    func getPlanetInfo(planetName: String) throws -> Single<PlanetResponse> {
        return try dataSource.getPlanetInfo(planetName: planetName)
    }
}
