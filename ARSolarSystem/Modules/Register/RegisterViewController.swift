//
//  RegisterViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 11/04/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "appLogo")
        return image
    }()
    
    private lazy var nameTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var passwordTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Already an user? Login here", for: .normal)
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return btn
    }()
    
    @objc private func loginAction() {
        let viewController = LoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = "Register"
        view.backgroundColor = .white
        view.addSubview(logoImage)
        view.addSubview(nameTextfield)
        view.addSubview(emailTextfield)
        view.addSubview(passwordTextfield)
        view.addSubview(registerBtn)
        view.addSubview(loginBtn)
        constraintsSetup()
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            logoImage.heightAnchor.constraint(equalToConstant: 300),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextfield.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 60),
            nameTextfield.heightAnchor.constraint(equalToConstant: 50),
            nameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextfield.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor, constant: 16),
            emailTextfield.heightAnchor.constraint(equalToConstant: 50),
            emailTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 16),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 50),
            passwordTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            registerBtn.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 16),
            registerBtn.heightAnchor.constraint(equalToConstant: 50),
            registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerBtn.widthAnchor.constraint(equalToConstant: 100),
            
            loginBtn.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 16),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
}
