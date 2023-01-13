//
//  AddFriendsTableViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 1/3/23.
//

import UIKit

// MARK: AddFriendsTableViewCell
class AddFriendsTableViewCell: UITableViewCell {
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
        btn.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
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
    static let reuseIdentifier = "AddFriendsTableViewCellReuse"
    private var mainUser: User!
    private weak var user: User!
    weak var updateRequestsDelegate: UpdateRequestsDelegate!
    
    // MARK: - init, configure, and setupConstraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        if user.hasRequested(user: mainUser) {
            text = AttributedString("requested")
        } else if mainUser.hasRequested(user: user) {
            text = AttributedString("accept")
        } else {
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
    @objc func sendRequest() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if user.hasRequested(user: mainUser) {
            // Currently says "requested"
            // mainUser has already sent a request. Change to follow and remove the request.
            user.removeRequest(user: mainUser)
            followButton.configuration?.title = "follow"
            updateRequestsDelegate.updateRequests()
        } else if mainUser.hasRequested(user: user) {
            // Curently says "accept"
            // The other user has sent a request to mainUser. Change to accepted and remove the request.
            mainUser.removeRequest(user: user)
            mainUser.addFriend(friend: user)
            user.addFriend(friend: mainUser)
            
            DispatchQueue.main.async {
                self.followButton.configuration?.title = "accepted"
                self.followButton.isUserInteractionEnabled = false
                self.updateRequestsDelegate.updateRequests()
            }
        } else {
            // Currently says "follow"
            // Send a request from mainUser to the other user
            user.addRequest(user: mainUser)
            DispatchQueue.main.async {
                self.followButton.configuration?.title = "requested"
                self.updateRequestsDelegate.updateRequests()
            }
        }

    }
}
