//
//  Extensions.swift
//  Scribbly
//
//  Created by Vin Bui on 12/23/22.
//

import UIKit

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
        view.endEditing(true)
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
