//
//  Extensions and Protocols.swift
//  Scribbly
//
//  Created by Vin Bui on 12/23/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: - Protocols
protocol ContactsDelegate: AnyObject {
    func addToFollow(userID: String)
    func removeFromFollow(userID: String)
}

protocol DismissTutorialDelegate: AnyObject {
    func dismissTutorial()
}

protocol DismissTimerDelegate: AnyObject {
    func dismissTimerVC()
}

protocol UpdateRequestsDelegate: AnyObject {
    func updateRequests()
}

protocol UpdateProfileDelegate: AnyObject {
    func updateProfile()
}

protocol UpdatePFPDelegate: AnyObject {
    func updatePFP()
}

protocol UpdateFeedDelegate: AnyObject {
    func updateFeed()
}

protocol SwitchViewDelegate: AnyObject {
    func switchView(pos: Int)
}

protocol ReloadStatsDelegate: AnyObject {
    func reloadStats()
}

protocol PostInfoDelegate: AnyObject {
    func showPostInfo(post: Post)
    func showMemsInfo(post: Post)
    func showBooksInfo(post: Post)
}

protocol EnlargeDrawingDelegate: AnyObject {
    func enlargeDrawing(drawing: UIImage)
}

protocol CommentDelegate: AnyObject {
    func sendReplyComment(comment: Comment)
    func sendReplyReply(comment: Comment, reply: Reply)
    func deleteComment(comment: Comment)
}

// MARK: - UIViewController
extension UIViewController {
    // MARK: - Dismissing keyboard
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Gradient Scroll
    func setupGradient() {
        if traitCollection.userInterfaceStyle == .dark {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0, 0.1, 0.85, 1]
            view.layer.mask = gradient
        }
    }
}

// MARK: - GradientView
final class GradientView: UIView {
    /**
     // Simple usage. From clear to black.
     let gradientView1 = GradientView(colors: [.clear, .black])

     // Tweak locations. Here the gradient from red to green will take 30% of the view.
     let gradientView2 = GradientView(colors: [.red, .green, .blue], locations: [0, 0.3, 1])

     // Create your own gradient.
     let gradient = CAGradientLayer()
     gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
     let gradientView3 = GradientView(gradient: gradient)
     */
    let gradient : CAGradientLayer

    init(gradient: CAGradientLayer) {
        self.gradient = gradient
        super.init(frame: .zero)
        self.gradient.frame = self.bounds
        self.layer.insertSublayer(self.gradient, at: 0)
    }

    convenience init(colors: [UIColor], locations:[Float] = [0.0, 1.0]) {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations.map { NSNumber(value: $0) }
        self.init(gradient: gradient)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.gradient.frame = self.bounds
    }

    required init?(coder: NSCoder) { fatalError("no init(coder:)") }
}

// MARK: - CustomVisualEffectView
final class CustomVisualEffectView: UIVisualEffectView {
    /**
     Create visual effect view with given effect and its intensity
        Parameters:
         - effect: visual effect, eg UIBlurEffect(style: .dark)
         - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
     */
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
    
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
}

// MARK: - CalendarHelper
class CalendarHelper {
    let calendar = Calendar.current
    
    func formatDate(date: Date) -> String {
        // Example: 26 December 2022 04:20:00
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "d MMMM yyyy HH:mm:ss"
        return date_formatter.string(from: date)
    }
    
    func getDateFromDayMonthYear(str: String) -> Date {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "d MMMM yyyy"
        return date_formatter.date(from: str)!
    }
    
    func monthYearString(date: Date) -> String {
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "MMMM yyyy"
        return date_formatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}

// MARK: - UIImageView (applyBlurEffect)
extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.1)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

// MARK: - UITextField
extension UITextField {
    func addUnderline(color: UIColor, width: Int) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 20, width: width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    func addUnderlineOnboard(color: UIColor, width: Int) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 50, width: width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    func addInvalid() {
        let img = UIImageView(image: UIImage(named: "caution_sign"))
        img.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(img)
        img.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -2).isActive = true
        img.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        img.heightAnchor.constraint(equalToConstant: 20).isActive = true
        img.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func removeInvalid() {
        for i in self.subviews {
            i.removeFromSuperview()
        }
    }
}

// MARK: - Dictionary Helpers
extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

// MARK: - StackView Helpers
class SeparatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.secondary_text.withAlphaComponent(0.3)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height:0.5)
    }
}

// MARK: - Crop to square
extension UIImage {
    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)

        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2

        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }

        return nil
    }
}
