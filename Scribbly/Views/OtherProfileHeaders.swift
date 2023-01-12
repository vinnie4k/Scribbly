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
    private weak var parentVC: UIViewController!
    private var change = [NSLayoutConstraint]()
    weak var updateProfileDelegate: UpdateProfileDelegate!
    weak var updateRequestsDelegate: UpdateRequestsDelegate?
    
    private var isBlocked: Bool!
    private var isFollowed: Bool!
    private var isRequested: Bool!
    private var otherRequested: Bool!
    
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
            // mainUser has the other user blocked
            self.isFollowed = false
            self.isBlocked = true
            self.isRequested = false
            self.otherRequested = false
            configureBlocked()
        } else if mainUser.isFriendsWith(user: user) || user.isFriendsWith(user: mainUser) {
            // mainUser and the other user are friends
            self.isFollowed = true
            self.isBlocked = false
            self.isRequested = false
            self.otherRequested = false
            configureFollowing()
        } else if user.hasRequested(user: mainUser) {
            // mainUser sent a request to the other user
            self.isFollowed = false
            self.isBlocked = false
            self.isRequested = true
            self.otherRequested = false
            configureNotFollowing()
        } else if mainUser.hasRequested(user: user){
            // the other user sent a reqest to mainUser
            self.isFollowed = false
            self.isBlocked = false
            self.isRequested = false
            self.otherRequested = true
            configureNotFollowing()
        } else {
            // Not following and not requested
            self.isFollowed = false
            self.isBlocked = false
            self.isRequested = false
            self.otherRequested = false
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
        followButton.configuration?.baseBackgroundColor = Constants.button_dark
        followButton.configuration?.baseForegroundColor = .label
        followButton.configuration?.background.strokeWidth = 0
            
        if mode == .light {
            followButton.configuration?.baseBackgroundColor = Constants.button_light
        }
        
        // Not following but mainUser sent a request to the other user
        if isRequested {
            text = AttributedString("requested")
            followButton.configuration?.baseBackgroundColor = .systemBackground
            followButton.configuration?.background.strokeColor = Constants.secondary_text
            followButton.configuration?.background.strokeWidth = 0.5
            followButton.configuration?.baseForegroundColor = Constants.secondary_text
        } else if otherRequested {
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
        if isFollowed {
            // Already friends, have the option to unfollow
            let unfollow = UIAlertAction(title: "Unfollow", style: .destructive) { (action) in
                self.mainUser.removeFriend(user: self.user)
                self.user.removeFriend(user: self.mainUser)
                
                DispatchQueue.main.async {
                    self.isFollowed = false
                    self.isRequested = false
                    self.isBlocked = false
                    self.otherRequested = false
                    
                    self.configureNotFollowing()
                    self.updateProfileDelegate.updateProfile()
                    if self.updateRequestsDelegate != nil {
                        self.updateRequestsDelegate?.updateRequests()
                    }
                }
            }
            let alertController = UIAlertController(title: nil, message: "You won't be able to see their posts after you unfollow them.", preferredStyle: .actionSheet)
            alertController.addAction(unfollow)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            parentVC.present(alertController, animated: true)
        } else if isRequested {
            // mainUser sent a request to the other user, then cancel the request
            user.removeRequest(user: mainUser)
            
            DispatchQueue.main.async {
                self.isFollowed = false
                self.isRequested = false
                self.isBlocked = false
                self.otherRequested = false
                
                self.configureNotFollowing()
                self.updateProfileDelegate.updateProfile()
                if self.updateRequestsDelegate != nil {
                    self.updateRequestsDelegate?.updateRequests()
                }
            }
        } else if otherRequested {
            // the other user sent a request to mainUser, add them as a friend
            mainUser.removeRequest(user: user)
            mainUser.addFriend(friend: user)
            user.addFriend(friend: mainUser)
            
            DispatchQueue.main.async {
                self.isBlocked = false
                self.isRequested = false
                self.isFollowed = true
                self.otherRequested = false
                
                self.configureFollowing()
                self.updateProfileDelegate.updateProfile()
                if self.updateRequestsDelegate != nil {
                    self.updateRequestsDelegate?.updateRequests()
                }
            }
        } else {
            // send a request to the other user, currently says "follow"
            user.addRequest(user: mainUser)
            
            DispatchQueue.main.async {
                self.isBlocked = false
                self.isRequested = true
                self.otherRequested = false
                self.isFollowed = false
                
                self.configureNotFollowing()
                self.updateProfileDelegate.updateProfile()
                if self.updateRequestsDelegate != nil {
                    self.updateRequestsDelegate?.updateRequests()
                }
            }
        }
    }
    
    @objc private func blockAction() {
        if isBlocked {
            let unblock = UIAlertAction(title: "Unblock", style: .destructive) { (action) in
                self.mainUser.unblockUser(user: self.user)
                
                DispatchQueue.main.async {
                    self.addConstr(lst: [
                        self.blockButton.topAnchor.constraint(equalTo: self.bioLabel.bottomAnchor, constant: Constants.prof_btn_top),
                        self.blockButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.prof_btn_side),
                        self.blockButton.widthAnchor.constraint(equalToConstant: Constants.prof_btn_width),
                    ])
                    
                    self.isBlocked = false
                    self.followButton.isHidden = false
                    
                    self.configureNotFollowing()
                    self.updateProfileDelegate.updateProfile()
                    if self.updateRequestsDelegate != nil {
                        self.updateRequestsDelegate?.updateRequests()
                    }
                }
            }
            
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to do this?", preferredStyle: .actionSheet)
            alertController.addAction(unblock)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            parentVC.present(alertController, animated: true)
        } else if !isBlocked {
            let block = UIAlertAction(title: "Block", style: .destructive) { (action) in
                self.mainUser.blockUser(user: self.user)
                
                DispatchQueue.main.async {
                    self.isBlocked = true
                    
                    self.configureBlocked()
                    self.updateProfileDelegate.updateProfile()
                    if self.updateRequestsDelegate != nil {
                        self.updateRequestsDelegate?.updateRequests()
                    }
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
