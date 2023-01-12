//
//  PostInfoView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: PostInfoView
class PostInfoView: UIView, ReloadStatsDelegate {
    // MARK: - Properties (view)
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(toggleStats))
        img.addGestureRecognizer(tap_gesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    private lazy var statsView: PostInfoStatsView = {
        let stats = PostInfoStatsView()
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(pushCommentVC))
        stats.addGestureRecognizer(tap_gesture)
        stats.isUserInteractionEnabled = true
        stats.translatesAutoresizingMaskIntoConstraints = false
        return stats
    }()
    
    private var redoDeleteView: RedoDeleteView = {
        let rdv = RedoDeleteView()
        rdv.translatesAutoresizingMaskIntoConstraints = false
        return rdv
    }()
    
    // MARK: - Properties (data)
    private var post: Post!
    private var mode: UIUserInterfaceStyle!
    private weak var parentVC: UIViewController!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(drawing)
        addSubview(statsView)
        addSubview(redoDeleteView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle, parentVC: UIViewController) {
        self.post = post
        self.mode = mode
        self.parentVC = parentVC
        
        drawing.image = post.getDrawing()
        statsView.configure(post: post, mode: mode)
        redoDeleteView.configure(post: post, mode: mode)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            drawing.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            drawing.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),

            statsView.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_info_stats_padding),
            statsView.trailingAnchor.constraint(equalTo: drawing.trailingAnchor, constant: -Constants.post_info_stats_padding),
            statsView.heightAnchor.constraint(equalToConstant: Constants.post_info_stats_height),
            statsView.bottomAnchor.constraint(equalTo: drawing.bottomAnchor, constant: -Constants.post_info_stats_padding),
            
            redoDeleteView.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_info_redo_top),
            redoDeleteView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func pushCommentVC() {
        let commentVC = CommentVC(post: post, mainUser: post.getUser())
        commentVC.reloadStatsDelegate = self
        parentVC.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    @objc func toggleStats() {
        if self.statsView.alpha == 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.statsView.alpha = 0.0
            }, completion: nil)
        } else if self.statsView.alpha == 0.0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.statsView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func reloadStats() {
        statsView.reloadStats()
    }
}

// MARK: PostInfoStatsView
class PostInfoStatsView: UIView {
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
        lbl.font = Constants.getFont(size: 14, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let caption: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 10, weight: .regular)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let likesView = UIView()
    private var commentView = UIView()
    private let bookmarkView = UIView()
    private let stack = UIStackView()
    
    // MARK: - Properties (data)
    private var post: Post!
    private var mode: UIUserInterfaceStyle!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = Constants.post_info_view_corner
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.3)
        customBlurEffectView.frame = self.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.layer.cornerRadius = Constants.post_info_view_corner
        customBlurEffectView.clipsToBounds = true
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customBlurEffectView)
        addSubview(userPFP)
        addSubview(displayName)
        addSubview(caption)
        addSubview(stack)
        
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
        
        backgroundColor = Constants.blur_dark
        if mode == .light {
            backgroundColor = Constants.blur_light
        }
        
        createLikesView(likeCount: post.getLikeCount(), mode: mode)
        createCommentView(commentCount: post.getCommentReplyCount(), mode: mode)
        createBookmarkView(bookmarkCount: post.getBookmarkCount(), mode: mode)
        
        createStackView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userPFP.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.post_info_pfp_top),
            userPFP.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.post_info_pfp_side),
            userPFP.widthAnchor.constraint(equalToConstant: 2 * Constants.post_info_pfp_radius),
            userPFP.heightAnchor.constraint(equalToConstant: 2 * Constants.post_info_pfp_radius),
            
            displayName.topAnchor.constraint(equalTo: userPFP.topAnchor, constant: 2),
            displayName.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.post_info_name_left),
            
            caption.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: Constants.post_info_caption_top),
            caption.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.post_info_name_left),

            stack.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: Constants.post_info_stack_top),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: Constants.post_info_stack_width),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.post_info_pfp_top),
        ])
    }
    
    // MARK: - Helpers
    func reloadStats() {
        for sub in commentView.subviews {
            sub.removeFromSuperview()
        }
        createCommentView(commentCount: post.getCommentReplyCount(), mode: mode)
    }
    
    private func createLikesView(likeCount: Int, mode: UIUserInterfaceStyle) {
        var img = UIImageView(image: UIImage(named: "heart_dark_empty"))
        if mode == .light {
            img = UIImageView(image: UIImage(named: "heart_light_empty"))
        }
        
        let lbl = UILabel()
        lbl.text = String(likeCount)
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .regular)
        
        img.translatesAutoresizingMaskIntoConstraints = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        likesView.translatesAutoresizingMaskIntoConstraints = false
        likesView.addSubview(img)
        likesView.addSubview(lbl)
        
        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: likesView.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: likesView.leadingAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: Constants.post_info_number_left),
            lbl.centerYAnchor.constraint(equalTo: likesView.centerYAnchor)
        ])
    }

    private func createCommentView(commentCount: Int, mode: UIUserInterfaceStyle) {
        var img = UIImageView(image: UIImage(named: "comment_dark"))
        if mode == .light {
            img = UIImageView(image: UIImage(named: "comment_light"))
        }

        let lbl = UILabel()
        lbl.text = String(commentCount)
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .regular)

        img.translatesAutoresizingMaskIntoConstraints = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.addSubview(img)
        commentView.addSubview(lbl)

        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: commentView.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: commentView.leadingAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: Constants.post_info_number_left),
            lbl.centerYAnchor.constraint(equalTo: commentView.centerYAnchor)
        ])
    }

    private func createBookmarkView(bookmarkCount: Int, mode: UIUserInterfaceStyle) {
        var img = UIImageView(image: UIImage(named: "bookmark_dark_empty"))
        if mode == .light {
            img = UIImageView(image: UIImage(named: "bookmark_light_empty"))
        }

        let lbl = UILabel()
        lbl.text = String(bookmarkCount)
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .regular)

        img.translatesAutoresizingMaskIntoConstraints = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        bookmarkView.translatesAutoresizingMaskIntoConstraints = false
        bookmarkView.addSubview(img)
        bookmarkView.addSubview(lbl)

        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: bookmarkView.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: bookmarkView.leadingAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: Constants.post_info_number_left),
            lbl.centerYAnchor.constraint(equalTo: bookmarkView.centerYAnchor)
        ])
    }

    private func createStackView() {
        stack.addArrangedSubview(likesView)
        stack.addArrangedSubview(commentView)
        stack.addArrangedSubview(bookmarkView)

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.post_info_stack_spacing

        stack.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: RedoDeleteView
class RedoDeleteView: UIStackView {
    // MARK: - Properties (view)
    private let redoButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Properties (data)
    private var post: Post!
    
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
        addArrangedSubview(redoButton)
        addArrangedSubview(deleteButton)
        addArrangedSubview(shareButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle) {
        self.post = post
        
        redoButton.configuration?.image = UIImage(named: "redo_dark")
        deleteButton.configuration?.image = UIImage(named: "delete_dark")
        shareButton.configuration?.image = UIImage(named: "share_dark")
        backgroundColor = Constants.blur_dark
        
        if mode == .light {
            redoButton.configuration?.image = UIImage(named: "redo_light")
            deleteButton.configuration?.image = UIImage(named: "delete_light")
            shareButton.configuration?.image = UIImage(named: "share_light")
            backgroundColor = Constants.blur_light
        }
    }
}
