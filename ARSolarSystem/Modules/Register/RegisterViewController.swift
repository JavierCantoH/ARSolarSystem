//
//  RegisterViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 11/04/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private lazy var nameTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        return textField
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        return textField
    }()
    
    private lazy var passwordTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        return textField
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Register", for: .normal)
        return btn
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Login", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .blue
        view.addSubview(nameTextfield)
        view.addSubview(emailTextfield)
        view.addSubview(passwordTextfield)
        view.addSubview(registerBtn)
        view.addSubview(loginBtn)
        constraintsSetup()
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            nameTextfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            nameTextfield.heightAnchor.constraint(equalToConstant: 30),
            nameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            emailTextfield.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor, constant: 16),
            emailTextfield.heightAnchor.constraint(equalToConstant: 30),
            emailTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 16),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 30),
            passwordTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            registerBtn.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 16),
            registerBtn.heightAnchor.constraint(equalToConstant: 30),
            registerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginBtn.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 16),
            loginBtn.heightAnchor.constraint(equalToConstant: 30),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
