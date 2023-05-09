//
//  UseCase.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

class UseCase<P, R> {
    func execute(params: P) throws -> Single<R> {
        preconditionFailure("You must implement this method")
    }
}
