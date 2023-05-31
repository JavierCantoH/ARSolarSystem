//
//  SolarSystemPresenter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 26/05/23.
//

import Foundation
import RxSwift

class SolarSystemPresenter: SolarSystemPresenterProtocol {
    
    private weak var view: SolarSystemViewProtocol?
    private var getPlanetInfoUseCase: UseCase<String, PlanetResponse>
    private let disposeBag = DisposeBag()
    
    init(getPlanetInfoUseCase: UseCase<String, PlanetResponse>) {
        self.getPlanetInfoUseCase = getPlanetInfoUseCase
    }
    
    func attachView(view: SolarSystemViewProtocol) {
        self.view = view
    }
    
    func getPlanetInfo(planetName: String) {
        view?.showLoader()
        do {
            try getPlanetInfoUseCase.execute(params: planetName)
                .observe(on: MainScheduler())
                .subscribe(onSuccess: { [weak self] response in
                    self?.view?.hideLoader()
                    self?.view?.showPlaneInfo(planetInfo: response)
                }, onFailure: { [weak self] error in
                    self?.view?.hideLoader()
                    self?.view?.showError(message: error.localizedDescription)
                }, onDisposed: nil).disposed(by: disposeBag)
        } catch {
            view?.showError(message: error.localizedDescription)
        }
    }
}
