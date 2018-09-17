//
//  LoginFacebookViewController.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/10/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import RealmSwift


class LoginFacebookViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var ref: DatabaseReference!
    let realm = try! Realm()
    var diaryList: Results<Diary>{
        get {
            return realm.objects(Diary.self)
            
        }
    }
    
    
    
    var LogginButtonFB: FBSDKLoginButton = FBSDKLoginButton()
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Logined")
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                Utils.SHOW_LOG(title: "Login firebase faile", content: error)
                return
            } else {
            Utils.SHOW_LOG(content: "Login Firebase success")
                self.ref = Database.database().reference().child("user").child((Auth.auth().currentUser?.uid)!)
                for item in self.diaryList {
                    if item != nil {
                        self.ref.updateChildValues([
                            item.postid: [
                                "title": item.title,
                                "detail": item.detail,
                                "hour": item.HourMinutes,
                                "date": item.date,
                                "status": item.status,
                                "postid": item.postid

                            ]
                            
                            ])
                    }
                }
//                self.checkLoginFB()
//                return
                let HomeStoryboard = UIStoryboard(name: "Main", bundle: nil)

                let Diary = HomeStoryboard.instantiateViewController(withIdentifier: "Calendar") as! ViewController
                self.navigationController?.pushViewController(Diary, animated: true)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        Utils.SHOW_LOG(content: "Logouted")
    }
    
    
    
    @IBAction func mLoginFacebook(_ sender: Any) {
        loginFB()
    }
    
    
    func checkLoginFB() {
       Auth.auth().addStateDidChangeListener { (auth, user) in
        if let user = user {
            self.ref = Database.database().reference().child("user").child((Auth.auth().currentUser?.uid)!)
            for item in self.diaryList {
                if item != nil {
                    self.ref.updateChildValues([
                        item.postid: [
                            "title": item.title,
                            "detail": item.detail,
                            "hour": item.HourMinutes,
                            "date": item.date,
                            "status": item.status,
                            "postid": item.postid
                        ]
                        
                        ])
                }
            }
            let HomeStoryboard = UIStoryboard(name: "Main", bundle: nil)
          
            let Diary = HomeStoryboard.instantiateViewController(withIdentifier: "Calendar") as! ViewController
          self.navigationController?.pushViewController(Diary, animated: true)
        
      //  self.present(Diary, animated: false, completion: nil)
            Utils.SHOW_LOG(title: "UID", content: user.uid)
            
        } else {
           
            self.LogginButtonFB.frame = CGRect(x: 16, y: 50, width: self.view.frame.width - 32, height: 50)
            self.LogginButtonFB.readPermissions = ["public_profile", "email"]
            self.LogginButtonFB.delegate = self
            self.view.addSubview(self.LogginButtonFB)
        }
        }
    }
    
    let fbLoginmanager: FBSDKLoginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     //   print( self.LogginButtonFB.readPermissions)
        // Do any additional setup after loading the view.
    }

    func loginFB() {
        
       
        fbLoginmanager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
           
            
            if (error == nil) {
                Utils.SHOW_LOG(content: "Login success")
                let fbLoginResul: FBSDKLoginManagerLoginResult = result!
                
                if (fbLoginResul.grantedPermissions != nil) {
                    self.getData()
                }
            } else {
                Utils.SHOW_LOG(title: "That bai", content: error)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        if Utils.checkInternet(viewcontroler: self) == true {
            checkLoginFB()
        } else {
            let HomeStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Diary = HomeStoryboard.instantiateViewController(withIdentifier: "Calendar") as! ViewController
            self.navigationController?.pushViewController(Diary, animated: true)
        }
        
    }
    
    
    func getData() {
        if FBSDKAccessToken.current() != nil {
            let params = ["fields": "id, name, email"]
            FBSDKGraphRequest(graphPath: "me", parameters: params).start(completionHandler: { (connect, result, error) in
                if (error == nil ) {
                    let dict = result as! Dictionary< String, Any>
                    print(dict)
                } else {
                    Utils.SHOW_LOG(title: "Get data false", content: error)
                }
                
            })
        }
    }

   

}
