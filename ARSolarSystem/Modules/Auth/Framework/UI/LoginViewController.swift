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
        textField.autocapitalizationType = .none
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
        textField.isSecureTextEntry = true
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
        present(RegisterRouter.launch(onRegisterSuccess: { user in
            print("User registed success: \(user)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.dismiss(animated: true)
            }
        }), animated: true)
    }
    
    var presenter: LoginPresenterProtocol?
    var loginSucceed: ((UserResult) -> Void)?
    private var userTextFieldBottomConstraint: NSLayoutConstraint?
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
            userTextField.heightAnchor.constraint(equalToConstant: 50),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        userTextFieldBottomConstraint = userTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400)
        userTextFieldBottomConstraint?.isActive = true
        passwordTextFieldBottomConstraint = passwordTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330)
        passwordTextFieldBottomConstraint?.isActive = true
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        // move the text field when the email text field is being edited
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: userTextFieldBottomConstraint!, keyboardWillShow: true, bottomConstraint: 100)
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: passwordTextFieldBottomConstraint!, keyboardWillShow: true, bottomConstraint: 30)
    }
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        // Move the field back to the previous position after editing is done
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: userTextFieldBottomConstraint!, keyboardWillShow: false, bottomConstraint: 400)
        updateViewWithKeyboard(notification: notification, viewBottomConstraint: passwordTextFieldBottomConstraint!, keyboardWillShow: false, bottomConstraint: 330)
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

extension LoginViewController: LoginViewProtocol {
    
    func loginSuccess(user: UserResult) {
        if let image = UIImage(systemName: "checkmark.circle") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast("\(user.firstName)", duration: 2.0, position: .top, title: "Welcome", image: tintedImage, style: toastStyleComplete)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.loginSucceed?(user)
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
