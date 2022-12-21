//
//  CommentVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/20/22.
//

import UIKit

class CommentVC: UIViewController {

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
        if (traitCollection.userInterfaceStyle == .light) {
            config.baseBackgroundColor = Constants.comment_light_bg
        } else if (traitCollection.userInterfaceStyle == .dark) {
            config.baseBackgroundColor = Constants.comment_dark_bg
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.image = post.getDrawing()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.comment_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var comments_tv: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // ------------ Fields (data) ------------
    private let post: Post
    private var comments: [Comment]
    private let main_user: User
    
    // ------------ Functions ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        if (traitCollection.userInterfaceStyle == .light) {
            view.backgroundColor = Constants.comment_light_bg
        } else if (traitCollection.userInterfaceStyle == .dark) {
            view.backgroundColor = Constants.comment_dark_bg
        }
        title = "comments"
        
        view.addSubview(drawing)
        view.addSubview(comments_tv)
        
        setupTableView()
        setupNavBar()
        setupConstraints()
    }
    
    init(post: Post, main_user: User) {
        self.post = post
        self.main_user = main_user
        self.comments = post.getComments()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        comments_tv.dataSource = self
        comments_tv.delegate = self
        comments_tv.register(CommentTableViewCell.self, forCellReuseIdentifier: Constants.comment_reuse)
        comments_tv.estimatedRowHeight = UITableView.automaticDimension
        comments_tv.estimatedSectionHeaderHeight = UITableView.automaticDimension
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavBar() {
        navigationItem.titleView = title_lbl
        back_btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_btn)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawing.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.comment_drawing_top_padding),
            drawing.widthAnchor.constraint(equalToConstant: Constants.comment_drawing_width),
            drawing.heightAnchor.constraint(equalToConstant: Constants.comment_drawing_height),
            
            comments_tv.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.comment_tv_top_padding),
            comments_tv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.comment_tv_side_padding),
            comments_tv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.comment_tv_side_padding),
            comments_tv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension CommentVC: UITableViewDelegate {
    // TODO: didSelectItemAt
}

extension CommentVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CommentHeaderView()
        if (traitCollection.userInterfaceStyle == .light) {
            view.backgroundColor = Constants.comment_cell_light
        } else if (traitCollection.userInterfaceStyle == .dark) {
            view.backgroundColor = Constants.comment_cell_dark
        }
        view.layer.cornerRadius = Constants.comment_cell_corner
        let comment = comments[section]
        view.configure(text: comment.getText(), user: comment.getUser(), vc: self)
//        view.configure(text: comment.getText(), user: main_user, vc: self)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments[section].getReplies().count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.comment_reuse, for: indexPath) as? CommentTableViewCell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
