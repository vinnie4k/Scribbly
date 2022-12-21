//
//  CommentTableViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/21/22.
//

import UIKit

class CommentHeaderView: UIView {
    // ------------ Fields (View) ------------
    private let user_pfp: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.comment_cell_pfp_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let display_name: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.comment_cell_username_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let text: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.comment_cell_text_font
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let reply_btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("reply", for: .normal)
        btn.setTitleColor(Constants.reply_button_color, for: .normal)
        btn.titleLabel?.font = Constants.reply_button_font
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // ------------ Fields (Data) ------------
    private var parent_vc: UIViewController? = nil

    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(text)
        addSubview(display_name)
        addSubview(user_pfp)
        addSubview(reply_btn)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pushProfileVC() {
        let profile_vc = ProfileVC()
        parent_vc?.navigationController?.pushViewController(profile_vc, animated: true)
    }
    
    func configure(text: String, user: User, vc: UIViewController) {
        self.text.text = text
        display_name.text = user.getUserName()
        user_pfp.setImage(user.getPFP(), for: .normal)
        user_pfp.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        parent_vc = vc
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            user_pfp.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            user_pfp.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.comment_cell_side),
            user_pfp.widthAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
            user_pfp.heightAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
                        
            display_name.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            display_name.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.comment_cell_name_side),
            
            text.topAnchor.constraint(equalTo: display_name.bottomAnchor, constant: Constants.comment_cell_text_top),
            text.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.comment_cell_name_side),
            text.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.comment_cell_name_side),
            
            reply_btn.topAnchor.constraint(equalTo: text.bottomAnchor, constant: Constants.comment_cell_reply_top),
            reply_btn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.comment_cell_reply_bot),
            reply_btn.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.comment_cell_name_side),
        ])
    }
}

class CommentTableViewCell: UITableViewCell {
    
    // ------------ Fields (View) ------------
    private let user_pfp: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.comment_cell_pfp_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let display_name: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.comment_cell_username_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let text: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = Constants.comment_cell_text_font
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let reply_btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("reply", for: .normal)
        btn.setTitleColor(Constants.reply_button_color, for: .normal)
        btn.titleLabel?.font = Constants.reply_button_font
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // ------------ Fields (Data) ------------
    private var parent_vc: UIViewController? = nil
    
    // ------------ Functions ------------
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(text)
        addSubview(display_name)
        addSubview(user_pfp)
        addSubview(reply_btn)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pushProfileVC() {
        let profile_vc = ProfileVC()
        parent_vc?.navigationController?.pushViewController(profile_vc, animated: true)
    }
    
    func configure(text: String, user: User, vc: UIViewController) {
        self.text.text = text
        display_name.text = user.getUserName()
        user_pfp.setImage(user.getPFP(), for: .normal)
        user_pfp.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        parent_vc = vc
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            user_pfp.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            user_pfp.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.comment_cell_side),
            user_pfp.widthAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
            user_pfp.heightAnchor.constraint(equalToConstant: 2 * Constants.comment_cell_pfp_radius),
                        
            display_name.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.comment_cell_top),
            display_name.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.comment_cell_name_side),
            
            text.topAnchor.constraint(equalTo: display_name.bottomAnchor, constant: Constants.comment_cell_text_top),
            text.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.comment_cell_name_side),
            
            reply_btn.topAnchor.constraint(equalTo: text.bottomAnchor, constant: Constants.comment_cell_reply_top),
            reply_btn.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.comment_cell_name_side),
        ])
    }
}
