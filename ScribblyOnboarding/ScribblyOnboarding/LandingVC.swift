//
//  LandingVC.swift
//  ScribblyOnboarding
//
//  Created by Liam Du on 12/27/22.
//

import UIKit

class LandingVC: UIViewController {
    
    private let introduction = UILabel()
    private let logo = UIImageView()
    private let login = UIButton()
    private let signup = UIButton()
    private let background = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        //background.contentMode = .scaleAspectFill
        background.image = UIImage(named: "landingbackground")
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)
        
        introduction.text = "welcome to"
        introduction.textColor = .gray
        introduction.font = OnboardConstants.comment_title_font
        introduction.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(introduction)
        
        
        logo.image = UIImage(named: "scribblydark")
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        login.setTitle("log in", for: .normal)
        login.addTarget(self, action: #selector(loginView), for: .touchUpInside)
        login.setTitleColor(.white, for: .normal)
        login.backgroundColor = OnboardConstants.button_gray
        login.layer.cornerRadius = 16
        login.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(login)
        
        signup.setTitle("sign up", for: .normal)
        signup.addTarget(self, action: #selector(signupView), for: .touchUpInside)
        signup.setTitleColor(.white, for: .normal)
        signup.backgroundColor = OnboardConstants.button_gray
        signup.layer.cornerRadius = 16
        signup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signup)
        
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            introduction.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: 84),
            introduction.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: introduction.bottomAnchor,
                                      constant: -24),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 141),

        ])
        
        NSLayoutConstraint.activate([
            login.bottomAnchor.constraint(equalTo: signup.topAnchor,
                                       constant: -8),
            login.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            login.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 24),
            login.heightAnchor.constraint(equalToConstant: 48)

        ])
        
        NSLayoutConstraint.activate([
            signup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                        constant: -57),
            signup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signup.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 24),
            signup.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc func signupView(){
        navigationController?.pushViewController(SignupVC(), animated: true)
    }
    
    @objc func loginView(){
        navigationController?.pushViewController(LoginVC(), animated: true)
    }
    

}
