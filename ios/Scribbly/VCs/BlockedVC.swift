//
//  BlockedVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/12/23.
//

import UIKit

// MARK: BlockedVC
class BlockedVC: UIViewController, UITextFieldDelegate {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "blocked users"
        lbl.textColor = .label
        lbl.font = Constants.getFont(size: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
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
        tv.register(BlockedTableViewCell.self, forCellReuseIdentifier: BlockedTableViewCell.reuseIdentifier)
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
        bar.placeholder = "search blocked users"
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
    private var blockedData = [Blocked]()
    private var mainUser: User
    private var filteredBlocks = [Blocked]()
    weak var updateFeedDelegate: UpdateFeedDelegate?
    
    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(spinner)
        setupNavBar()
        setupConstraints()
        
//        setupGradient()
        
        spinner.startAnimating()
        DatabaseManager.getBlocked(with: mainUser.id, completion: { [weak self] users in
            guard let `self` = self else { return }
            self.setupBlockedData(blocked: users)
            self.configureDatasource()
            self.spinner.stopAnimating()
        })
    }
    
    init(mainUser: User) {
        self.mainUser = mainUser
        super.init(nibName: nil, bundle: nil)
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
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.friends_tv_side_padding),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Setup Data
    func setupBlockedData(blocked: [User]) {
        blockedData = []
        for i in blocked {
            blockedData.append(Blocked(user: i))
        }
        filteredBlocks = blockedData
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshTV() {
        DatabaseManager.getBlocked(with: mainUser.id, completion: { [weak self] users in
            guard let `self` = self else { return }
            self.setupBlockedData(blocked: users.reversed())
            self.createSnapshot()
            self.refreshControl.endRefreshing()
        })
    }
}

// MARK: - Extensions
extension BlockedVC {
    // MARK: - Diffable Data Source
    typealias Datasource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case blockedListSection
    }
    
    enum Item: Hashable {
        case blockedListItem(Blocked)
    }
    
    struct Blocked: Hashable {
        let id = UUID()
        let user: User
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: BlockedVC.Blocked, rhs: BlockedVC.Blocked) -> Bool {
            lhs.user === rhs.user
        }
    }
    
    private func cell(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell {
        switch item {
        case .blockedListItem(let blocked):
            let cell = tableView.dequeueReusableCell(withIdentifier: BlockedTableViewCell.reuseIdentifier, for: indexPath) as! BlockedTableViewCell
            cell.configure(user: blocked.user, mainUser: mainUser, parentVC: self)
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
        snapshot.appendSections([.blockedListSection])
        snapshot.appendItems(filteredBlocks.map({ Item.blockedListItem($0) }), toSection: .blockedListSection)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Extension (UITableViewDelegate)
extension BlockedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.friends_cell_height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text!.isEmpty {
            let blocked = filteredBlocks[indexPath.row].user
            let profileVC = OtherUserProfileVC(user: blocked, mainUser: mainUser)
            profileVC.updateFeedDelegate = updateFeedDelegate
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - Other Extensions
extension BlockedVC: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBlocks = []
        
        if searchText.isEmpty {
            filteredBlocks = blockedData
        } else {
            for name in blockedData {
                if name.user.getUserName().lowercased().contains(searchText.lowercased()) || name.user.getFullName().lowercased().contains(searchText.lowercased()) {
                    filteredBlocks.append(name)
                }
            }
        }
        
        var oldSnapshot = datasource.snapshot()
        oldSnapshot.deleteAllItems()
        datasource.apply(oldSnapshot, animatingDifferences: false)
        createSnapshot()
    }
}
