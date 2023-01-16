//
//  AddFriendsVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/3/23.
//

import UIKit

// MARK: AddFriendsVC
class AddFriendsVC: UIViewController {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "add friends"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.right")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: AddFriendsTableViewCell.reuseIdentifier)
        tv.register(FollowRequestViewCell.self, forCellReuseIdentifier: FollowRequestViewCell.reuseIdentifier)
        tv.sectionHeaderTopPadding = 0
        tv.separatorStyle = .none
        tv.delegate = self
        tv.addSubview(refreshControl)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.placeholder = "search by username"
        bar.tintColor = .label
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.delegate = self
        return bar
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTV), for: .valueChanged)
        return refresh
    }()
    
    // MARK: - Properties (data)
    private var datasource: Datasource!
    private var friendsData = [Friend]()
    private var requestsData = [User]()
    private var mainUser: User
    weak var updateFeedDelegate: UpdateFeedDelegate!
    weak var updateRequestsDelegate: UpdateRequestsDelegate!
    var searchTask: DispatchWorkItem?
    
    // MARK: - viewDidLoad, viewWillAppear, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(spinner)
        
//        setupGradient()
        spinner.startAnimating()
        setupNavBar()
        setupRequestsData()
        configureDatasource()
        setupConstraints()
    }
    
    init(mainUser: User) {
        self.mainUser = mainUser
        super.init(nibName: nil, bundle: nil)
        setupFriendsData(users: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.friends_tv_side_padding),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.friends_tv_side_padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Setup Data
    private func setupRequestsData() {
        requestsData = []
        DatabaseManager.getRequests(with: mainUser.id, completion: { [weak self] users in
            guard let `self` = self else { return }
            self.requestsData = users.reversed()
            
            var oldSnapshot = self.datasource.snapshot()
            oldSnapshot.deleteAllItems()
            self.datasource.apply(oldSnapshot, animatingDifferences: false)
            
            self.createSnapshot()
            self.refreshControl.endRefreshing()
            self.spinner.stopAnimating()
        })
    }
    
    func setupFriendsData(users: [User]) {
        friendsData = []
        for i in users {
            if i.id != mainUser.id && (!mainUser.isFriendsWith(user: i) || !i.isFriendsWith(user: mainUser)) && !mainUser.isBlocked(user: i) && !i.isBlocked(user: mainUser) {
                friendsData.append(Friend(user: i))
            }
        }
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        navigationController?.dismiss(animated: false)
    }
    
    @objc private func refreshTV() {
        DatabaseManager.getFriends(with: mainUser, completion: { [weak self] users in
            guard let `self` = self else { return }
            self.setupFriendsData(users: users)
            self.createSnapshot()
            self.refreshControl.endRefreshing()
        })
    }
}

// MARK: - Extensions
extension AddFriendsVC {
    // MARK: - Diffable Data Source
    typealias Datasource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case requestsSection
        case friendsListSection
    }
    
    enum Item: Hashable {
        case requestsSectionItem
        case friendsListItem(Friend)
    }
    
    struct Friend: Hashable {
        let id = UUID()
        let user: User
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: AddFriendsVC.Friend, rhs: AddFriendsVC.Friend) -> Bool {
            lhs.user === rhs.user
        }
    }
    
    private func cell(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell {
        switch item {
        case .requestsSectionItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowRequestViewCell.reuseIdentifier, for: indexPath) as! FollowRequestViewCell
            cell.configure(requests: requestsData)
            cell.selectionStyle = .none
            return cell
        case .friendsListItem(let friend):
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFriendsTableViewCell.reuseIdentifier, for: indexPath) as! AddFriendsTableViewCell
            cell.configure(user: friend.user, mainUser: mainUser)
            cell.updateRequestsDelegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private func configureDatasource() {
        datasource = Datasource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, item in return self.cell(tableView: tableView, indexPath: indexPath, item: item)})
        createSnapshot()
    }
    
    private func createSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.requestsSection, Section.friendsListSection])
        snapshot.appendItems(friendsData.map({ Item.friendsListItem($0) }), toSection: .friendsListSection)
        snapshot.appendItems([Item.requestsSectionItem], toSection: .requestsSection)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Extension (UITableViewDelegate)
extension AddFriendsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.friends_cell_height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && searchBar.text!.isEmpty {
            let requestsVC = RequestsVC(mainUser: mainUser, requests: requestsData)
            requestsVC.updateRequestsDelegate = self
            requestsVC.updateFeedDelegate = updateFeedDelegate
            navigationController?.pushViewController(requestsVC, animated: true)
        } else {
            let request = friendsData[indexPath.row].user
            let profileVC = OtherUserProfileVC(user: request, mainUser: mainUser)
            profileVC.updateRequestsDelegate = self
            profileVC.updateFeedDelegate = updateFeedDelegate
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - Other Extensions
extension AddFriendsVC: UISearchBarDelegate, UpdateRequestsDelegate {
    // MARK: - UpdateRequestsDelegate
    func updateRequests() {
        setupRequestsData()
        updateRequestsDelegate.updateRequests()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cancel previous task if any
        searchTask?.cancel()
        
        var oldSnapshot = self.datasource.snapshot()
        oldSnapshot.deleteAllItems()
        self.datasource.apply(oldSnapshot, animatingDifferences: false)
        
        if searchText.isEmpty {
            self.friendsData = []
            createSnapshot()
            self.spinner.stopAnimating()
        } else {
            self.spinner.startAnimating()
            // Replace previous task with a new one
            let task = DispatchWorkItem { [weak self] in
                guard let `self` = self else { return }
                DatabaseManager.searchUsers(with: searchText.lowercased(), completion: { [weak self] users in
                    guard let `self` = self else { return }
                    self.setupFriendsData(users: users)
                    self.spinner.stopAnimating()
                    
                    var snapshot = Snapshot()
                    snapshot.appendSections([Section.friendsListSection])
                    snapshot.appendItems(self.friendsData.map({ Item.friendsListItem($0) }), toSection: .friendsListSection)
                    self.datasource.apply(snapshot, animatingDifferences: false)
                })
            }
            
            searchTask = task
            // Execute task in 0.75 second, depends on network speed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
        }
    }
}
