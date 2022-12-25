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
