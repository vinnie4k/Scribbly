////
////  SignupVC.swift
////  Scribbly
////
////  Created by Vin Bui on 1/10/23.
////
//
//import UIKit
//
//// MARK: SignupVC
//class SignupVC: UIViewController, UITextFieldDelegate {
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
//    private let createAccountLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "create an account"
//        lbl.font = Constants.getFont(size: 24, weight: .semibold)
//        lbl.textColor = .label
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private let emailLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "email"
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = Constants.secondary_text
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private lazy var emailTextField: UITextField = {
//        let txtField = UITextField()
//        txtField.placeholder = "enter your email"
//        txtField.textColor = .label
//        txtField.font = Constants.getFont(size: 14, weight: .regular)
//        txtField.tintColor = .label
//        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
//        txtField.delegate = self
//        txtField.autocorrectionType = .no
//        txtField.addInvalid()
//        txtField.translatesAutoresizingMaskIntoConstraints = false
//        return txtField
//    }()
//
//    private let usernameLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "username"
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = Constants.secondary_text
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private lazy var usernameTextField: UITextField = {
//        let txtField = UITextField()
//        txtField.placeholder = "enter a username"
//        txtField.textColor = .label
//        txtField.font = Constants.getFont(size: 14, weight: .regular)
//        txtField.tintColor = .label
//        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
//        txtField.delegate = self
//        txtField.autocorrectionType = .no
//        txtField.addInvalid()
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
//        txtField.placeholder = "enter a password"
//        txtField.textColor = .label
//        txtField.font = Constants.getFont(size: 14, weight: .regular)
//        txtField.tintColor = .label
//        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
//        txtField.delegate = self
//        txtField.autocorrectionType = .no
//        txtField.isSecureTextEntry = true
//        txtField.textContentType = .oneTimeCode
//        txtField.addInvalid()
//        txtField.translatesAutoresizingMaskIntoConstraints = false
//        return txtField
//    }()
//
//    private let confirmPasswordLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "confirm password"
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = Constants.secondary_text
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private lazy var confirmPasswordTextField: UITextField = {
//        let txtField = UITextField()
//        txtField.placeholder = "retype your password"
//        txtField.textColor = .label
//        txtField.font = Constants.getFont(size: 14, weight: .regular)
//        txtField.tintColor = .label
//        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
//        txtField.delegate = self
//        txtField.autocorrectionType = .no
//        txtField.isSecureTextEntry = true
//        txtField.textContentType = .oneTimeCode
//        txtField.addInvalid()
//        txtField.translatesAutoresizingMaskIntoConstraints = false
//        return txtField
//    }()
//
//    private let eulaLabelTop: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "by clicking \"create account,\" you agree to scribbly's"
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = Constants.secondary_text
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private let eulaLabelBot: UILabel = {
//        let lbl = UILabel()
//        let attrText = NSAttributedString(string: "End User License Agreement", attributes: [.underlineStyle: 1])
//        lbl.attributedText = attrText
//        lbl.font = Constants.getFont(size: 14, weight: .medium)
//        lbl.textColor = .label
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        return lbl
//    }()
//
//    private lazy var createAccountButton: UIButton = {
//        let btn = UIButton()
//        btn.addTarget(self, action: #selector(confirmChanges), for: .touchUpInside)
//        var config = UIButton.Configuration.filled()
//
//        var text = AttributedString("create account")
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
//    private let spinner: UIActivityIndicatorView = {
//        let spin = UIActivityIndicatorView(style: .medium)
//        spin.hidesWhenStopped = true
//        spin.color = .label
//        spin.translatesAutoresizingMaskIntoConstraints = false
//        return spin
//    }()
//
//    // MARK: - viewDidLoad, viewWillAppear, setupNavBar, and setupConstraints
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .systemBackground
//        hideKeyboardWhenTappedAround()  // For dismissing keyboard
//
//        view.addSubview(createAccountLabel)
//        view.addSubview(usernameLabel)
//        view.addSubview(usernameTextField)
//        view.addSubview(emailLabel)
//        view.addSubview(emailTextField)
//        view.addSubview(passwordLabel)
//        view.addSubview(passwordTextField)
//        view.addSubview(confirmPasswordLabel)
//        view.addSubview(confirmPasswordTextField)
//        view.addSubview(eulaLabelTop)
//        view.addSubview(eulaLabelBot)
//        view.addSubview(createAccountButton)
//        view.addSubview(spinner)
//
//        setupNavBar()
//        setupConstraints()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        usernameTextField.addTarget(self, action: #selector(lowercaseText), for: .editingChanged)
//        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
//            createAccountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.login_top),
//            createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            usernameLabel.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: Constants.login_top),
//            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
//
//            usernameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            usernameTextField.heightAnchor.constraint(equalToConstant: 15),
//            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
//
//            emailLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: Constants.login_top),
//            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
//
//            emailTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emailTextField.heightAnchor.constraint(equalToConstant: 15),
//            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
//
//            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Constants.login_top),
//            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
//
//            passwordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 15),
//            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
//
//            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.login_top),
//            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
//
//            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 15),
//            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 5),
//
//            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot),
//            createAccountButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.login_side_padding),
//            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            eulaLabelBot.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -15),
//            eulaLabelBot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            eulaLabelTop.bottomAnchor.constraint(equalTo: eulaLabelBot.topAnchor, constant: -3),
//            eulaLabelTop.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//    // MARK: - Helper Functions
//    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//
//    @objc func lowercaseText(textField: UITextField) {
//        textField.text = textField.text?.lowercased()
//    }
//
//    @objc func textFieldDidChange(textField: UITextField) {
//        checkCriteria()
//    }
//
//    private func checkCriteria() {
//        // Username must have 6-20 characters
//        // Password must have at least 6 characters
//        // Email must have an @ symbol and non-empty
//
//        if !validUserName() {
//            usernameTextField.addInvalid()
//        } else {
//            usernameTextField.removeInvalid()
//        }
//
//        if !validPassword() {
//            passwordTextField.addInvalid()
//        } else {
//            passwordTextField.removeInvalid()
//        }
//
//        if !validConfirmPassword() {
//            confirmPasswordTextField.addInvalid()
//        } else {
//            confirmPasswordTextField.removeInvalid()
//        }
//
//        if !validEmail() {
//            emailTextField.addInvalid()
//        } else {
//            emailTextField.removeInvalid()
//        }
//    }
//
//    private func validUserName() -> Bool {
//        let text = usernameTextField.text!
//        if text.count < 6 || text.count > 20 || text.firstIndex(of: " ") != nil {
//            return false
//        }
//        return true
//    }
//
//    private func validPassword() -> Bool {
//        let text = passwordTextField.text!
//        if text.count < 6 {
//            return false
//        }
//        return true
//    }
//
//    private func validEmail() -> Bool {
//        let text = emailTextField.text!
//        if text.isEmpty || text.firstIndex(of: "@") == nil || text.firstIndex(of: ".") == nil {
//            return false
//        }
//        return true
//    }
//
//    private func validConfirmPassword() -> Bool {
//        let confirmText = confirmPasswordTextField.text!
//        let passText = passwordTextField.text!
//        if confirmText.count < 6 || confirmText != passText {
//            return false
//        }
//        return true
//    }
//
//    // MARK: - Button Helpers
//    @objc private func popVC() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc private func confirmChanges() {
//        if validUserName() && validPassword() && validConfirmPassword() && validEmail() {
//            // Check to see if the username already exists
//            spinner.startAnimating()
//
//            DatabaseManager.usernameExists(with: usernameTextField.text!, completion: { [weak self] exists in
//                guard let `self` = self else { return }
//                if !exists {
//
//                    DatabaseManager.emailExists(with: self.emailTextField.text!, completion: { [weak self] exists in
//                        guard let `self` = self else { return }
//                        if !exists {
//                            let phoneVC = PhoneVC(username: self.usernameTextField.text!, password: self.passwordTextField.text!, email: self.emailTextField.text!)
//                            self.navigationController?.pushViewController(phoneVC, animated: true)
//                            self.spinner.stopAnimating()
//                        } else {
//                            let alert = UIAlertController(title: "Invalid email", message: "That email has been taken", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//                            self.present(alert, animated: true)
//                            self.spinner.stopAnimating()
//                        }
//                    })
//
//                } else {
//                    let alert = UIAlertController(title: "Invalid username", message: "That username has been taken", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//                    self.present(alert, animated: true)
//                    self.spinner.stopAnimating()
//                }
//            })
//
//        } else if !validUserName() {
//            let alert = UIAlertController(title: "Invalid username", message: "Username must have 6 to 20 characters and cannot contain spaces", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//            present(alert, animated: true)
//        } else if !validPassword() {
//            let alert = UIAlertController(title: "Invalid password", message: "Password must have at least 6 characters", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//            present(alert, animated: true)
//        } else if !validConfirmPassword() {
//            let alert = UIAlertController(title: "Invalid password", message: "Passwords do not match", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//            present(alert, animated: true)
//        } else if !validEmail() {
//            let alert = UIAlertController(title: "Invalid email", message: "Please enter a valid email address", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
//            present(alert, animated: true)
//        }
//    }
//
//}
