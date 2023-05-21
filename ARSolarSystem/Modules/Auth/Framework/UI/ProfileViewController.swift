//
//  ProfileViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 14/04/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userSchoolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.circle")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        return image
    }()
    
    private lazy var logoutBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.setTitle("Logout", for: .normal)
        btn.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        return btn
    }()
    
    let authDataSource = AuthDataSource()
    
    @objc private func logoutUser() {
        
    }
    
    private func populateView() {
        let result = authDataSource.getUserData()
        userNameLabel.text = "Welcome \(result.0?.firstName ?? "user first name")"
        emailLabel.text = result.0?.email
        userIdLabel.text = result.0?.alias
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userSchoolLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16),
            userSchoolLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userIdLabel.topAnchor.constraint(equalTo: userSchoolLabel.bottomAnchor, constant: 16),
            userIdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            logoutBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutBtn.heightAnchor.constraint(equalToConstant: 50),
            logoutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutBtn.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

    override func viewDidLoad() {
        title = "Profile"
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(userNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(profileImageView)
        view.addSubview(logoutBtn)
        view.addSubview(userSchoolLabel)
        view.addSubview(userIdLabel)
        setupConstraints()
        populateView()
    }
}