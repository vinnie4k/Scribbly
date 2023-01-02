//
//  FriendsTableViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 1/1/23.
//

import UIKit

// MARK: FriendsTableViewCell
class FriendsTableViewCell: UITableViewCell {
    // MARK: - Properties (view)
    private let profileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.friends_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let fullNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.textColor = Constants.secondary_text
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var followButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(changeFollow), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .mini
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Constants.primary_dark
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "FriendsTableViewCellReuse"
    private var user: User!
    private var isFollowed: Bool!
    private var isRequested: Bool!
    private var mainUser: User!
    
    // MARK: - init, configure, and setupConstraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(profileImage)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(followButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, mainUser: User) {
        self.user = user
        self.mainUser = mainUser
        
        var text: AttributedString

        if mainUser.isFriendsWith(user: user) {
            self.isFollowed = true
            self.isRequested = false
            text = AttributedString("unfollow")
        } else if mainUser.hasRequested(user: user) {
            self.isFollowed = false
            self.isRequested = true
            text = AttributedString("requested")
        } else {
            self.isFollowed = false
            self.isRequested = false
            text = AttributedString("follow")
        }
        
        text.font = Constants.getFont(size: 16, weight: .medium)
        followButton.configuration?.attributedTitle = text
        
        profileImage.image = user.getPFP()
        fullNameLabel.text = user.getFullName()
        userNameLabel.text = "@" + user.getUserName()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: Constants.friends_pfp_radius * 2),
            profileImage.heightAnchor.constraint(equalToConstant: Constants.friends_pfp_radius * 2),
            
            fullNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: Constants.friends_fullname_left),
            fullNameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            
            userNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            followButton.widthAnchor.constraint(equalToConstant: Constants.friends_follow_btn_width)
        ])
    }
    
    // MARK: - Button Helpers
    @objc func changeFollow() {
        if isFollowed {
            // Tapped on unfollow
            mainUser.removeFriend(user: user)
            followButton.configuration?.title = "follow"
            isFollowed = false
        } else if isRequested {
            mainUser.unsendRequest(user: user)
            followButton.configuration?.title = "follow"
            isRequested = false
        } else {
            // Tapped on follow
            mainUser.sendRequest(user: user)
            followButton.configuration?.title = "requested"
            isRequested = true
        }
    }
}

// MARK: FollowRequestViewCell
class FollowRequestViewCell: UITableViewCell {
    // MARK: - Properties (view)
    private let leftProfileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.friends_request_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let rightProfileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.friends_request_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let followRequestsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "follow requests"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let requestNamesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.secondary_text
        lbl.font = Constants.getFont(size: 16, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let rightArrowImage: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "chevron.right"))
        img.tintColor = .label
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "FollowRequestViewCellReuse"
    
    // MARK: - init, configure, and setupConstraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(rightProfileImage)
        contentView.addSubview(leftProfileImage)
        contentView.addSubview(followRequestsLabel)
        contentView.addSubview(requestNamesLabel)
        contentView.addSubview(rightArrowImage)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(requests: [User], mode: UIUserInterfaceStyle) {        
        leftProfileImage.backgroundColor = Constants.button_dark
        rightProfileImage.backgroundColor = Constants.primary_dark
        
        if mode == .light {
            leftProfileImage.backgroundColor = Constants.secondary_light
            rightProfileImage.backgroundColor = Constants.secondary_text
        }
        
        if requests.count > 2 {
            leftProfileImage.image = requests[0].getPFP()
            rightProfileImage.image = requests[1].getPFP()
            requestNamesLabel.text = "@" + requests[0].getUserName() + " + " + String(requests.count - 1) + " others"
        } else if requests.count == 2 {
            leftProfileImage.image = requests[0].getPFP()
            rightProfileImage.image = requests[1].getPFP()
            requestNamesLabel.text = "@" + requests[0].getUserName() + " + 1 other"
        } else if requests.count == 1 {
            leftProfileImage.image = requests[0].getPFP()
            requestNamesLabel.text = "@" + requests[0].getUserName() + " + 0 others"
        } else {
            requestNamesLabel.text = "no follow requests"
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leftProfileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftProfileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftProfileImage.widthAnchor.constraint(equalToConstant: Constants.friends_request_pfp_radius * 2),
            leftProfileImage.heightAnchor.constraint(equalToConstant: Constants.friends_request_pfp_radius * 2),
            
            rightProfileImage.leadingAnchor.constraint(equalTo: leftProfileImage.centerXAnchor, constant: 2),
            rightProfileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightProfileImage.widthAnchor.constraint(equalToConstant: Constants.friends_request_pfp_radius * 2),
            rightProfileImage.heightAnchor.constraint(equalToConstant: Constants.friends_request_pfp_radius * 2),
            
            followRequestsLabel.leadingAnchor.constraint(equalTo: rightProfileImage.trailingAnchor, constant: Constants.friends_fullname_left),
            followRequestsLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            
            requestNamesLabel.topAnchor.constraint(equalTo: followRequestsLabel.bottomAnchor),
            requestNamesLabel.leadingAnchor.constraint(equalTo: followRequestsLabel.leadingAnchor),
            
            rightArrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightArrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Other
    override func prepareForReuse() {
        super.prepareForReuse()
        leftProfileImage.image = .none
        rightProfileImage.image = .none
    }
}
