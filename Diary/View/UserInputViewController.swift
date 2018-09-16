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
    
    
    
 //  let diaryItem = Diary()
    
    

    
    @IBOutlet weak var mStatusTableView: UITableView!
    @IBOutlet weak var mDetail: UITextView!
    @IBOutlet weak var mStatus: UITextView!
    @IBOutlet weak var mTitle: UITextView!
    
    let realm = try! Realm()
    
    var diaryList: Results<Diary>{
        get {
            return realm.objects(Diary.self)
        }
    }
  
    @IBAction func mStatusButton(_ sender: Any) {
        mStatusTableView.isHidden = false
        
    }
    
    
    
    @IBAction func mAddButton(_ sender: Any) {
       let diaryItem = Diary()
        diaryItem.title = mTitle.text
        diaryItem.status = mStatus.text
        diaryItem.detail = mDetail.text
          diaryItem.date = self.mIndex
        diaryItem.HourMinutes = self.mHourMinutes
         diaryItem.postid = "\(UInt64(Date().timeIntervalSince1970 * 10000000))"
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("user")
        
            ref.updateChildValues([
                "\(UInt64(Date().timeIntervalSince1970 * 10000000))": [
                "title": mTitle.text ?? "",
                "detail": mDetail.text ?? "",
                "hour": self.mHourMinutes,
                "date": self.mIndex,
                "status":  mStatus.text ?? ""
                ]
                ])
        
       
        Utils.SHOW_LOG(title: "timestamp", content: diaryItem.postid)
        Utils.SHOW_LOG(title: "date", content: mIndex)
        Utils.SHOW_LOG(title: "hour", content: mHourMinutes)
        if (mTitle.text != "" || mStatus.text != "" || mDetail.text != "" ) {
            
        try! self.realm.write({
            self.realm.add(diaryItem)
//            dismiss(animated: true, completion: nil)
        })
        }
        _ = navigationController?.popViewController(animated: true)
        
//        let StoryBoard = UIStoryboard(name: "Diary", bundle: nil)
//        let Diary = StoryBoard.instantiateViewController(withIdentifier: "DiaryViewController") as! DiaryViewController
//        Diary.mDate = mIndex
//        Diary.mHour = mHourMinutes
//        self.navigationController?.pushViewController(Diary, animated: true)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first as! UITouch
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
