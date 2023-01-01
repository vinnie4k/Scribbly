//
//  EditProfileVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/31/22.
//

import UIKit

// MARK: EditProfileVC
class EditProfileVC: UIViewController, UITextFieldDelegate {

    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "edit profile"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(named: "checkmark_dark")
        if traitCollection.userInterfaceStyle == .light {
            config.image = UIImage(named: "checkmark_light")
        }
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var editProfilePictureView: EditProfilePictureView = {
        let view = EditProfilePictureView()
        view.configure(mode: traitCollection.userInterfaceStyle, mainUser: mainUser)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "first name"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let txtField = UITextField()
        txtField.text = mainUser.getFirstName().lowercased()
        txtField.autocapitalizationType = .none
        txtField.placeholder = "first name"
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 14, weight: .regular)
        txtField.tintColor = .label
        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.edit_prof_side_padding))
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let lastNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "last name"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let txtField = UITextField()
        txtField.text = mainUser.getLastName().lowercased()
        txtField.autocapitalizationType = .none
        txtField.placeholder = "last name"
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 14, weight: .regular)
        txtField.tintColor = .label
        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.edit_prof_side_padding))
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "username"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var userNameTextField: UITextField = {
        let txtField = UITextField()
        txtField.text = mainUser.getUserName().lowercased()
        txtField.autocapitalizationType = .none
        txtField.placeholder = "username"
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 14, weight: .regular)
        txtField.tintColor = .label
        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.edit_prof_side_padding))
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "bio"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var bioTextField: UITextField = {
        let txtField = UITextField()
        txtField.text = mainUser.getBio().lowercased()
        txtField.autocapitalizationType = .none
        txtField.placeholder = "bio"
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 14, weight: .regular)
        txtField.tintColor = .label
        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.edit_prof_side_padding))
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "email"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var emailTextField: UITextField = {
        let txtField = UITextField()
        txtField.text = mainUser.getEmail().lowercased()
        txtField.autocapitalizationType = .none
        txtField.placeholder = "email"
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 14, weight: .regular)
        txtField.tintColor = .label
        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.edit_prof_side_padding))
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    // MARK: - Properties (data)
    private var mainUser: User

    // MARK: - viewDidLoad, viewWillAppear, init, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
        
        view.addSubview(editProfilePictureView)
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(userNameLabel)
        view.addSubview(userNameTextField)
        view.addSubview(bioLabel)
        view.addSubview(bioTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        
        setupNavBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        bioTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    init(mainUser: User) {
        self.mainUser = mainUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            editProfilePictureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.edit_prof_pfp_top),
            editProfilePictureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            firstNameLabel.topAnchor.constraint(equalTo: editProfilePictureView.bottomAnchor, constant: Constants.edit_prof_label_top),
            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            firstNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: Constants.edit_prof_txtfield_top),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: Constants.edit_prof_label_top),
            lastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            lastNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: Constants.edit_prof_txtfield_top),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            userNameLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: Constants.edit_prof_label_top),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            userNameTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: Constants.edit_prof_txtfield_top),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            bioLabel.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: Constants.edit_prof_label_top),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            bioTextField.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: Constants.edit_prof_txtfield_top),
            bioTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            bioTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            emailLabel.topAnchor.constraint(equalTo: bioTextField.bottomAnchor, constant: Constants.edit_prof_label_top),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: Constants.edit_prof_txtfield_top),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edit_prof_side_padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edit_prof_side_padding),
        ])
    }
    
    // MARK: - Helper Functions
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textField.text = textField.text?.lowercased()
    }
}
