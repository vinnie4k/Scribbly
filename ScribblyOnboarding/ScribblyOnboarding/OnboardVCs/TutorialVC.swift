//
//  TutorialVC.swift
//  ScribblyOnboarding
//
//  Created by Liam Du on 12/29/22.
//

import UIKit


class TutorialVC: UIViewController {

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
        config.image = UIImage(systemName: "")
        config.baseForegroundColor = OnboardConstants.text_dark
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let question: UILabel = {
        let lbl = UILabel()
        lbl.text = "you are almost there!"
        lbl.textAlignment = .left
        lbl.textColor = OnboardConstants.text_dark
        lbl.font = OnboardConstants.question_font
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let forms: UITextField = {
        let txt_field = UITextField()
        txt_field.placeholder = "(xxx) xxx-xxxx"
        txt_field.textColor = .label
        txt_field.font = OnboardConstants.question_font
        txt_field.tintColor = .label
        txt_field.background = UIImage(named: "textfieldunderline")
        txt_field.contentMode = .scaleAspectFit
        txt_field.keyboardType = UIKeyboardType.twitter
        txt_field.translatesAutoresizingMaskIntoConstraints = false
        return txt_field
    }()
    
    private let carousel: UIImageView = {
        let carousel = UIImageView()
        carousel.image = UIImage(named: "carouselpos7")
        carousel.contentMode = .scaleAspectFit
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    private let backButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("back", for: .normal)
        createButton.addTarget(self, action: #selector(previousview), for: .touchUpInside)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = OnboardConstants.primary_dark
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    private let nextButton: UIButton = {
        let createButton = UIButton()
        createButton.setTitle("next", for: .normal)
        createButton.addTarget(self, action: #selector(nextview), for: .touchUpInside)
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        view.addSubview(question)
        view.addSubview(forms)
        view.addSubview(carousel)
        view.addSubview(nextButton)
        view.addSubview(backButton)
        setupConstraints()

        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            question.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            question.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            question.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            forms.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 228),
            forms.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            forms.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            carousel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -64),
            carousel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 144),
            carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -144),
        ])
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -57),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            backButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -57),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
    }
    
    @objc func previousview(){
        navigationController?.pushViewController(FriendrecVC(), animated: false)
    }
    
    @objc func nextview(){
        navigationController?.pushViewController(LandingVC(), animated: true)
    }

}
