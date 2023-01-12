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
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(tappedLogout), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("log out")
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
    
    // MARK: - viewDidLoad, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoutButton)
        
        setupNavBar()
        setupConstraints()
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
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
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
