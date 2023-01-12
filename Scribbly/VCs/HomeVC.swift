//
//  HomeVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit
import FirebaseAuth

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
        btn.backgroundColor = Constants.secondary_text
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
        cv.alwaysBounceVertical = true
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
    
    private let logoLoading: UILabel = {
        let lbl = UILabel()
        lbl.text = "scribbly"
        lbl.font = Constants.getFont(size: 40, weight: .semibold)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    private let noFriendsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 24, weight: .regular)
        lbl.text = "add friends through your profile"
        lbl.numberOfLines = 2
        lbl.textColor = Constants.secondary_text
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Properties (data)
    private var mainUser: User!
    private var posts: [Post] = []
    private var prompt: String = ""
    private var mainUserPost: UIImage?
    private var initialPopup: Bool
    
    // MARK: - Backend Helpers
    private func validateLogin() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let landingVC = LandingVC()
            let nav = UINavigationController(rootViewController: landingVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func getPrompt() {
        let format = DateFormatter()
        format.dateFormat = "M-d-yy"
        
        DatabaseManager.getTodaysPrompt(with: format.string(from: Date()), completion: { [weak self] myPrompt in
            guard let `self` = self else { return }
            self.prompt = myPrompt
        })
    }
    
    private func refreshHomePage() {
        // Update friends
        DatabaseManager.getFriends(with: mainUser, completion: { [weak self] _ in
            guard let `self` = self else { return }
            if self.mainUser.friends == nil || self.mainUser.getFriends().count == 0 {
                self.noFriendsLabel.isHidden = false
                self.posts = []
                self.postCV.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                DatabaseManager.getFeedData(with: self.mainUser.getFriends(), completion: { [weak self] posts in
                    guard let `self` = self else { return }
                    self.noFriendsLabel.isHidden = true
                    self.posts = posts
                    self.postCV.reloadData()
                    self.refreshControl.endRefreshing()
                })
            }
        })
        
        // Update post stats
        if let todaysPost = mainUser.getTodaysPost() {
            DatabaseManager.updatePostStats(with: todaysPost, completion: { [weak self] success in
                guard let `self` = self else { return }
                if success {
                    self.postCV.reloadData()
                }
            })
        }
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        testCreateUser2()
//        testCreateUser()
        validateLogin()
    }
    
    // MARK: - viewDidLoad, initialStartup, loadHomePage, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        startLoading()
        initialStartup()
    }
    
    private func initialStartup() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let landingVC = LandingVC()
            let nav = UINavigationController(rootViewController: landingVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else {
            self.getPrompt()
            DatabaseManager.getStartup(completion: { [weak self] user, posts in
                guard let `self` = self else { return }
                
                if let user = user {
                    self.mainUser = user
                    self.profileButton.setImage(user.getPFP(), for: .normal)
                    
                    if user.todaysPost == "" {
                        let timerVC = TimerVC(mainUser: user, prompt: self.prompt, initialPopup: self.initialPopup)
                        timerVC.updateFeedDelegate = self
                        self.navigationController?.pushViewController(timerVC, animated: false)
                    }
                    
                    self.posts = posts
                    self.loadHomePage()
                } else {
                    // Go to user account creation
                    let firstNameVC = FirstNameVC()
                    self.navigationController?.pushViewController(firstNameVC, animated: false)
                }
            })
        }
    }
    
    private func loadHomePage() {
        view.addSubview(postCV)
        view.addSubview(noFriendsLabel)
        view.addSubview(drawViewLarge)
                
        if mainUser.friends != nil {
            noFriendsLabel.isHidden = true
        }
        setupGradient()
        setupNavBar()
        setupCollectionView()
        setupConstraints()
        stopLoading()
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
            drawViewLarge.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            noFriendsLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * Constants.no_friends_side),
            noFriendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFriendsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - init
    init(initialPopup: Bool) {
        self.initialPopup = initialPopup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    private func startLoading() {
        view.addSubview(logoLoading)
        view.addSubview(spinner)
        spinner.startAnimating()
        NSLayoutConstraint.activate([
            logoLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: logoLoading.bottomAnchor, constant: 30)
        ])
    }
    
    private func stopLoading() {
        logoLoading.alpha = 0
        spinner.stopAnimating()
    }
    
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
        let profileVC = MainUserProfileVC(mainUser: mainUser)
        profileVC.updateFeedDelegate = self
        profileVC.updatePFPDelegate = self
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func refreshFeed() {
        refreshHomePage()
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
                header.configure(prompt: prompt, post: mainUser.getTodaysPost())
                header.postInfoDelegate = self
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
            cell.configure(mainUser: mainUser, post: post, parentVC: self, mode: traitCollection.userInterfaceStyle)
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
        refreshHomePage()
    }
    
    // MARK: - UpdatePFPDelegate
    func updatePFP() {
        guard let mainUser = mainUser else { return }
        self.profileButton.setImage(mainUser.getPFP(), for: .normal)
    }
}

// MARK: - TESTING EXTENSION
extension HomeVC {
    private func testCreateUser() {
        let testEmail = "b.vinhan01@gmail.com"
        let testPassword = "password"
        
        FirebaseAuth.Auth.auth().createUser(withEmail: testEmail, password: testPassword) { authResult, error in
            guard let userID = authResult?.user.uid else { return }
            
            let format = DateFormatter()
            format.dateFormat = "d MMMM yyyy HH:mm:ss"
            let date = format.string(from: Date())
            
            let safeEmail = testEmail.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
            
            let user = User(id: userID, userName: "vinnie", firstName: "vin", lastName: "bui", pfp: "\(safeEmail)_profile_picture.jpg", accountStart: date, bio: "", friends: [:], requests: [:], blocked: [:], posts: [:], bookmarkedPosts: [:], todaysPost: "")
            
            DatabaseManager.addUser(with: user, completion: { success in
                if success {
                    print("User was created successfully.")
                } else {
                    print("Unable to create user.")
                }
            })
        }
    }
    
    private func testCreateUser2() {
        let testEmail = "caitlynjin@gmail.com"
        let testPassword = "password"
        
        FirebaseAuth.Auth.auth().createUser(withEmail: testEmail, password: testPassword) { authResult, error in
            guard let userID = authResult?.user.uid else { return }
            
            let format = DateFormatter()
            format.dateFormat = "d MMMM yyyy HH:mm:ss"
            let date = format.string(from: Date())
            
            let safeEmail = testEmail.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
            
            let user = User(id: userID, userName: "cakeymecake", firstName: "caitlyn", lastName: "jin", pfp: "images/\(safeEmail)_profile_picture.jpg", accountStart: date, bio: "minecraft", friends: [:], requests: [:], blocked: [:], posts: [:], bookmarkedPosts: [:], todaysPost: "")
            
            DatabaseManager.addUser(with: user, completion: { success in
                if success {
                    print("User was created successfully.")
                } else {
                    print("Unable to create user.")
                }
            })
        }
    }
    
}
