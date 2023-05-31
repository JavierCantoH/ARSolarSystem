//
//  TasksResponse.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 29/05/23.
//

import Foundation

struct TasksResponse: Codable {
    var tasksArray: [Task]
    
    enum CodingKeys: String, CodingKey {
        case tasksArray = "Tasks"
    }
}

struct Task: Codable {
    var title: String
    var date: String
    var description: String
    var done: Bool
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case date = "Date"
        case description = "Description"
        case done = "Done"
    }
}
