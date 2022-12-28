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
    
    // ------------ Fields (data) ------------
    var main_user: User? = nil
    private var mems_data = [[String]]() // 43 elements, first element is the month and year
    
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
        view.addSubview(draw_view_large)
        
        setupMemsData()
        setupMemsCV()
        setupNavBar()
        setupConstraints()
    }
    
    @objc private func reduceImage() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.draw_view_large.alpha = 0.0
        }, completion: nil)
        draw_view_large.subviews[1].removeFromSuperview()
        mems_cv.reloadData()
//        self.navigationController?.navigationBar. toggle()
    }
    
    /**
     Returns a list of Strings representing a day given a selected date. An empty string is used as a placeholder.
     The first element is a String representing the month and year (such as "December 2022")
     For example, if the date is December 2022, the function returns
     ["","","","","1","2",...]
     */
    private func setupMemsData() {
        let months = main_user!.monthsFromStart()
        for month in months {
            var accum = [String]()
            accum.append(month)
            
            let date = CalendarHelper().getDateFromDayMonthYear(str: "1 " + month)
            let days = getDaysAsString(selected_date: date)
            for day in days {
                accum.append(day)
            }
            mems_data.append(accum)
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
            mems_cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            draw_view_large.topAnchor.constraint(equalTo: view.topAnchor),
            draw_view_large.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            draw_view_large.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            draw_view_large.leadingAnchor.constraint(equalTo: view.leadingAnchor)
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
                header.configure(text: mems_data[indexPath.section - 1][0])
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mems_data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        }
        return mems_data[section - 1].count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = mems_cv.dequeueReusableCell(withReuseIdentifier: Constants.mems_reuse, for: indexPath) as? MemsCollectionViewCell {
            let text = mems_data[indexPath.section - 1][indexPath.row + 1]
            if (text != "") {
                let month_str = mems_data[indexPath.section - 1][0]
                let date = CalendarHelper().getDateFromDayMonthYear(str: text + " " + month_str)
                let post = main_user!.getPostFromDate(selected_date: date)
                cell.configure(post: post, text: text, mode: traitCollection.userInterfaceStyle)
                cell.post_info_delegate = self
            } else {
                cell.configure(post: nil, text: "", mode: traitCollection.userInterfaceStyle)
            }
            return cell
        }
        return UICollectionViewCell()
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

extension MainUserProfileVC: ReloadCVDelegate, PostInfoDelegate {
    func showPostInfo(post: Post) {
        let view = MemsInfoView()
        view.configure(post: post, mode: traitCollection.userInterfaceStyle, parent_vc: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hide_share_view.reload_cv_delegate = self

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

    func reloadCV() {
        mems_cv.reloadData()
    }
}
