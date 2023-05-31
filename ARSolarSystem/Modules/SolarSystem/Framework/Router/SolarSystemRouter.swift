//
//  SolarSystemRouter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation
import UIKit

class SolarSystemRouter: SolarSystemRouterProtocol {
    static func launch() -> UIViewController {
        let dataSource: SolarSystemDataSourceProtocol = SolarSystemDataSource()
        let repository: SolarSystemRepositoryProtocol = SolarSystemRepository(dataSource: dataSource)
        let getPlanetsUseCase: UseCase<String, PlanetResponse> = GetPlanetsInformationUseCase(repository: repository)
        let presenter: SolarSystemPresenterProtocol = SolarSystemPresenter(getPlanetInfoUseCase: getPlanetsUseCase)
        let viewController = SolarSystemViewController()
        viewController.presenter = presenter
        return viewController
    }
}
