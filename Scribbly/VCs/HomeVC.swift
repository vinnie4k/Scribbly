//
//  HomeVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class HomeVC: UIViewController {
    // ------------ Fields (view) ------------
    private lazy var user_post: UIImageView = {
        let img = UIImageView()
        if (user.getPosts().count != 0) {
            img.image = user.getLatestPost().getDrawing()
        } else {
            img.image = UIImage(systemName: "plus.app")
        }
        img.tintColor = .label
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.user_post_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var friends_btn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "person.2.fill")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "scribbly"
        lbl.textColor = .label
        lbl.font = Constants.logo_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let prompt_heading: UILabel = {
        let lbl = UILabel()
        lbl.text = "today's prompt"
        lbl.textColor = .label
        lbl.font = Constants.prompt_heading_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let prompt: UILabel = {
        let lbl = UILabel()
        // TODO: Create a function that changes the text
        lbl.text = "bird"
        lbl.textColor = .label
        lbl.font = Constants.prompt_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var profile_btn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
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
    
    private lazy var draw_view_large: UIView = {
        let view = UIView()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        if (traitCollection.userInterfaceStyle == .light) {
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(reduceImage))
        view.addGestureRecognizer(tap_gesture)
        view.isUserInteractionEnabled = true
        
        view.addSubview(blurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    // TODO: START REMOVE
    let vinnie_img = UIImage(named: "vinnie_pfp")
    // TODO: END REMOVE
    // TODO: Don't force unwrap image. Make a placeholder.
    // Made lazy since property initializers run before 'self' is available
    private lazy var user: User = User(pfp: vinnie_img!, full_name: "Vin Bui", user_name: "vinnie", bio: "I hate school")
    
    // TODO: START REMOVE
    private func createPosts() {
        let user2_pfp = UIImage(named: "cakey_pfp")
        let drawing1 = UIImage(named: "bird_drawing1")
        let drawing2 = UIImage(named: "bird_drawing2")
        let user2 = User(pfp: user2_pfp!, full_name: "Caitlyn Jin", user_name: "cakeymecake", bio: "I love drawing")
        let post1 = Post(user: user, drawing: drawing1!, caption: "i drew this in middle school guys", time: Date())
        let post2 = Post(user: user2, drawing: drawing2!, caption: "better than vin's", time: Date())
        user.addPost(post: post1)
        user2.addPost(post: post2)
        posts.append(post1)
        posts.append(post2)
        
        post1.addComment(comment_user: user2, text: "This sucks")
        post1.addComment(comment_user: user, text: "This does not suck")
        post1.addComment(comment_user: user, text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        
        post1.getComments()[0].addReply(text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", prev: nil, reply_user: user)
        
        post1.getComments()[0].addReply(text: "Are you okay...", prev: post1.getComments()[0].getReplies()[0], reply_user: user2)
    }
    // TODO: END REMOVE
    
    // ------------ Fields (data) ------------
    private var posts: [Post] = []
    
    // ------------ Functions ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Add to view
        view.addSubview(prompt_heading)
        view.addSubview(prompt)
        view.addSubview(post_cv)
        view.addSubview(user_post)
        view.addSubview(draw_view_large)
        
        // Function Calls
        setupNavBar()
        setupCollectionView()
        setupConstraints()
        // TODO: START REMOVE
        createPosts()
        // TODO: END REMOVE
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
        
        // TODO: PUT BELOW IN A HELPER
        if (user.getPosts().count != 0) {
            user_post.image = user.getLatestPost().getDrawing()
        } else {
            user_post.image = UIImage(systemName: "plus.app")
        }
    }
    
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 0.0
        }, completion: nil)
        draw_view_large.subviews[1].removeFromSuperview()
        self.navigationController?.navigationBar.layer.zPosition = 0
    }
    
    @objc private func pushProfileVC() {
        let profile_vc = ProfileVC()
        self.navigationController?.pushViewController(profile_vc, animated: true)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: friends_btn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profile_btn)
        navigationItem.titleView = logo
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupCollectionView() {
        post_cv.delegate = self
        post_cv.dataSource = self
        post_cv.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: Constants.reuse)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profile_btn.widthAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            profile_btn.heightAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            
            friends_btn.widthAnchor.constraint(equalToConstant: Constants.friends_button_width),
            friends_btn.heightAnchor.constraint(equalToConstant: Constants.friends_button_height),
            
            prompt_heading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.prompt_heading_top_padding),
            prompt_heading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.prompt_side_padding),

            prompt.topAnchor.constraint(equalTo: prompt_heading.bottomAnchor, constant: Constants.prompt_top_padding),
            prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.prompt_side_padding),
            
            user_post.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.user_post_top_padding),
            user_post.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.user_post_side_padding),
            user_post.widthAnchor.constraint(equalToConstant: Constants.user_post_width),
            user_post.heightAnchor.constraint(equalToConstant: Constants.user_post_height),
                                             
            post_cv.topAnchor.constraint(equalTo: prompt.bottomAnchor, constant: Constants.post_cv_top_padding),
            post_cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.post_cv_side_padding),
            post_cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.post_cv_side_padding),
            post_cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            draw_view_large.topAnchor.constraint(equalTo: view.topAnchor),
            draw_view_large.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            draw_view_large.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            draw_view_large.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuse, for: indexPath) as?
            PostCollectionViewCell {
            let post = posts[indexPath.row]
            cell.configure(main_user: user, post: post, parent_vc: self, mode: traitCollection.userInterfaceStyle)
            cell.layer.cornerRadius = Constants.post_cell_corner
            cell.enlarge_delegate = self
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

extension HomeVC: EnlargeDrawingDelegate {
    func enlargeDrawing(drawing: UIImage) {
        let img = UIImageView(image: drawing)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        draw_view_large.addSubview(img)
        
        NSLayoutConstraint.activate([
            img.centerYAnchor.constraint(equalTo: draw_view_large.centerYAnchor),
            img.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            img.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 1.0
        }, completion: nil)
        self.navigationController?.navigationBar.layer.zPosition = -1
    }
}
