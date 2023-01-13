//
//  TimerVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/3/23.
//

import UIKit

// MARK: TimerVC
class TimerVC: UIViewController {
    // MARK: - Properties (view)
    private let logo: UIImageView = {
        let img = UIImageView(image: UIImage(named: "scribbly_title"))
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var questionButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.image = UIImage(systemName: "questionmark.circle")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var profileButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushSettingsVC), for: .touchUpInside)
        btn.setImage(mainUser.getPFP(), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.profile_button_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let promptHeading: UILabel = {
        let lbl = UILabel()
        lbl.text = "today's prompt"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let prompt: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 40, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.landing_button_corner
        config.baseBackgroundColor = Constants.primary_dark
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var finishButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        
        var text = AttributedString("finish")
        text.font = Constants.getFont(size: 16, weight: .bold)
        config.attributedTitle = text
        
        config.baseBackgroundColor = Constants.button_dark
        config.buttonSize = .large
        config.background.cornerRadius = Constants.landing_button_corner
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.addArrangedSubview(startButton)
        stack.addArrangedSubview(finishButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "10:00"
        lbl.font = Constants.getFont(size: 96, weight: .semibold)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var drawViewLarge: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = view.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customBlurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private var timer = Timer()
    
    // MARK: - Properties (data)
    private var mainUser: User
    
    private var hasStart: Bool = false
    private var isPaused: Bool = false
    private var isFinished: Bool = false
    
    private var seconds = 600   // 10 minutes
    private var initialPopup: Bool
    
    weak var updateFeedDelegate: UpdateFeedDelegate?
    
    // MARK: - viewDidLoad, init, configure, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.secondary_dark
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = Constants.secondary_light
        }
        
        view.addSubview(promptHeading)
        view.addSubview(prompt)
        view.addSubview(stack)
        view.addSubview(timerLabel)
        view.addSubview(drawViewLarge)
        
        configure()
        setupNavBar()
        setupConstraints()
        
        if initialPopup {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tutorialView()
            }
        }
    }
    
    init(mainUser: User, prompt: String, initialPopup: Bool) {
        self.mainUser = mainUser
        self.prompt.text = prompt
        self.initialPopup = initialPopup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        if isFinished {
            startButton.removeFromSuperview()
            var text = AttributedString("post")
            text.font = Constants.getFont(size: 16, weight: .bold)
            finishButton.configuration?.attributedTitle = text
        }
        else if !hasStart {
            var text = AttributedString("start")
            text.font = Constants.getFont(size: 16, weight: .bold)
            startButton.configuration?.attributedTitle = text
        } else if hasStart && !isPaused {
            var text = AttributedString("pause")
            text.font = Constants.getFont(size: 16, weight: .bold)
            startButton.configuration?.attributedTitle = text
        } else if hasStart && isPaused {
            var text = AttributedString("unpause")
            text.font = Constants.getFont(size: 16, weight: .bold)
            startButton.configuration?.attributedTitle = text
        }
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.titleView = logo
        navigationItem.setHidesBackButton(true, animated: false)
        questionButton.addTarget(self, action: #selector(tutorialView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: questionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            profileButton.heightAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            
            promptHeading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptHeading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.timer_prompt_top),
            
            prompt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            prompt.topAnchor.constraint(equalTo: promptHeading.bottomAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25),
            
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.timer_btn_bot),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.timer_btn_side),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.timer_btn_side),
            
            drawViewLarge.topAnchor.constraint(equalTo: view.topAnchor),
            drawViewLarge.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawViewLarge.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawViewLarge.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func tutorialView() {
        let view = TutorialView()
        view.dismissTutorialDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        drawViewLarge.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: drawViewLarge.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.tutorial_side),
            view.centerXAnchor.constraint(equalTo: drawViewLarge.centerXAnchor),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 1.0
        }, completion: nil)
    }
    
    @objc private func pushSettingsVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let settingsVC = SettingsVC(mainUser: mainUser)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func popVC() {
        dismiss(animated: true)
    }
    
    @objc private func startTimer() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if !hasStart {
            hasStart = true
            runTimer()
        } else if hasStart && !isPaused {
            isPaused = true
            timer.invalidate()
        } else {
            isPaused = false
            runTimer()
        }
        configure()
    }
    
    @objc private func updateTimer() {
        seconds -= 1
        if seconds == 0 {
            timer.invalidate()
            isFinished = true
            configure()
        }
        updateTimeString()
    }
    
    @objc private func stopTimer() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        isFinished = true
        let uploadVC = UploadPostVC(mainUser: mainUser)
        uploadVC.dismissTimerDelegate = self
        navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    // MARK: - Helper Functions
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimeString() {
        let mins = Int(seconds / 60)
        let secs = seconds - (mins * 60)

        var minsString = String(mins)
        var secsString = String(secs)
        
        if minsString.count == 1 {
            minsString = "0" + minsString
        }
        
        if secsString.count == 1 {
            secsString = "0" + secsString
        }
        
        timerLabel.text = minsString + ":" + secsString
    }
}

// MARK: - Extensions for delegation
extension TimerVC: DismissTimerDelegate, DismissTutorialDelegate {
    func dismissTimerVC() {
        navigationController?.popViewController(animated: true)
        updateFeedDelegate?.updateFeed()
    }
    
    func dismissTutorial() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 0.0
        }, completion: nil)
        drawViewLarge.subviews[1].removeFromSuperview()
    }
}
