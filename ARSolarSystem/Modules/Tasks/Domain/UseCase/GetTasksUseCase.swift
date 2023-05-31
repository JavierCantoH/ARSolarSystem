//
//  GetTasksUseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import RxSwift

class GetTasksUseCase: UseCase<Void, TasksResponse> {
    
    var repository: TasksRepositoryProtocol
    
    init(repository: TasksRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(params: Void) throws -> Single<TasksResponse> {
        return try repository.getTasks()
    }
}
