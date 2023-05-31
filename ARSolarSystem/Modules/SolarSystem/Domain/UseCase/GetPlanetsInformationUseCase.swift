//
//  GetPlanetsInformationUseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation
import RxSwift

class GetPlanetsInformationUseCase: UseCase<String, PlanetResponse> {
    
    var repository: SolarSystemRepositoryProtocol
    
    init(repository: SolarSystemRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(params: String) throws -> Single<PlanetResponse> {
        return try repository.getPlanetInfo(planetName: params)
    }
}
