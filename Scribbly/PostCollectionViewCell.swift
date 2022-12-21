//
//  PostCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    // ------------ Fields (view) ------------
    private var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.layer.borderWidth = Constants.post_cell_drawing_border_width
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let like_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = .label
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
        config.image = UIImage(systemName: "text.bubble")
        config.baseForegroundColor = .label
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
        config.image = UIImage(systemName: "paperplane")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = UIColor(white: 1, alpha: 0)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let bookmark_btn: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.buttonSize = .medium
        config.image = UIImage(systemName: "text.book.closed")
        config.baseForegroundColor = .label
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
        view.layer.cornerRadius = Constants.post_cell_cap_view_corner
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var parent_vc: UIViewController? = nil
    
    // ------------ Fields (Data) ------------
    private var mode: UIUserInterfaceStyle? = nil
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(drawing)
        contentView.addSubview(stack)
        contentView.addSubview(caption_view)

        // Design
        self.backgroundColor = Constants.post_cell_bg_color
        self.layer.cornerRadius = Constants.post_cell_corner
        
        // Function Calls
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pushProfileVC() {
        let profile_vc = ProfileVC()
        parent_vc?.navigationController?.pushViewController(profile_vc, animated: true)
    }
    
    func configure(user: User, drawing: UIImage, caption: String, parent_vc: UIViewController, mode: UIUserInterfaceStyle) {
        self.caption_view.configure(caption: caption, user: user)
        self.drawing.image = drawing
        self.parent_vc = parent_vc
        self.mode = mode
        setMode(mode: mode)
    }
    
    func setMode(mode: UIUserInterfaceStyle) {
        self.mode = mode
        if (self.mode == .light) {
            self.drawing.layer.borderColor = Constants.post_cell_drawing_border_light.cgColor
            self.stack.backgroundColor = Constants.post_cell_drawing_border_light
            self.caption_view.backgroundColor = Constants.post_cell_cap_view_light
        } else if (self.mode == .dark) {
            self.drawing.layer.borderColor = Constants.post_cell_drawing_border_dark.cgColor
            self.stack.backgroundColor = Constants.post_cell_drawing_border_dark
            self.caption_view.backgroundColor = Constants.post_cell_cap_view_dark
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.post_cell_side_padding),
            drawing.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            drawing.heightAnchor.constraint(equalToConstant: Constants.post_cell_drawing_height),
            drawing.widthAnchor.constraint(equalToConstant: Constants.post_cell_drawing_width),
            
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            caption_view.bottomAnchor.constraint(equalTo: drawing.bottomAnchor, constant: -Constants.post_cell_cap_view_bot),
            caption_view.leadingAnchor.constraint(equalTo: drawing.leadingAnchor, constant: Constants.post_cell_cap_view_side),
            caption_view.widthAnchor.constraint(equalToConstant: Constants.post_cell_cap_view_width),
            caption_view.heightAnchor.constraint(equalToConstant: Constants.post_cell_cap_view_height),
        ])
    }
    
}

class CaptionView: UIView {
    private let user_pfp: UIButton = {
        let btn = UIButton()
//        btn.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
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
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(caption)
        addSubview(display_name)
        addSubview(user_pfp)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(caption: String, user: User) {
        self.caption.text = caption
        display_name.text = user.getUserName()
        user_pfp.setImage(user.getPFP(), for: .normal)
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
