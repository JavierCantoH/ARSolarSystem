//
//  BaseView.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation

protocol BaseView: AnyObject {
    func showLoader()
    func hideLoader()
    func showError(message: String)
}
