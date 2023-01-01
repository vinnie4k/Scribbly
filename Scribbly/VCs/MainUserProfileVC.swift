//
//  MainUserProfileVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

// TODO: ALREADY REFACTORED

import UIKit

class MainUserProfileVC: UIViewController {
    // MARK: - Properties (view)
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "profile"
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
    
    private lazy var settingsButton: UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        if (traitCollection.userInterfaceStyle == .dark) {
            config.image = UIImage(named: "settings_dark")
        } else if (traitCollection.userInterfaceStyle == .light) {
            config.image = UIImage(named: "settings_light")
        }
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        btn.configuration = config
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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

        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(reduceImage))
        view.addGestureRecognizer(tap_gesture)
        view.isUserInteractionEnabled = true

        view.addSubview(customBlurEffectView)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        cv.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: ProfileHeaderCell.reuseIdentifier)
        cv.register(MemsBookHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MemsBookHeaderView.reuseIdentifier)
        cv.register(MemsBookHeaderView.self, forSupplementaryViewOfKind: MemsBookHeaderView.reuseIdentifier, withReuseIdentifier: MemsBookHeaderView.reuseIdentifier)
        cv.register(MemsCollectionViewCell.self, forCellWithReuseIdentifier: MemsCollectionViewCell.reuseIdentifier)
        cv.register(BookmarksCollectionViewCell.self, forCellWithReuseIdentifier: BookmarksCollectionViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Properties (data)
    var mainUser: User!
    private var memsData = [Month]()
    private var booksData = [Bookmarks]()
    private var datasource: Datasource!
    private var updateMems: Bool = true
    var updateFeedDelegate: UpdateFeedDelegate!
    var updatePFPDelegate: UpdatePFPDelegate!
    
    // MARK: - viewDidLoad, setupNavBar, and setupConstraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.primary_dark
        collectionView.backgroundColor = Constants.primary_dark
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor =  Constants.primary_light
            collectionView.backgroundColor = Constants.primary_light
        }
        
        view.addSubview(collectionView)
        view.addSubview(drawViewLarge)
        
        setupGradient()
        setupBooksData()
        setupMemsData()
        configureDatasource()
        setupNavBar()
        setupConstraints()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.prof_head_top),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            drawViewLarge.topAnchor.constraint(equalTo: view.topAnchor),
            drawViewLarge.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawViewLarge.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawViewLarge.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    // MARK: - Data Helper Functions
    private func setupBooksData() {
        booksData = [Bookmarks]()   // Must reset first
        for books in mainUser.getBookmarks() {
            booksData.append(Bookmarks(post: books))
        }
        booksData.reverse()
    }
    
    /**
     Returns a list of Strings representing a day given a selected date. An empty string is used as a placeholder.
     The first element is a String representing the month and year (such as "December 2022")
     For example, if the date is December 2022, the function returns
     ["","","","","1","2",...]
     */
    private func setupMemsData() {
        memsData = [Month]()   // Must reset first
        
        let months = mainUser.monthsFromStart()
        for month in months {
            var accum = [String]()
            accum.append(month)
            
            let date = CalendarHelper().getDateFromDayMonthYear(str: "1 " + month)
            let days = getDaysAsString(selected_date: date)
            for day in days {
                accum.append(day)
            }
            memsData.append(Month(array: accum))
        }
    }
    
    /**
     Returns a list of Strings representing a day given a selected date. An empty string is used as a placeholder.
     For example, if the date is December 2022, the function returns
     ["","","","","1","2",...]
     */
    private func getDaysAsString(selected_date: Date) -> [String] {
        var result = [String]()
        
        let days_in_month = CalendarHelper().daysInMonth(date: selected_date)
        let first_day_of_month = CalendarHelper().firstOfMonth(date: selected_date)
        let starting_spaces = CalendarHelper().weekDay(date: first_day_of_month)
        
        var count: Int = 1
        while (count <= 42) {
            if (count <= starting_spaces || count - starting_spaces > days_in_month) {
                result.append("")
            } else {
                result.append(String(count - starting_spaces))
            }
            count += 1
        }
        
        // Delete last row
        var delete_last_row: Bool = true
        for i in 35...41 {
            if (result[i] != "") {
                delete_last_row = false
            }
        }
        if (delete_last_row) {
            for _ in 35...41 {
                result.removeLast()
            }
        }
        return result
    }
    
    // MARK: - Button Helpers
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.drawViewLarge.alpha = 0.0
        }, completion: nil)
        drawViewLarge.subviews[1].removeFromSuperview()
        reloadMemsBooksItems()
        updateFeedDelegate.updateFeed()
    }
}

