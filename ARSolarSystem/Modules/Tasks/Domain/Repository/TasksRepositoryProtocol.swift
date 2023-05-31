//
//  TasksRepositoryProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import RxSwift

protocol TasksRepositoryProtocol: AnyObject {
    func getTasks() throws -> Single<TasksResponse>
}

