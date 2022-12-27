//
//  MemsCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

import UIKit

class MemsCollectionViewCell: UICollectionViewCell {
    // ------------ Fields (View) ------------
    var date_lbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // ------------ Fields (Data) ------------
    private var parent_vc: UIViewController? = nil
    private var post: Post? = nil
    
    // ------------ Functions ------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        layer.cornerRadius = Constants.mems_cell_corner
        
        addSubview(date_lbl)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        date_lbl.text = text
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            date_lbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            date_lbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
