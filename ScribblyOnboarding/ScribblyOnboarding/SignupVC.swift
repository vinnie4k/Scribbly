//
//  LoginVC.swift
//  ScribblyOnboarding
//
//  Created by Liam Du on 12/28/22.
//

import UIKit

class SignupVC: UIViewController {

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
        lbl.text = "create an account"
        lbl.textColor = OnboardConstants.text_dark
        lbl.font = OnboardConstants.logo_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let forms: UILabel = {
        let form = UILabel()
        form.backgroundColor = .systemGray4
        form.translatesAutoresizingMaskIntoConstraints = false
        return form
    }()
    
    private let trdParty: UILabel = {
        let trdParty = UILabel()
        trdParty.backgroundColor = .systemGray4
        trdParty.translatesAutoresizingMaskIntoConstraints = false
        return trdParty
    }()
    
    private let eula: UILabel = {
        let eula = UILabel()
        eula.text = "by clicking “create account,” you agree to scribbly’s"
        eula.font = OnboardConstants.description_font
        eula.textColor = OnboardConstants.secondary_text
        eula.textAlignment = .center
        eula.translatesAutoresizingMaskIntoConstraints = false
        return eula
    }()
    
    private let eula_clickable: UILabel = {
        let eula_clickable = UILabel()
        eula_clickable.text = "End User License Agreement"
        eula_clickable.font = OnboardConstants.description_font
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
    
    private func setupForm() {

    }
    
    private func setupTrdparty() {
        
    }
    
    private func setupConfirm() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        view.addSubview(createacc)
        view.addSubview(forms)
        view.addSubview(trdParty)
        view.addSubview(eula)
        view.addSubview(eula_clickable)
        view.addSubview(createButton)
        setupTrdparty()
        setupConfirm()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createacc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            createacc.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            forms.topAnchor.constraint(equalTo: createacc.bottomAnchor, constant: 32),
            forms.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forms.heightAnchor.constraint(equalToConstant: 174)
        ])
        
        NSLayoutConstraint.activate([
            trdParty.topAnchor.constraint(equalTo: forms.bottomAnchor, constant: 98),
            trdParty.heightAnchor.constraint(equalToConstant: 103),
            trdParty.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
