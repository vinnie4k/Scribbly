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
        
        config.baseBackgroundColor = Constants.button_dark
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    private var mainUser: User
    private var hasUploaded: Bool = false
    private var change: [NSLayoutConstraint] = []
    var dismissTimerDelegate: DismissTimerDelegate!
    
    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
        
        view.addSubview(borderView)
        view.addSubview(captionLabel)
        view.addSubview(captionTextField)
        view.addSubview(postButton)
        
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
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        if hasUploaded {
            let post = Post(user: mainUser, drawing: uploadImageView.image!, caption: captionTextField.text!, time: Date())
            mainUser.addPost(post: post)
            
            navigationController?.popViewController(animated: false)
            dismissTimerDelegate.dismissTimerVC()
        } else {
            let alert = UIAlertController(title: "Please upload your drawing by tapping on the view above", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
        }
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
