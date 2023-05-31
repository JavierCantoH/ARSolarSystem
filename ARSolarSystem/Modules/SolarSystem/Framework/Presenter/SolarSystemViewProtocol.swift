//
//  SolarSystemViewProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation

protocol SolarSystemViewProtocol: BaseView {
    //func showPlaneInfo(planetInfo: [String: [String]])
    func showPlaneInfo(planetInfo: PlanetResponse)
}
