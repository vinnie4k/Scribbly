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
    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "scribbly"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 24, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var profileButton: UIButton = {
        let btn = UIButton()
//        btn.addTarget(self, action: #selector(pushMainUserProfileVC), for: .touchUpInside)
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
        lbl.text = "bird"
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
        lbl.text = "00:10"
        lbl.font = Constants.getFont(size: 96, weight: .semibold)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var timer = Timer()
    
    // MARK: - Properties (data)
    private var mainUser: User
    
    private var hasStart: Bool = false
    private var isPaused: Bool = false
    private var isFinished: Bool = false
    
    private var seconds = 10   // 10 minutes
    
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
        
        configure()
        setupNavBar()
        setupConstraints()
    }
    
    init(mainUser: User) {
        self.mainUser = mainUser
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
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.timer_btn_side)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        dismiss(animated: true)
    }
    
    @objc private func startTimer() {
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
extension TimerVC: DismissTimerDelegate {
    func dismissTimerVC() {
        navigationController?.popViewController(animated: true)
    }
}
