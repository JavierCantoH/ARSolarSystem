//
//  SolarSystemPresenterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation

protocol SolarSystemPresenterProtocol: AnyObject {
    func attachView(view: SolarSystemViewProtocol)
    func getPlanetInfo(planetName: String)
}
