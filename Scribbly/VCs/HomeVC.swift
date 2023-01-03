//
//  HomeVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: HomeVC
class HomeVC: UIViewController {
    // MARK: - Properties (view)
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
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
        lbl.font = Constants.getFont(size: 24, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var profileButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(pushMainUserProfileVC), for: .touchUpInside)
        btn.setImage(user.getPFP(), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 0.5 * 2 * Constants.profile_button_radius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var postCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: Constants.post_cv_top_padding, left: 0, bottom: Constants.post_cv_bot_padding, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.addSubview(refreshControl)
        return cv
    }()
    
    private lazy var drawViewLarge: UIView = {
        let view = UIView()
        
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        if (traitCollection.userInterfaceStyle == .light) {
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
        customBlurEffectView.frame = view.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reduceImage))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        view.addSubview(customBlurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        return refresh
    }()
    
    // TODO: START REMOVE
    private lazy var user: User = User(pfp: UIImage(named: "vinnie_pfp")!, fullName: "vin bui", userName: "vinnie", bio: "I hate school", email: "vinbui@gmail.com", accountStart: CalendarHelper().getDateFromDayMonthYear(str: "10 October 2022"))
    
    private func createTests() {
        let caitlyn = User(pfp: UIImage(named: "cakey_pfp")!, fullName: "caitlyn jin", userName: "cakeymecake", bio: "I love drawing", email: "caitlynjin@gmail.com", accountStart: CalendarHelper().getDateFromDayMonthYear(str: "12 November 2022"))
        let karen = User(pfp: UIImage(named: "piano")!, fullName: "karen sabile", userName: "karensabile", bio: "my music taste is top tier", email: "karensabile@gmail.com", accountStart: CalendarHelper().getDateFromDayMonthYear(str: "25 December 2022"))
        let katherine = User(pfp: UIImage(named: "katherine_pfp")!, fullName: "katherine chang", userName: "strokeslover101", bio: "Slay!!", email: "katherinechang@gmail.com", accountStart: Date())
        
        let vin_post = Post(user: user, drawing: UIImage(named: "bird_drawing1")!, caption: "i drew this in middle school", time: Date())
        let caitlyn_post = Post(user: caitlyn, drawing: UIImage(named: "bird_drawing2")!, caption: "better than vin's", time: Date())
        let karen_post = Post(user: karen, drawing: UIImage(named: "piano")!, caption: "naur", time: Date())
        let katherine_post = Post(user: katherine, drawing: UIImage(named: "katherine_drawing")!, caption: "This is so beautiful❤️", time: Date())

        for i in 1...25 {
            let date = String(i) + " December 2022"
            let post = Post(user: user, drawing: UIImage(named: "bird_drawing1")!, caption: "i drew this in middle school", time: CalendarHelper().getDateFromDayMonthYear(str: date))
            post.addComment(comment_user: caitlyn, text: "This sucks")
            post.addComment(comment_user: user, text: "This does not suck")
            user.addPost(post: post)
        }
        
        Database.addUser(user: user)
        Database.addUser(user: caitlyn)
        Database.addUser(user: karen)
        Database.addUser(user: katherine)
        
        user.addFriend(friend: caitlyn)
        user.addFriend(friend: karen)
        user.addFriend(friend: katherine)
        
        for _ in 1...30 {
            let newPost = Post(user: caitlyn, drawing: UIImage(named: "bird_drawing1")!, caption: "hey", time: Date())
            caitlyn.addPost(post: newPost)
            user.addBookmarkPost(post: newPost)
        }
        
        caitlyn.addFriend(friend: user)
        karen.addFriend(friend: user)
        katherine.addFriend(friend: user)
        
        user.addPost(post: vin_post)
        vin_post.setHidden(bool: true)
        caitlyn.addPost(post: caitlyn_post)
        katherine.addPost(post: katherine_post)
        
        karen.addPost(post: karen_post)
        
        vin_post.addComment(comment_user: caitlyn, text: "This sucks")
        vin_post.addComment(comment_user: katherine, text: "So bad 😭")
        vin_post.addComment(comment_user: user, text: "This does not suck")
        vin_post.addComment(comment_user: user, text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
        vin_post.getComments()[0].addReply(text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", prev: nil, replyUser: user)
        vin_post.getComments()[0].addReply(text: "Are you okay...", prev: vin_post.getComments()[0].getReplies()[0], replyUser: caitlyn)
        
        // Friend requests
        let liam = User(pfp: UIImage(named: "liam_pfp")!, fullName: "liam du", userName: "liamdu", bio: "i eat cheese", email: "liamdu@gmail.com", accountStart: Date())
        Database.addUser(user: liam)
        let liam_post = Post(user: liam, drawing: UIImage(named: "bird_drawing2")!, caption: "yo", time: Date())
        liam.addPost(post: liam_post)
//        karen.sendRequest(user: user)
//        katherine.sendRequest(user: user)
        liam.sendRequest(user: user)
    }
    // TODO: END REMOVE
    
    // MARK: - Properties (data)
    private var posts: [Post] = []
    
    // MARK: - viewDidLoad and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(postCV)
        view.addSubview(drawViewLarge)
        
        // TODO: START REMOVE
        createTests()
        // TODO: END REMOVE
        
        setupPostsData()
        setupGradient()
        setupNavBar()
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            profileButton.heightAnchor.constraint(equalToConstant: 2 * Constants.profile_button_radius),
            
            searchButton.widthAnchor.constraint(equalToConstant: Constants.search_button_width),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.search_button_height),
            
            postCV.topAnchor.constraint(equalTo: view.topAnchor),
            postCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.post_cv_side_padding),
            postCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.post_cv_side_padding),
            postCV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            drawViewLarge.topAnchor.constraint(equalTo: view.topAnchor),
            drawViewLarge.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawViewLarge.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawViewLarge.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    // MARK: - Setup Data
    private func setupPostsData() {
        posts = [Post]()
        posts = user.updateFeed()
    }
    
    // MARK: - Helper Functions
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.titleView = logo
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupCollectionView() {
        postCV.delegate = self
        postCV.dataSource = self
        postCV.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseIdentifier)
        postCV.register(PromptHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PromptHeaderView.reuseIdentifier)
    }
    
    // MARK: - Button Helpers
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 0.0
        }, completion: nil)
        drawViewLarge.subviews[1].removeFromSuperview()
    }
    
    @objc private func pushMainUserProfileVC() {
        let profileVC = MainUserProfileVC(mainUser: user)
        profileVC.updateFeedDelegate = self
        profileVC.updatePFPDelegate = self
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func refreshFeed() {
        setupPostsData()
        postCV.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - Extension: UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    // MARK: - Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Constants.prompt_width, height: Constants.prompt_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PromptHeaderView.reuseIdentifier, for: indexPath) as? PromptHeaderView {
                header.backgroundColor = .systemBackground
                if (user.getPosts().count != 0) {
                    header.configure(prompt: "bird", post: user.getTodaysPost())
                    header.postInfoDelegate = self
                }
                return header
            }
        }
        return UICollectionReusableView()
    }
    // MARK: - Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier, for: indexPath) as?
            PostCollectionViewCell {
            let post = posts[indexPath.row]
            cell.configure(mainUser: user, post: post, parentVC: self, mode: traitCollection.userInterfaceStyle)
            cell.layer.cornerRadius = Constants.post_cell_corner
            cell.captionView.updateFeedDelegate = self
            cell.enlargeDrawingDelegate = self
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - Extension: UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.post_container_width, height: Constants.post_container_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.post_container_spacing
    }
}

