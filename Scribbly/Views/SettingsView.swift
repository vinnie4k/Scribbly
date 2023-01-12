//
//  SettingsView.swift
//  Scribbly
//
//  Created by Vin Bui on 1/11/23.
//

import UIKit

// MARK: SettingsView
class SettingsView: UIView {
    // MARK: - Properties (view)
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.tintColor = .label
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let textLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 17, weight: .medium)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let rightArrow: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "chevron.right"))
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.tintColor = .label
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(imgView)
        addSubview(textLabel)
        addSubview(rightArrow)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: Constants.settings_stack_height).isActive = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, text: String) {
        imgView.image = image
        textLabel.text = text
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10),
            rightArrow.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
