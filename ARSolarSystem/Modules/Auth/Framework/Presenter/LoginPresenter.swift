//
//  LoginPresenter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 18/05/23.
//

import Foundation
import RxSwift

class LoginPresenter: LoginPresenterProtocol {
    
    private weak var view: LoginViewProtocol?
    private var loginUseCase: UseCase<UserLoginCredentials, UserResult>
    private let disposeBag = DisposeBag()
    
    init(loginUseCase: UseCase<UserLoginCredentials, UserResult>) {
        self.loginUseCase = loginUseCase
    }
    
    func attachView(view: LoginViewProtocol) {
        self.view = view
    }
    
    func loginUser(user: UserLoginCredentials) {
        guard !user.email.isEmpty else {
            view?.showError(message: "Please enter your email")
            return
        }
        guard isValidEmail(email: user.email) else {
            view?.showError(message: "Please enter a valid email")
            return
        }
        guard !user.password.isEmpty else {
            view?.showError(message: "Please enter your password")
            return
        }
        view?.showLoader()
        do {
            try loginUseCase.execute(params: user)
                .observe(on: MainScheduler())
                .subscribe(onSuccess: { [weak self] user in
                    self?.view?.hideLoader()
                    self?.view?.loginSuccess(user: user)
                }, onFailure: { [weak self] error in
                    self?.view?.hideLoader()
                    self?.view?.showError(message: error.localizedDescription)
                }, onDisposed: nil).disposed(by: disposeBag)
        } catch {
            view?.showError(message: error.localizedDescription)
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
