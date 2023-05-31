//
//  ProfileViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 14/04/23.
//

import UIKit
import Toast

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
    
    var presenter: ProfilePresenterProtocol?
    private var userToken = ""
    
    @objc private func logoutUser() {
        presenter?.logoutUser(token: userToken)
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
        presenter?.attachView(view: self)
        presenter?.getUserData()
    }
}

extension ProfileViewController: ProfileViewProtocol {
    
    func getUserData(result: UserResult?, token: String?) {
        userNameLabel.text = "Welcome \(result?.firstName ?? "")"
        emailLabel.text = result?.email
        userIdLabel.text = result?.alias
        userToken = token ?? ""
    }
    
    func logoutSuccess(message: String) {
        if message == "You have been Logged Out" {
            if let image = UIImage(systemName: "checkmark.circle") {
                let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
                view.makeToast(":(", duration: 2.0, position: .top, title: "See you soon", image: tintedImage, style: toastStyleComplete)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    (UIApplication.shared.delegate as? AppDelegate)?.logout()
                }
            }
        }
    }
    
    func showLoader() {
        view.makeToastActivity(.center)
    }
    
    func hideLoader() {
        view.hideToastActivity()
    }
    
    func showError(message: String) {
        if let image = UIImage(systemName: "exclamationmark.square.fill") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast(message, duration: 2.0, position: .center, title: "Ups!", image: tintedImage, style: toastStyleMissElements)
        }
    }
}
