//
//  PhoneVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import UIKit

// MARK: PhoneVC
class PhoneVC: UIViewController, UITextFieldDelegate {
    // MARK: - Properties (view)
    private let logo: UIImageView = {
        let img = UIImageView(image: UIImage(named: "scribbly_title"))
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 36, weight: .semibold)
        lbl.text = "what is your phone number?"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.text = "us numbers only. standard msg rates may apply"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var phoneTextField: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 40, weight: .semibold)
        txtField.placeholder = "(xxx) xxx-xxxx"
        txtField.tintColor = .clear
        txtField.addUnderlineOnboard(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
        txtField.autocorrectionType = .no
        txtField.keyboardType = .phonePad
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("next")
        text.font = Constants.getFont(size: 16, weight: .bold)
        config.attributedTitle = text
        
        config.background.cornerRadius = Constants.landing_button_corner
        config.baseBackgroundColor = Constants.secondary_text
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - viewDidLoad, viewWillAppear, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
                
        view.addSubview(textLabel)
        view.addSubview(nextButton)
        view.addSubview(phoneTextField)
        view.addSubview(descTextLabel)
        
        setupNavBar()
        setupConstraints()
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
            
            descTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 15),
            descTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            descTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            nextButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot)
        ])
    }
    
    // MARK: - Helper Functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
        
        if textField.text!.count == 14 {
            nextButton.configuration?.baseBackgroundColor = Constants.button_dark
            nextButton.isUserInteractionEnabled = true
            textField.resignFirstResponder()
        } else {
            nextButton.configuration?.baseBackgroundColor = Constants.secondary_text
            nextButton.isUserInteractionEnabled = false
        }
        
        return string == " "
    }
    
    private func format(with mask: String, phone: String) -> String {
        // mask example: `+X (XXX) XXX-XXXX` (capital X)
        
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextPage() {
        // TODO: IMPLEMENT THIS
        let number = "+1" + format(with: "XXXXXXXXXX", phone: phoneTextField.text!)
        AuthManager.startAuth(number: number, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                let confirmPhoneVC = ConfirmPhoneVC(number: number)
                self.navigationController?.pushViewController(confirmPhoneVC, animated: true)
            } else {
                let alert = UIAlertController(title: "Invalid phone number", message: "This phone number may already be in use", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self.present(alert, animated: true)
            }
        })
    }
}
