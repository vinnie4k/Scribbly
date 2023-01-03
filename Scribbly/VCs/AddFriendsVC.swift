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
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: AddFriendsTableViewCell.reuseIdentifier)
        tv.sectionHeaderTopPadding = 0
        tv.separatorStyle = .none
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.placeholder = "search for a user"
        bar.tintColor = .label
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.delegate = self
        return bar
    }()
    
    // MARK: - Properties (data)
    private var datasource: Datasource!
    private var friendsData = [Friend]()
    private var mainUser: User
    var updateRequestsDelegate: UpdateRequestsDelegate!
    private var filteredFriends = [Friend]()
    var updateFeedDelegate: UpdateFeedDelegate!
    
    // MARK: - viewDidLoad, viewWillAppear, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
//        setupGradient()
        setupNavBar()
        configureDatasource()
        setupConstraints()
    }
    
    init(mainUser: User, users: [User]) {
        self.mainUser = mainUser
        super.init(nibName: nil, bundle: nil)
        setupFriendsData(users: users)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.friends_tv_side_padding),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.friends_tv_side_padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding)
        ])
    }
    
    // MARK: - Setup Data
    func setupFriendsData(users: [User]) {
        for i in users {
            friendsData.append(Friend(user: i))
        }
        filteredFriends = friendsData
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions
extension AddFriendsVC {
    // MARK: - Diffable Data Source
    typealias Datasource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case friendsListSection
    }
    
    enum Item: Hashable {
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
        case .friendsListItem(let friend):
            let cell = tableView.dequeueReusableCell(withIdentifier: AddFriendsTableViewCell.reuseIdentifier, for: indexPath) as! AddFriendsTableViewCell
            cell.configure(user: friend.user, mainUser: mainUser)
            cell.updateRequestsDelegate = updateRequestsDelegate
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private func configureDatasource() {
        datasource = Datasource(tableView: tableView, cellProvider: cell(tableView:indexPath:item:))
        createSnapshot()
    }
    
    private func createSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.friendsListSection])
        snapshot.appendItems(filteredFriends.map({ Item.friendsListItem($0) }), toSection: .friendsListSection)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Extension (UITableViewDelegate)
extension AddFriendsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.friends_cell_height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text!.isEmpty {
            let request = filteredFriends[indexPath.row].user
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
        var oldSnapshot = datasource.snapshot()
        oldSnapshot.deleteAllItems()
        datasource.apply(oldSnapshot, animatingDifferences: false)
        createSnapshot()
        
        updateRequestsDelegate.updateRequests() // Update friends list as well
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = []
        
        if searchText.isEmpty {
            filteredFriends = friendsData
        } else {
            for name in friendsData {
                if name.user.getUserName().lowercased().contains(searchText.lowercased()) || name.user.getFullName().lowercased().contains(searchText.lowercased()) {
                    filteredFriends.append(name)
                }
            }
        }
        
        var oldSnapshot = datasource.snapshot()
        oldSnapshot.deleteAllItems()
        datasource.apply(oldSnapshot, animatingDifferences: false)
        createSnapshot()
    }
}