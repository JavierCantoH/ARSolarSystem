//
//  TasksRouter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import UIKit

class TasksRouter: TasksRouterProtocol {
    static func launch() -> UIViewController {
        let dataSource: TasksDataSourceProtocol = TasksDataSource()
        let repository: TasksRepositoryProtocol = TasksRepository(dataSource: dataSource)
        let getTasksUseCase: UseCase<Void, TasksResponse> = GetTasksUseCase(repository: repository)
        let presenter: TasksPresenterProtocol = TasksPresenter(getTasksUseCase: getTasksUseCase)
        let viewController = TasksViewController()
        viewController.presenter = presenter
        return viewController
    }
}
