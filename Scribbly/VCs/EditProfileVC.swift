//
//  EditProfileVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/31/22.
//

import UIKit
import PhotosUI

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
        btn.addTarget(self, action: #selector(confirmChanges), for: .touchUpInside)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pfpAlert))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
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
    var updatePFPDelegate: UpdatePFPDelegate!
    var updateProfileDelegate: UpdateProfileDelegate!
    
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
    
    private func checkCriteria() {
        // First name, last name, username, and email cannot be empty
        // username and email cannot be taken
        // email must contain @ symbol
        if !validFirstName() {
            firstNameTextField.addInvalid()
        } else {
            firstNameTextField.removeInvalid()
        }
        
        if !validLastName() {
            lastNameTextField.addInvalid()
        } else {
            lastNameTextField.removeInvalid()
        }
        
        if !validUserName() {
            userNameTextField.addInvalid()
        } else {
            userNameTextField.removeInvalid()
        }
        
        if !validEmail() {
            emailTextField.addInvalid()
        } else {
            emailTextField.removeInvalid()
        }
    }
    
    private func validFirstName() -> Bool {
        if firstNameTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    private func validLastName() -> Bool {
        if lastNameTextField.text!.isEmpty {
            return false
        }
        return true
    }
    
    private func validUserName() -> Bool {
        let text = userNameTextField.text!
        if text.isEmpty || text.firstIndex(of: " ") != nil || Database.containsUsername(username: text, user: mainUser) {
            return false
        }
        return true
    }
    
    private func validEmail() -> Bool {
        let text = emailTextField.text!
        if text.isEmpty || text.firstIndex(of: "@") == nil || Database.containsEmail(email: text, user: mainUser) {
            return false
        }
        return true
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textField.text = textField.text?.lowercased()
        
        checkCriteria()
    }
    
    @objc func pfpAlert() {
        let photoLibraryAlert = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.checkPhotosAccess()
        }
        
        let cameraAlert = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.checkCameraAccess()
        }
        
        let deleteAlert = UIAlertAction(title: "Delete Profile Picture", style: .destructive) { (action) in
            self.deleteProfilePicture()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(photoLibraryAlert)
        alert.addAction(cameraAlert)
        alert.addAction(deleteAlert)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @objc func confirmChanges() {
        if validFirstName() && validLastName() && validEmail() && validUserName() {
            mainUser.setFirstName(name: firstNameTextField.text!)
            mainUser.setLastName(name: lastNameTextField.text!)
            mainUser.updateFullName()
            mainUser.setUserName(name: userNameTextField.text!)
            mainUser.setEmail(text: emailTextField.text!)
            mainUser.setBio(text: bioTextField.text!)
            updatePFPDelegate.updatePFP()
            updateProfileDelegate.updateProfile()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid Changes", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }
}

// MARK: - Extensions
extension EditProfileVC: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Accessing Photo Library
    private func checkPhotosAccess() {
        let authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch authStatus {
        case .authorized, .limited:
            self.accessPhotos()
        case .denied, .restricted:
            self.accessDenied(title: "Photo library access denied", message: "Please enable in Settings > Privacy")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized, .limited:
                    self.accessPhotos()
                case .denied, .restricted:
                    self.accessDenied(title: "Photo library access denied", message: "Please enable in Settings > Privacy")
                case .notDetermined:
                    print("This won't happen")
                @unknown default:
                    fatalError("Unknown")
                }
            }
        @unknown default:
            fatalError("Unknown")
        }
    }
    
    private func accessPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.livePhotos, .images])
        configuration.preferredAssetRepresentationMode = .automatic
        
        DispatchQueue.main.async {
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard !results.isEmpty else {
            return
        }
        
        let item = results[0].itemProvider
        if item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.mainUser.setPFP(image: image)
                        self.editProfilePictureView.profileImage.image = self.mainUser.getPFP()
                        self.updatePFPDelegate.updatePFP()
                        self.updateProfileDelegate.updateProfile()
                    }
                }
            }
        }
    }
    
    // MARK: - Accessing Camera
    private func checkCameraAccess() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.accessCamera()
                } else {
                    self.accessDenied(title: "Camera access denied", message: "Please enable in Settings > Privacy")
                }
            }
        case .denied, .restricted:
            self.accessDenied(title: "Camera access denied", message: "Please enable in Settings > Privacy")
        case .authorized:
            self.accessCamera()
        @unknown default:
            fatalError("Unknown")
        }
    }
    
    private func accessCamera() {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.delegate = self;
            picker.mediaTypes = ["public.image"]
            picker.sourceType = UIImagePickerController.SourceType.camera

            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.mainUser.setPFP(image: image)
            self.editProfilePictureView.profileImage.image = self.mainUser.getPFP()
            self.updatePFPDelegate.updatePFP()
            self.updateProfileDelegate.updateProfile()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delete Profile Picture
    private func deleteProfilePicture() {
        self.mainUser.defaultPFP()
        self.editProfilePictureView.profileImage.image = self.mainUser.getPFP()
        self.updatePFPDelegate.updatePFP()
        self.updateProfileDelegate.updateProfile()
    }
    
    // MARK: - Helpers
    private func accessDenied(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}
