//
//  RegisterViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 11/04/23.
//

import UIKit
import Toast

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
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        // Add a padding view to the left of the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .black
        // Add a padding view to the left of the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordTextfield: UITextField = {
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
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
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
        dismiss(animated: true)
    }
    
    @objc private func registerAction() {
        presenter?.registerUser(user: UserRegisterCredentials(email: emailTextfield.text ?? "", firstName: nameTextfield.text ?? "", lastName: nameTextfield.text ?? "", alias: nameTextfield.text ?? "", password: passwordTextfield.text ?? ""))
    }
    
    var presenter: RegisterPresenterProtocol?
    var registerSucceed: ((UserResult) -> Void)?
    private var nameTextFieldBottomConstraint: NSLayoutConstraint?
    private var emailTextFieldBottomConstraint: NSLayoutConstraint?
    private var passwordTextFieldBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // adding notification observers for keyboard show and hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // removing all the notification observers
      NotificationCenter.default.removeObserver(self)
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
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self

    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            logoImage.heightAnchor.constraint(equalToConstant: 300),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextfield.heightAnchor.constraint(equalToConstant: 50),
            nameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextfield.heightAnchor.constraint(equalToConstant: 50),
            emailTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        nameTextFieldBottomConstraint = nameTextfield.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400)
        nameTextFieldBottomConstraint?.isActive = true
        emailTextFieldBottomConstraint = emailTextfield.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330)
        emailTextFieldBottomConstraint?.isActive = true
        passwordTextFieldBottomConstraint = passwordTextfield.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -260)
        passwordTextFieldBottomConstraint?.isActive = true
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        // move the text field when the email text field is being edited
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: nameTextFieldBottomConstraint!, keyboardWillShow: true, bottomConstraint: 170)
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: emailTextFieldBottomConstraint!, keyboardWillShow: true, bottomConstraint: 100)
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: passwordTextFieldBottomConstraint!, keyboardWillShow: true, bottomConstraint: 30)
    }
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        // Move the field back to the previous position after editing is done
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: nameTextFieldBottomConstraint!, keyboardWillShow: false, bottomConstraint: 400)
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: emailTextFieldBottomConstraint!, keyboardWillShow: false, bottomConstraint: 330)
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: passwordTextFieldBottomConstraint!, keyboardWillShow: false, bottomConstraint: 260)
    }
       
    private func updateViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool, bottomConstraint: CGFloat) {
       // getting keyboard size
       guard let userInfo = notification.userInfo,
       let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
          return
       }
       // getting duration for keyboard animation
       guard let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
          return
       }
       // getting keyboard animation's curve
       guard let keyboardCurve = UIView.AnimationCurve(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int) else {
          return
       }
       // getting keyboard height
       let keyboardHeight = keyboardSize.cgRectValue.height
       // setting constant for keyboard show and hide
       if keyboardWillShow {
          viewBottomConstraint.constant = -(keyboardHeight + (bottomConstraint))
       } else {
           viewBottomConstraint.constant = -(bottomConstraint)
       }
       // animate the view the same way the keyboard animates
       let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) {
          [weak self] in self?.view.layoutIfNeeded()
       }
       // perform the animation
       animator.startAnimation()
    }
}

extension RegisterViewController: RegisterViewProtocol {
    
    func registerSuccess(user: UserResult) {
        if let image = UIImage(systemName: "checkmark.circle") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast("Please Login", duration: 2.0, position: .top, title: "Register succeed!", image: tintedImage, style: toastStyleComplete)
            registerSucceed?(user)
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
            view.makeToast(message, duration: 2.0, position: .center, title: "Ups!", image: tintedImage, style: toastStyleMissElements)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() 
        return true
    }
}
