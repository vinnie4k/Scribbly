//
//  MemsInfoView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/27/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: MemsInfoView
class MemsInfoView: UIView, ReloadStatsDelegate, UIScrollViewDelegate {
    // MARK: - Properties (view)
    private lazy var zoomImg: UIScrollView = {
        let scroll = UIScrollView()
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 6.0
        scroll.delegate = self
        scroll.frame = CGRectMake(0, 0, self.drawing.frame.width, self.drawing.frame.height)
        scroll.alwaysBounceVertical = false
        scroll.alwaysBounceHorizontal = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.layer.cornerRadius = Constants.post_cell_drawing_corner
        scroll.flashScrollIndicators()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(drawing)
        return scroll
    }()
    
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
    private weak var parentVC: UIViewController!

    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(zoomImg)
        addSubview(statsView)
        addSubview(hideShareView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post, parentVC: UIViewController) {
        self.post = post
        self.parentVC = parentVC
        
        drawing.image = post.getDrawing()
        statsView.configure(post: post)
        hideShareView.configure(post: post, parentVC: parentVC)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            drawing.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            zoomImg.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            zoomImg.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            zoomImg.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            statsView.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_info_stats_padding),
            statsView.trailingAnchor.constraint(equalTo: drawing.trailingAnchor, constant: -Constants.post_info_stats_padding),
//            statsView.heightAnchor.constraint(equalToConstant: Constants.post_info_stats_height),
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
    
    // MARK: - Zoom-in Helpers
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return drawing
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        statsView.isHidden = true
        hideShareView.isHidden = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        statsView.isHidden = false
        hideShareView.isHidden = false
        scrollView.setZoomScale(0, animated: true)
    }
}

// MARK: HideShareView
class HideShareView: UIStackView {
    // MARK: - Properties (view)
    private lazy var hideButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(hidePost), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let shareButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Properties (data)
    private var post: Post!
    private weak var parentVC: UIViewController!

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
    
    func configure(post: Post, parentVC: UIViewController) {
        self.post = post
        self.parentVC = parentVC
        
        if post.isHidden() {
            hideButton.configuration?.image = UIImage(named: "hidden")
        } else {
            hideButton.configuration?.image = UIImage(named: "shown")
        }
        deleteButton.configuration?.image = UIImage(named: "delete")
        shareButton.configuration?.image = UIImage(named: "share")
        backgroundColor = Constants.blur_color
    }
    
    // MARK: - Button Helpers
    @objc func hidePost() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.hideButton.imageView?.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0, animations: {() -> Void in
                self.hideButton.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })

        if post.isHidden() {
            post.setHidden(bool: false)
            hideButton.configuration?.image = UIImage(named: "shown")
        } else {
            post.setHidden(bool: true)
            hideButton.configuration?.image = UIImage(named: "hidden")
        }
    }
    
    @objc private func deletePost() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let redoAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] action in
            guard let `self` = self else { return }
            DatabaseManager.deletePost(with: self.post, userID: self.post.user, completion: { success in
                if success {
                    let homeVC = HomeVC(initialPopup: false)
                    let nav = UINavigationController(rootViewController: homeVC)
                    nav.modalPresentationStyle = .fullScreen
                    self.parentVC.present(nav, animated: true)
                } else {
                    let alert = UIAlertController(title: "Unable to remove the post", message: "Please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self.parentVC.present(alert, animated: true)
                }
            })
        })
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this post? This cannot be undone.", preferredStyle: .actionSheet)
        alert.addAction(redoAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        parentVC.present(alert, animated: true)
    }
}

