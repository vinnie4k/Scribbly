//
//  BlockedTableViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 1/12/23.
//

import UIKit

// MARK: BlockedTableViewCell
class BlockedTableViewCell: UITableViewCell {
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
    
    private lazy var unblockButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(blockAction), for: .touchUpInside)
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
    static let reuseIdentifier = "BlockedTableViewCellReuse"
    private var mainUser: User!
    private var isBlocked: Bool!
    private weak var user: User!
    private weak var parentVC: UIViewController!
    
    // MARK: - init, configure, and setupConstraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImage)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(unblockButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, mainUser: User, parentVC: UIViewController) {
        self.user = user
        self.mainUser = mainUser
        self.parentVC = parentVC
        
        var text: AttributedString
        
        if mainUser.isBlocked(user: user) {
            self.isBlocked = true
            text = AttributedString("unblock")
        } else {
            self.isBlocked = false
            text = AttributedString("block")
        }
        
        text.font = Constants.getFont(size: 16, weight: .medium)
        unblockButton.configuration?.attributedTitle = text
        
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
            
            unblockButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unblockButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            unblockButton.widthAnchor.constraint(equalToConstant: Constants.friends_follow_btn_width)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func blockAction() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if isBlocked {
            let unblock = UIAlertAction(title: "Unblock", style: .destructive) { (action) in
                self.mainUser.unblockUser(user: self.user)
                
                DispatchQueue.main.async {
                    self.isBlocked = false
                    self.unblockButton.configuration?.title = "block"
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
                    self.unblockButton.configuration?.title = "unblock"
                }
            }
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to do this?", preferredStyle: .actionSheet)
            alertController.addAction(block)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            parentVC.present(alertController, animated: true)
        }
    }
}
