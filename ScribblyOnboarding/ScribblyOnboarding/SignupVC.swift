//
//  LoginVC.swift
//  ScribblyOnboarding
//
//  Created by Liam Du on 12/28/22.
//

import UIKit

class LoginVC: UIViewController {

    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "scribbly"
        lbl.textColor = .label
        lbl.font = OnboardConstants.logo_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var back_btn: UIButton = {
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
    
    private let createacc: UILabel = {
        let lbl = UILabel()
        lbl.text = "create an account"
        lbl.textColor = .label
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
        eula.text = "by clicking “create account,” you agree to scribbly’s End User License Agreement"
        eula.translatesAutoresizingMaskIntoConstraints = false
        return eula
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("create account", for: .normal)
        createButton.addTarget(LoginVC.self, action: #selector(numberView), for: .touchUpInside)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .systemBlue
        createButton.layer.cornerRadius = 15
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    
    private func setupNavBar() {
        navigationItem.titleView = logo
        back_btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_btn)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
            eula.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -16),
            eula.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                        constant: -57),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 24),
        ])
        
        
    }
    
    @objc func numberView(){
        navigationController?.pushViewController(NumberVC(), animated: true)
    }
    

}
