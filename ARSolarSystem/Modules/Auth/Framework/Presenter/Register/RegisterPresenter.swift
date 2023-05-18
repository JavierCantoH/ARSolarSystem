//
//  RegisterPresenter.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import RxSwift

class RegisterPresenter: RegisterPresenterProtocol {
    
    private weak var view: RegisterViewProtocol?
    private var registerUseCase: UseCase<UserRegisterCredentials, UserResult>
    private let disposeBag = DisposeBag()
    
    init(registerUseCase: UseCase<UserRegisterCredentials, UserResult>) {
        self.registerUseCase = registerUseCase
    }
    
    func attachView(view: RegisterViewProtocol) {
        self.view = view
    }
    
    func registerUser(user: UserRegisterCredentials) {
        // Validar correo electrónico y contraseña
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
        guard isSafePassword(password: user.password) else {
            view?.showError(message: "Please enter a safe password")
            return
        }
        view?.showLoader()
        do {
            try registerUseCase.execute(params: user)
                .observe(on: MainScheduler())
                .subscribe(onSuccess: { [weak self] user in
                    self?.view?.hideLoader()
                    self?.view?.registerSuccess(user: user)
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
    
    // The password must be at least 8 characters long. Must contain at least one alphabetic character (A-Z or a-z).Must contain at least one numeric character (0-9).
    private func isSafePassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