// MARK: - Extensions
extension MainUserProfileVC {
    // MARK: - Layout
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
    }

    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = datasource.snapshot().sectionIdentifiers[index]

        switch section {
        case .profileHeader:
            return createProfileHeaderSection()
        case .memsSection:
            return createMemsSection()
        case .booksSection:
            return createBooksSection()
        }
    }
    
    func createBooksSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/4)), subitems: [item])
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.mems_book_height)), elementKind: MemsBookHeaderView.reuseIdentifier, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createMemsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(Constants.mems_month_height + 50)), subitems: [item])
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.mems_book_height)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createProfileHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.prof_head_height)), subitems: [item])

        return NSCollectionLayoutSection(group: group)
    }
    
    // MARK: - Diffable Data Source
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case profileHeader
        case memsSection
        case booksSection
    }

    enum Item: Hashable {
        case profileHeaderCell
        case memsCell(Month)
        case booksCell(Bookmarks)
    }
    
    struct Bookmarks: Hashable {
        var id = UUID()
        var post: Post
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: MainUserProfileVC.Bookmarks, rhs: MainUserProfileVC.Bookmarks) -> Bool {
            lhs.post === rhs.post
        }
    }
    
    struct Month: Hashable {
        var id = UUID()
        var array: [String]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
        
    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell {
        switch item {
        case .profileHeaderCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHeaderCell.reuseIdentifier, for: indexPath) as! ProfileHeaderCell
            cell.configure(user: mainUser, mode: traitCollection.userInterfaceStyle, parentVC: self)
            cell.updatePFPDelegate = updatePFPDelegate
            cell.updateProfileDelegate = self
            return cell
        case .memsCell (let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemsCollectionViewCell.reuseIdentifier, for: indexPath) as! MemsCollectionViewCell
            cell.postInfoDelegate = self
            cell.configure(data: data.array, user: mainUser)
            return cell
        case .booksCell(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarksCollectionViewCell.reuseIdentifier, for: indexPath) as! BookmarksCollectionViewCell
            cell.configure(post: data.post)
            cell.postInfoDelegate = self
            return cell
        }
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case MemsBookHeaderView.reuseIdentifier:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: MemsBookHeaderView.reuseIdentifier, withReuseIdentifier: MemsBookHeaderView.reuseIdentifier, for: indexPath) as! MemsBookHeaderView
            header.switchViewDelegate = self
            header.configure(mode: traitCollection.userInterfaceStyle, start: 1)
            return header
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MemsBookHeaderView.reuseIdentifier, for: indexPath) as! MemsBookHeaderView
            header.switchViewDelegate = self
            header.configure(mode: traitCollection.userInterfaceStyle, start: 0)
            return header
        }
    }
    
    private func configureDatasource() {
        datasource = Datasource(collectionView: collectionView, cellProvider: cell(collectionView:indexPath:item:))
        datasource.apply(snapshot(), animatingDifferences: false)
        datasource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
    }
    
    func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.profileHeader, .memsSection])
        snapshot.appendItems([.profileHeaderCell], toSection: .profileHeader)
        snapshot.appendItems(memsData.map({ Item.memsCell($0) }), toSection: .memsSection)
        return snapshot
    }
}

// MARK: - Delegation and Other Extensions
extension MainUserProfileVC: PostInfoDelegate, SwitchViewDelegate, UpdateProfileDelegate {
    // MARK: - PostInfoDelegate
    func showPostInfo(post: Post) {
        return  // Do nothing here
    }
    
    func showMemsInfo(post: Post) {
        let view = MemsInfoView()
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
    
    func showBooksInfo(post: Post) {
        let view = BooksInfoView()
        view.configure(post: post, mode: traitCollection.userInterfaceStyle, parentVC: self, mainUser: mainUser)
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
    
    // MARK: - SwitchViewDelegate
    func switchView(pos: Int) {
        var newSnapshot = Snapshot()
        
        var oldSnapshot = datasource.snapshot(for: Section.profileHeader)
        oldSnapshot.deleteAll()
        
        if pos == 0 {
            var oldSnapshot = datasource.snapshot(for: Section.booksSection)
            oldSnapshot.deleteAll()
            
            newSnapshot.appendSections([.profileHeader, .memsSection])
            newSnapshot.appendItems([.profileHeaderCell], toSection: .profileHeader)
            newSnapshot.appendItems(memsData.map({ Item.memsCell($0) }), toSection: .memsSection)
            
            updateMems = true
        } else if pos == 1 {
            var oldSnapshot = datasource.snapshot(for: Section.memsSection)
            oldSnapshot.deleteAll()
            
            newSnapshot.appendSections([.profileHeader, .booksSection])
            newSnapshot.appendItems([.profileHeaderCell], toSection: .profileHeader)
            newSnapshot.appendItems(booksData.map({ Item.booksCell($0) }), toSection: .booksSection)
            
            updateMems = false
        }
        datasource.apply(newSnapshot, animatingDifferences: true)
    }
    
    // MARK: - UpdateProfileDelegate
    func updateProfile() {
        collectionView.reloadData()
    }
    
    // MARK: - Extra Helpers
    func reloadMemsBooksItems() {
        var newSnapshot = Snapshot()
        
        if updateMems {
            var oldSnapshot = datasource.snapshot(for: Section.memsSection)
            oldSnapshot.deleteAll()
            
            setupMemsData()

            newSnapshot.appendSections([.profileHeader, .memsSection])
            newSnapshot.appendItems([.profileHeaderCell], toSection: .profileHeader)
            newSnapshot.appendItems(memsData.map({ Item.memsCell($0) }), toSection: .memsSection)
        } else {
            var oldSnapshot = datasource.snapshot(for: Section.memsSection)
            oldSnapshot.deleteAll()
            
            setupBooksData()
            
            newSnapshot.appendSections([.profileHeader, .booksSection])
            newSnapshot.appendItems([.profileHeaderCell], toSection: .profileHeader)
            newSnapshot.appendItems(booksData.map({ Item.booksCell($0) }), toSection: .booksSection)
        }
        datasource.applySnapshotUsingReloadData(newSnapshot)
    }
}
