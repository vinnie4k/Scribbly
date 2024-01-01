//
//  FirstNameVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import UIKit

// MARK: FirstNameVC
class FirstNameVC: UIViewController, UITextFieldDelegate {
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
        lbl.text = "hey there!\nwhat's your name?"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var textField: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 40, weight: .semibold)
        txtField.placeholder = "first name"
        txtField.tintColor = .label
        txtField.addUnderlineOnboard(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
        txtField.autocorrectionType = .no
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
    
    private let pageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "page1")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - viewDidLoad, viewWillAppear, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
                
        view.addSubview(textLabel)
        view.addSubview(nextButton)
        view.addSubview(textField)
        view.addSubview(pageView)
        
        setupNavBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            nextButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot),
            
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -Constants.onboard_dots_bot)
        ])
    }
    
    // MARK: - Helper Functions
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textField.text = textField.text?.lowercased()
        if textField.text!.isEmpty {
            nextButton.isUserInteractionEnabled = false
            nextButton.configuration?.baseBackgroundColor = Constants.secondary_text
        } else {
            nextButton.isUserInteractionEnabled = true
            nextButton.configuration?.baseBackgroundColor = Constants.button_both_color
        }
    }
    
    // MARK: - Button Helpers
    @objc private func nextPage() {
        let lastNameVC = LastNameVC(firstName: textField.text!.lowercased())
        let nav = UINavigationController(rootViewController: lastNameVC)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
