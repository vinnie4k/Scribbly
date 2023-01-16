//
//  SettingsVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/4/23.
//

import UIKit
import FirebaseAuth

// MARK: SettingsVC
class SettingsVC: UIViewController {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "settings"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(tappedLogout), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("log out")
        text.font = Constants.getFont(size: 16, weight: .bold)
        config.attributedTitle = text
        
        config.background.cornerRadius = Constants.landing_button_corner
        config.baseBackgroundColor = Constants.button_both_color
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let essentialsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "essentials"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var essentialsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 2
        stack.layer.cornerRadius = Constants.settings_stack_corner
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.backgroundColor = Constants.post_color
        
        let blockedUsers = SettingsView()
        blockedUsers.configure(image: UIImage(systemName: "x.circle")!, text: "blocked users")
        blockedUsers.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushBlockVC)))
        blockedUsers.isUserInteractionEnabled = true
        
        let mode = SettingsView()
        mode.configure(image: UIImage(systemName: "pencil.circle")!, text: "appearance")
        mode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushAppearance)))
        mode.isUserInteractionEnabled = true
        
        stack.addArrangedSubview(mode)
        stack.addArrangedSubview(SeparatorView())
        stack.addArrangedSubview(blockedUsers)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let aboutLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "about"
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var aboutStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 2
        stack.layer.cornerRadius = Constants.settings_stack_corner
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        
        stack.backgroundColor = Constants.post_color
        
        let help = SettingsView()
        help.configure(image: UIImage(systemName: "questionmark.circle")!, text: "help")
        
        let about = SettingsView()
        about.configure(image: UIImage(systemName: "info.circle")!, text: "about")
        
        let contact = SettingsView()
        contact.configure(image: UIImage(systemName: "envelope.circle")!, text: "contact us")
        
        let rate = SettingsView()
        rate.configure(image: UIImage(systemName: "star.circle")!, text: "rate scribbly")
        
        let share = SettingsView()
        share.configure(image: UIImage(systemName: "square.and.arrow.up.circle")!, text: "share scribbly")
        
        stack.addArrangedSubview(help)
        stack.addArrangedSubview(SeparatorView())
        stack.addArrangedSubview(about)
        stack.addArrangedSubview(SeparatorView())
        stack.addArrangedSubview(contact)
        stack.addArrangedSubview(SeparatorView())
        stack.addArrangedSubview(rate)
        stack.addArrangedSubview(SeparatorView())
        stack.addArrangedSubview(share)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Properties (data)
    private var mainUser: User!
    weak var resetBackgroundDelegate: ResetBackgroundDelegate?
    
    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoutButton)
        view.addSubview(essentialsLabel)
        view.addSubview(essentialsStack)
        view.addSubview(aboutLabel)
        view.addSubview(aboutStack)
        
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
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.settings_bot),
            logoutButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.settings_side_padding),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            essentialsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.settings_top),
            essentialsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.settings_side_padding + 10),
            
            essentialsStack.topAnchor.constraint(equalTo: essentialsLabel.bottomAnchor, constant: 5),
            essentialsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.settings_side_padding),
            essentialsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.settings_side_padding),
            
            aboutLabel.topAnchor.constraint(equalTo: essentialsStack.bottomAnchor, constant: Constants.settings_spacing),
            aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.settings_side_padding + 10),
            
            aboutStack.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 5),
            aboutStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.settings_side_padding),
            aboutStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.settings_side_padding)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func pushAppearance() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let appearanceVC = AppearanceVC()
        appearanceVC.resetBackgroundDelegate = resetBackgroundDelegate
        navigationController?.pushViewController(appearanceVC, animated: true)
    }
    
    @objc private func pushBlockVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let blockVC = BlockedVC(mainUser: mainUser)
        navigationController?.pushViewController(blockVC, animated: true)
    }
    
    @objc private func popVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedLogout() {
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] action in
            guard let `self` = self else { return }
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let landingVC = LandingVC()
                let nav = UINavigationController(rootViewController: landingVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            } catch {
                print("Failed to log out.")
            }
        })
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alert.addAction(logoutAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
