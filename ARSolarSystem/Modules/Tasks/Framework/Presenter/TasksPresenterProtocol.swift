//
//  TasksPresenterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {
    func attachView(view: TasksViewProtocol)
    func getTasks()
}
