//
//  PostCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class PromptHeaderView: UICollectionReusableView {
    // ------------ Fields (view) ------------
    private lazy var user_post: UIImageView = {
        let img = UIImageView()
        img.tintColor = .label
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.user_post_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(showStats))
        img.addGestureRecognizer(tap_gesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    private let prompt_heading: UILabel = {
        let lbl = UILabel()
        lbl.text = "today's prompt"
        lbl.textColor = .label
        lbl.font = Constants.prompt_heading_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let prompt: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.prompt_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // ------------ Fields (data) ------------
    var post_info_delegate: PostInfoDelegate?
    private var post: Post? = nil

    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(prompt_heading)
        addSubview(prompt)
        addSubview(user_post)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func showStats() {
        post_info_delegate?.showPostInfo(post: post!)
    }
    
    func configure(prompt: String, post: Post) {
        self.prompt.text = prompt
        self.user_post.image = post.getDrawing()
        self.post = post
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            prompt_heading.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.prompt_heading_top_padding),
            prompt_heading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prompt_side_padding),

            prompt.topAnchor.constraint(equalTo: prompt_heading.bottomAnchor, constant: Constants.prompt_top_padding),
            prompt.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prompt_side_padding),
            
            user_post.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.user_post_top_padding),
            user_post.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.user_post_side_padding),
            user_post.widthAnchor.constraint(equalToConstant: Constants.user_post_width),
            user_post.heightAnchor.constraint(equalToConstant: Constants.user_post_height),
        ])
    }
}


class PostCollectionViewCell: UICollectionViewCell {
    
