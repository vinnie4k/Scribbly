//
//  RequestsVC.swift
//  Scribbly
//
//  Created by Vin Bui on 1/1/23.
//

import UIKit

// MARK: RequestsVC
class RequestsVC: UIViewController {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "requests"
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
        tv.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.reuseIdentifier)
        tv.sectionHeaderTopPadding = 0
        tv.separatorStyle = .none
        tv.delegate = self
        tv.addSubview(noRequestLabel)
        tv.addSubview(refreshControl)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let noRequestLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "there are no requests"
        lbl.font = Constants.getFont(size: 20, weight: .regular)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.alpha = 0
        return lbl
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.placeholder = "search requests"
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
    
    // MARK: - Properties (data)
    private var datasource: Datasource!
    private var requestsData = [Request]()
    private var mainUser: User
    private var filteredRequests = [Request]()
    weak var updateRequestsDelegate: UpdateRequestsDelegate?
    weak var updateFeedDelegate: UpdateFeedDelegate?
    
    // MARK: - viewDidLoad, init, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
//        setupGradient()
        determineLabel()
        setupNavBar()
        configureDatasource()
        setupConstraints()
    }
    
    init(mainUser: User, requests: [User]) {
        self.mainUser = mainUser
        super.init(nibName: nil, bundle: nil)
        setupRequestsData(requests: requests)
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
            
            noRequestLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            noRequestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Setup Data
    func setupRequestsData(requests: [User]) {
        requestsData = []
        for i in requests {
            requestsData.append(Request(user: i))
        }
        filteredRequests = requestsData
    }
    
    private func determineLabel() {
        if filteredRequests.isEmpty {
            noRequestLabel.alpha = 1
        } else {
            noRequestLabel.alpha = 0
        }
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        navigationController?.popViewController(animated: true)
        self.updateRequestsDelegate?.updateRequests()
    }
    
    @objc private func refreshTV() {
        DatabaseManager.getRequests(with: mainUser.id, completion: { [weak self] users in
            guard let `self` = self else { return }
            self.setupRequestsData(requests: users.reversed())
            self.createSnapshot()
            self.determineLabel()
            self.refreshControl.endRefreshing()
        })
    }
}

// MARK: - Extensions
extension RequestsVC {
    // MARK: - Diffable Data Source
    typealias Datasource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case requestsListSection
    }
    
    enum Item: Hashable {
        case requestsListItem(Request)
    }
    
    struct Request: Hashable {
        let id = UUID()
        let user: User
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: RequestsVC.Request, rhs: RequestsVC.Request) -> Bool {
            lhs.user === rhs.user
        }
    }
    
    private func cell(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell {
        switch item {
        case .requestsListItem(let request):
            let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.reuseIdentifier, for: indexPath) as! RequestTableViewCell
            cell.updateRequestsDelegate = updateRequestsDelegate
            cell.configure(user: request.user, mainUser: mainUser)
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
        snapshot.appendSections([Section.requestsListSection])
        snapshot.appendItems(filteredRequests.map({ Item.requestsListItem($0) }), toSection: .requestsListSection)
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Extension (UITableViewDelegate)
extension RequestsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.friends_cell_height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text!.isEmpty {
            let request = filteredRequests[indexPath.row].user
            let profileVC = OtherUserProfileVC(user: request, mainUser: mainUser)
            profileVC.updateRequestsDelegate = updateRequestsDelegate
            profileVC.updateFeedDelegate = updateFeedDelegate
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

// MARK: - Other Extensions
extension RequestsVC: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRequests = []
        
        if searchText.isEmpty {
            filteredRequests = requestsData
        } else {
            for name in requestsData {
                if name.user.getUserName().lowercased().contains(searchText.lowercased()) || name.user.getFullName().lowercased().contains(searchText.lowercased()) {
                    filteredRequests.append(name)
                }
            }
        }
        
        var oldSnapshot = datasource.snapshot()
        oldSnapshot.deleteAllItems()
        datasource.apply(oldSnapshot, animatingDifferences: false)
        createSnapshot()
    }
}
