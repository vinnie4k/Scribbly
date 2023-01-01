//
//  EditProfilePictureView.swift
//  Scribbly
//
//  Created by Vin Bui on 12/31/22.
//

import UIKit

// MARK: EditProfilePictureView
class EditProfilePictureView: UIView {
    // MARK: - Properties (view)
    let profileImage: UIImageView = {
        let img = UIImageView()
        img.alpha = 0.5
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 0.5 * 2 * Constants.prof_pfp_radius
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let pencilImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImage)
        addSubview(pencilImage)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(mode: UIUserInterfaceStyle, mainUser: User) {
        profileImage.image = mainUser.getPFP()
        pencilImage.image = UIImage(named: "pencil_dark")
        if mode == .light {
            pencilImage.image = UIImage(named: "pencil_light")
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: Constants.edit_prof_pfp_radius * 2),
            profileImage.heightAnchor.constraint(equalToConstant: Constants.edit_prof_pfp_radius * 2),
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileImage.topAnchor.constraint(equalTo: self.topAnchor),
            profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            pencilImage.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor),
            pencilImage.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }
}
