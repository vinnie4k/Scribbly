//
//  MainUserProfileVC.swift
//  Scribbly
//
//  Created by Vin Bui on 12/19/22.
//

import UIKit

class MainUserProfileVC: UIViewController {
    // ------------ Fields (view) ------------
    private let title_lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "profile"
        lbl.textColor = .label
        lbl.font = Constants.comment_title_font
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var back_btn: UIButton = {
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
    
    private lazy var settings_btn: UIButton = {
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
    
    private let mems_cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // ------------ Fields (data) ------------
    var main_user: User? = nil
    
    private var selected_date = Date()
    private var total_cells = [String]()
    
    // ------------ Functions ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "profile"
        
        if (traitCollection.userInterfaceStyle == .dark) {
            view.backgroundColor = Constants.secondary_dark
        } else if (traitCollection.userInterfaceStyle == .light) {
            view.backgroundColor = Constants.secondary_light
        }
        
        view.addSubview(mems_cv)
        
        setupMonthView()
        setupMemsCV()
        setupNavBar()
        setupConstraints()
    }
    
    private func setupMonthView() {
        total_cells.removeAll()
        
        let days_in_month = CalendarHelper().daysInMonth(date: selected_date)
        let first_day_of_month = CalendarHelper().firstOfMonth(date: selected_date)
        let starting_spaces = CalendarHelper().weekDay(date: first_day_of_month)
        
        var count: Int = 1
        while (count <= 42) {
            if (count <= starting_spaces || count - starting_spaces > days_in_month) {
                total_cells.append("")
            } else {
                total_cells.append(String(count - starting_spaces))
            }
            count += 1
        }
        
        deleteLastRow()
    }
    
    private func deleteLastRow() {
        var delete_last_row: Bool = true
        for i in 35...41 {
            if (total_cells[i] != "") {
                delete_last_row = false
            }
        }
        if (delete_last_row) {
            for _ in 35...41 {
                total_cells.removeLast()
            }
        }
    }

    private func setupMemsCV() {
        mems_cv.dataSource = self
        mems_cv.delegate = self
        mems_cv.register(MemsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.mems_reuse)
        mems_cv.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.prof_head_reuse)
        mems_cv.register(MonthHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.mems_month_reuse)
        
        mems_cv.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupNavBar() {
        navigationItem.titleView = title_lbl
        back_btn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_btn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settings_btn)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mems_cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mems_cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mems_cv.topAnchor.constraint(equalTo: view.topAnchor),
            mems_cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MainUserProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0) {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.prof_head_reuse, for: indexPath) as? ProfileHeaderView {
                header.configure(user: main_user!, mode: traitCollection.userInterfaceStyle)
                return header
            }
        } else {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.mems_month_reuse, for: indexPath) as? MonthHeaderView {
                print(main_user!.monthsFromStart())
                print(indexPath.section - 1)
                header.configure(text: main_user!.monthsFromStart()[indexPath.section - 1])
                return header
            }
        }

        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return main_user!.monthsFromStart().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        }
        return total_cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = mems_cv.dequeueReusableCell(withReuseIdentifier: Constants.mems_reuse, for: indexPath) as? MemsCollectionViewCell {
            let text = total_cells[indexPath.item]
            cell.configure(text: text)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSize(width: UIScreen.main.bounds.width, height: Constants.prof_head_height)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: Constants.mems_month_head_height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if (section == 0) {
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }
        return UIEdgeInsets(top: Constants.mems_section_top, left: 10, bottom: Constants.mems_section_bot, right: 10)
    }
}

extension MainUserProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.mems_cell_width, height: Constants.mems_cell_width)
    }
}