    // ------------ Fields (view) ------------
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.layer.borderWidth = Constants.post_cell_drawing_border_width
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(enlargeImage))
        img.addGestureRecognizer(tap_gesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    private lazy var like_btn: UIButton = {
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
    
    private let comment_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let share_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var bookmark_btn: UIButton = {
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
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [like_btn, comment_btn, share_btn, bookmark_btn])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.layoutMargins = UIEdgeInsets(top: Constants.post_cell_stack_top, left: Constants.post_cell_stack_side, bottom: Constants.post_cell_stack_top, right: Constants.post_cell_stack_side)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = Constants.post_cell_stack_spacing
        stack.layer.cornerRadius = Constants.post_cell_stack_corner
        stack.tintColor = .white
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let caption_view: CaptionView = {
        let view = CaptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // ------------ Fields (Data) ------------
    private var parent_vc: UIViewController? = nil
    private var mode: UIUserInterfaceStyle? = nil
    private var post: Post? = nil
    private var main_user: User? = nil
    var enlarge_delegate: EnlargeDrawingDelegate?
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(drawing)
        contentView.addSubview(stack)
        contentView.addSubview(caption_view)
        
        // Function Calls
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func bookmarkPost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bookmark_btn.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.bookmark_btn.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
        if (main_user!.isBookmarked(post: post!)) {
            main_user?.removeBookmarkPost(post: post!)
            post?.removeBookmarkUser(user: main_user!)
            if (mode == .light) {
                bookmark_btn.configuration?.image = UIImage(named: "bookmark_light_empty")
            } else if (mode == .dark) {
                bookmark_btn.configuration?.image = UIImage(named: "bookmark_dark_empty")
            }
        } else {
            main_user?.addBookmarkPost(post: post!)
            post?.addBookmarkUser(user: main_user!)
            if (mode == .light) {
                bookmark_btn.configuration?.image = UIImage(named: "bookmark_light_filled")
            } else if (mode == .dark) {
                bookmark_btn.configuration?.image = UIImage(named: "bookmark_dark_filled")
            }
        }
    }
    
    @objc func likePost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.like_btn.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.like_btn.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
        if (post!.containsLikedUser(user: main_user!)) {
            post?.removedLikedUsers(user: main_user!)
            if (mode == .light) {
                like_btn.configuration?.image = UIImage(named: "heart_light_empty")
            } else if (mode == .dark) {
                like_btn.configuration?.image = UIImage(named: "heart_dark_empty")
            }
        } else {
            post?.addLikedUsers(user: main_user!)
            like_btn.configuration?.image = UIImage(named: "heart_filled")
        }
    }
    
    @objc func enlargeImage() {
        if let drawing = drawing.image {
            enlarge_delegate?.enlargeDrawing(drawing: drawing)
        }
    }
    
    @objc private func pushCommentVC() {
        if let post = post {
            let comment_vc = CommentVC(post: post, main_user: main_user!)
            parent_vc?.navigationController?.pushViewController(comment_vc, animated: true)
        }
    }
    
    func configure(main_user: User, post: Post, parent_vc: UIViewController, mode: UIUserInterfaceStyle) {
        self.caption_view.configure(caption: post.getCaption(), post_user: post.getUser(), vc: parent_vc)
        self.drawing.image = post.getDrawing()
        self.parent_vc = parent_vc
        self.mode = mode
        self.post = post
        self.main_user = main_user
        setMode(mode: mode)
        comment_btn.addTarget(self, action: #selector(pushCommentVC), for: .touchUpInside)
    }
    
    func setMode(mode: UIUserInterfaceStyle) {
        self.mode = mode
        if (self.mode == .light) {
            self.drawing.layer.borderColor = Constants.post_cell_drawing_border_light.cgColor
            self.stack.backgroundColor = Constants.post_cell_drawing_border_light
            self.caption_view.backgroundColor = Constants.post_cell_cap_view_light
            self.like_btn.configuration?.image = UIImage(named: "heart_light_empty")
            self.comment_btn.configuration?.image = UIImage(named: "comment_light")
            self.share_btn.configuration?.image = UIImage(named: "share_light")
            self.bookmark_btn.configuration?.image = UIImage(named: "bookmark_light_empty")
        } else if (self.mode == .dark) {
            self.drawing.layer.borderColor = Constants.post_cell_drawing_border_dark.cgColor
            self.stack.backgroundColor = Constants.post_cell_drawing_border_dark
            self.caption_view.backgroundColor = Constants.post_cell_cap_view_dark
            self.like_btn.configuration?.image = UIImage(named: "heart_dark_empty")
            self.comment_btn.configuration?.image = UIImage(named: "comment_dark")
            self.share_btn.configuration?.image = UIImage(named: "share_dark")
            self.bookmark_btn.configuration?.image = UIImage(named: "bookmark_dark_empty")
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.post_cell_side_padding),
            drawing.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            drawing.heightAnchor.constraint(equalToConstant: Constants.post_cell_drawing_height),
            drawing.widthAnchor.constraint(equalToConstant: Constants.post_cell_drawing_width),
            
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: Constants.post_cell_stack_width),
            
            caption_view.bottomAnchor.constraint(equalTo: drawing.bottomAnchor, constant: -Constants.post_cell_cap_view_bot),
            caption_view.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_cell_cap_view_side),
            caption_view.trailingAnchor.constraint(equalTo: drawing.trailingAnchor, constant: -Constants.post_cell_cap_view_side),
            caption_view.heightAnchor.constraint(equalToConstant: Constants.post_cell_cap_view_height),
        ])
    }
    
}

class CaptionView: UIView {
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
        
    // ------------ Fields (Data) ------------
    private var parent_vc: UIViewController? = nil

    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.layer.cornerRadius = Constants.post_cell_cap_view_corner
        customBlurEffectView.clipsToBounds = true
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = Constants.post_cell_cap_view_corner
        
        addSubview(customBlurEffectView)
        addSubview(caption)
        addSubview(display_name)
        addSubview(user_pfp)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pushProfileVC() {
        let profile_vc = MainUserProfileVC()
        parent_vc?.navigationController?.pushViewController(profile_vc, animated: true)
    }
    
    func configure(caption: String, post_user: User, vc: UIViewController) {
        self.caption.text = caption
        display_name.text = post_user.getUserName()
        user_pfp.setImage(post_user.getPFP(), for: .normal)
        user_pfp.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        parent_vc = vc
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            user_pfp.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            user_pfp.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.post_cell_pfp_side),
            user_pfp.widthAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),
            user_pfp.heightAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),
            
            display_name.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            display_name.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.post_cell_name_side),
            
            caption.topAnchor.constraint(equalTo: display_name.bottomAnchor, constant: Constants.post_cell_caption_top),
            caption.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.post_cell_name_side),
        ])
    }
}
