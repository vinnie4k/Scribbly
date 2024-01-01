//
//  TutorialView.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import UIKit

// MARK: TutorialView
class TutorialView: UIView {
    // MARK: - Properties (view)
    private let textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 24, weight: .semibold)
        lbl.textAlignment = .center
        lbl.text = "here is a quick tutorial of how the app works!"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tip1: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "1. you and friends will receive a random prompt everyday"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tip2: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "2. you can draw it any way you like and at any time"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tip3: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "3. when ready, you can start the app's built-in timer"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tip4: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "4. each artwork is intended to be completed in 10 minutes, and when finished, simply take a pic and upload it"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tip5: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "5. this timeframe is not meant to be stressful, but rather meant to keep it light and simple"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let tip6: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "6. you will be able to interact with your friends' post after your drawing has uploaded"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
        
    private let tip7: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.text = "7. your profile page serves as a way to see your progression, add new friends, and view your favorite posts!"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var continueButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(dismissTutorial), for: .touchUpInside)
        var config = UIButton.Configuration.filled()

        var text = AttributedString("continue")
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
    
    // MARK: - Properties (data)
    weak var dismissTutorialDelegate: DismissTutorialDelegate?
    
    // MARK: - init and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.primary_color
        
        layer.cornerRadius = Constants.tutorial_corner

        addSubview(textLabel)
        addSubview(tip1)
        addSubview(tip2)
        addSubview(tip3)
        addSubview(tip4)
        addSubview(tip5)
        addSubview(tip6)
        addSubview(tip7)
        addSubview(continueButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.tutorial_top),
            textLabel.widthAnchor.constraint(equalToConstant: 275),
            
            tip1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip1.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: Constants.tutorial_spacing + 2),
            
            tip2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip2.topAnchor.constraint(equalTo: tip1.bottomAnchor, constant: Constants.tutorial_spacing),
            
            tip3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip3.topAnchor.constraint(equalTo: tip2.bottomAnchor, constant: Constants.tutorial_spacing),
            
            tip4.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip4.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip4.topAnchor.constraint(equalTo: tip3.bottomAnchor, constant: Constants.tutorial_spacing),
            
            tip5.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip5.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip5.topAnchor.constraint(equalTo: tip4.bottomAnchor, constant: Constants.tutorial_spacing),
            
            tip6.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip6.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip6.topAnchor.constraint(equalTo: tip5.bottomAnchor, constant: Constants.tutorial_spacing),
            
            tip7.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            tip7.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            tip7.topAnchor.constraint(equalTo: tip6.bottomAnchor, constant: Constants.tutorial_spacing),
            
            continueButton.topAnchor.constraint(equalTo: tip7.bottomAnchor, constant: Constants.tutorial_spacing + 10),
            continueButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.tutorial_side),
            continueButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.tutorial_side),
            continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.tutorial_top)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func dismissTutorial() {
        dismissTutorialDelegate?.dismissTutorial()
    }
}
