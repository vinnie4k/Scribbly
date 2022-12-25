//
//  PostInfoView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

import UIKit

class PostInfoView: UIView {
    // ------------ Fields (view) ------------
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
    
    private var redo_delete_view = RedoDeleteView()
    private var stats_view = PostInfoStatsView()
    
    // ------------ Fields (Data) ------------
    private var post: Post? = nil
    private var mode: UIUserInterfaceStyle? = nil

    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(drawing)
        addSubview(stats_view)
        addSubview(redo_delete_view)
        
        stats_view.translatesAutoresizingMaskIntoConstraints = false
        redo_delete_view.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleStats() {
        if (self.stats_view.alpha == 1.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.stats_view.alpha = 0.0
            }, completion: nil)
        } else if (self.stats_view.alpha == 0.0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.stats_view.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle) {
        self.post = post
        self.mode = mode
        drawing.image = post.getDrawing()
        stats_view.configure(post: post, mode: mode)
        redo_delete_view.configure(post: post, mode: mode)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            drawing.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            drawing.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),

            stats_view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.post_info_stats_padding),
            stats_view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.post_info_stats_padding),
            stats_view.heightAnchor.constraint(equalToConstant: Constants.post_info_stats_height),
            stats_view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.post_info_stats_padding - 15),
            
            redo_delete_view.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_info_redo_top),
            redo_delete_view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
}

class PostInfoStatsView: UIView {
    // ------------ Fields (View) ------------
    private let user_pfp: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.post_cell_pfp_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let display_name: UILabel = {
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
    
    private let likes_view = UIView()
    private let comment_view = UIView()
    private let bookmark_view = UIView()
    private let stack = UIStackView()
    
    // ------------ Fields (Data) ------------

    // ------------ Functions ------------
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
        
        addSubview(customBlurEffectView)
        addSubview(user_pfp)
        addSubview(display_name)
        addSubview(caption)
        addSubview(stack)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle) {
        user_pfp.setImage(post.getUser().getPFP(), for: .normal)
        display_name.text = post.getUser().getUserName()
        caption.text = post.getCaption()
        
        if (mode == .dark) {
            backgroundColor = Constants.post_cell_cap_view_dark
        } else if (mode == .light) {
            backgroundColor = Constants.post_cell_cap_view_light
        }
        
        createLikesView(like_count: post.getLikeCount(), mode: mode)
        createCommentView(comment_count: post.getCommentReplyCount(), mode: mode)
        createBookmarkView(bookmark_count: post.getBookmarkCount(), mode: mode)
        
        createStackView()
    }
    
    private func createLikesView(like_count: Int, mode: UIUserInterfaceStyle) {
        var img = UIImageView(image: UIImage(named: "heart_dark_empty"))
        if (mode == .light) {
            img = UIImageView(image: UIImage(named: "heart_light_empty"))
        }

        let lbl = UILabel()
        lbl.text = String(like_count)
        lbl.textColor = .label
        lbl.font = Constants.post_info_number_font

        img.translatesAutoresizingMaskIntoConstraints = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        likes_view.translatesAutoresizingMaskIntoConstraints = false
        likes_view.addSubview(img)
        likes_view.addSubview(lbl)
        
        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: likes_view.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: likes_view.leadingAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: Constants.post_info_number_left),
            lbl.centerYAnchor.constraint(equalTo: likes_view.centerYAnchor)
        ])
    }

    private func createCommentView(comment_count: Int, mode: UIUserInterfaceStyle) {
        var img = UIImageView(image: UIImage(named: "comment_dark"))
        if (mode == .light) {
            img = UIImageView(image: UIImage(named: "comment_light"))
        }

        let lbl = UILabel()
        lbl.text = String(comment_count)
        lbl.textColor = .label
        lbl.font = Constants.post_info_number_font

        img.translatesAutoresizingMaskIntoConstraints = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        comment_view.translatesAutoresizingMaskIntoConstraints = false
        comment_view.addSubview(img)
        comment_view.addSubview(lbl)

        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: comment_view.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: comment_view.leadingAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: Constants.post_info_number_left),
            lbl.centerYAnchor.constraint(equalTo: comment_view.centerYAnchor)
        ])
    }

    private func createBookmarkView(bookmark_count: Int, mode: UIUserInterfaceStyle) {
        var img = UIImageView(image: UIImage(named: "bookmark_dark_empty"))
        if (mode == .light) {
            img = UIImageView(image: UIImage(named: "bookmark_light_empty"))
        }

        let lbl = UILabel()
        lbl.text = String(bookmark_count)
        lbl.textColor = .label
        lbl.font = Constants.post_info_number_font

        img.translatesAutoresizingMaskIntoConstraints = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        bookmark_view.translatesAutoresizingMaskIntoConstraints = false
        bookmark_view.addSubview(img)
        bookmark_view.addSubview(lbl)

        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: bookmark_view.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: bookmark_view.leadingAnchor),
            lbl.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: Constants.post_info_number_left),
            lbl.centerYAnchor.constraint(equalTo: bookmark_view.centerYAnchor)
        ])
    }

    private func createStackView() {
        stack.addArrangedSubview(likes_view)
        stack.addArrangedSubview(comment_view)
        stack.addArrangedSubview(bookmark_view)

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.post_info_stack_spacing

        stack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            user_pfp.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.post_info_pfp_top),
            user_pfp.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.post_info_pfp_side),
            user_pfp.widthAnchor.constraint(equalToConstant: 2 * Constants.post_info_pfp_radius),
            user_pfp.heightAnchor.constraint(equalToConstant: 2 * Constants.post_info_pfp_radius),
            
            display_name.topAnchor.constraint(equalTo: user_pfp.topAnchor, constant: 2),
            display_name.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.post_info_name_left),
            
            caption.topAnchor.constraint(equalTo: display_name.bottomAnchor, constant: Constants.post_info_caption_top),
            caption.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.post_info_name_left),

            stack.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: Constants.post_info_stack_top),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: Constants.post_info_stack_width),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.post_info_pfp_top),
        ])
    }
}

class RedoDeleteView: UIStackView {
    // ------------ Fields (View) ------------
    private let redo_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let delete_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // ------------ Fields (Data) ------------
    private var post: Post? = nil
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .horizontal
        distribution = .fillEqually
        spacing = Constants.post_info_redo_spacing
        
        self.layer.cornerRadius = Constants.post_info_redo_corner
        self.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.isLayoutMarginsRelativeArrangement = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.5)
        customBlurEffectView.frame = self.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.layer.cornerRadius = Constants.post_info_redo_corner
        customBlurEffectView.clipsToBounds = true
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customBlurEffectView)
        addArrangedSubview(redo_btn)
        addArrangedSubview(delete_btn)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle) {
        self.post = post

        if (mode == .dark) {
            redo_btn.configuration?.image = UIImage(named: "redo_dark")
            delete_btn.configuration?.image = UIImage(named: "delete_dark")
            backgroundColor = Constants.post_cell_cap_view_dark
        } else if (mode == .light) {
            redo_btn.configuration?.image = UIImage(named: "redo_light")
            delete_btn.configuration?.image = UIImage(named: "delete_light")
            backgroundColor = Constants.post_cell_cap_view_light
        }
    }
}
