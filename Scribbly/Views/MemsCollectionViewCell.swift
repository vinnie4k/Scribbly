//
//  MemsCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

import UIKit

class MemsCollectionViewCell: UICollectionViewCell {
    // ------------ Fields (View) ------------
    private let date_lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.mems_date_font
        lbl.tintColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.mems_cell_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
//        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(toggleStats))
//        img.addGestureRecognizer(tap_gesture)
//        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    // ------------ Fields (Data) ------------
    private var parent_vc: UIViewController? = nil
    private var post: Post? = nil
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = Constants.mems_cell_corner
        
        addSubview(drawing)
        addSubview(date_lbl)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post?, text: String) {
        self.post = post
        
        if post == nil {
            backgroundColor = .systemBackground
        } else {
            drawing.image = post?.getDrawing()
        }
        date_lbl.text = text
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            drawing.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            drawing.topAnchor.constraint(equalTo: self.topAnchor),
            drawing.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            date_lbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            date_lbl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear all content based views and their actions here
        drawing.image = nil
        date_lbl.text = ""
    }
}
