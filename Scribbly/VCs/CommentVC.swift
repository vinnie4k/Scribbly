//
//  CommentVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/20/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: CommentVC
class CommentVC: UIViewController, UITextFieldDelegate, CommentDelegate {
    // MARK: - For zooming in
    private let zoomImg = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "comments"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var replyCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
         
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        cv.backgroundColor = bgColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.addSubview(refreshControl)
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    private lazy var textField: UITextField = {
        let txt_field = UITextField()
        txt_field.placeholder = "add a comment as @" + mainUser.getUserName()
        txt_field.textColor = .label
        txt_field.font = Constants.getFont(size: 16, weight: .regular)
        txt_field.tintColor = .label
        txt_field.delegate = self
        txt_field.addTarget(self, action: #selector(changeSendButtonColor), for: UIControl.Event.editingChanged)
        txt_field.keyboardType = UIKeyboardType.twitter
        txt_field.translatesAutoresizingMaskIntoConstraints = false
        return txt_field
    }()
    
    private lazy var profileImage: UIImageView = {
        let img = UIImageView(image: mainUser.getPFP())
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.post_cell_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var commentButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.image = UIImage(named: "comment_send_gray")
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
            gradient = GradientView(colors: [UIColor(red: 1, green: 1, blue: 1, alpha: 0.1),Constants.secondary_color], locations: [0,0.3,1])
        }
        gradient.translatesAutoresizingMaskIntoConstraints = false
        return gradient
    }()
    
    private lazy var textInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.comment_input_corner

        view.addSubview(gradient)
        view.addSubview(textField)
        view.addSubview(profileImage)
        view.addSubview(commentButton)

        NSLayoutConstraint.activate([
            gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradient.topAnchor.constraint(equalTo: view.topAnchor),
            gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.comment_input_pfp_side),
            profileImage.widthAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),
            profileImage.heightAnchor.constraint(equalToConstant: 2 * Constants.post_cell_pfp_radius),

