//
//  UploadPostVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/3/23.
//

import UIKit
import PhotosUI

// MARK: UploadPostVC
class UploadPostVC: UIViewController, UITextFieldDelegate {
    // MARK: - Properties (view)
    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "upload"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 24, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.upload_corner
        view.backgroundColor = Constants.button_dark
        
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = Constants.button_light
        }
        
        view.addSubview(uploadImageView)
        addConstr(lst: [
            uploadImageView.widthAnchor.constraint(equalToConstant: 75),
            uploadImageView.heightAnchor.constraint(equalToConstant: 75),
            uploadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadAlert))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var uploadImageView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "upload_dark")
        if traitCollection.userInterfaceStyle == .light {
            img.image = UIImage(named: "upload_light")
        }
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let captionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "caption"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var captionTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "enter a caption"
        txtField.textColor = .label
        txtField.font = Constants.getFont(size: 14, weight: .regular)
        txtField.tintColor = .label
        txtField.addUnderline(color: Constants.secondary_text, width: Int(UIScreen.main.bounds.width - 2 * Constants.upload_side_padding))
        txtField.delegate = self
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var postButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(postDrawing), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("post")
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
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    // MARK: - Properties (data)
    private var mainUser: User
    private var hasUploaded: Bool = false
    private var change: [NSLayoutConstraint] = []
    weak var dismissTimerDelegate: DismissTimerDelegate!

    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
        
        view.addSubview(borderView)
        view.addSubview(captionLabel)
        view.addSubview(captionTextField)
        view.addSubview(postButton)
        view.addSubview(spinner)
        
        setupNavBar()
        setupConstraints()
    }
    
    init(mainUser: User) {
        self.mainUser = mainUser
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
            borderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            borderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.upload_side_padding),
            borderView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.upload_side_padding),
            borderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.upload_top),
            
            captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.upload_side_padding),
            captionLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: Constants.upload_caption_top),
            
            captionTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.upload_side_padding),
            captionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captionTextField.heightAnchor.constraint(equalToConstant: 15),
            captionTextField.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 5),
            
            postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.timer_btn_bot),
            postButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.upload_side_padding),
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Button Helpers
    @objc private func uploadAlert() {
        checkCameraAccess()
    }
    
    @objc private func postDrawing() {
        spinner.startAnimating()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if hasUploaded {
            let postID = UUID().uuidString
            let fileName = "images/posts/\(postID).jpg"
            
            guard let image = uploadImageView.image, let data = image.jpegData(compressionQuality: 0.3) else { return }
            
            StorageManager.uploadImage(with: data, fileName: fileName, completion: { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let downloadURL):
                    ImageMap.map[fileName] = image
                    let format = DateFormatter()
                    format.dateFormat = "d MMMM yyyy HH:mm:ss"
                    
                    let post = Post(id: postID, user: self.mainUser.id, drawing: fileName, caption: self.captionTextField.text!, time: format.string(from: Date()), comments: [:], likedUsers: [:], bookmarkedUsers: [:], hidden: false)
                    
                    DatabaseManager.addPost(with: post, userID: self.mainUser.id, completion: { [weak self] success, key in
                        guard let `self` = self else { return }
                        if success {
                            self.mainUser.addPost(key: key, post: post)
                            self.mainUser.todaysPost = post.id
                            self.navigationController?.popViewController(animated: false)
                            self.dismissTimerDelegate.dismissTimerVC()
                            self.spinner.stopAnimating()
                        } else {
                            self.uploadError()
                            self.spinner.stopAnimating()
                        }
                    })
                    print(downloadURL)
                    
                case .failure(let error):
                    print("Storage manager error: \(error)")
                    self.uploadError()
                    self.spinner.stopAnimating()
                }
            })
        } else {
            let alert = UIAlertController(title: "Please upload your drawing by tapping on the view above", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Error Helpers
    private func uploadError() {
        let alert = UIAlertController(title: "Error", message: "Unable to upload the image. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Extensions
extension UploadPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            self.uploadImageView.image = image
            self.reconfigureConstraints()
            hasUploaded = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Other Helpers
    private func accessDenied(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    private func reconfigureConstraints() {
        uploadImageView.layer.cornerRadius = Constants.upload_corner
        
        addConstr(lst: [
            uploadImageView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            uploadImageView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
            uploadImageView.topAnchor.constraint(equalTo: borderView.topAnchor),
            uploadImageView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor)
        ])
    }
    
    private func addConstr(lst: [NSLayoutConstraint]) {
        // Deactivates all the old constraints in the list
        // Activate the new constraints and add to the list
        for constr in change {
            constr.isActive = false
        }
        for i in lst {
            i.isActive = true
            change.append(i)
        }
    }
}
