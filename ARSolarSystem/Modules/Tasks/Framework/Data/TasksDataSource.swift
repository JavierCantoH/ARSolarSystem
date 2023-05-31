//
//  TasksDataSource.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation
import RxSwift
import Alamofire

class TasksDataSource: TasksDataSourceProtocol {
    
    func getTasks() throws -> Single<TasksResponse> {
        return requestTasks()
            .do(onSuccess: { response in
                print("getTasks success: \(response)")
            }, afterSuccess: nil, onError: { error in
                throw MyError.error(error.localizedDescription)
            }, afterError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
                .map { response in
                    return response
                }
    }
    
    private func requestTasks() -> Single<TasksResponse> {
        return Single.create { observable in
            AF.request("http://localhost:3000/tasks", method: .get, encoding: JSONEncoding.default, headers: nil)
                .responseDecodable(of: TasksResponse.self) { response in
                    print(response)
                    switch response.result {
                    case .success(let tasks):
                        observable(.success(tasks))
                    case .failure(let error):
                        debugPrint("Error: \(error)")
                        observable(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
