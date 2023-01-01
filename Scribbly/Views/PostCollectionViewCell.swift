//
//  PostCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: PromptHeaderView
class PromptHeaderView: UICollectionReusableView {
    // MARK: - Properties (view)
    private lazy var userPost: UIImageView = {
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
    
    private let promptHeading: UILabel = {
        let lbl = UILabel()
        lbl.text = "today's prompt"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let prompt: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 40, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "PromptHeaderViewReuse"
    var postInfoDelegate: PostInfoDelegate!
    private var post: Post!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(promptHeading)
        addSubview(prompt)
        addSubview(userPost)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(prompt: String, post: Post) {
        self.prompt.text = prompt
        self.userPost.image = post.getDrawing()
        self.post = post
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            promptHeading.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.prompt_heading_top_padding),
            promptHeading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prompt_side_padding),

            prompt.topAnchor.constraint(equalTo: promptHeading.bottomAnchor, constant: Constants.prompt_top_padding),
            prompt.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.prompt_side_padding),
            
            userPost.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.user_post_top_padding),
            userPost.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.user_post_side_padding),
            userPost.widthAnchor.constraint(equalToConstant: Constants.user_post_width),
            userPost.heightAnchor.constraint(equalToConstant: Constants.user_post_height),
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func showStats() {
        postInfoDelegate.showPostInfo(post: post!)
    }
}

// MARK: PostCollectionViewCell
class PostCollectionViewCell: UICollectionViewCell {
    // MARK: - Properites (view)
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.layer.borderWidth = Constants.post_cell_drawing_border_width
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enlargeImage))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
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
    
    private let commentButton: UIButton = {
        let btn = UIButton()
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
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton, bookmarkButton])
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
    
    private lazy var captionView: CaptionView = {
        let view = CaptionView()        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties (data)
    static let reuseIdentifier = "PostCollectionViewCellReuse"
    private var parentVC: UIViewController!
    private var mode: UIUserInterfaceStyle!
    private var post: Post!
    private var mainUser: User!
    var enlargeDrawingDelegate: EnlargeDrawingDelegate!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(drawing)
        contentView.addSubview(stack)
        contentView.addSubview(captionView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mainUser: User, post: Post, parentVC: UIViewController, mode: UIUserInterfaceStyle) {
        self.parentVC = parentVC
        self.mode = mode
        self.post = post
        self.mainUser = mainUser
        
        setMode(mode: mode)
        
        captionView.configure(caption: post.getCaption(), postUser: post.getUser(), parentVC: parentVC)
        drawing.image = post.getDrawing()
        
        if post.containsLikedUser(user: mainUser) {
            likeButton.configuration?.image = UIImage(named: "heart_filled")
        }
        if mainUser.isBookmarked(post: post) {
            bookmarkButton.configuration?.image = UIImage(named: "bookmark_dark_filled")
            if mode == .light {
                bookmarkButton.configuration?.image = UIImage(named: "bookmark_light_filled")
            }
        }
        
        commentButton.addTarget(self, action: #selector(pushCommentVC), for: .touchUpInside)
    }
    
    func setMode(mode: UIUserInterfaceStyle) {
        if mode == .light {
            drawing.layer.borderColor = Constants.secondary_light.cgColor
            stack.backgroundColor = Constants.secondary_light
            captionView.backgroundColor = Constants.blur_light
            likeButton.configuration?.image = UIImage(named: "heart_light_empty")
            commentButton.configuration?.image = UIImage(named: "comment_light")
            shareButton.configuration?.image = UIImage(named: "share_light")
            bookmarkButton.configuration?.image = UIImage(named: "bookmark_light_empty")
        } else if mode == .dark {
            drawing.layer.borderColor = Constants.primary_dark.cgColor
            stack.backgroundColor = Constants.primary_dark
            captionView.backgroundColor = Constants.blur_dark
            likeButton.configuration?.image = UIImage(named: "heart_dark_empty")
            commentButton.configuration?.image = UIImage(named: "comment_dark")
            shareButton.configuration?.image = UIImage(named: "share_dark")
            bookmarkButton.configuration?.image = UIImage(named: "bookmark_dark_empty")
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
            
            captionView.bottomAnchor.constraint(equalTo: drawing.bottomAnchor, constant: -Constants.post_cell_cap_view_bot),
            captionView.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_cell_cap_view_side),
            captionView.trailingAnchor.constraint(equalTo: drawing.trailingAnchor, constant: -Constants.post_cell_cap_view_side),
            captionView.heightAnchor.constraint(equalToConstant: Constants.post_cell_cap_view_height)
        ])
    }
    
    // MARK: - Button Helpers
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
    
    @objc func likePost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.likeButton.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.likeButton.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
        
        if (post.containsLikedUser(user: mainUser)) {
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
    
    @objc func enlargeImage() {
        if let drawing = drawing.image {
            enlargeDrawingDelegate.enlargeDrawing(drawing: drawing)
        }
    }
    
    @objc private func pushCommentVC() {
        let commentVC = CommentVC(post: post, mainUser: mainUser)
        parentVC.navigationController?.pushViewController(commentVC, animated: true)
    }
}

// MARK: CaptionView
class CaptionView: UIView {
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
        
    // MARK: - Properties (data)
    private var parentVC: UIViewController!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.layer.cornerRadius = Constants.post_cell_cap_view_corner
        customBlurEffectView.clipsToBounds = true
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = Constants.post_cell_cap_view_corner
        
        addSubview(customBlurEffectView)
        addSubview(caption)
        addSubview(displayName)
        addSubview(userPFP)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(caption: String, postUser: User, parentVC: UIViewController) {
        self.parentVC = parentVC
        
        self.caption.text = caption
        displayName.text = postUser.getUserName()
        userPFP.setImage(postUser.getPFP(), for: .normal)
        userPFP.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userPFP.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userPFP.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.post_cell_pfp_side),
            userPFP.widthAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),
            userPFP.heightAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),
            
            displayName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            displayName.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.post_cell_name_side),
            
            caption.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: Constants.post_cell_caption_top),
            caption.leadingAnchor.constraint(equalTo: userPFP.trailingAnchor, constant: Constants.post_cell_name_side),
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func pushProfileVC() {
        let profileVC = MainUserProfileVC()
        parentVC?.navigationController?.pushViewController(profileVC, animated: true)
    }
}