            textField.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: Constants.comment_input_txt_side),

            commentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.comment_input_pfp_side),
            commentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.comment_input_pfp_top2),
            commentButton.widthAnchor.constraint(equalToConstant: 2 * Constants.comment_input_btn_radius),
            commentButton.heightAnchor.constraint(equalToConstant: 2 * Constants.comment_input_btn_radius),
        ])
        return view
    }()
    
    private lazy var drawViewLarge: UIView = {
        let view = UIView()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        if (traitCollection.userInterfaceStyle == .light) {
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = view.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reduceImage))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        view.addSubview(customBlurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshComments), for: .valueChanged)
        return refresh
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    // MARK: - Properties (data)
    private let post: Post
    private let mainUser: User
    private var bgColor: UIColor?
    private var change: [NSLayoutConstraint]
    private var prevComment: Comment? = nil
    private var prevReply: Reply? = nil
    weak var reloadStatsDelegate: ReloadStatsDelegate?
    private var comments: [Comment]
    
    // MARK: - Backend Helpers
    @objc private func refreshComments() {
        DatabaseManager.getComments(with: post.id, completion: { [weak self] dict in
            guard let `self` = self else { return }
            self.post.comments = dict
            self.comments = self.post.getComments()
            self.replyCV.reloadData()
            self.reloadStatsDelegate?.reloadStats()
            self.refreshControl.endRefreshing()
        })
    }
    
    private func loadComments() {
       self.replyCV.reloadData()
       self.reloadStatsDelegate?.reloadStats()
       self.spinner.stopAnimating()
    }
    
    // MARK: - viewDidLoad, viewWillDisappear, init, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgColor = Constants.secondary_color
        
        view.backgroundColor = bgColor
        title = "comments"
               
        hideKeyboardWhenTappedAround()  // For dismissing keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(replyCV)
        view.addSubview(textInputView)
        view.addSubview(drawViewLarge)
        view.addSubview(spinner)
        
        setupNavBar()
        setupConstraints()
    
        spinner.startAnimating()
        DatabaseManager.getComments(with: post.id, completion: { [weak self] dict in
            guard let `self` = self else { return }
            self.post.comments = dict
            self.comments = self.post.getComments()
            self.setupCollectionView()
            self.spinner.stopAnimating()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(post: Post, mainUser: User) {
        self.post = post
        self.mainUser = mainUser
        self.bgColor = nil
        self.change = []
        self.comments = post.getComments()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            replyCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.comment_cv_top_padding),
            replyCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.comment_cv_side_padding),
            replyCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.comment_cv_side_padding),
            replyCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.comment_cv_bot_padding),
            
            textInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            drawViewLarge.topAnchor.constraint(equalTo: view.topAnchor),
            drawViewLarge.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawViewLarge.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawViewLarge.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        addConstr(lst: [
            textInputView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            textInputView.heightAnchor.constraint(equalToConstant: Constants.comment_input_height_gradient),
            
            profileImage.topAnchor.constraint(equalTo: textInputView.topAnchor, constant: Constants.comment_input_pfp_top),
            textField.trailingAnchor.constraint(equalTo: textInputView.trailingAnchor, constant: -Constants.comment_input_pfp_side)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 0.0
        }, completion: nil)
        drawViewLarge.subviews[1].removeFromSuperview()
    }
    
    func deleteComment(comment: Comment) {
        // For delegation
        spinner.startAnimating()
        DatabaseManager.removeComment(with: comment, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.post.removeComment(key: key)
                self.comments = self.post.getComments()
                self.loadComments()
            } else {
                self.spinner.stopAnimating()
                self.deleteError()
            }
        })
    }
    
    func sendReplyReply(comment: Comment, reply: Reply) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        // For delegation
        textField.becomeFirstResponder()
        textField.text = "@" + reply.getReplyUser().getUserName() + " "
        prevComment = comment
        prevReply = reply
    }
        
    func sendReplyComment(comment: Comment) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        // For delegation
        textField.becomeFirstResponder()
        textField.text = "@" + comment.getUser().getUserName() + " "
        prevComment = comment
        prevReply = nil
    }
    
    @objc private func sendComment() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        spinner.startAnimating()
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        format.timeZone = TimeZone(identifier: "America/New_York")

        if let text = textField.text, !text.isEmpty {
            if prevComment != nil, prevReply != nil {
                let username = "@" + (prevReply?.getReplyUser().getUserName())! + " "
                let commentKey = post.comments?.allKeys(forValue: prevComment!)[0]
                
                if text.contains(username) {
                    let length = (prevReply?.getReplyUser().getUserName().count)! + 2
                    let index = text.index(text.startIndex, offsetBy: length)
                    let rep = text[index...]
                    
                    let reply = Reply(id: UUID().uuidString, prevReply: prevReply!.id, user: mainUser.id, text: username + String(rep), time: format.string(from: Date()))
                    DatabaseManager.addReply(with: reply, comment: prevComment!, key: commentKey!, completion: { [weak self] success, key in
                        guard let `self` = self else { return }
                        if success {
                            self.prevComment?.addReply(key: key, reply: reply)
                            self.refreshComments()
                            self.spinner.stopAnimating()
                        } else {
                            self.spinner.stopAnimating()
                            self.uploadError()
                        }
                    })
                    
                } else {
                    let reply = Reply(id: UUID().uuidString, prevReply: prevReply!.id, user: mainUser.id, text: username + text, time: format.string(from: Date()))
                    DatabaseManager.addReply(with: reply, comment: prevComment!, key: commentKey!, completion: { [weak self] success, key in
                        guard let `self` = self else { return }
                        if success {
                            self.prevComment?.addReply(key: key, reply: reply)
                            self.refreshComments()
                            self.spinner.stopAnimating()
                        } else {
                            self.spinner.stopAnimating()
                            self.uploadError()
                        }
                    })
                }
                prevComment = nil  // Set back to nil
                prevReply = nil    // Set back to nil
            } else if prevComment != nil {
                let username = "@" + (prevComment?.getUser().getUserName())! + " "
                let commentKey = post.comments?.allKeys(forValue: prevComment!)[0]
                
                if text.contains(username) {
                    let length = (prevComment?.getUser().getUserName().count)! + 2
                    let index = text.index(text.startIndex, offsetBy: length)
                    let rep = text[index...]
                    
                    let reply = Reply(id: UUID().uuidString, prevReply: "", user: mainUser.id, text: username + String(rep), time: format.string(from: Date()))
                    DatabaseManager.addReply(with: reply, comment: prevComment!, key: commentKey!, completion: { [weak self] success, key in
                        guard let `self` = self else { return }
                        if success {
                            self.prevComment?.addReply(key: key, reply: reply)
                            self.refreshComments()
                            self.spinner.stopAnimating()
                        } else {
                            self.spinner.stopAnimating()
                            self.uploadError()
                        }
                    })
                    
                } else {
                    let reply = Reply(id: UUID().uuidString, prevReply: "", user: mainUser.id, text: username + text, time: format.string(from: Date()))
                    DatabaseManager.addReply(with: reply, comment: prevComment!, key: commentKey!, completion: { [weak self] success, key in
                        guard let `self` = self else { return }
                        if success {
                            self.prevComment?.addReply(key: key, reply: reply)
                            self.refreshComments()
                            self.spinner.stopAnimating()
                        } else {
                            self.spinner.stopAnimating()
                            self.uploadError()
                        }
                    })
                }
                prevComment = nil  // Set back to nil
            } else {
                let format = DateFormatter()
                format.dateFormat = "d MMMM yyyy HH:mm:ss"
                format.timeZone = TimeZone(identifier: "America/New_York")
                
                let cmt = Comment(id: UUID().uuidString, post: post.id, user: mainUser.id, text: text, time: format.string(from: Date()), replies: [:])
                DatabaseManager.addComment(with: cmt, completion: { [weak self] success, key in
                    guard let `self` = self else { return }
                    if success {
                        self.post.addComment(key: key, comment: cmt)
                        self.comments = self.post.getComments()
                        self.loadComments()
                        self.spinner.stopAnimating()
                    } else {
                        self.spinner.stopAnimating()
                        self.uploadError()
                    }
                })
                
            }
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.hideKeyboard()
                self.textField.text = ""
            }
        }
    }
    
    @objc private func changeSendButtonColor(sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            commentButton.isUserInteractionEnabled = true
            commentButton.configuration?.image = UIImage(named: "comment_send")
        } else {
            commentButton.isUserInteractionEnabled = false
            commentButton.configuration?.image = UIImage(named: "comment_send_gray")
        }
    }
    
    @objc private func popVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        navigationController?.navigationBar.layer.zPosition = 0
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    private func uploadError() {
        let alert = UIAlertController(title: "Error", message: "Unable to post the comment. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    private func deleteError() {
        let alert = UIAlertController(title: "Error", message: "Unable to delete the comment. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    private func changeCommentView(pop: Bool) {
        if (pop) { // Keyboard pops up
            textInputView.backgroundColor = UIColor(named: "comment_input")

            gradient.isHidden = true
            commentButton.isHidden = false

            addConstr(lst: [
                textInputView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: Constants.comment_input_pfp_top2),
                textInputView.heightAnchor.constraint(equalToConstant: Constants.comment_input_height_normal),
                
                profileImage.topAnchor.constraint(equalTo: textInputView.topAnchor, constant: Constants.comment_input_pfp_top2),
                                
                textField.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -Constants.comment_input_pfp_side)
            ])
        } else {
            prevComment = nil
            prevReply =  nil
//            textField.text = ""
            commentButton.isUserInteractionEnabled = false
            commentButton.configuration?.image = UIImage(named: "comment_send_gray")
            
            textInputView.backgroundColor = .none
            commentButton.isHidden = true
            gradient.isHidden = false

            addConstr(lst: [
                textInputView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
                textInputView.heightAnchor.constraint(equalToConstant: Constants.comment_input_height_gradient),
                
                profileImage.topAnchor.constraint(equalTo: textInputView.topAnchor, constant: Constants.comment_input_pfp_top),
                
                textField.trailingAnchor.constraint(equalTo: textInputView.trailingAnchor, constant: -Constants.comment_input_pfp_side),
            ])
        }
    }
    
    private func setupCollectionView() {
        replyCV.delegate = self
        replyCV.dataSource = self
        replyCV.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: CommentCollectionViewCell.reuseIdentifier)
        replyCV.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.reuseIdentifier)
        replyCV.register(DrawingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DrawingHeaderView.reuseIdentifier)
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        // PLEASE DO NOT TOUCH THIS
        let height: CGFloat = 99999
        let size = CGSize(width: Constants.comment_cell_text_width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: Constants.getFont(size: 16, weight: .regular)]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}