// MARK: - Extension: Delegation
extension HomeVC: EnlargeDrawingDelegate, PostInfoDelegate, UpdateFeedDelegate, UpdatePFPDelegate {
    // MARK: - EnlargeDrawingDelegate
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
        
        drawViewLarge.addSubview(outerView)
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            img.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            
            outerView.centerYAnchor.constraint(equalTo: drawViewLarge.centerYAnchor),
            outerView.centerXAnchor.constraint(equalTo: drawViewLarge.centerXAnchor),
            outerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
            outerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.enlarge_side_padding),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - PostInfoDelegate
    func showPostInfo(post: Post) {
        let view = PostInfoView()
        view.configure(post: post, mode: traitCollection.userInterfaceStyle, parentVC: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        drawViewLarge.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: drawViewLarge.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: drawViewLarge.leadingAnchor, constant: Constants.enlarge_side_padding),
            view.trailingAnchor.constraint(equalTo: drawViewLarge.trailingAnchor, constant: -Constants.enlarge_side_padding),
            view.heightAnchor.constraint(equalToConstant: Constants.post_info_view_height),
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 1.0
        }, completion: nil)
    }
    
    func showMemsInfo(post: Post) {
        return  // Do nothing here
    }
    
    func showBooksInfo(post: Post) {
        return  // Do nothing here
    }
    
    // MARK: - UpdateFeedDelegate
    func updateFeed() {
        setupPostsData()
        postCV.reloadData()
    }
    
    // MARK: - UpdatePFPDelegate
    func updatePFP() {
        profileButton.setImage(user.getPFP(), for: .normal)
    }
}
