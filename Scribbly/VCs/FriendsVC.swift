//
//  FriendsVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/31/22.
//

import UIKit

// MARK: FriendsVC
class FriendsVC: UIViewController {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "friends"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var addFriendsButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .systemBackground
        tv.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.reuseIdentifier)
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
        bar.placeholder = "search friends"
        bar.tintColor = .label
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.delegate = self
        return bar
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTV), for: .valueChanged)
        return refresh
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(style: .medium)
        spin.hidesWhenStopped = true
        spin.color = .label
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()
    
    // MARK: - Properties (data)
    private var datasource: Datasource!
    private var friendsData = [Friend]()
    private var requestsData = [User]()
    private var user: User
    private var filteredFriends = [Friend]()
    weak var updateFeedDelegate: UpdateFeedDelegate!

    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(spinner)
                
//        setupGradient()
        spinner.startAnimating()
        setupNavBar()
        setupData()
        configureDatasource()
        setupConstraints()
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        addFriendsButton.addTarget(self, action: #selector(pushAddFriendsVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFriendsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.friends_tv_side_padding),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.friends_tv_side_padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Setup Data
    private func setupData() {
        requestsData = []
        friendsData = []
        
        DatabaseManager.getRequests(with: user.id, completion: { [weak self] users in
            guard let `self` = self else { return }
            self.requestsData = users.reversed()
            
            DatabaseManager.getFriends(with: self.user, completion: { [weak self] users in
                guard let `self` = self else {return }
                
                for i in users {
                    self.friendsData.insert(Friend(friend: i), at: 0)
                }
                self.filteredFriends = self.friendsData
                
                var oldSnapshot = self.datasource.snapshot()
                oldSnapshot.deleteAllItems()
                self.datasource.apply(oldSnapshot, animatingDifferences: false)
                
                self.createSnapshot()
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
            })
        })
    }
    
    // MARK: - Button Helpers
    @objc private func refreshTV() {
        updateRequests()
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pushAddFriendsVC() {
        let addFriendsVC = AddFriendsVC(mainUser: user)
        addFriendsVC.updateRequestsDelegate = self
        navigationController?.pushViewController(addFriendsVC, animated: true)
    }
}

// MARK: - Extensions
extension FriendsVC {
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
        let friend: User

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: FriendsVC.Friend, rhs: FriendsVC.Friend) -> Bool {
            lhs.friend === rhs.friend
        }
    }
    
    private func cell(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell {
        switch item {
        case .requestsSectionItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowRequestViewCell.reuseIdentifier, for: indexPath) as! FollowRequestViewCell
            cell.configure(requests: requestsData, mode: traitCollection.userInterfaceStyle)
            cell.selectionStyle = .none
            return cell
        case .friendsListItem (let friend):
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.reuseIdentifier, for: indexPath) as! FriendsTableViewCell
            cell.configure(user: friend.friend, mainUser: user, parentVC: self)
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
        snapshot.appendItems(filteredFriends.map({ Item.friendsListItem($0) }), toSection: .friendsListSection)
        snapshot.appendItems([Item.requestsSectionItem], toSection: .requestsSection)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Extension (UITableViewDelegate)
extension FriendsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.friends_cell_height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let label = UILabel()
            label.text = "your friends"
            label.font = Constants.getFont(size: 16, weight: .semibold)
            label.textColor = .label
            return label
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return CGFloat(30)
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && searchBar.text!.isEmpty {
            let requestsVC = RequestsVC(mainUser: user, requests: requestsData)
            requestsVC.updateRequestsDelegate = self
            requestsVC.updateFeedDelegate = updateFeedDelegate
            navigationController?.pushViewController(requestsVC, animated: true)
        } else {
            let friend = filteredFriends[indexPath.row].friend
            let profileVC = OtherUserProfileVC(user: friend, mainUser: user)
            profileVC.updateFeedDelegate = updateFeedDelegate
            profileVC.updateRequestsDelegate = self
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - Other Extensions
extension FriendsVC: UpdateRequestsDelegate, UISearchBarDelegate {
    // MARK: - UpdateRequestsDelegate
    func updateRequests() {
        setupData()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var oldSnapshot = datasource.snapshot()
        oldSnapshot.deleteAllItems()
        datasource.apply(oldSnapshot, animatingDifferences: false)

        filteredFriends = []
        
        if searchText.isEmpty {
            filteredFriends = friendsData
            createSnapshot()
        } else {
            for name in friendsData {
                if name.friend.getUserName().lowercased().contains(searchText.lowercased()) || name.friend.getFullName().lowercased().contains(searchText.lowercased()) {
                    filteredFriends.append(name)
                }
            }
            var snapshot = Snapshot()
            snapshot.appendSections([Section.friendsListSection])
            snapshot.appendItems(filteredFriends.map({ Item.friendsListItem($0) }), toSection: .friendsListSection)
            datasource.apply(snapshot, animatingDifferences: false)
        }
    }
}
