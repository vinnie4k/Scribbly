//
//  HomeVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class HomeVC: UIViewController {
    
    // ------------ Fields (view) ------------
    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Scribbly"
        lbl.textColor = .none
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let prompt_heading: UILabel = {
        let lbl = UILabel()
        lbl.text = "Today's prompt"
        lbl.textColor = .none
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .light)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let prompt: UILabel = {
        let lbl = UILabel()
        // TODO: Create a function that changes the text
        lbl.text = "Bird"
        lbl.textColor = .none
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // Made lazy since property initializers run before 'self' is available
    private lazy var profile_btn: UIButton = {
        let btn = UIButton()
        btn.setImage(user.getPFP(), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.profile_button_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let post_cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // ------------ Fields (data) ------------
    
    // TODO: START REMOVE
    let vinnie_img = UIImage(named: "vinnie_pfp")
    // TODO: END REMOVE
    // TODO: Don't force unwrap image. Make a placeholder.
    // Made lazy since property initializers run before 'self' is available
    private lazy var user: User = User(pfp: vinnie_img!, full_name: "Vin Bui", user_name: "vinnie", bio: "I hate school")
    
    // TODO: START REMOVE
    private func createPosts() {
        let drawing1 = UIImage(named: "caitlyn_drawing")
        let drawing2 = UIImage(named: "piano")
        let post1 = Post(user: user, drawing: drawing1!, caption: "i drew this in middle school guys", likes: 5, time: Date())
        let post2 = Post(user: user, drawing: drawing2!, caption: "my piano is just in the corner now", likes: 5, time: Date())
        posts.append(post1)
        posts.append(post1)
        posts.append(post2)
    }
    // TODO: END REMOVE
    
    private var posts: [Post] = []
    
    // ------------ Functions ------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Add to view
        view.addSubview(logo)
        view.addSubview(prompt_heading)
        view.addSubview(prompt)
        view.addSubview(profile_btn)
        view.addSubview(post_cv)
        
        // Function Calls
        setupCollectionView()
        setupConstraints()
        // TODO: START REMOVE
        createPosts()
        // TODO: END REMOVE
    }
    
    private func setupCollectionView() {
        post_cv.delegate = self
        post_cv.dataSource = self
        post_cv.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: Constants.reuse)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: view.topAnchor, constant: Constants.border_top_padding),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.border_side_padding),
            
            prompt_heading.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: Constants.prompt_heading_top_padding),
            prompt_heading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            prompt.topAnchor.constraint(equalTo: prompt_heading.bottomAnchor, constant: Constants.prompt_top_padding),
            prompt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profile_btn.centerYAnchor.constraint(equalTo: view.topAnchor, constant: Constants.border_top_padding),
            profile_btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.border_side_padding),
            profile_btn.widthAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            profile_btn.heightAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            
            post_cv.topAnchor.constraint(equalTo: prompt.bottomAnchor, constant: Constants.post_cv_top_padding),
            post_cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.post_cv_side_padding),
            post_cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.post_cv_side_padding),
            post_cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeVC: UICollectionViewDelegate {
    // TODO: didSelectItemAt
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuse, for: indexPath) as?
            PostCollectionViewCell {
            let post = posts[indexPath.row]
            cell.configure(user: post.getUser(), drawing: post.getDrawing(), caption: post.getCaption())
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.post_container_width, height: Constants.post_container_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.post_container_spacing
    }
}
