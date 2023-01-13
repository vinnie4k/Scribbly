//
//  ProfileHeaders.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

// TODO: ALREADY REFACTORED

import UIKit
import RESegmentedControl

// MARK: MemsBookHeaderView
class MemsBookHeaderView: UICollectionReusableView {
    // MARK: - Properties (view)
    private lazy var segmentedControl: RESegmentedControl = {
        let control = RESegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.mems_book_height))
        
        var style = SegmentItemStyle(textColor: UIColor.white, tintColor: UIColor.white, selectedTextColor: UIColor.white, selectedTintColor: UIColor.white, backgroundColor: Constants.primary_dark, borderWidth: 0, borderColor: nil, font: UIFont.systemFont(ofSize: 10), selectedFont: UIFont.systemFont(ofSize: 10), imageHeight: Constants.mems_book_height - 23, imageRenderMode: .alwaysOriginal, spacing: 0, cornerRadius: 0, shadow: nil, separator: nil, axis: .horizontal)
        
        var selectedStyle = SegmentSelectedItemStyle(backgroundColor: UIColor.white, cornerRadius: 0, borderWidth: 0, borderColor: nil, size: .height(2.0, position: .bottom), offset: 0, shadow: nil)
    
        var segmentItems = [SegmentModel(imageName: "mems_dark"), SegmentModel(imageName: "bookmarks_dark")]
        
        var preset = MaterialPreset(backgroundColor: Constants.primary_dark, tintColor: UIColor.white)
        
        preset.segmentItemStyle = style
        preset.segmentSelectedItemStyle = selectedStyle
        
        control.configure(segmentItems: segmentItems, preset: preset)
        
        control.addTarget(self, action: #selector(changeView), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    // MARK: - Properties (data)
    private var mode: UIUserInterfaceStyle?
    weak var switchViewDelegate: SwitchViewDelegate?
    
    static let reuseIdentifier = "MemsBookHeaderViewReuseMems"
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(segmentedControl)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mode: UIUserInterfaceStyle, start: Int) {
        self.mode = mode
        if mode == .light {
            configureLightMode()
        }
        segmentedControl.selectedSegmentIndex = start
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc func changeView() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            switchViewDelegate?.switchView(pos: 0)
        case 1:
            switchViewDelegate?.switchView(pos: 1)
        default:
            switchViewDelegate?.switchView(pos: 0)
        }
    }
    
    // MARK: - Helper Functions
    private func configureLightMode() {
        let style = SegmentItemStyle(textColor: UIColor.black, tintColor: UIColor.black, selectedTextColor: UIColor.black, selectedTintColor: UIColor.black, backgroundColor: Constants.primary_light, borderWidth: 0, borderColor: nil, font: UIFont.systemFont(ofSize: 10), selectedFont: UIFont.systemFont(ofSize: 10), imageHeight: Constants.mems_book_height - 23, imageRenderMode: .alwaysOriginal, spacing: 0, cornerRadius: 0, shadow: nil, separator: nil, axis: .horizontal)
            
        let selectedStyle = SegmentSelectedItemStyle(backgroundColor: UIColor.black, cornerRadius: 0, borderWidth: 0, borderColor: nil, size: .height(2.0, position: .bottom), offset: 0, shadow: nil)
            
        let segmentItems = [SegmentModel(imageName: "mems_light"), SegmentModel(imageName: "bookmarks_light")]
            
        var preset = MaterialPreset(backgroundColor: Constants.primary_light, tintColor: UIColor.black)
        
        preset.segmentItemStyle = style
        preset.segmentSelectedItemStyle = selectedStyle
        
        segmentedControl.configure(segmentItems: segmentItems, preset: preset)
    }
}

// MARK: ProfileHeaderCell
class ProfileHeaderCell: UICollectionViewCell {
    // MARK: - Properties (view)
    private let profileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.prof_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let fullnameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 24, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 14, weight: .regular)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var friendsButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushFriendsVC), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        var text = AttributedString("friends")
        text.font = Constants.getFont(size: 14, weight: .medium)
        
        config.attributedTitle = text
        config.buttonSize = .large
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var editButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushEditProfileVC), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        var text = AttributedString("edit")
        text.font = Constants.getFont(size: 14, weight: .medium)
        
        config.attributedTitle = text
        config.buttonSize = .large
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    private var user: User!
    private var mode: UIUserInterfaceStyle!
    private weak var parentVC: UIViewController!
    weak var updatePFPDelegate: UpdatePFPDelegate!
    weak var updateFeedDelegate: UpdateFeedDelegate!
    
    static let reuseIdentifier = "ProfileHeaderViewReuse"
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(profileImage)
        addSubview(fullnameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(friendsButton)
        addSubview(editButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, mode: UIUserInterfaceStyle, parentVC: UIViewController) {
        self.user = user
        self.mode = mode
        self.parentVC = parentVC
        
        backgroundColor = Constants.primary_dark
        friendsButton.configuration?.baseBackgroundColor = Constants.button_dark
        editButton.configuration?.baseBackgroundColor = Constants.button_dark
            
        if mode == .light {
            backgroundColor = Constants.primary_light
            friendsButton.configuration?.baseBackgroundColor = Constants.button_light
            editButton.configuration?.baseBackgroundColor = Constants.button_light
        }
       
        profileImage.image = ImageMap.map[user.pfp]
        fullnameLabel.text = user.getFullName()
        usernameLabel.text = "@" + user.getUserName()
        bioLabel.text = user.bio
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: Constants.prof_pfp_radius * 2),
            profileImage.heightAnchor.constraint(equalToConstant: Constants.prof_pfp_radius * 2),
            profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.prof_pfp_top),
            
            fullnameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: Constants.prof_fullname_top),
            fullnameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: Constants.prof_username_top),
            usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: Constants.prof_bio_top),
            bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            friendsButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
            friendsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prof_btn_side),
            friendsButton.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
            
            editButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.prof_btn_side),
            editButton.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
        ])
    }
    
    // MARK: - Button Helpers
    @objc func pushFriendsVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let friendsVC = FriendsVC(user: user)
        friendsVC.updateFeedDelegate = updateFeedDelegate
        parentVC.navigationController?.pushViewController(friendsVC, animated: true)
    }
    
    @objc func pushEditProfileVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let editProfileVC = EditProfileVC(mainUser: self.user)
        editProfileVC.updatePFPDelegate = updatePFPDelegate
        editProfileVC.updateProfileDelegate = self
        parentVC.navigationController?.pushViewController(editProfileVC, animated: true)
    }
}

// MARK: - Extensions for delegation
extension ProfileHeaderCell: UpdateProfileDelegate {
    func updateProfile() {
        profileImage.image = user.getPFP()
        fullnameLabel.text = user.getFullName()
        bioLabel.text = user.getBio()
        usernameLabel.text = user.getUserName()
    }
}
