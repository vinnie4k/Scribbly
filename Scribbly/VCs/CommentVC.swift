//
//  CommentVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/20/22.
//

import UIKit

class CommentVC: UIViewController, UITextFieldDelegate, CommentDelegate {

    // ------------ Fields (view) ------------
    private let title_lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "comments"
        lbl.textColor = .label
        lbl.font = Constants.comment_title_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var back_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var reply_cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
         
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        cv.backgroundColor = bg_color
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var txt_field: UITextField = {
        let txt_field = UITextField()
        txt_field.placeholder = "add a comment as @" + main_user.getUserName()
        txt_field.textColor = .label
        txt_field.font = Constants.comment_cell_text_font
        txt_field.tintColor = .label
        txt_field.delegate = self
        txt_field.addTarget(self, action: #selector(changeSendButtonColor), for: UIControl.Event.editingChanged)
        txt_field.keyboardType = UIKeyboardType.twitter
        txt_field.translatesAutoresizingMaskIntoConstraints = false
        return txt_field
    }()
    
    private lazy var profile_img: UIImageView = {
        let img = UIImageView(image: main_user.getPFP())
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.post_cell_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var comment_btn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(named: "comment_send_gray")
        if (traitCollection.userInterfaceStyle == .dark) {
            config.image = UIImage(named: "comment_send_gray_dark")
            config.baseBackgroundColor = Constants.comment_input_dark
        } else if (traitCollection.userInterfaceStyle == .light) {
            config.image = UIImage(named: "comment_send_gray_light")
            config.baseBackgroundColor = Constants.comment_input_light
        }
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isUserInteractionEnabled = false
        btn.isHidden = true
        return btn
    }()
    
    private lazy var gradient: GradientView = {
        var gradient = GradientView(colors: [
            .clear,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4),
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.9),
            .black], locations: [0,0.2,0.5,1])
        if (traitCollection.userInterfaceStyle == . light) {
            gradient = GradientView(colors: [UIColor(red: 1, green: 1, blue: 1, alpha: 0.1),Constants.comment_light_bg], locations: [0,0.3,1])
        }
        gradient.translatesAutoresizingMaskIntoConstraints = false
        return gradient
    }()
    
    private lazy var input_view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.comment_input_corner

        view.addSubview(gradient)
        view.addSubview(txt_field)
        view.addSubview(profile_img)
        view.addSubview(comment_btn)

        NSLayoutConstraint.activate([
            gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradient.topAnchor.constraint(equalTo: view.topAnchor),
            gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            profile_img.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.comment_input_pfp_side),
            profile_img.widthAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),
            profile_img.heightAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),

            txt_field.centerYAnchor.constraint(equalTo: profile_img.centerYAnchor),
            txt_field.leadingAnchor.constraint(equalTo: profile_img.trailingAnchor, constant: Constants.comment_input_txt_side),

            comment_btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.comment_input_pfp_side),
            comment_btn.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.comment_input_pfp_top2),
            comment_btn.widthAnchor.constraint(equalToConstant: 2 * Constants.comment_input_btn_radius),
            comment_btn.heightAnchor.constraint(equalToConstant: 2 * Constants.comment_input_btn_radius),
        ])
        return view
    }()
    
    private lazy var draw_view_large: UIView = {
        let view = UIView()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        if (traitCollection.userInterfaceStyle == .light) {
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = view.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(reduceImage))
        view.addGestureRecognizer(tap_gesture)
        view.isUserInteractionEnabled = true
        
        view.addSubview(customBlurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    // ------------ Fields (data) ------------
    private let post: Post
    private let main_user: User
    private var bg_color: UIColor?
    private var change: [NSLayoutConstraint]
    private var prev_comment: Comment? = nil
    private var prev_reply: Reply? = nil
    var reload_stats_delegate: ReloadStatsDelegate?
    
    // ------------ Functions ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        if (traitCollection.userInterfaceStyle == .light) {
            bg_color = Constants.comment_light_bg
        } else if (traitCollection.userInterfaceStyle == .dark) {
            bg_color = Constants.comment_dark_bg
        }
        view.backgroundColor = bg_color
        title = "comments"
               
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(reply_cv)
        view.addSubview(input_view)
        view.addSubview(draw_view_large)
    
        setupCollectionView()
        setupNavBar()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(post: Post, main_user: User) {
        self.post = post
        self.main_user = main_user
        self.bg_color = nil
        self.change = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 0.0
        }, completion: nil)
        draw_view_large.subviews[1].removeFromSuperview()
