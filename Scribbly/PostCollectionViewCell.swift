//
//  PostCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    // ------------ Fields (view) ------------
    private let user_pfp: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.profile_button_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let display_name: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .none
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let caption: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .none
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let like_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let comment_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.image = UIImage(systemName: "bubble.left")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let share_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.image = UIImage(systemName: "paperplane")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(user_pfp)
        contentView.addSubview(display_name)
        contentView.addSubview(caption)
        contentView.addSubview(drawing)
        contentView.addSubview(like_btn)
        contentView.addSubview(comment_btn)
        contentView.addSubview(share_btn)
        
        // Design
        self.backgroundColor = Constants.post_cell_bg_color
        self.layer.cornerRadius = Constants.post_cell_corner
        
        // Function Calls
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: User, drawing: UIImage, caption: String) {
        user_pfp.setImage(user.getPFP(), for: .normal)
        display_name.text = user.getFullName()
        self.caption.text = caption
        self.drawing.image = drawing
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            user_pfp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.post_cell_top_padding),
            user_pfp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.post_cell_side_padding),
            user_pfp.widthAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            user_pfp.heightAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            
            display_name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.post_cell_top_padding + 5),
            display_name.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.post_cell_name_side),
            
            caption.topAnchor.constraint(equalTo: display_name.bottomAnchor, constant: Constants.post_cell_caption_top),
            caption.leadingAnchor.constraint(equalTo: user_pfp.trailingAnchor, constant: Constants.post_cell_name_side),
            
            drawing.topAnchor.constraint(equalTo: user_pfp.bottomAnchor, constant: Constants.post_cell_drawing_top),
            drawing.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.post_cell_side_padding),
            drawing.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.post_cell_side_padding),
            drawing.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.post_cell_drawing_bot),
            
            like_btn.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_cell_btn_top),
            like_btn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.post_cell_side_padding),
            
            comment_btn.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_cell_btn_top),
            comment_btn.leadingAnchor.constraint(equalTo: like_btn.trailingAnchor, constant: Constants.post_cell_btn_side),
            
            share_btn.topAnchor.constraint(equalTo: drawing.bottomAnchor, constant: Constants.post_cell_btn_top),
            share_btn.leadingAnchor.constraint(equalTo: comment_btn.trailingAnchor, constant: Constants.post_cell_btn_side),
        ])
    }
    
}
