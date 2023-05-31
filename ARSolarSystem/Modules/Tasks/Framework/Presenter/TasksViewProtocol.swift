//
//  TasksViewProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation

protocol TasksViewProtocol: BaseView {
    func showTasks(tasks: TasksResponse)
}