//        self.navigationController?.navigationBar.toggle()
    }
    
    func deleteComment(comment: Comment) {
        // For delegation
        post.removeComment(comment: comment)
        reply_cv.reloadData()
        reload_stats_delegate?.reloadStats()
    }
    
    func sendReplyReply(comment: Comment, reply: Reply) {
        // For delegation
        txt_field.becomeFirstResponder()
        txt_field.text = "@" + reply.getReplyUser().getUserName() + " "
        prev_comment = comment
        prev_reply = reply
    }
        
    func sendReplyComment(comment: Comment) {
        // For delegation
        txt_field.becomeFirstResponder()
        txt_field.text = "@" + comment.getUser().getUserName() + " "
        prev_comment = comment
        prev_reply = nil
    }
    
    @objc private func sendComment() {
        if let text = txt_field.text, !text.isEmpty {
            if prev_comment != nil, prev_reply != nil {
                let username = "@" + (prev_reply?.getReplyUser().getUserName())! + " "
                
                if text.contains(username) {
                    let length = (prev_reply?.getReplyUser().getUserName().count)! + 2
                    let index = text.index(text.startIndex, offsetBy: length)
                    let rep = text[index...]
                    prev_comment?.addReply(text: String(rep), prev: prev_reply, reply_user: main_user)
                } else {
                    prev_comment?.addReply(text: text, prev: prev_reply, reply_user: main_user)
                }
                prev_comment = nil  // Set back to nil
                prev_reply = nil    // Set back to nil
            } else if prev_comment != nil {
                let username = "@" + (prev_comment?.getUser().getUserName())! + " "
                
                if text.contains(username) {
                    let length = (prev_comment?.getUser().getUserName().count)! + 2
                    let index = text.index(text.startIndex, offsetBy: length)
                    let rep = text[index...]
                    prev_comment?.addReply(text: String(rep), prev: nil, reply_user: main_user)
                } else {
                    prev_comment?.addReply(text: text, prev: nil, reply_user: main_user)
                }
                prev_comment = nil  // Set back to nil
            } else {
                post.addComment(comment_user: main_user, text: text)
            }
            hideKeyboard()
            txt_field.text = ""
            reply_cv.reloadData()
            reload_stats_delegate?.reloadStats()
        }
    }
    
    @objc private func changeSendButtonColor(sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            comment_btn.isUserInteractionEnabled = true
            if (traitCollection.userInterfaceStyle == .dark) {
                comment_btn.configuration?.image = UIImage(named: "comment_send_white")
            } else if (traitCollection.userInterfaceStyle == .light) {
                comment_btn.configuration?.image = UIImage(named: "comment_send_black")
            }
        } else {
            comment_btn.isUserInteractionEnabled = false
            if (traitCollection.userInterfaceStyle == .dark) {
                comment_btn.configuration?.image = UIImage(named: "comment_send_gray_dark")
            } else if (traitCollection.userInterfaceStyle == .light) {
                comment_btn.configuration?.image = UIImage(named: "comment_send_gray_light")
            }
        }
    }
    
    private func changeCommentView(pop: Bool) {
        if (pop) { // Keyboard pops up
            if (traitCollection.userInterfaceStyle == .dark) {
                input_view.backgroundColor = Constants.comment_input_dark
            } else if (traitCollection.userInterfaceStyle == .light) {
                input_view.backgroundColor = Constants.comment_input_light
            }
            gradient.isHidden = true
            comment_btn.isHidden = false

            addConstr(lst: [
                input_view.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: Constants.comment_input_pfp_top2),
                input_view.heightAnchor.constraint(equalToConstant: Constants.comment_input_height_normal),
                
                profile_img.topAnchor.constraint(equalTo: input_view.topAnchor, constant: Constants.comment_input_pfp_top2),
                                
                txt_field.trailingAnchor.constraint(equalTo: comment_btn.leadingAnchor, constant: -Constants.comment_input_pfp_side)
            ])
        } else {
            prev_comment = nil
            prev_reply =  nil
            txt_field.text = ""
            comment_btn.isUserInteractionEnabled = false
            if (traitCollection.userInterfaceStyle == .dark) {
                comment_btn.configuration?.image = UIImage(named: "comment_send_gray_dark")
            } else if (traitCollection.userInterfaceStyle == .light) {
                comment_btn.configuration?.image = UIImage(named: "comment_send_gray_light")
            }
            
            input_view.backgroundColor = .none
            comment_btn.isHidden = true
            gradient.isHidden = false

            addConstr(lst: [
                input_view.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
                input_view.heightAnchor.constraint(equalToConstant: Constants.comment_input_height_gradient),
                
                profile_img.topAnchor.constraint(equalTo: input_view.topAnchor, constant: Constants.comment_input_pfp_top),
                
                txt_field.trailingAnchor.constraint(equalTo: input_view.trailingAnchor, constant: -Constants.comment_input_pfp_side),
            ])
        }
    }
    
    private func setupCollectionView() {
        reply_cv.delegate = self
        reply_cv.dataSource = self
        reply_cv.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: Constants.reply_reuse)
        reply_cv.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.comment_reuse)
        reply_cv.register(DrawingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.drawing_reuse)
    }
    
    @objc private func popVC() {
        navigationController?.navigationBar.layer.zPosition = 0
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavBar() {
        navigationItem.titleView = title_lbl
        back_btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_btn)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            reply_cv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.comment_cv_top_padding),
            reply_cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.comment_cv_side_padding),
            reply_cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.comment_cv_side_padding),
            reply_cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.comment_cv_bot_padding),
            
            input_view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            input_view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            draw_view_large.topAnchor.constraint(equalTo: view.topAnchor),
            draw_view_large.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            draw_view_large.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            draw_view_large.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        addConstr(lst: [
            input_view.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            input_view.heightAnchor.constraint(equalToConstant: Constants.comment_input_height_gradient),
            
            profile_img.topAnchor.constraint(equalTo: input_view.topAnchor, constant: Constants.comment_input_pfp_top),
            txt_field.trailingAnchor.constraint(equalTo: input_view.trailingAnchor, constant: -Constants.comment_input_pfp_side)
        ])
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        // PLEASE DO NOT TOUCH THIS
        let height: CGFloat = 99999
        let size = CGSize(width: Constants.comment_cell_text_width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: Constants.comment_cell_text_font]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}

