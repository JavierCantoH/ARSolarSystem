//
//  ProfileViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 14/04/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isLogged: Bool = false
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.cornerRadius = 10.0
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth = 2.0
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Welcome"
        return label
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
        return btn
    }()
    
    @objc private func presentViewController() {
        navigationController?.pushViewController(RegisterRouter.launch(onRegisterSuccess: { [weak self] user in
            self?.checkIfUserIsLogged()
            self?.userNameLabel.text = user.firstName
        }), animated: true)
    }
    
    private func checkIfUserIsLogged() {
        if isLogged {
            loginBtn.setTitle("Logout", for: .normal)
        } else {
            loginBtn.setTitle("Login", for: .normal)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNameLabel.heightAnchor.constraint(equalToConstant: 100),
            loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(userNameLabel)
        view.addSubview(loginBtn)
        setupConstraints()
        checkIfUserIsLogged()
    }
}
