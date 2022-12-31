//
//  BooksInfoView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/30/22.
//

// TODO: ALREADY REFRACTORED

import UIKit

// MARK: BooksInfoView
class BooksInfoView: UIView {
    // MARK: - Properties (view)
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false

        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(toggleCaption))
        img.addGestureRecognizer(tap_gesture)
        img.isUserInteractionEnabled = true

        return img
    }()
    
    private lazy var captionView: BooksCaptionView = {
        let caption = BooksCaptionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushCommentVC))
        caption.addGestureRecognizer(tapGesture)
        caption.isUserInteractionEnabled = true
        
        caption.translatesAutoresizingMaskIntoConstraints = false
        return caption
    }()
    
    private let booksButtonView: BooksButtonView = {
        let btns = BooksButtonView()
        btns.translatesAutoresizingMaskIntoConstraints = false
        return btns
    }()
    
    // MARK: - Properties (data)
    private var post: Post!
    private var mode: UIUserInterfaceStyle!
    private var parentVC: UIViewController!
    private var mainUser: User!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(drawing)
        addSubview(captionView)
        addSubview(booksButtonView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle, parentVC: UIViewController, mainUser: User) {
        self.post = post
        self.mode = mode
        self.parentVC = parentVC
        self.mainUser = mainUser
        
        drawing.image = post.getDrawing()
        captionView.configure(post: post, mode: mode)
        booksButtonView.configure(post: post, mode: mode, parentVC: parentVC, mainUser: mainUser)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            drawing.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            drawing.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            captionView.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_info_stats_padding),
            captionView.trailingAnchor.constraint(equalTo: drawing.trailingAnchor, constant: -Constants.post_info_stats_padding),
            captionView.heightAnchor.constraint(equalToConstant: Constants.post_info_stats_height / 2),
            captionView.bottomAnchor.constraint(equalTo: drawing.bottomAnchor, constant: -Constants.post_info_stats_padding),
            
            booksButtonView.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_info_redo_top),
            booksButtonView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc func toggleCaption() {
        if (self.captionView.alpha == 1.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.captionView.alpha = 0.0
            }, completion: nil)
        } else if (self.captionView.alpha == 0.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.captionView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    @objc private func pushCommentVC() {
        let commentVC = CommentVC(post: post, main_user: mainUser)
        parentVC.navigationController?.pushViewController(commentVC, animated: true)
    }

}

// MARK: BooksCaptionView
class BooksCaptionView: UIView {
    // MARK: - Properties (view)
    private let userPFP: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.post_cell_pfp_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let displayName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.post_cell_username_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let caption: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.post_cell_caption_font
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Properties (data)
    private var post: Post!
    private var mode: UIUserInterfaceStyle!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = Constants.post_info_view_corner
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.3)
        customBlurEffectView.frame = self.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.layer.cornerRadius = Constants.post_info_view_corner
        customBlurEffectView.clipsToBounds = true
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userPFP)
        addSubview(displayName)
        addSubview(caption)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle) {
        self.post = post
        self.mode = mode
        
        userPFP.setImage(post.getUser().getPFP(), for: .normal)
        displayName.text = post.getUser().getUserName()
        caption.text = post.getCaption()

        if (mode == .dark) {
            backgroundColor = Constants.post_cell_cap_view_dark
        } else if (mode == .light) {
            backgroundColor = Constants.post_cell_cap_view_light
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userPFP.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.post_info_pfp_top),
            userPFP.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.post_info_pfp_side),
            userPFP.widthAnchor.constraint(equalToConstant: 2 * Constants.post_info_pfp_radius),
            userPFP.heightAnchor.constraint(equalToConstant: 2 * Constants.post_info_pfp_radius),
            
            displayName.topAnchor.constraint(equalTo: userPFP.topAnchor),
            displayName.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.post_info_name_left),
            
            caption.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: Constants.post_info_caption_top),
            caption.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.post_info_name_left)
        ])
    }
}

// MARK: BooksButtonView
class BooksButtonView: UIStackView {
    // MARK: - Properties (view)
    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(likePost), for: .touchUpInside)
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var commentButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushCommentVC), for: .touchUpInside)
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(bookmarkPost), for: .touchUpInside)
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    private var post: Post!
    private var mode: UIUserInterfaceStyle!
    private var parentVC: UIViewController!
    private var mainUser: User!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fillEqually
        spacing = Constants.post_info_redo_spacing
        
        layer.cornerRadius = Constants.post_info_redo_corner
        layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        isLayoutMarginsRelativeArrangement = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.5)
        customBlurEffectView.frame = self.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.layer.cornerRadius = Constants.post_info_redo_corner
        customBlurEffectView.clipsToBounds = true
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customBlurEffectView)
        addArrangedSubview(likeButton)
        addArrangedSubview(commentButton)
        addArrangedSubview(shareButton)
        addArrangedSubview(bookmarkButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle, parentVC: UIViewController, mainUser: User) {
        self.post = post
        self.mode = mode
        self.parentVC = parentVC
        self.mainUser = mainUser
        
        likeButton.configuration?.image = UIImage(named: "heart_dark_empty")
        commentButton.configuration?.image = UIImage(named: "comment_dark")
        shareButton.configuration?.image = UIImage(named: "share_dark")
        bookmarkButton.configuration?.image = UIImage(named: "bookmark_dark_filled")
        backgroundColor = Constants.post_cell_cap_view_dark
        
        if mode == .light {
            likeButton.configuration?.image = UIImage(named: "heart_light_empty")
            commentButton.configuration?.image = UIImage(named: "comment_light")
            shareButton.configuration?.image = UIImage(named: "share_light")
            bookmarkButton.configuration?.image = UIImage(named: "bookmark_light_filled")
            backgroundColor = Constants.post_cell_cap_view_light
        }
        
        if post.containsLikedUser(user: mainUser) {
            likeButton.configuration?.image = UIImage(named: "heart_filled")
        }
    }
    
    // MARK: - Button Helpers
    @objc func likePost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.likeButton.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.likeButton.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
        if post.containsLikedUser(user: mainUser) {
            post.removedLikedUsers(user: mainUser)
            likeButton.configuration?.image = UIImage(named: "heart_dark_empty")
            if mode == .light {
                likeButton.configuration?.image = UIImage(named: "heart_light_empty")
            }
        } else {
            post.addLikedUsers(user: mainUser)
            likeButton.configuration?.image = UIImage(named: "heart_filled")
        }
    }
    
    @objc func pushCommentVC() {
        let commentVC = CommentVC(post: post, main_user: mainUser)
        parentVC.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @objc func bookmarkPost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bookmarkButton.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.bookmarkButton.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
        if mainUser.isBookmarked(post: post) {
            mainUser.removeBookmarkPost(post: post)
            post.removeBookmarkUser(user: mainUser)
            bookmarkButton.configuration?.image = UIImage(named: "bookmark_dark_empty")
            if mode == .light {
                bookmarkButton.configuration?.image = UIImage(named: "bookmark_light_empty")
            }
        } else {
            mainUser.addBookmarkPost(post: post)
            post.addBookmarkUser(user: mainUser)
            bookmarkButton.configuration?.image = UIImage(named: "bookmark_dark_filled")
            if mode == .light {
                bookmarkButton.configuration?.image = UIImage(named: "bookmark_light_filled")
            }
        }
    }
}
