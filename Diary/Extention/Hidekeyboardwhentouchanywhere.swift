//
//  Hidekeyboardwhentouchanywhere.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/3/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
