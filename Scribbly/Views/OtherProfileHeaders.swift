//
//  OtherProfileHeaders.swift
//  Scribbly
//
//  Created by Vin Bui on 1/2/23.
//

import UIKit

// MARK: OtherProfileHeaderCell
class OtherProfileHeaderCell: UICollectionViewCell {
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
    
    private lazy var followButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var blockButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(blockAction), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    private var user: User!
    private var mainUser: User!
    private var mode: UIUserInterfaceStyle!
    private var parentVC: UIViewController!
    private var change = [NSLayoutConstraint]()
    var updateProfileDelegate: UpdateProfileDelegate!
    var updateRequestsDelegate: UpdateRequestsDelegate?
    
    static let reuseIdentifier = "OtherProfileHeaderCellReuse"
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImage)
        addSubview(fullnameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(followButton)
        addSubview(blockButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, mainUser: User, mode: UIUserInterfaceStyle, parentVC: UIViewController) {
        self.user = user
        self.mainUser = mainUser
        self.mode = mode
        self.parentVC = parentVC
        
        backgroundColor = Constants.primary_dark
        followButton.configuration?.baseBackgroundColor = Constants.button_dark
        blockButton.configuration?.baseBackgroundColor = Constants.button_dark
            
        if mode == .light {
            backgroundColor = Constants.primary_light
            followButton.configuration?.baseBackgroundColor = Constants.button_light
            blockButton.configuration?.baseBackgroundColor = Constants.button_light
        }
       
        profileImage.image = user.getPFP()
        fullnameLabel.text = user.getFullName().lowercased()
        usernameLabel.text = "@" + user.getUserName().lowercased()
        bioLabel.text = user.getBio().lowercased()
        
        if mainUser.isBlocked(user: user) {
            configureBlocked()
        } else if mainUser.isFriendsWith(user: user) {
            configureFollowing()
        } else if !mainUser.isFriendsWith(user: user) {
            configureNotFollowing()
        }
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
            
            followButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
            followButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prof_btn_side),
            followButton.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width)
        ])
        
        addConstr(lst: [
            blockButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
            blockButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.prof_btn_side),
            blockButton.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
        ])
    }
    
    // MARK: - Helper Functions
    private func configureNotFollowing() {
        var text = AttributedString("follow")
        followButton.configuration?.baseForegroundColor = .label
        followButton.configuration?.background.strokeWidth = 0

        // Not following but requested
        if mainUser.hasRequested(user: user) {
            text = AttributedString("requested")
            followButton.configuration?.baseBackgroundColor = .systemBackground
            followButton.configuration?.background.strokeColor = Constants.secondary_text
            followButton.configuration?.background.strokeWidth = 0.5
            followButton.configuration?.baseForegroundColor = Constants.secondary_text
        } else if user.hasRequested(user: mainUser) {
            // Other person requested
            text = AttributedString("accept")
        }
        
        text.font = Constants.getFont(size: 14, weight: .medium)
        followButton.configuration?.attributedTitle = text
        
        text = AttributedString("block")
        text.font = Constants.getFont(size: 14, weight: .medium)
        blockButton.configuration?.attributedTitle = text
    }
    
    private func configureFollowing() {
        var text = AttributedString("unfollow")
        text.font = Constants.getFont(size: 14, weight: .medium)
        followButton.configuration?.attributedTitle = text
        
        followButton.configuration?.baseBackgroundColor = .systemBackground
        followButton.configuration?.background.strokeColor = Constants.secondary_text
        followButton.configuration?.background.strokeWidth = 0.5
        followButton.configuration?.baseForegroundColor = Constants.secondary_text
        
        text = AttributedString("block")
        text.font = Constants.getFont(size: 14, weight: .medium)
        blockButton.configuration?.attributedTitle = text
    }
    
    private func configureBlocked() {
        profileImage.image = nil
        profileImage.backgroundColor = Constants.button_dark
        followButton.isHidden = true

        var text = AttributedString("unblock")
        text.font = Constants.getFont(size: 14, weight: .medium)
        blockButton.configuration?.attributedTitle = text
        
        addConstr(lst: [
            blockButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
            blockButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            blockButton.widthAnchor.constraint(equalToConstant: 2 * Constants.prof_btn_width),
        ])
        
        if mode == .light {
            profileImage.backgroundColor = Constants.button_light
        }
    }
    
    private func addConstr(lst: [NSLayoutConstraint]) {
        // Deactivates all the old constraints in the list
        // Activate the new constraints and add to the list
        for constr in change {
            constr.isActive = false
        }
        for i in lst {
            i.isActive = true
            change.append(i)
        }
    }
    
    // MARK: - Button Helpers
    @objc private func followAction() {
        if mainUser.isFriendsWith(user: user) {
            let unfollow = UIAlertAction(title: "Unfollow", style: .destructive) { (action) in
                self.mainUser.removeFriend(user: self.user)
                self.configure(user: self.user, mainUser: self.mainUser, mode: self.mode, parentVC: self.parentVC)
                self.updateProfileDelegate.updateProfile()
                if self.updateRequestsDelegate != nil {
                    self.updateRequestsDelegate?.updateRequests()
                }
            }
            let alertController = UIAlertController(title: nil, message: "You won't be able to see their posts after you unfollow them.", preferredStyle: .actionSheet)
            alertController.addAction(unfollow)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            parentVC.present(alertController, animated: true)
        } else if mainUser.hasRequested(user: user) {
            mainUser.unsendRequest(user: user)
        } else if user.hasRequested(user: mainUser) {
            mainUser.acceptRequest(user: user)
        } else {
            mainUser.sendRequest(user: user)
        }
        configure(user: user, mainUser: mainUser, mode: mode, parentVC: parentVC)
        updateProfileDelegate.updateProfile()
        if updateRequestsDelegate != nil {
            updateRequestsDelegate?.updateRequests()
        }
    }
    
    @objc private func blockAction() {
        if mainUser.isBlocked(user: user) {
            let unblock = UIAlertAction(title: "Unblock", style: .destructive) { (action) in
                self.mainUser.unblockUser(user: self.user)
                self.addConstr(lst: [
                    self.blockButton.topAnchor.constraint(equalTo: self.bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
                    self.blockButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.prof_btn_side),
                    self.blockButton.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
                ])
                self.followButton.isHidden = false
                self.configure(user: self.user, mainUser: self.mainUser, mode: self.mode, parentVC: self.parentVC)
                self.updateProfileDelegate.updateProfile()
                if self.updateRequestsDelegate != nil {
                    self.updateRequestsDelegate?.updateRequests()
                }
            }
            
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to do this?", preferredStyle: .actionSheet)
            alertController.addAction(unblock)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            parentVC.present(alertController, animated: true)
        } else if !mainUser.isBlocked(user: user) {
            let block = UIAlertAction(title: "Block", style: .destructive) { (action) in
                self.mainUser.blockUser(user: self.user)
                self.configure(user: self.user, mainUser: self.mainUser, mode: self.mode, parentVC: self.parentVC)
                self.updateProfileDelegate.updateProfile()
                if self.updateRequestsDelegate != nil {
                    self.updateRequestsDelegate?.updateRequests()
                }
            }
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to do this?", preferredStyle: .actionSheet)
            alertController.addAction(block)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            parentVC.present(alertController, animated: true)
        }
    }
}

// MARK: OtherBookmarksHeaderView
class OtherBookmarksHeaderView: UICollectionReusableView {
    // MARK: - Properties (view)
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "your saved posts from this user"
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "OtherBookmarksHeaderViewReuse"
    
    // MARK: - init, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
