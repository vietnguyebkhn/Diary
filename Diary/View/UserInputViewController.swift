//
//  UserInputViewController.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase



//protocol UserInputViewControllerDelegate {
//    func ReturnIndex(result: String) -> Void
//   // func ReturnHourMinute(result: String) -> Void
//
//}


class UserInputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
  
    
 var status = ["An lành", "Buồn bã", "Chán nản", "Choáng váng", "Cô đơn", "Đáng yêu", "Đau đớn", "Điên", "Đang yêu", "Hạnh phúc", "Hoa mắt", "Không hứng thú", "Kích thích", "Kiệt sức"]
  //  var mDelegate : UserInputViewControllerDelegate?
    var mIndex: String = ""
    var mHourMinutes: String = ""
    var SaveDate = String()
    var postid = ""
    let InsUpdDelItem = InsUpdDel()
    var ListInsUpdDel: Results<InsUpdDel> {
        get {
            return realm.objects(InsUpdDel.self)
        }
    }
    
    
 //  let diaryItem = Diary()
    
    

    
    @IBOutlet weak var mStatusTableView: UITableView!
    @IBOutlet weak var mDetail: UITextView!
    @IBOutlet weak var mStatus: UITextView!
    @IBOutlet weak var mTitle: UITextView!
     let diaryItem = Diary()
    let realm = try! Realm()
     var ref: DatabaseReference!
    var diaryList: Results<Diary>{
        get {
            return realm.objects(Diary.self)
        }
    }
  
    @IBAction func mStatusButton(_ sender: Any) {
        mStatusTableView.isHidden = false
        
    }
    
    
    
    @IBAction func mAddButton(_ sender: Any) {
      
        diaryItem.title = mTitle.text
        diaryItem.status = mStatus.text
        diaryItem.detail = mDetail.text
          diaryItem.date = self.mIndex
        diaryItem.HourMinutes = self.mHourMinutes
        let uid = (Auth.auth().currentUser?.uid) ?? ""
        if postid == "" {
         diaryItem.postid = "\(UInt64(Date().timeIntervalSince1970 * 10000000))"
        
        if (mTitle.text != "" || mStatus.text != "" || mDetail.text != "" ) {
            
            try! self.realm.write({
                self.realm.add(diaryItem)
            })
        }
        } else {
            diaryItem.postid = postid
            try! self.realm.write({
                self.realm.add(diaryItem, update: true)
                Utils.SHOW_LOG(title: "diaryItem", content: diaryItem)
            
            })
        }
        
        if Utils.checkInternet(viewcontroler: self) {
            self.ref = Database.database().reference().child("user").child(uid)

            self.ref.updateChildValues([
                diaryItem.postid: [
                    "title": diaryItem.title,
                    "detail": diaryItem.detail,
                    "hour": diaryItem.HourMinutes,
                    "date": diaryItem.date,
                    "status": diaryItem.status,
                    "postid": diaryItem.postid
                ]
                
                ])
        } else {
            InsUpdDelItem.ins.append(diaryItem.postid)
            try! self.realm.write({
                self.realm.add(InsUpdDelItem)
                Utils.SHOW_LOG(title: "Item Insert", content: ListInsUpdDel)
            })
        }
        
        Utils.SHOW_LOG(title: "timestamp", content: diaryItem.postid)
        Utils.SHOW_LOG(title: "date", content: mIndex)
        Utils.SHOW_LOG(title: "hour", content: mHourMinutes)
       
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ejimoti", for: indexPath)
        cell.textLabel?.text = status[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mStatus.text = status[indexPath.row]
        mStatusTableView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        Utils.SHOW_LOG(title: "mIndex", content: mIndex)
        Utils.SHOW_LOG(title: "mHourMinute", content: mHourMinutes)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if postid != "" {
            for item in diaryList {
                if item.postid == postid {
                    mTitle.text = item.title
                    mStatus.text = item.status
                    mDetail.text = item.detail

                }
            }
            
//            Utils.SHOW_LOG(title: "title", content: diaryList.filter("postid == %@", postid).value(forKey: "title") ?? "a")
//            Utils.SHOW_LOG(title: "title", content: diaryList.filter("postid == %@", postid).value(forKeyPath: "detail") ?? "a")
//            Utils.SHOW_LOG(title: "title", content: diaryList.filter("postid == %@", postid).value(forKeyPath: "status") ?? "a")
//            mTitle.text = String(diaryList.filter("postid == %@", postid).value(forKeyPath: "title") as? String ?? "a")
//            Utils.SHOW_LOG(title: "title", content: mTitle.text)
//
//            mStatus.text = String(diaryList.filter("postid == %@", postid).value(forKeyPath: "status") as? String ?? "a")
//            mDetail.text = String(diaryList.filter("postid == %@", postid).value(forKeyPath: "detail") as? String ?? "a")
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //        //location is relative to the current view
        //        // do something with the touched point
               if touch?.view != mStatusTableView {
                  mStatusTableView.isHidden = true
    }
    }
    


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraints) in
            if constraints.firstAttribute == .height {
                constraints.constant = estimateSize.height
            }
            
        }
    }
}
