//
//  CommentCells.swift
//  Scribbly
//
//  Created by Vin Bui on 12/21/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: DrawingHeaderView
class DrawingHeaderView: UICollectionReusableView {
    // MARK: - Properties (view)
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.comment_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(enlargeImage))
        img.addGestureRecognizer(tap_gesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "DrawingHeaderViewReuse"
    weak var enlargeDrawingDelegate: EnlargeDrawingDelegate!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(drawing)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(drawing: UIImage) {
        self.drawing.image = drawing
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            drawing.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_drawing_top_padding),
            drawing.widthAnchor.constraint(equalToConstant: Constants.comment_drawing_width),
            drawing.heightAnchor.constraint(equalToConstant: Constants.comment_drawing_height),
        ])
    }
    
    // MARK: - Button Helpers
    @objc func enlargeImage() {
        if let drawing = drawing.image {
            enlargeDrawingDelegate.enlargeDrawing(drawing: drawing)
        }
    }
}

// MARK: CommentHeaderView
class CommentHeaderView: UICollectionReusableView, UIContextMenuInteractionDelegate {
    // MARK: - Properties (view)
    private let userPFP: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.comment_cell_pfp_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let displayName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 14, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let text: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 16, weight: .regular)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let replyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("reply", for: .normal)
        btn.setTitleColor(Constants.secondary_text, for: .normal)
        btn.titleLabel?.font = Constants.getFont(size: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "CommentHeaderViewReuse"
    private weak var parentVC: UIViewController!
    private var comment: Comment!
    private var mainUser: User!
    weak var commentDelegate: CommentDelegate!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(text)
        addSubview(displayName)
        addSubview(userPFP)
        addSubview(replyButton)
        
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(parentVC: UIViewController, comment: Comment, mainUser: User) {
        self.parentVC = parentVC
        self.comment = comment
        self.mainUser = mainUser
        
        self.text.text = comment.getText()
        displayName.text = comment.getUser().getUserName()
        userPFP.setImage(comment.getUser().getPFP(), for: .normal)
        userPFP.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(sendReply), for: .touchUpInside)
        
        if mainUser.isBlocked(user: comment.getUser()) {
            self.text.text = "This comment has been removed."
            displayName.text = ""
            userPFP.alpha = 0
            replyButton.alpha = 0
            self.isUserInteractionEnabled = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userPFP.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            userPFP.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.comment_cell_side),
            userPFP.widthAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
            userPFP.heightAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
                        
            displayName.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            displayName.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.comment_cell_name_side),

            text.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: Constants.comment_cell_text_top),
            text.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.comment_cell_name_side),
            text.widthAnchor.constraint(equalToConstant: Constants.comment_cell_text_width),
            
            replyButton.topAnchor.constraint(equalTo: text.bottomAnchor, constant: Constants.comment_cell_reply_top),
            replyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.comment_cell_reply_bot),
            replyButton.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.comment_cell_name_side),
        ])
    }
    
    // MARK: - Button Helpers
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { suggestedActions in
            
            let copyAction =
                UIAction(title: NSLocalizedString("Copy", comment: "")) { action in
                    UIPasteboard.general.string = self.comment?.getText()
                }
                
            if self.comment.getUser() === self.mainUser {
                let deleteAction =
                    UIAction(title: NSLocalizedString("Delete", comment: ""),
                             image: UIImage(systemName: "trash"),
                             attributes: .destructive) { action in
                        self.commentDelegate.deleteComment(comment: self.comment)
                    }
                return UIMenu(title: "", children: [copyAction, deleteAction])
            }
            return UIMenu(title: "", children: [copyAction])
        })
    }
    
    @objc private func sendReply() {
        commentDelegate.sendReplyComment(comment: comment)
    }
    
    @objc private func pushProfileVC() {
        if comment.getUser() !== mainUser {
            let profileVC = OtherUserProfileVC(user: comment.getUser(), mainUser: mainUser)
            parentVC.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: CommentCollectionViewCell
class CommentCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties (view)
    private let userPFP: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.comment_cell_pfp_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let displayName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 14, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let text: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let replyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("reply", for: .normal)
        btn.setTitleColor(Constants.secondary_text, for: .normal)
        btn.titleLabel?.font = Constants.getFont(size: 16, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "CommentCollectionViewCellReuse"
    private weak var parentVC: UIViewController!
    private var comment: Comment!
    private var reply: Reply!
    private var mainUser: User!
    weak var replyDelegate: CommentDelegate!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(text)
        addSubview(displayName)
        addSubview(userPFP)
        addSubview(replyButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(parentVC: UIViewController, comment: Comment, reply: Reply, mainUser: User) {
        self.parentVC = parentVC
        self.comment = comment
        self.reply = reply
        self.mainUser = mainUser
        
        self.text.attributedText = reply.getText()
        displayName.text = reply.getReplyUser().getUserName()
        userPFP.setImage(reply.getReplyUser().getPFP(), for: .normal)
        userPFP.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(sendReply), for: .touchUpInside)
        
        if mainUser.isBlocked(user: comment.getUser()) {
            self.text.attributedText = NSAttributedString(string: "This comment has been removed.")
            displayName.text = ""
            userPFP.alpha = 0
            replyButton.alpha = 0
            self.isUserInteractionEnabled = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userPFP.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            userPFP.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.comment_cell_side),
            userPFP.widthAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
            userPFP.heightAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
                        
            displayName.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            displayName.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.comment_cell_name_side),

            text.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: Constants.comment_cell_text_top),
            text.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.comment_cell_name_side),
            text.widthAnchor.constraint(equalToConstant: Constants.comment_cell_reply_text_width),
            
            replyButton.topAnchor.constraint(equalTo: text.bottomAnchor, constant: Constants.comment_cell_reply_top),
            replyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.comment_cell_reply_bot),
            replyButton.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.comment_cell_name_side),
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func sendReply() {
        replyDelegate?.sendReplyReply(comment: comment, reply: reply)
    }
    
    @objc private func pushProfileVC() {
        if reply.getReplyUser() !== mainUser {
            let profileVC = OtherUserProfileVC(user: reply.getReplyUser(), mainUser: mainUser)
            parentVC.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
