//
//  Utils.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Utils {
    
    static let ref = Database.database().reference()
    
    static func remove(child1: String, child2: String, child3: String) {
        
        let ref = self.ref.child(child1).child(child2).child(child3)
        
        ref.removeValue { error, _ in
            
            print(error)
        }
    }
    
    static func showMessage(title: String?, message: String?, viewcontroler: UIViewController) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        viewcontroler.present(alert, animated: true, completion: nil)
    }
    
    static func SHOW_LOG(content: Any) {
        print(content)
    }
    static func SHOW_LOG(title: String, content: Any) {
        print("\(title): \(content)")
    }
    static func checkInternet(viewcontroler: UIViewController) -> Bool {
        if Connectivity.isConnectedToInternet() {
            Utils.SHOW_LOG(content: "Yes! internet is available.")
            return true
        }
        
         showMessage(title: "utils_message_title".localized, message: "internet_disable".localized, viewcontroler: viewcontroler)
     
        return false
    }
    
    
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
