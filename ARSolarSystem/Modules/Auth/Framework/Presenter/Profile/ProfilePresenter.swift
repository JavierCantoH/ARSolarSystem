//
//  ProfilePresenter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 21/05/23.
//

import Foundation
import RxSwift

class ProfilePresenter: ProfilePresenterProtocol {
    
    private weak var view: ProfileViewProtocol?
    private var logoutUseCase: UseCase<String, LogoutResponse>
    private var getUserDataUseCase: UseCase<Void, (UserResult?, String?)>
    private let disposeBag = DisposeBag()
    
    init(logoutUseCase: UseCase<String, LogoutResponse>, getUserDataUseCase: UseCase<Void, (UserResult?, String?)>) {
        self.logoutUseCase = logoutUseCase
        self.getUserDataUseCase = getUserDataUseCase
    }
    
    func attachView(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func getUserData() {
        view?.showLoader()
        do {
            try getUserDataUseCase.execute(params: Void())
                .observe(on: MainScheduler())
                .subscribe(onSuccess: { [weak self] response in
                    self?.view?.hideLoader()
                    self?.view?.getUserData(result: response.0, token: response.1)
                }, onFailure: { [weak self] error in
                    self?.view?.hideLoader()
                    self?.view?.showError(message: error.localizedDescription)
                }, onDisposed: nil).disposed(by: disposeBag)
        } catch {
            view?.showError(message: error.localizedDescription)
        }
    }
    
    func logoutUser(token: String) {
        view?.showLoader()
        do {
            try logoutUseCase.execute(params: token)
                .observe(on: MainScheduler())
                .subscribe(onSuccess: { [weak self] response in
                    self?.view?.hideLoader()
                    self?.view?.logoutSuccess(message: response.message)
                }, onFailure: { [weak self] error in
                    self?.view?.hideLoader()
                    self?.view?.showError(message: error.localizedDescription)
                }, onDisposed: nil).disposed(by: disposeBag)
        } catch {
            view?.showError(message: error.localizedDescription)
        }
    }
}
