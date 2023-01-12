//
//  ConfirmPhoneVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import UIKit

// MARK: ConfirmPhoneVC
class ConfirmPhoneVC: UIViewController, UITextFieldDelegate {
    // MARK: - Properties (view)
    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "scribbly"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 24, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 36, weight: .semibold)
        lbl.text = "enter your verification code"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var fieldOne: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.layer.cornerRadius = Constants.onboard_confirm_corner
        txtField.textAlignment = .center
        txtField.keyboardType = .phonePad
        txtField.becomeFirstResponder()
        
        txtField.backgroundColor = Constants.button_dark
        if traitCollection.userInterfaceStyle == .light {
            txtField.backgroundColor = Constants.button_light
        }
        
        txtField.font = Constants.getFont(size: 32, weight: .medium)
        txtField.tintColor = .clear
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var fieldTwo: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.layer.cornerRadius = Constants.onboard_confirm_corner
        txtField.textAlignment = .center
        txtField.keyboardType = .phonePad
        
        txtField.backgroundColor = Constants.button_dark
        if traitCollection.userInterfaceStyle == .light {
            txtField.backgroundColor = Constants.button_light
        }
        
        txtField.font = Constants.getFont(size: 32, weight: .medium)
        txtField.tintColor = .clear
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var fieldThree: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.layer.cornerRadius = Constants.onboard_confirm_corner
        txtField.textAlignment = .center
        txtField.keyboardType = .phonePad
        
        txtField.backgroundColor = Constants.button_dark
        if traitCollection.userInterfaceStyle == .light {
            txtField.backgroundColor = Constants.button_light
        }
        
        txtField.font = Constants.getFont(size: 32, weight: .medium)
        txtField.tintColor = .clear
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var fieldFour: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.layer.cornerRadius = Constants.onboard_confirm_corner
        txtField.textAlignment = .center
        txtField.keyboardType = .phonePad
        
        txtField.backgroundColor = Constants.button_dark
        if traitCollection.userInterfaceStyle == .light {
            txtField.backgroundColor = Constants.button_light
        }
        
        txtField.font = Constants.getFont(size: 32, weight: .medium)
        txtField.tintColor = .clear
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var fieldFive: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.layer.cornerRadius = Constants.onboard_confirm_corner
        txtField.textAlignment = .center
        txtField.keyboardType = .phonePad
        
        txtField.backgroundColor = Constants.button_dark
        if traitCollection.userInterfaceStyle == .light {
            txtField.backgroundColor = Constants.button_light
        }
        
        txtField.font = Constants.getFont(size: 32, weight: .medium)
        txtField.tintColor = .clear
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var fieldSix: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.layer.cornerRadius = Constants.onboard_confirm_corner
        txtField.textAlignment = .center
        txtField.keyboardType = .phonePad

        txtField.backgroundColor = Constants.button_dark
        if traitCollection.userInterfaceStyle == .light {
            txtField.backgroundColor = Constants.button_light
        }
        
        txtField.font = Constants.getFont(size: 32, weight: .medium)
        txtField.tintColor = .clear
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 10
        
        stack.addArrangedSubview(fieldOne)
        stack.addArrangedSubview(fieldTwo)
        stack.addArrangedSubview(fieldThree)
        stack.addArrangedSubview(fieldFour)
        stack.addArrangedSubview(fieldFive)
        stack.addArrangedSubview(fieldSix)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let resendLabelTop: UILabel = {
        let lbl = UILabel()
        lbl.text = "didn't receive your code?"
        lbl.textColor = Constants.secondary_text
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var resendLabelBot: UILabel = {
        let lbl = UILabel()
        let attrText = NSAttributedString(string: "send the code again", attributes: [.underlineStyle: 1])
        lbl.attributedText = attrText
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resendCode))
        lbl.addGestureRecognizer(tapGesture)
        lbl.isUserInteractionEnabled = true
        
        return lbl
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    // MARK: - Properties (data)
    private var number: String
    
    // MARK: - viewDidLoad, viewWillAppear, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
                
        view.addSubview(textLabel)
        view.addSubview(stack)
        view.addSubview(resendLabelTop)
        view.addSubview(resendLabelBot)
        view.addSubview(spinner)
        
        setupNavBar()
        setupConstraints()
    }
    
    init(number: String) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationItem.titleView = logo
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.login_top),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding + 5),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding - 5),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: Constants.onboard_confirm_height),
            
            resendLabelTop.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendLabelTop.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 25),
            
            resendLabelBot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendLabelBot.topAnchor.constraint(equalTo: resendLabelTop.bottomAnchor, constant: 2),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: resendLabelBot.bottomAnchor, constant: 50)
        ])
    }
    
    // MARK: - Helper Functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") {
            textField.text = string
            if textField == fieldOne {
                fieldTwo.becomeFirstResponder()
            } else if textField == fieldTwo {
                fieldThree.becomeFirstResponder()
            } else if textField == fieldThree {
                fieldFour.becomeFirstResponder()
            } else if textField == fieldFour{
                fieldFive.becomeFirstResponder()
            } else if textField == fieldFive {
                fieldSix.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                submitVerification()
            }
            return false
        } else if string == "" {
            textField.text = string
            if textField == fieldSix {
                fieldFive.becomeFirstResponder()
            } else if textField == fieldFive {
                fieldFour.becomeFirstResponder()
            } else if textField == fieldFour {
                fieldThree.becomeFirstResponder()
            } else if textField == fieldThree{
                fieldTwo.becomeFirstResponder()
            } else if textField == fieldTwo {
                fieldOne.becomeFirstResponder()
            }
            return false
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 { }
        return true
    }
    
    private func submitVerification() {
        spinner.startAnimating()
        let code = fieldOne.text! + fieldTwo.text! + fieldThree.text! + fieldFour.text! + fieldFive.text! + fieldSix.text!
        AuthManager.verifyCode(code: code, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                let homeVC = HomeVC(initialPopup: false)
                let nav = UINavigationController(rootViewController: homeVC)
                nav.modalTransitionStyle = .crossDissolve
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            } else {
                let alert = UIAlertController(title: "Invalid code", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self.present(alert, animated: true)
            }
            self.spinner.stopAnimating()
        })
    }
    
    // MARK: - Button Helpers
    @objc private func resendCode() {
        AuthManager.startAuth(number: self.number, completion: { _ in })
    }
}
