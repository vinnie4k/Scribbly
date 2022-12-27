//
//  Extensions.swift
//  Scribbly
//
//  Created by Vin Bui on 12/23/22.
//

import UIKit

/**
 Delegation
 */
protocol PostInfoDelegate {
    func showPostInfo(post: Post)
}

protocol EnlargeDrawingDelegate {
    func enlargeDrawing(drawing: UIImage)
}

protocol CommentDelegate {
    func sendReplyComment(comment: Comment)
    func sendReplyReply(comment: Comment, reply: Reply)
    func deleteComment(comment: Comment)
}

extension UIViewController {
    /**
     For dimissing the keyboard
     */
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
    
}

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

extension UINavigationBar {
    func toggle() {
        if self.layer.zPosition == -1 {
            self.layer.zPosition = 0
            self.isUserInteractionEnabled = true
        } else {
            self.layer.zPosition = -1
            self.isUserInteractionEnabled = false
        }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

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
