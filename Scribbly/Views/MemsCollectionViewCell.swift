//
//  MemsCollectionViewCell.swift
//  Scribbly
//
//  Created by Vin Bui on 12/25/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: MemsTinyPostView
class MemsTinyPostView: UIView {
    // MARK: - Properties (view)
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.tintColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var drawing: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = Constants.mems_cell_corner
        img.translatesAutoresizingMaskIntoConstraints = false

        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(showStats))
        img.addGestureRecognizer(tap_gesture)
        img.isUserInteractionEnabled = true

        return img
    }()

    private let hiddenImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    // MARK: - Properties (data)
    private weak var parentVC: UIViewController!
    private var post: Post? = nil
    weak var postInfoDelegate: PostInfoDelegate?
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = Constants.mems_cell_corner
        
        backgroundColor = Constants.secondary_color
        
        addSubview(drawing)
        addSubview(dateLabel)
        addSubview(hiddenImage)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: Post?, text: String) {
        self.post = post

        if post != nil {
            drawing.image = post!.getDrawing()
        }
        dateLabel.text = text
        determineBlur()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            drawing.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            drawing.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            drawing.topAnchor.constraint(equalTo: self.topAnchor),
            drawing.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            hiddenImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hiddenImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    // MARK: - Helper Functions
    private func determineBlur() {
        if post != nil {
            if post!.isHidden() {
                drawing.applyBlurEffect()
                dateLabel.text = ""
                hiddenImage.image = UIImage(named: "hidden")
            } else {
                hiddenImage.image = nil
            }
        }
    }
    
    // MARK: - Button Helpers
    @objc private func showStats() {
        if post != nil {
            postInfoDelegate?.showMemsInfo(post: post!)
        }
    }
}

// MARK: MemsCollectionViewCell
class MemsCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties (view)
    private let monthLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Constants.getFont(size: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let dayOfWeekStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.tintColor = .label
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false

        let day_of_week = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
        for day in day_of_week {
            let lbl = UILabel()
            lbl.text = day
            lbl.font = Constants.getFont(size: 14, weight: .medium)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(lbl)
        }
        return stack
    }()
    
    private var stackGrid: UIStackView!
    
    // MARK: - Properties (data)
    static let reuseIdentifier = "MemsCollectionViewCellReuse"
    private var data: [String]!
    private var user: User!
    weak var postInfoDelegate: PostInfoDelegate!
    
    // MARK: - init, configure, and setupConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.secondary_color
                
        addSubview(monthLabel)
        addSubview(dayOfWeekStack)
                
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: [String], user: User) {
        self.data = data
        self.user = user
        
        monthLabel.text = data[0].lowercased()
        stackGrid = createOuterStack(info: data, spacing: CGFloat(5))
        
        addSubview(stackGrid)
        
        NSLayoutConstraint.activate([
            stackGrid.topAnchor.constraint(equalTo: dayOfWeekStack.bottomAnchor, constant: 5),
            stackGrid.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            stackGrid.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            stackGrid.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            monthLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            monthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dayOfWeekStack.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 5),
            dayOfWeekStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.mems_day_of_week_side),
            dayOfWeekStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.mems_day_of_week_side),
        ])
    }
    
    // MARK: - Helper Functions
    private func createOuterStack(info: [String], spacing: CGFloat) -> UIStackView {
        let outerStack = UIStackView()
        outerStack.axis = .vertical
        outerStack.distribution = .equalSpacing
        outerStack.spacing = spacing
        outerStack.translatesAutoresizingMaskIntoConstraints = false
        
        var data = info
        data.removeFirst()
        
        var count = 7
        while count < info.count {
            outerStack.addArrangedSubview(getInnerStack(info: Array(data.prefix(upTo: 7)), spacing: spacing))
            data.removeFirst(7)
            count += 7
        }
        return outerStack
    }
    
    private func getInnerStack(info: [String], spacing: CGFloat) -> UIStackView {
        let innerStack = UIStackView()
        innerStack.axis = .horizontal
        innerStack.distribution = .fillEqually
        innerStack.spacing = spacing
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        for text in info {
            let tinyView = MemsTinyPostView()
            
            if (text != "") {
                let date = CalendarHelper().getDateFromDayMonthYear(str: text + " " + data[0])
                let post = self.user.getPostFromDate(selected_date: date)
                tinyView.configure(post: post, text: text)
                tinyView.postInfoDelegate = self.postInfoDelegate
            } else {
                tinyView.configure(post: nil, text: text)
            }

            tinyView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7 - 4).isActive = true
            
            innerStack.addArrangedSubview(tinyView)
        }
        return innerStack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        data = nil
        stackGrid.removeFromSuperview()
        stackGrid = nil
    }
}
