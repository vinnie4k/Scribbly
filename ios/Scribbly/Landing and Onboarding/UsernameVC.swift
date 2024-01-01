//
//  UsernameVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/11/23.
//

import UIKit

// MARK: UsernameVC

class UsernameVC: UIViewController, UITextFieldDelegate {
    // MARK: - Properties (view)
    private let logo: UIImageView = {
        let img = UIImageView(image: UIImage(named: "scribbly_title"))
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 36, weight: .semibold)
        lbl.text = "now, choose a username"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.text = "you can always change this later"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var textField: UITextField = {
        let txtField = UITextField()
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 40, weight: .semibold)
        txtField.placeholder = "username"
        txtField.tintColor = .label
        txtField.addUnderlineOnboard(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.login_side_padding))
        txtField.autocorrectionType = .no
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("back")
        text.font = Constants.getFont(size: 16, weight: .bold)
        config.attributedTitle = text
        
        config.background.cornerRadius = Constants.landing_button_corner
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Constants.primary_black
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.addArrangedSubview(backButton)
        stack.addArrangedSubview(nextButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "page3")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    // MARK: - Properties (data)
    private var firstName: String
    private var lastName: String
    
    // MARK: - viewDidLoad, viewWillAppear, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
                
        view.addSubview(textLabel)
        view.addSubview(textField)
        view.addSubview(stack)
        view.addSubview(pageView)
        view.addSubview(descTextLabel)
        view.addSubview(spinner)
        
        setupNavBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
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
            
            descTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 15),
            descTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            descTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -Constants.onboard_dots_bot),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textField.text = textField.text?.lowercased()
        let text = textField.text!
        
        if textField.text!.isEmpty || text.count < 6 || text.count > 20 || text.firstIndex(of: " ") != nil {
            nextButton.isUserInteractionEnabled = false
            nextButton.configuration?.baseBackgroundColor = Constants.secondary_text
        } else {
            nextButton.isUserInteractionEnabled = true
            nextButton.configuration?.baseBackgroundColor = Constants.button_both_color
        }
    }
    
    private func checkUsername() {
        // Check to see if the username already exists
        spinner.startAnimating()

        DatabaseManager.usernameExists(with: textField.text!, completion: { [weak self] exists in
            guard let `self` = self else { return }
            if !exists {
                let profPicVC = ProfilePicVC(firstName: self.firstName, lastName: self.lastName, username: self.textField.text!.lowercased())
                let nav = UINavigationController(rootViewController: profPicVC)
                nav.modalTransitionStyle = .crossDissolve
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            } else {
                let alert = UIAlertController(title: "Invalid username", message: "That username has been taken", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self.present(alert, animated: true)
            }
            self.spinner.stopAnimating()
        })
    }
    
    // MARK: - Button Helpers
    @objc private func prevPage() {
        dismiss(animated: true)
    }
    
    @objc private func nextPage() {
        checkUsername()
    }
}
