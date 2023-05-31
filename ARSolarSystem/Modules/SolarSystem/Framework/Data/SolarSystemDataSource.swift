//
//  SolarSystemDataSource.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation
import RxSwift
import Alamofire

class SolarSystemDataSource: SolarSystemDataSourceProtocol {
    
    
    func getPlanetInfo(planetName: String) throws -> Single<PlanetResponse> {
        return requestPlanetInfo(planetName: planetName)
            .do(onSuccess: { response in
                print("GetPlanetInfo success: \(response)")
        }, afterSuccess: nil, onError: { error in
            throw MyError.error(error.localizedDescription)
        }, afterError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
                .map { response in
                    return response
                }
    }
    
    private func requestPlanetInfo(planetName: String) -> Single<PlanetResponse> {
        return Single.create { observable in
            AF.request("http://localhost:3000/planet/\(planetName.capitalized)", method: .get, encoding: JSONEncoding.default, headers: nil)
                .responseDecodable(of: PlanetResponse.self) { response in
                    print(response)
                    switch response.result {
                    case .success(let info):
                        observable(.success(info))
                    case .failure(let error):
                        debugPrint("Error: \(error)")
                        observable(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
