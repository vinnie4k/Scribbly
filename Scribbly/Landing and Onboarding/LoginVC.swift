////
////  LoginVC.swift
////  Scribbly
////
////  Created by Vin Bui on 1/4/23.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseDatabase
//
//// MARK: LoginVC
//class LoginVC: UIViewController, UITextFieldDelegate {
//    // MARK: - Properties (view)
//    private let logo: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "scribbly"
//        lbl.textColor = .label
//        lbl.font = Constants.getFont(size: 24, weight: .semibold)
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//    
//    private lazy var backButton: UIButton = {
//        let btn = UIButton()
//        var config = UIButton.Configuration.filled()
//        config.buttonSize = .large
//        config.image = UIImage(systemName: "chevron.left")
//        config.baseForegroundColor = .label
//        config.baseBackgroundColor = .clear
//        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//        btn.configuration = config
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    
//    private let loginLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "log in"
//        lbl.font = Constants.getFont(size: 24, weight: .semibold)
//        lbl.textColor = .label
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//    
//    private let usernameLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "username or phone number"
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = Constants.secondary_text
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//    
//    private lazy var usernameTextField: UITextField = {
//        let txtField = UITextField()
//        txtField.placeholder = "enter username or phone number"
//        txtField.textColor = .label
//        txtField.font = Constants.getFont(size: 14, weight: .regular)
//        txtField.tintColor = .label
//        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
//        txtField.delegate = self
//        txtField.autocorrectionType = .no
//        txtField.translatesAutoresizingMaskIntoConstraints = false
//        return txtField
//    }()
//    
//    private let passwordLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "password"
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = Constants.secondary_text
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//    
//    private lazy var passwordTextField: UITextField = {
//        let txtField = UITextField()
//        txtField.placeholder = "enter password"
//        txtField.textColor = .label
//        txtField.font = Constants.getFont(size: 14, weight: .regular)
//        txtField.tintColor = .label
//        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
//        txtField.delegate = self
//        txtField.autocorrectionType = .no
//        txtField.isSecureTextEntry = true
//        txtField.translatesAutoresizingMaskIntoConstraints = false
//        return txtField
//    }()
//    
//    private lazy var loginButton: UIButton = {
//        let btn = UIButton()
//        btn.addTarget(self, action: #selector(tappedLogin), for: .touchUpInside)
//        var config = UIButton.Configuration.filled()
//        
//        var text = AttributedString("log in")
//        text.font = Constants.getFont(size: 16, weight: .bold)
//        config.attributedTitle = text
//        
//        config.background.cornerRadius = Constants.landing_button_corner
//        config.baseBackgroundColor = Constants.button_dark
//        config.buttonSize = .large
//        config.baseForegroundColor = .white
//        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
//        btn.configuration = config
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    
//    // MARK: - Properties (data)
//    private let database = Database.database().reference()
//    
//    // MARK: - viewDidLoad, viewWillAppear, setupNavBar, and setupConstraints
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .systemBackground
//        hideKeyboardWhenTappedAround()  // For dismissing keyboard
//
//        view.addSubview(loginLabel)
//        view.addSubview(usernameLabel)
//        view.addSubview(usernameTextField)
//        view.addSubview(passwordLabel)
//        view.addSubview(passwordTextField)
//        view.addSubview(loginButton)
//        
//        setupNavBar()
//        setupConstraints()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//    }
//    
//    private func setupNavBar() {
//        navigationItem.titleView = logo
//        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.login_top),
//            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            usernameLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Constants.login_top),
//            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
//            
//            usernameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            usernameTextField.heightAnchor.constraint(equalToConstant: 15),
//            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
//            
//            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: Constants.login_top),
//            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
//            
//            passwordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 15),
//            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
//            
//            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot),
//            loginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//    
//    // MARK: - Helper Functions
//    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//    
//    @objc func textFieldDidChange(textField: UITextField) {
//        textField.text = textField.text?.lowercased()
//    }
//    
//    // MARK: - Button Helpers
//    @objc private func popVC() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc private func tappedLogin() {
//        guard let username = usernameTextField.text, let password = passwordTextField.text,
//            !username.isEmpty, !password.isEmpty else {
//                alertLoginError()
//                return
//        }
//        
//        // Get email associated with the username
//        database.child("user_email_map/\(username)").getData(completion: { error, snapshot in
//            guard error == nil else {
//                print("Unable to get email from this username")
//                return
//            }
//            let email = snapshot?.value as? String ?? "INVALID USERNAME"
//            
//            // Firebase Login
//            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
//                // Make weak self to prevent a retain cycle and memory leaks
//                guard let `self` = self else { return }
//                
//                guard let result = authResult, error == nil else {
//                    print("Unable to login with the username \(username) and email \(email)")
//                    self.alertLoginError()
//                    return
//                }
//                let user = result.user
//                print("Sucessfully logged in user: \(user)")
//                self.navigationController?.dismiss(animated: true)
//            })
//        })
//        
//    }
//    
//    // MARK: - Login Helpers
//    private func alertLoginError() {
//        let alert = UIAlertController(title: "Invalid Login", message: "The username or password you entered is incorrect", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//        present(alert, animated: true)
//    }
//}
