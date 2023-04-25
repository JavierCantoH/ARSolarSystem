//
//  LoginViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 11/04/23.
//

import UIKit

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
        btn.setTitle("Play", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
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
    
    @objc private func registerAction() {
        let viewController = RegisterViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
