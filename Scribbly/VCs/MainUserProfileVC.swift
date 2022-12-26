//
//  MainUserProfileVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/19/22.
//

import UIKit

class MainUserProfileVC: UIViewController {
    // ------------ Fields (view) ------------
    private let title_lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "profile"
        lbl.textColor = .label
        lbl.font = Constants.comment_title_font
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
    
    private lazy var settings_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        if (traitCollection.userInterfaceStyle == .dark) {
            config.image = UIImage(named: "settings_dark")
        } else if (traitCollection.userInterfaceStyle == .light) {
            config.image = UIImage(named: "settings_light")
        }
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var scroll_view: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(prof_head_view)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let prof_head_view = ProfileHeaderView()
    
    // ------------ Fields (data) ------------
    var main_user: User? = nil
    
    // ------------ Functions ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "profile"
        
        if (traitCollection.userInterfaceStyle == .dark) {
            view.backgroundColor = Constants.secondary_dark
        } else if (traitCollection.userInterfaceStyle == .light) {
            view.backgroundColor = Constants.secondary_light
        }
        
        view.addSubview(scroll_view)
        
        setupProfileHeaderView()
        setupNavBar()
        setupConstraints()
    }
    
    private func setupProfileHeaderView() {
        prof_head_view.configure(user: main_user!, mode: traitCollection.userInterfaceStyle)
        prof_head_view.translatesAutoresizingMaskIntoConstraints = false
    }
        
    private func setupNavBar() {
        navigationItem.titleView = title_lbl
        back_btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_btn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settings_btn)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scroll_view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll_view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll_view.topAnchor.constraint(equalTo: view.topAnchor),
            scroll_view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            prof_head_view.centerXAnchor.constraint(equalTo: scroll_view.centerXAnchor),
            prof_head_view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            prof_head_view.heightAnchor.constraint(equalToConstant: Constants.prof_head_height),
            prof_head_view.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }

}
