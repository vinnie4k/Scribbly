//
//  MemsInfoView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/27/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: MemsInfoView
class MemsInfoView: UIView, ReloadStatsDelegate {
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

    private lazy var hideShareView: HideShareView = {
        let hsv = HideShareView()
        hsv.translatesAutoresizingMaskIntoConstraints = false
        return hsv
    }()

    private lazy var statsView: PostInfoStatsView = {
        let stats = PostInfoStatsView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushCommentVC))
        stats.addGestureRecognizer(tapGesture)
        stats.isUserInteractionEnabled = true
        stats.translatesAutoresizingMaskIntoConstraints = false
        return stats
    }()

    // MARK: - Properties (data)
    private var post: Post!
    private var mode: UIUserInterfaceStyle!
    private var parentVC: UIViewController!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(drawing)
        addSubview(statsView)
        addSubview(hideShareView)

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
        hideShareView.configure(post: post, mode: mode)
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
            
            hideShareView.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_info_redo_top),
            hideShareView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    func reloadStats() {
        statsView.reloadStats()
    }

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
}

// MARK: HideShareView
class HideShareView: UIStackView {
    // MARK: - Properties (view)
    private lazy var hideButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(hidePost), for: .touchUpInside)
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
    private var mode: UIUserInterfaceStyle!

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
        addArrangedSubview(hideButton)
        addArrangedSubview(deleteButton)
        addArrangedSubview(shareButton)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, mode: UIUserInterfaceStyle) {
        self.post = post
        self.mode = mode
        
        if post.isHidden() {
            hideButton.configuration?.image = UIImage(named: "hidden_dark")
        } else {
            hideButton.configuration?.image = UIImage(named: "shown_dark")
        }
        deleteButton.configuration?.image = UIImage(named: "delete_dark")
        shareButton.configuration?.image = UIImage(named: "share_dark")
        backgroundColor = Constants.blur_dark
 
        if mode == .light {
            if post.isHidden() {
                hideButton.configuration?.image = UIImage(named: "hidden_light")
            } else {
                hideButton.configuration?.image = UIImage(named: "shown_light")
            }
            deleteButton.configuration?.image = UIImage(named: "delete_light")
            shareButton.configuration?.image = UIImage(named: "share_light")
            backgroundColor = Constants.blur_light
        }
    }
    
    // MARK: - Button Helpers
    @objc func hidePost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.hideButton.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.hideButton.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })

        if post.isHidden() {
            post.setHidden(bool: false)
            hideButton.configuration?.image = UIImage(named: "shown_dark")
            if mode == .light {
                hideButton.configuration?.image = UIImage(named: "shown_light")
            }
        } else {
            post.setHidden(bool: true)
            hideButton.configuration?.image = UIImage(named: "hidden_dark")
            if (mode == .light) {
                hideButton.configuration?.image = UIImage(named: "hidden_light")
            }
        }
    }
}

