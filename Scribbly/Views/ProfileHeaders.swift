//
//  ProfileHeaders.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

import UIKit

class MonthHeaderView: UICollectionReusableView {
    // ------------ Fields (view) ------------
    private let month_lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.mems_date_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.tintColor = .label
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false

        let day_of_week = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
        for day in day_of_week {
            let lbl = UILabel()
            lbl.text = day
            lbl.font = Constants.mems_date_font
            lbl.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(lbl)
        }
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(month_lbl)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            month_lbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.mems_day_of_week_side),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.mems_day_of_week_side),
            stack.topAnchor.constraint(equalTo: month_lbl.bottomAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        month_lbl.text = text.lowercased()
    }
}

class ProfileHeaderView: UICollectionReusableView {
    // ------------ Fields (view) ------------    
    private let profile_img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.prof_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let fullname_lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.prof_fullname_font
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let username_lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.prof_username_font
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bio_lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.prof_bio_font
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let friends_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        var text = AttributedString("friends")
        text.font = Constants.prof_btn_font
        
        config.attributedTitle = text
        config.buttonSize = .large
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let edit_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        var text = AttributedString("edit")
        text.font = Constants.prof_btn_font
        
        config.attributedTitle = text
        config.buttonSize = .large
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let mems_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let bookmarks_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // ------------ Fields (data) ------------
    private var user: User? = nil
    private var mode: UIUserInterfaceStyle? = nil
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = Constants.prof_head_corner
        
        addSubview(profile_img)
        addSubview(fullname_lbl)
        addSubview(username_lbl)
        addSubview(bio_lbl)
        addSubview(friends_btn)
        addSubview(edit_btn)
        addSubview(bookmarks_btn)
        addSubview(mems_btn)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, mode: UIUserInterfaceStyle) {
        self.user = user
        self.mode = mode
        
        if (mode == .dark) {
            backgroundColor = Constants.primary_dark
            friends_btn.configuration?.baseBackgroundColor = Constants.prof_btn_color_dark
            edit_btn.configuration?.baseBackgroundColor = Constants.prof_btn_color_dark
            mems_btn.configuration?.image = UIImage(named: "mems_dark")
            bookmarks_btn.configuration?.image = UIImage(named: "bookmarks_dark")
            
        } else if (mode == .light) {
            backgroundColor = Constants.primary_light
            friends_btn.configuration?.baseBackgroundColor = Constants.prof_btn_color_light
            edit_btn.configuration?.baseBackgroundColor = Constants.prof_btn_color_light
            mems_btn.configuration?.image = UIImage(named: "mems_light")
            bookmarks_btn.configuration?.image = UIImage(named: "bookmarks_light")
        }
       
        profile_img.image = user.getPFP()
        fullname_lbl.text = user.getFullName().lowercased()
        username_lbl.text = "@" + user.getUserName().lowercased()
        bio_lbl.text = user.getBio().lowercased()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profile_img.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profile_img.widthAnchor.constraint(equalToConstant: Constants.prof_pfp_radius * 2),
            profile_img.heightAnchor.constraint(equalToConstant: Constants.prof_pfp_radius * 2),
            profile_img.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.prof_pfp_top),
            
            fullname_lbl.topAnchor.constraint(equalTo: profile_img.bottomAnchor, constant: Constants.prof_fullname_top),
            fullname_lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            username_lbl.topAnchor.constraint(equalTo: fullname_lbl.bottomAnchor, constant: Constants.prof_username_top),
            username_lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            bio_lbl.topAnchor.constraint(equalTo: username_lbl.bottomAnchor, constant: Constants.prof_bio_top),
            bio_lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            friends_btn.topAnchor.constraint(equalTo: bio_lbl.bottomAnchor, constant: Constants.prof_btn_top),
            friends_btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prof_btn_side),
            friends_btn.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
            
            edit_btn.topAnchor.constraint(equalTo: bio_lbl.bottomAnchor, constant: Constants.prof_btn_top),
            edit_btn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.prof_btn_side),
            edit_btn.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
            
            mems_btn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            mems_btn.leadingAnchor.constraint(equalTo: friends_btn.leadingAnchor),
            mems_btn.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
            
            bookmarks_btn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            bookmarks_btn.trailingAnchor.constraint(equalTo: edit_btn.trailingAnchor),
            bookmarks_btn.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width)
        ])
    }
}
