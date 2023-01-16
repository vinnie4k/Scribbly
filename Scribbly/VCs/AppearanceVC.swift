//
//  AppearanceVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/15/23.
//

import UIKit

// MARK: - AppearanceVC
class AppearanceVC: UIViewController {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "appearance"
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
    
    private lazy var lightModeView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLight)))
        view.isUserInteractionEnabled = true
        
        let img = UIImageView(image: UIImage(named: "app_icon_light"))
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let text = UILabel()
        text.textAlignment = .center
        text.text = "light"
        text.textColor = .label
        text.font = Constants.getFont(size: 20, weight: .medium)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        view.addSubview(text)
        
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.topAnchor.constraint(equalTo: view.topAnchor),
            img.widthAnchor.constraint(equalToConstant: 100),
            img.heightAnchor.constraint(equalToConstant: 100),
            
            text.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10),
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var darkModeView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDark)))
        view.isUserInteractionEnabled = true

        let img = UIImageView(image: UIImage(named: "app_icon_dark"))
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let text = UILabel()
        text.textAlignment = .center
        text.text = "dark"
        text.textColor = .label
        text.font = Constants.getFont(size: 20, weight: .medium)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(img)
        view.addSubview(text)
        
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.topAnchor.constraint(equalTo: view.topAnchor),
            img.widthAnchor.constraint(equalToConstant: 100),
            img.heightAnchor.constraint(equalToConstant: 100),
            
            text.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10),
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lightButton: UIImageView = {
        let img = UIImageView()
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLight)))
        img.isUserInteractionEnabled = true
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var darkButton: UIImageView = {
        let img = UIImageView()
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDark)))
        img.isUserInteractionEnabled = true
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        stack.addArrangedSubview(lightModeView)
        stack.addArrangedSubview(darkModeView)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let systemLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "use system settings"
        lbl.font = Constants.getFont(size: 18, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var systemSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(selectSystem), for: .touchUpInside)
        sw.onTintColor = .systemBlue
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    // MARK: - Properties (data)
    private lazy var isDark: Bool = traitCollection.userInterfaceStyle == .dark
    weak var resetBackgroundDelegate: ResetBackgroundDelegate?
    
    // MARK: - viewDidLoad, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(stack)
        view.addSubview(lightButton)
        view.addSubview(darkButton)
        view.addSubview(systemLabel)
        view.addSubview(systemSwitch)
        
        configure()
        setupNavBar()
        setupConstraints()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraints() {
        let topPadding = CGFloat(50)
        let sidePadding = CGFloat(30)
        let btnRadius = CGFloat(15)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * sidePadding),
            stack.heightAnchor.constraint(equalToConstant: 150),
            
            lightButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 15),
            lightButton.centerXAnchor.constraint(equalTo: lightModeView.centerXAnchor),
            lightButton.widthAnchor.constraint(equalToConstant: 2 * btnRadius),
            lightButton.heightAnchor.constraint(equalToConstant: 2 * btnRadius),
            
            darkButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 15),
            darkButton.centerXAnchor.constraint(equalTo: darkModeView.centerXAnchor),
            darkButton.widthAnchor.constraint(equalToConstant: 2 * btnRadius),
            darkButton.heightAnchor.constraint(equalToConstant: 2 * btnRadius),
            
            systemLabel.topAnchor.constraint(equalTo: lightButton.bottomAnchor, constant: 60),
            systemLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding + 30),
            
            systemSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding - 30),
            systemSwitch.centerYAnchor.constraint(equalTo: systemLabel.centerYAnchor)
        ])
    }
    
    // MARK: - Helper Functions
    private func configure() {
        if UserDefaults.standard.value(forKey: "theme") as! String == Theme.system.rawValue {
            systemSwitch.isOn = true
            if traitCollection.userInterfaceStyle == .dark {
                lightButton.image = UIImage(systemName: "circle")
                lightButton.tintColor = Constants.secondary_text
                darkButton.image = UIImage(systemName: "checkmark.circle.fill")
                darkButton.tintColor = .gray
            } else {
                darkButton.image = UIImage(systemName: "circle")
                darkButton.tintColor = Constants.secondary_text
                lightButton.image = UIImage(systemName: "checkmark.circle.fill")
                lightButton.tintColor = .gray
            }
        } else {
            systemSwitch.isOn = false
            if traitCollection.userInterfaceStyle == .dark {
                lightButton.image = UIImage(systemName: "circle")
                lightButton.tintColor = Constants.secondary_text
                darkButton.image = UIImage(systemName: "checkmark.circle.fill")
                darkButton.tintColor = .systemBlue
            } else {
                darkButton.image = UIImage(systemName: "circle")
                darkButton.tintColor = Constants.secondary_text
                lightButton.image = UIImage(systemName: "checkmark.circle.fill")
                lightButton.tintColor = .systemBlue
            }
        }
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectLight() {
        if !systemSwitch.isOn {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            darkButton.image = UIImage(systemName: "circle")
            lightButton.image = UIImage(systemName: "checkmark.circle.fill")
            darkButton.tintColor = Constants.secondary_text
            lightButton.tintColor = .systemBlue
            UserDefaults.standard.setValue(Theme.light.rawValue, forKey: "theme")
            resetBackgroundDelegate?.resetBackground()
        }
    }
    
    @objc private func selectDark() {
        if !systemSwitch.isOn {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            lightButton.image = UIImage(systemName: "circle")
            darkButton.image = UIImage(systemName: "checkmark.circle.fill")
            lightButton.tintColor = Constants.secondary_text
            darkButton.tintColor = .systemBlue
            UserDefaults.standard.setValue(Theme.dark.rawValue, forKey: "theme")
            resetBackgroundDelegate?.resetBackground()
        }
    }
    
    @objc private func selectSystem() {
        if systemSwitch.isOn {
            UserDefaults.standard.setValue(Theme.system.rawValue, forKey: "theme")
            resetBackgroundDelegate?.resetBackground()
        } else {
            if traitCollection.userInterfaceStyle == .dark {
                UserDefaults.standard.setValue(Theme.dark.rawValue, forKey: "theme")
            } else {
                UserDefaults.standard.setValue(Theme.light.rawValue, forKey: "theme")
            }
            resetBackgroundDelegate?.resetBackground()
        }
        configure()
    }
}
