//
//  LandingVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/4/23.
//

import UIKit

// MARK: LandingVC
class LandingVC: UIViewController {
    // MARK: - Properties (view)
    private let welcomeToLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "welcome to"
        lbl.font = Constants.getFont(size: 24, weight: .semibold)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let logoLabel: UIImageView = {
        let img = UIImageView(image: UIImage(named: "scribbly_logo"))
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var continueLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "tap anywhere to continue"
        lbl.font = Constants.getFont(size: 16, weight: .semibold)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var linesImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "landing_bg")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
//    private lazy var loginButton: UIButton = {
//        let btn = UIButton()
//        btn.addTarget(self, action: #selector(pushLoginVC), for: .touchUpInside)
//        var config = UIButton.Configuration.filled()
//
//        var text = AttributedString("login")
//        text.font = Constants.getFont(size: 16, weight: .bold)
//        config.attributedTitle = text
//
//        config.baseBackgroundColor = Constants.blur_dark
//        if traitCollection.userInterfaceStyle == .light {
//            config.baseBackgroundColor = Constants.blur_light
//        }
//
//        config.background.cornerRadius = Constants.landing_button_corner
//        config.buttonSize = .large
//        config.baseForegroundColor = .label
//        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
//
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
//        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
//        customBlurEffectView.frame = btn.bounds
//        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        customBlurEffectView.layer.cornerRadius = Constants.landing_button_corner
//        customBlurEffectView.clipsToBounds = true
//        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        customBlurEffectView.isUserInteractionEnabled = false
//
//        btn.addSubview(customBlurEffectView)
//
//        btn.configuration = config
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    private lazy var signupButton: UIButton = {
//        let btn = UIButton()
//        btn.addTarget(self, action: #selector(pushSignupVC), for: .touchUpInside)
//        var config = UIButton.Configuration.filled()
//
//        var text = AttributedString("sign up")
//        text.font = Constants.getFont(size: 16, weight: .bold)
//        config.attributedTitle = text
//
//        config.baseBackgroundColor = Constants.blur_dark
//        if traitCollection.userInterfaceStyle == .light {
//            config.baseBackgroundColor = Constants.blur_light
//        }
//
//        config.buttonSize = .large
//        config.background.cornerRadius = Constants.landing_button_corner
//        config.baseForegroundColor = .label
//        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
//
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
//        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
//        customBlurEffectView.frame = btn.bounds
//        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        customBlurEffectView.layer.cornerRadius = Constants.landing_button_corner
//        customBlurEffectView.clipsToBounds = true
//        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        customBlurEffectView.isUserInteractionEnabled = false
//        
//        btn.addSubview(customBlurEffectView)
//
//        btn.configuration = config
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
        
    // MARK: - viewDidLoad and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushPhoneVC))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    
        view.addSubview(welcomeToLabel)
        view.addSubview(logoLabel)
        view.addSubview(linesImage)
        view.addSubview(continueLabel)
//        view.addSubview(loginButton)
//        view.addSubview(signupButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeToLabel.bottomAnchor.constraint(equalTo: logoLabel.topAnchor),
            welcomeToLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoLabel.widthAnchor.constraint(equalToConstant: Constants.loading_logo_width),
            
            continueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.login_bot - 10),
            
//            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.landing_bot),
//            signupButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.landing_btn_side),
//
//            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loginButton.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant: -10),
//            loginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.landing_btn_side),
            
            linesImage.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            linesImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            linesImage.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            linesImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func pushPhoneVC() {
        let phoneVC = PhoneVC()
        let nav = UINavigationController(rootViewController: phoneVC)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
//    @objc private func pushLoginVC() {
//        let loginVC = LoginVC()
//        navigationController?.pushViewController(loginVC, animated: true)
//    }
//
//    @objc private func pushSignupVC() {
//        let signupVC = SignupVC()
//        navigationController?.pushViewController(signupVC, animated: true)
//    }
}
