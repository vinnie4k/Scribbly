//
//  MemsInfoView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/27/22.
//

import UIKit

class MemsInfoView: UIView, ReloadStatsDelegate {
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

    lazy var hide_share_view: HideShareView = {
        let hsv = HideShareView()
        hsv.translatesAutoresizingMaskIntoConstraints = false
        return hsv
    }()

    private lazy var stats_view: PostInfoStatsView = {
        let stats = PostInfoStatsView()
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(pushCommentVC))
        stats.addGestureRecognizer(tap_gesture)
        stats.isUserInteractionEnabled = true
        stats.translatesAutoresizingMaskIntoConstraints = false
        return stats
    }()

    // ------------ Fields (Data) ------------
    private var post: Post? = nil
    private var mode: UIUserInterfaceStyle? = nil
    private var parent_vc: UIViewController? = nil

    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(drawing)
        addSubview(stats_view)
        addSubview(hide_share_view)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadStats() {
        stats_view.reloadStats()
    }

    @objc private func pushCommentVC() {
        if let post = post {
            let comment_vc = CommentVC(post: post, main_user: post.getUser())
            comment_vc.reload_stats_delegate = self
            parent_vc?.navigationController?.pushViewController(comment_vc, animated: true)
        }
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

    func configure(post: Post, mode: UIUserInterfaceStyle, parent_vc: UIViewController) {
        self.post = post
        self.mode = mode
        self.parent_vc = parent_vc
        drawing.image = post.getDrawing()
        stats_view.configure(post: post, mode: mode)
        hide_share_view.configure(post: post, mode: mode)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            drawing.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            drawing.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),

            stats_view.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_info_stats_padding),
            stats_view.trailingAnchor.constraint(equalTo: drawing.trailingAnchor, constant: -Constants.post_info_stats_padding),
            stats_view.heightAnchor.constraint(equalToConstant: Constants.post_info_stats_height),
            stats_view.bottomAnchor.constraint(equalTo: drawing.bottomAnchor, constant: -Constants.post_info_stats_padding),

            hide_share_view.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_info_redo_top),
            hide_share_view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

}

class HideShareView: UIStackView {
    // ------------ Fields (View) ------------
    private lazy var hide_btn: UIButton = {
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

    private let share_btn: UIButton = {
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
    private var mode: UIUserInterfaceStyle? = nil
    var reload_cv_delegate: ReloadCVDelegate?

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
        addArrangedSubview(hide_btn)
        addArrangedSubview(delete_btn)
        addArrangedSubview(share_btn)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func hidePost() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.hide_btn.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.hide_btn.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })

        if (post!.isHidden()) {
            post?.setHidden(bool: false)
            if (mode == .light) {
                hide_btn.configuration?.image = UIImage(named: "shown_light")
            } else if (mode == .dark) {
                hide_btn.configuration?.image = UIImage(named: "shown_dark")
            }
        } else {
            post?.setHidden(bool: true)
            if (mode == .light) {
                hide_btn.configuration?.image = UIImage(named: "hidden_light")
            } else if (mode == .dark) {
                hide_btn.configuration?.image = UIImage(named: "hidden_dark")
            }
        }
        reload_cv_delegate!.reloadCV()
    }

    func configure(post: Post, mode: UIUserInterfaceStyle) {
        self.post = post
        self.mode = mode

        if (mode == .dark) {
            if (post.isHidden()) {
                hide_btn.configuration?.image = UIImage(named: "hidden_dark")
            } else {
                hide_btn.configuration?.image = UIImage(named: "shown_dark")
            }
            delete_btn.configuration?.image = UIImage(named: "delete_dark")
            share_btn.configuration?.image = UIImage(named: "share_dark")
            backgroundColor = Constants.post_cell_cap_view_dark
        } else if (mode == .light) {
            if (post.isHidden()) {
                hide_btn.configuration?.image = UIImage(named: "hidden_light")
            } else {
                hide_btn.configuration?.image = UIImage(named: "shown_light")
            }
            delete_btn.configuration?.image = UIImage(named: "delete_light")
            share_btn.configuration?.image = UIImage(named: "share_light")
            backgroundColor = Constants.post_cell_cap_view_light
        }
    }
}

