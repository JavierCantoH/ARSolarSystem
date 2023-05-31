//
//  TasksDataSourceProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import RxSwift

protocol TasksDataSourceProtocol: AnyObject {
    func getTasks() throws -> Single<TasksResponse>
}

