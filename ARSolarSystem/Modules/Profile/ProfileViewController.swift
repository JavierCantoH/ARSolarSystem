//
//  ProfileViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 14/04/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isLogged: Bool = false
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
        return btn
    }()
    
    @objc private func presentViewController() {
        let viewController = LoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func checkIfUserIsLogged(isLogged: Bool) {
        if isLogged {
            loginBtn.setTitle("Logout", for: .normal)
        } else {
            loginBtn.setTitle("Login", for: .normal)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loginBtn)
        setupConstraints()
        checkIfUserIsLogged(isLogged: isLogged)
    }
}