// MARK: - Extension: UICollectionViewDataSource
extension CommentVC: UICollectionViewDataSource {
    // MARK: - Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comments.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DrawingHeaderView.reuseIdentifier, for: indexPath) as? DrawingHeaderView {
                header.configure(drawing: post.getDrawing())
                header.enlargeDrawingDelegate = self
                return header
            }
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommentHeaderView.reuseIdentifier, for: indexPath) as? CommentHeaderView {
                header.backgroundColor = Constants.primary_color
                header.layer.cornerRadius = Constants.comment_cell_corner
                let comment = comments[indexPath.section - 1]
                header.configure(parentVC: self, comment: comment, mainUser: mainUser)
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
        let text = comments[section - 1].getText()
        height = estimateFrameForText(text: text).height + padding
        return CGSize(width: Constants.comment_cell_text_width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.comment_cv_spacing
    }
    
    // MARK: - Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return comments[section - 1].getReplies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section != 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.reuseIdentifier, for: indexPath) as? CommentCollectionViewCell {
                let comment = comments[indexPath.section - 1]
                let rep = comment.getReplies()[indexPath.row]
                cell.backgroundColor = Constants.primary_color
                cell.layer.cornerRadius = Constants.comment_cell_corner
                cell.configure(parentVC: self, comment: comment, reply: rep, mainUser: mainUser)
                cell.replyDelegate = self
                return cell
            }
        }
        return UICollectionViewListCell()
    }
}

