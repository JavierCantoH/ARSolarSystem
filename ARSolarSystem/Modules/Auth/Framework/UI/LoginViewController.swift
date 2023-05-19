//
//  LoginViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 11/04/23.
//

import UIKit
import Toast

class LoginViewController: UIViewController {

    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "appLogo")
        return image
    }()
    
    private lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.attributedPlaceholder = NSAttributedString(string: "User", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        // Add a padding view to the left of the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()

    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        // Add a padding view to the left of the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var buttonEnter: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var resgisterBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("No account? Register here", for: .normal)
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var toastStyleMissElements: ToastStyle = {
        var style = ToastStyle()
        style.backgroundColor = .red
        style.titleColor = .white
        style.imageSize = CGSize(width: 50, height: 50)
        return style
    }()
    
    private lazy var toastStyleComplete: ToastStyle = {
        var style = ToastStyle()
        style.backgroundColor = .green
        style.titleColor = .white
        style.imageSize = CGSize(width: 50, height: 50)
        return style
    }()
    
    @objc private func loginAction() {
        presenter?.loginUser(user: UserLoginCredentials(email: userTextField.text ?? "", password: passwordTextField.text ?? ""))
    }
    
    @objc private func registerAction() {
        navigationController?.pushViewController(RegisterRouter.launch(onRegisterSuccess: { [weak self] user in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }), animated: true)
    }
    
    var presenter: LoginPresenterProtocol?
    var loginSucceed: ((UserResult) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.attachView(view: self)
    }
    
    private func setupView() {
        title = "Login"
        view.backgroundColor = .white
        view.addSubview(logoImage)
        view.addSubview(userTextField)
        view.addSubview(passwordTextField)
        view.addSubview(buttonEnter)
        view.addSubview(resgisterBtn)
        constraintsSetUp()
        userTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func constraintsSetUp(){
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            logoImage.heightAnchor.constraint(equalToConstant: 300),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 16),
            userTextField.heightAnchor.constraint(equalToConstant: 50),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonEnter.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            buttonEnter.heightAnchor.constraint(equalToConstant: 50),
            buttonEnter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonEnter.widthAnchor.constraint(equalToConstant: 100),
            resgisterBtn.topAnchor.constraint(equalTo: buttonEnter.bottomAnchor, constant: 16),
            resgisterBtn.heightAnchor.constraint(equalToConstant: 50),
            resgisterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resgisterBtn.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
}

extension LoginViewController: LoginViewProtocol {
    
    func loginSuccess(user: UserResult) {
        if let image = UIImage(systemName: "checkmark.circle") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast("Welcome!", duration: 2.0, position: .top, title: title, image: tintedImage, style: toastStyleComplete)
            loginSucceed?(user)
        }
    }
    
    func showLoader() {
        view.makeToastActivity(.bottom)
    }
    
    func hideLoader() {
        view.hideToastActivity()
    }
    
    func showError(message: String) {
        if let image = UIImage(systemName: "exclamationmark.square.fill") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast(message, duration: 2.0, position: .center, title: title, image: tintedImage, style: toastStyleMissElements)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
