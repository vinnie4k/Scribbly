//
//  BookmarksCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/30/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: BookmarksCollectionViewCell
class BookmarksCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties (view)
    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.books_cell_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(enlargePost))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "BookmarksCollectionViewCellReuse"
    private var post: Post!
    weak var postInfoDelegate: PostInfoDelegate!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(drawing)
                
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post) {
        self.post = post
        print(self.post.user)
        drawing.image = post.getDrawing()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            drawing.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            drawing.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            drawing.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
    
    // MARK: - Button Helpers
    @objc func enlargePost() {
        postInfoDelegate.showBooksInfo(post: post)
    }
}
