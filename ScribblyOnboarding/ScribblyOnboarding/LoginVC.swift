//
//  SignupVC.swift
//  ScribblyOnboarding
//
//  Created by Liam Du on 12/28/22.
//

import UIKit

class LoginVC: UIViewController {
   
    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "scribbly"
        lbl.textColor = OnboardConstants.text_dark
        lbl.font = OnboardConstants.logo_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var back_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = OnboardConstants.text_dark
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let createacc: UILabel = {
        let lbl = UILabel()
        lbl.text = "log in"
        lbl.textColor = OnboardConstants.text_dark
        lbl.font = OnboardConstants.logo_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let usernametxt: UILabel = {
        let lbl = UILabel()
        lbl.text = "username"
        lbl.textColor = OnboardConstants.secondary_text
        lbl.font = OnboardConstants.description_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let passwrdtxt: UILabel = {
        let lbl = UILabel()
        lbl.text = "password"
        lbl.textColor = OnboardConstants.secondary_text
        lbl.font = OnboardConstants.description_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private let usernameform: UITextField = {
        let txt_field = UITextField()
        txt_field.textColor = OnboardConstants.text_dark
        txt_field.font = OnboardConstants.description_font
        txt_field.tintColor = OnboardConstants.secondary_text
        txt_field.background = UIImage(named: "smallfieldunderline")
        txt_field.contentMode = .scaleAspectFit
        txt_field.keyboardType = UIKeyboardType.twitter
        txt_field.translatesAutoresizingMaskIntoConstraints = false
        return txt_field
    }()
    
    private let passwordform: UITextField = {
        let txt_field = UITextField()
        txt_field.textColor = OnboardConstants.text_dark
        txt_field.font = OnboardConstants.description_font
        txt_field.tintColor = OnboardConstants.secondary_text
        txt_field.background = UIImage(named: "smallfieldunderline")
        txt_field.contentMode = .scaleAspectFit
        txt_field.keyboardType = UIKeyboardType.twitter
        txt_field.translatesAutoresizingMaskIntoConstraints = false
        return txt_field
    }()
    
    
    private let trdparty = UIImageView()
    
    private let googleloginbutton: UIButton = {
        let createButton = UIButton()
        //createButton.addTarget(self, action: #selector(nextview), for: .touchUpInside)
        createButton.setTitleColor(.white, for: .normal)
        createButton.setImage(UIImage(named: "googlelogo"), for: .normal)
        createButton.imageView?.contentMode = .scaleAspectFit
        createButton.imageView?.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        createButton.backgroundColor = .white
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let appleloginbutton: UIButton = {
        let createButton = UIButton()
        //createButton.addTarget(self, action: #selector(nextview), for: .touchUpInside)
        createButton.setTitleColor(.white, for: .normal)
        createButton.setImage(UIImage(named: "applelogo"), for: .normal)
        createButton.imageView?.contentMode = .scaleAspectFit
        createButton.imageView?.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        createButton.backgroundColor = OnboardConstants.primary_dark
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let eula: UILabel = {
        let eula = UILabel()
        eula.text = "by clicking “create account,” you agree to scribbly’s"
        eula.font = OnboardConstants.eula_font
        eula.textColor = OnboardConstants.secondary_text
        eula.textAlignment = .center
        eula.translatesAutoresizingMaskIntoConstraints = false
        return eula
    }()
    
    private let eula_clickable: UILabel = {
        let eula_clickable = UILabel()
        eula_clickable.text = "End User License Agreement"
        eula_clickable.font = OnboardConstants.eula_font
        eula_clickable.textColor = OnboardConstants.text_dark
        eula_clickable.numberOfLines = 2
        eula_clickable.textAlignment = .center
        eula_clickable.translatesAutoresizingMaskIntoConstraints = false
        return eula_clickable
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("create account", for: .normal)
        createButton.addTarget(self, action: #selector(numberView), for: .touchUpInside)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = OnboardConstants.button_gray
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    
    private func setupNavBar() {
        navigationItem.titleView = logo
        back_btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_btn)
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        view.addSubview(createacc)
        view.addSubview(usernametxt)
        view.addSubview(usernameform)
        view.addSubview(passwrdtxt)
        view.addSubview(passwordform)
        
        trdparty.image = UIImage(named: "thirdpartylogin")
        trdparty.contentMode = .scaleAspectFit
        trdparty.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trdparty)
        
        view.addSubview(googleloginbutton)
        view.addSubview(appleloginbutton)
        
        view.addSubview(eula)
        view.addSubview(eula_clickable)
        view.addSubview(createButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createacc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            createacc.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            usernametxt.topAnchor.constraint(equalTo: createacc.bottomAnchor, constant: 32),
            usernametxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            usernameform.topAnchor.constraint(equalTo: usernametxt.bottomAnchor, constant: 8),
            usernameform.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameform.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            passwrdtxt.topAnchor.constraint(equalTo: usernameform.bottomAnchor, constant: 24),
            passwrdtxt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            passwordform.topAnchor.constraint(equalTo: passwrdtxt.bottomAnchor, constant: 8),
            passwordform.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordform.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            trdparty.topAnchor.constraint(equalTo: passwordform.bottomAnchor, constant: 48),
            trdparty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trdparty.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            trdparty.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            googleloginbutton.topAnchor.constraint(equalTo: trdparty.bottomAnchor, constant: 32),
            googleloginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleloginbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            googleloginbutton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            googleloginbutton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
        NSLayoutConstraint.activate([
            appleloginbutton.topAnchor.constraint(equalTo: trdparty.bottomAnchor, constant: 32),
            appleloginbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleloginbutton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            appleloginbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            appleloginbutton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
        NSLayoutConstraint.activate([
            eula.bottomAnchor.constraint(equalTo: eula_clickable.topAnchor, constant: -2),
            eula.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eula.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            eula.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            eula_clickable.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -16),
            eula_clickable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eula_clickable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            eula_clickable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -57),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            createButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
    }
    
    @objc func numberView(){
        navigationController?.pushViewController(NumberVC(), animated: true)
    }
    

}