extension CommentVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        }
        return post.getComments()[section - 1].getReplies().count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return post.getComments().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section != 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reply_reuse, for: indexPath) as? CommentCollectionViewCell {
                let comment = post.getComments()[indexPath.section - 1]
                let rep = comment.getReplies()[indexPath.row]
                if (traitCollection.userInterfaceStyle == .light) {
                    cell.backgroundColor = Constants.comment_cell_light
                } else if (traitCollection.userInterfaceStyle == .dark) {
                    cell.backgroundColor = Constants.comment_cell_dark
                }
                cell.layer.cornerRadius = Constants.comment_cell_corner
                cell.configure(parentVC: self, comment: comment, reply: rep)
                cell.replyDelegate = self
                return cell
            }
        }
        return UICollectionViewListCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.drawing_reuse, for: indexPath) as? DrawingHeaderView {
                header.configure(drawing: post.getDrawing())
                header.enlargeDrawingDelegate = self
                return header
            }
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.comment_reuse, for: indexPath) as? CommentHeaderView {
                if (traitCollection.userInterfaceStyle == .light) {
                    header.backgroundColor = Constants.comment_cell_light
                } else if (traitCollection.userInterfaceStyle == .dark) {
                    header.backgroundColor = Constants.comment_cell_dark
                }
                header.layer.cornerRadius = Constants.comment_cell_corner
                let comment = post.getComments()[indexPath.section - 1]
                header.configure(parentVC: self, comment: comment, mainUser: main_user)
                header.commentDelegate = self
                return header
            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (section == 0) {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: Constants.comment_cv_spacing, left: Constants.comment_cell_reply_side, bottom: Constants.comment_cv_spacing, right: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // PLEASE DO NOT TOUCH THIS
        if (section == 0) {
            return CGSize(width: Constants.comment_drawing_width, height: Constants.comment_drawing_height + 2 * Constants.comment_drawing_top_padding)
        }
        var height: CGFloat = 999
        let padding: CGFloat = 65
        let text = post.getComments()[section - 1].getText()
        height = estimateFrameForText(text: text).height + padding
        return CGSize(width: Constants.comment_cell_text_width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.comment_cv_spacing
    }
}

extension CommentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: Constants.post_cell_drawing_width, height: Constants.post_cell_drawing_height)
        } else {
            // PLEASE DO NOT TOUCH THIS
            var height: CGFloat = 999
            let padding: CGFloat = 65
            let rep = post.getComments()[indexPath.section - 1].getReplies()[indexPath.row].getText()
            height = estimateFrameForText(text: rep.string).height + padding
            return CGSize(width: Constants.comment_cell_reply_box_width, height: height)
        }
    }
}

extension CommentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let comment = self.post.getComments()[indexPath.section - 1]
            let rep = comment.getReplies()[indexPath.row]
            
            let copyAction =
                UIAction(title: NSLocalizedString("Copy", comment: "")) { action in
                    UIPasteboard.general.string = rep.getText().string
                }
            
            if (rep.getReplyUser() === self.main_user) {
                let deleteAction =
                    UIAction(title: NSLocalizedString("Delete", comment: ""),
                             image: UIImage(systemName: "trash"),
                             attributes: .destructive) { [self] action in

                        comment.removeReply(reply: rep)
                        self.reload_stats_delegate?.reloadStats()
                        self.reply_cv.reloadData()
                    }
                return UIMenu(title: "", children: [copyAction, deleteAction])
            }
            return UIMenu(title: "", children: [copyAction])
        }
    }
}

extension CommentVC {
    private func addConstr(lst: [NSLayoutConstraint]) {
        // Deactivates all the old constraints in the list
        // Activate the new constraints and add to the list
        for constr in change {
            constr.isActive = false
        }
        for i in lst {
            i.isActive = true
            change.append(i)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        changeCommentView(pop: true)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        changeCommentView(pop: false)
    }
}

extension CommentVC: EnlargeDrawingDelegate {
    func enlargeDrawing(drawing: UIImage) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding, height: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.15
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: Constants.post_cell_drawing_corner).cgPath
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImageView(image: drawing)
        img.frame = outerView.bounds
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        outerView.addSubview(img)
        
        draw_view_large.addSubview(outerView)
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            img.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            outerView.centerYAnchor.constraint(equalTo: draw_view_large.centerYAnchor),
            outerView.centerXAnchor.constraint(equalTo: draw_view_large.centerXAnchor),
            outerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            outerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 1.0
        }, completion: nil)
//        self.navigationController?.navigationBar.toggle()
    }
}