// MARK: - Extension: UICollectionViewDelegateFlowLayout
extension CommentVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: Constants.post_cell_drawing_width, height: Constants.post_cell_drawing_height)
        } else {
            // PLEASE DO NOT TOUCH THIS
            var height: CGFloat = 999
            let padding: CGFloat = 65
            let rep = comments[indexPath.section - 1].getReplies()[indexPath.row].getText()
            height = estimateFrameForText(text: rep.string).height + padding
            return CGSize(width: Constants.comment_cell_reply_box_width, height: height)
        }
    }
}

// MARK: - Extension: UICollectionViewDelegate
extension CommentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let comment = self.comments[indexPath.section - 1]
            let rep = comment.getReplies()[indexPath.row]
            
            let copyAction =
                UIAction(title: NSLocalizedString("Copy", comment: "")) { action in
                    UIPasteboard.general.string = rep.getText().string
                }
            
            if (rep.getReplyUser() === self.mainUser) {
                let deleteAction =
                    UIAction(title: NSLocalizedString("Delete", comment: ""),
                             image: UIImage(systemName: "trash"),
                             attributes: .destructive) { [self] action in
                        
                        spinner.startAnimating()
                        let commentKey = post.comments?.allKeys(forValue: comment)[0]
                        DatabaseManager.removeReply(with: rep, comment: comment, key: commentKey!, completion: { [weak self] success, key in
                            guard let `self` = self else { return }
                            if success {
                                comment.removeReply(key: key)
                                self.comments = self.post.getComments()
                                self.loadComments()
                            } else {
                                self.spinner.stopAnimating()
                                self.deleteError()
                            }
                        })
                    }
                return UIMenu(title: "", children: [copyAction, deleteAction])
            }
            return UIMenu(title: "", children: [copyAction])
        }
    }
}

// MARK: - Other Extensions and Delegation
extension CommentVC: EnlargeDrawingDelegate, UIScrollViewDelegate {
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
    
    // MARK: - EnlargeDrawingDelegate and UIScrollViewDelegate
    func enlargeDrawing(drawing: UIImage) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding, height: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.15
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: Constants.post_cell_drawing_corner).cgPath
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        zoomImg.image = drawing
        zoomImg.frame = outerView.bounds
        
        let scroll = UIScrollView()
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 6.0
        scroll.delegate = self
        scroll.frame = CGRectMake(0, 0, zoomImg.frame.width, zoomImg.frame.height)
        scroll.alwaysBounceVertical = false
        scroll.alwaysBounceHorizontal = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.layer.cornerRadius = Constants.post_cell_drawing_corner
        scroll.flashScrollIndicators()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(zoomImg)
        
        outerView.addSubview(scroll)
                
        drawViewLarge.addSubview(outerView)
        
        NSLayoutConstraint.activate([
            zoomImg.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            zoomImg.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            scroll.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            scroll.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            outerView.centerYAnchor.constraint(equalTo: drawViewLarge.centerYAnchor),
            outerView.centerXAnchor.constraint(equalTo: drawViewLarge.centerXAnchor),
            outerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            outerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImg
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(0, animated: true)
    }
}
