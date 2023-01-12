//
//  SuggestionsVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import UIKit

// MARK: SuggestionsVC
class SuggestionsVC: UIViewController {
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
        lbl.text = "does anyone look familiar?"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let descTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.text = "you can always add friends later"
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
        
        var text = AttributedString("finish")
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
    
    private let pageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "page5")
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
    private var username: String
    private var pfp: UIImage?
    
    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
                        
        view.addSubview(textLabel)
        view.addSubview(descTextLabel)
        view.addSubview(stack)
        view.addSubview(pageView)
        view.addSubview(spinner)
        
        setupNavBar()
        setupConstraints()
    }
    
    init(firstName: String, lastName: String, username: String, pfp: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.pfp = pfp
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
            
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -Constants.onboard_dots_bot),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func prevPage() {
        dismiss(animated: true)
    }
    
    @objc private func nextPage() {
        spinner.startAnimating()
        
        let group = DispatchGroup()
        var pfpURL = "images/pfp/scribbly_default_pfp.png"
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        
        AuthManager.currentUserID(completion: { [weak self] userID in
            guard let `self` = self, let userID = userID else { return }
            
            if self.pfp != nil {
                guard let image = self.pfp, let data = image.jpegData(compressionQuality: 0.3) else { return }
                let fileName = "images/pfp/\(userID)_pfp.jpg"
                
                group.enter()
                StorageManager.uploadImage(with: data, fileName: fileName, completion: { result in
                    switch result {
                    case .success(let downloadURL):
                        ImageMap.map[fileName] = self.pfp
                        pfpURL = fileName
                        print(downloadURL)
                    case .failure(let error):
                        print("Storage manager error: \(error)")
                        self.uploadError()
                    }
                    group.leave()
                })
            }
            
            group.notify(queue: .main) {
                let user = User(id: userID, userName: self.username, firstName: self.firstName, lastName: self.lastName, pfp: pfpURL, accountStart: format.string(from: Date()), bio: "", friends: [:], requests: [:], blocked: [:], posts: [:], bookmarkedPosts: [:], todaysPost: "")
                
                DatabaseManager.addUser(with: user, completion: { [weak self] success in
                    guard let `self` = self else { return }
                    if success {
                        print("User was created successfully.")
                        
                        let homeVC = HomeVC(initialPopup: true)
                        let nav = UINavigationController(rootViewController: homeVC)
                        nav.modalTransitionStyle = .crossDissolve
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true)
                        
                    } else {
                        let alert = UIAlertController(title: "Unable to create account", message: "Please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self.present(alert, animated: true)
                    }
                    self.spinner.stopAnimating()
                })
            }
        })
    }
    
    // MARK: - Helper Functions
    private func uploadError() {
        let alert = UIAlertController(title: "Error", message: "Unable to upload your profile picture. The default will be used for now.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}
