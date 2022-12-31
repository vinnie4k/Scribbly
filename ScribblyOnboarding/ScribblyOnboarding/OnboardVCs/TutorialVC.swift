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
    
    private let hint: UILabel = {
        let lbl = UILabel()
        lbl.text = "here is a quick tutorial of how the app works!"
        lbl.textAlignment = .left
        lbl.textColor = OnboardConstants.text_dark
        lbl.font = OnboardConstants.tutorial_font
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tutorial: UILabel = {
        let lbl = UILabel()
        lbl.text = "1. you + friends will receive a prompt everyday. \n\n2. you can draw it any way you like and at any time as long as it is before the new prompt comes. \n\n3. when you finish your artwork with your preferred medium, take a pic and upload it. \n\n4. each artwork is intended to be completed around 10 minutes, and the app has a built in timer before you upload! \n\n5. this timeframe is not meant to be stressful, but rather meant to keep it light and simple. \n\n6. you cannot see what your friends drew unless you post your artwork. \n\n7. your profile page serves as a way to see how you progressed throughout the time you spent practicing everyday."
        lbl.textAlignment = .left
        lbl.textColor = OnboardConstants.text_dark
        lbl.font = OnboardConstants.eula_font
        lbl.numberOfLines = 50
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
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
        view.addSubview(hint)
        view.addSubview(tutorial)
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
            hint.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 14),
            hint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            tutorial.topAnchor.constraint(equalTo: hint.bottomAnchor, constant: 16),
            tutorial.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            tutorial.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
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
