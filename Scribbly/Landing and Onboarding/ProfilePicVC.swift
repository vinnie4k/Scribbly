//
//  ProfilePicVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import UIKit
import PhotosUI

// MARK: ProfilePicVC
class ProfilePicVC: UIViewController {
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
        lbl.text = "now let's pick a profile picture for you"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.text = "uploading a picture can be useful for your friends to find you!"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
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
        config.baseBackgroundColor = Constants.primary_dark
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("skip")
        text.font = Constants.getFont(size: 16, weight: .bold)
        config.attributedTitle = text
        
        config.background.cornerRadius = Constants.landing_button_corner
        config.baseBackgroundColor = Constants.button_dark
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
    
    private lazy var profileImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "upload_pfp")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.onboard_pfp_radius
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pfpAlert))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    private let pageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "page4")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - Properties (data)
    private var firstName: String
    private var lastName: String
    private var username: String
    private var changedImage = false
    
    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                        
        view.addSubview(textLabel)
        view.addSubview(descTextLabel)
        view.addSubview(stack)
        view.addSubview(profileImage)
        view.addSubview(pageView)
        
        setupNavBar()
        setupConstraints()
    }
    
    init(firstName: String, lastName: String, username: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
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
            
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.login_side_padding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.login_side_padding),
            
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: descTextLabel.bottomAnchor, constant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: Constants.onboard_pfp_radius * 2),
            profileImage.heightAnchor.constraint(equalToConstant: Constants.onboard_pfp_radius * 2),
            
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -Constants.onboard_dots_bot)
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
            nextButton.configuration?.baseBackgroundColor = Constants.button_dark
        }
    }
    
    // MARK: - Button Helpers
    @objc private func prevPage() {
        dismiss(animated: true)
    }
    
    @objc private func nextPage() {
        var image: UIImage?
        if !changedImage {
            image = nil
        } else {
            image = profileImage.image
        }
        
        let suggestionsVC = SuggestionsVC(firstName: firstName, lastName: lastName, username: username, pfp: image)
        let nav = UINavigationController(rootViewController: suggestionsVC)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func pfpAlert() {
        let photoLibraryAlert = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.checkPhotosAccess()
        }
        
        let cameraAlert = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.checkCameraAccess()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(photoLibraryAlert)
        alert.addAction(cameraAlert)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

extension ProfilePicVC: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Accessing Photo Library
    @objc private func checkPhotosAccess() {
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
                        self.profileImage.image = image
                        self.nextButton.configuration?.title = "next"
                        self.changedImage = true
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
            self.profileImage.image = image
            self.nextButton.configuration?.title = "next"
            self.changedImage = true
        }
        picker.dismiss(animated: true, completion: nil)
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
