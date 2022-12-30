//
//  HomeVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class HomeVC: UIViewController {
    // ------------ Fields (view) ------------    
    private lazy var search_btn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushProfileVC), for: .touchUpInside)
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        if (traitCollection.userInterfaceStyle == .light) {
            config.image = UIImage(named: "search_light")
        } else if (traitCollection.userInterfaceStyle == .dark) {
            config.image = UIImage(named: "search_dark")
        }
        config.baseBackgroundColor = .clear
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
        cv.contentInset = UIEdgeInsets(top: Constants.post_cv_top_padding, left: 0, bottom: Constants.post_cv_bot_padding, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var draw_view_large: UIView = {
        let view = UIView()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        if (traitCollection.userInterfaceStyle == .light) {
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = view.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(reduceImage))
        view.addGestureRecognizer(tap_gesture)
        view.isUserInteractionEnabled = true
        
        view.addSubview(customBlurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    // TODO: START REMOVE
    private lazy var user: User = User(pfp: UIImage(named: "vinnie_pfp")!, full_name: "Vin Bui", user_name: "vinnie", bio: "I hate school", account_start: CalendarHelper().getDateFromDayMonthYear(str: "10 October 2022"))
    
    private func createTests() {
        let caitlyn = User(pfp: UIImage(named: "cakey_pfp")!, full_name: "Caitlyn Jin", user_name: "cakeymecake", bio: "I love drawing", account_start: CalendarHelper().getDateFromDayMonthYear(str: "12 November 2022"))
        let karen = User(pfp: UIImage(named: "piano")!, full_name: "Karen Sabile", user_name: "karensabile", bio: "my music taste is top tier", account_start: CalendarHelper().getDateFromDayMonthYear(str: "25 December 2022"))
        
        let vin_post = Post(user: user, drawing: UIImage(named: "bird_drawing1")!, caption: "i drew this in middle school", time: Date())
        let caitlyn_post = Post(user: caitlyn, drawing: UIImage(named: "bird_drawing2")!, caption: "better than vin's", time: Date())
        let karen_post = Post(user: karen, drawing: UIImage(named: "piano")!, caption: "naur", time: Date())
        
        for i in 1...25 {
            let date = String(i) + " December 2022"
            let post = Post(user: user, drawing: UIImage(named: "bird_drawing1")!, caption: "i drew this in middle school", time: CalendarHelper().getDateFromDayMonthYear(str: date))
            post.addComment(comment_user: caitlyn, text: "This sucks")
            post.addComment(comment_user: user, text: "This does not suck")
            user.addPost(post: post)
        }
        
        user.addFriend(friend: caitlyn)
        user.addFriend(friend: karen)
        caitlyn.addFriend(friend: user)
        karen.addFriend(friend: user)
        
        user.addPost(post: vin_post)
        vin_post.setHidden(bool: true)
        caitlyn.addPost(post: caitlyn_post)
        karen.addPost(post: karen_post)
        
        posts = user.updateFeed()
        
        vin_post.addComment(comment_user: caitlyn, text: "This sucks")
        vin_post.addComment(comment_user: user, text: "This does not suck")
        vin_post.addComment(comment_user: user, text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        vin_post.getComments()[0].addReply(text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", prev: nil, reply_user: user)
        vin_post.getComments()[0].addReply(text: "Are you okay...", prev: vin_post.getComments()[0].getReplies()[0], reply_user: caitlyn)
    }
    // TODO: END REMOVE
    
    // ------------ Fields (data) ------------
    private var posts: [Post] = []
    
    // ------------ Functions ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(post_cv)
        view.addSubview(draw_view_large)
        
        // Function Calls
        setupGradient()
        setupNavBar()
        setupCollectionView()
        setupConstraints()
        // TODO: START REMOVE
        createTests()
        // TODO: END REMOVE
    }
    
    private func setupGradient() {
        if (traitCollection.userInterfaceStyle == .dark) {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0, 0.1, 0.85, 1]
            view.layer.mask = gradient
        }
    }
    
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 0.0
        }, completion: nil)
        draw_view_large.subviews[1].removeFromSuperview()
//        self.navigationController?.navigationBar.toggle()
    }
    
    @objc private func pushProfileVC() {
        let profile_vc = MainUserProfileVC()
        profile_vc.main_user = user
        self.navigationController?.pushViewController(profile_vc, animated: true)
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: search_btn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profile_btn)
        navigationItem.titleView = logo
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupCollectionView() {
        post_cv.delegate = self
        post_cv.dataSource = self
        post_cv.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: Constants.reuse)
        post_cv.register(PromptHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.prompt_reuse)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profile_btn.widthAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            profile_btn.heightAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            
            search_btn.widthAnchor.constraint(equalToConstant: Constants.search_button_width),
            search_btn.heightAnchor.constraint(equalToConstant: Constants.search_button_height),
            
            post_cv.topAnchor.constraint(equalTo: view.topAnchor),
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.prompt_reuse, for: indexPath) as? PromptHeaderView {
                header.backgroundColor = .systemBackground
                if (user.getPosts().count != 0) {
                    header.configure(prompt: "bird", post: user.getTodaysPost())
                    header.post_info_delegate = self
                }
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constants.prompt_width, height: Constants.prompt_height)
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
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding, height: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.15
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: Constants.post_cell_drawing_corner).cgPath
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImageView(image: drawing)
        img.frame = outerView.bounds
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.post_cell_drawing_corner
        img.translatesAutoresizingMaskIntoConstraints = false
        
        outerView.addSubview(img)
        
        draw_view_large.addSubview(outerView)
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            img.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            outerView.centerYAnchor.constraint(equalTo: draw_view_large.centerYAnchor),
            outerView.centerXAnchor.constraint(equalTo: draw_view_large.centerXAnchor),
            outerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            outerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 1.0
        }, completion: nil)
//        self.navigationController?.navigationBar.toggle()
    }
}

extension HomeVC: PostInfoDelegate {
    func showPostInfo(post: Post) {        
        let view = PostInfoView()
        view.configure(post: post, mode: traitCollection.userInterfaceStyle, parent_vc: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        draw_view_large.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: draw_view_large.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: draw_view_large.leadingAnchor, constant: Constants.enlarge_side_padding),
            view.trailingAnchor.constraint(equalTo: draw_view_large.trailingAnchor, constant: -Constants.enlarge_side_padding),
            view.heightAnchor.constraint(equalToConstant: Constants.post_info_view_height),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 1.0
        }, completion: nil)
//        self.navigationController?.navigationBar.toggle()
    }
}
