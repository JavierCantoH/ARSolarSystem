//
//  TasksRepository.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import RxSwift

class TasksRepository: TasksRepositoryProtocol {
    
    private var dataSource: TasksDataSourceProtocol
    
    init(dataSource: TasksDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getTasks() throws -> Single<TasksResponse> {
        return try dataSource.getTasks()
    }
}

