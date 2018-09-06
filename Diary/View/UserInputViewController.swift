//
//  UserInputViewController.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit
import RealmSwift



//protocol UserInputViewControllerDelegate {
//    func ReturnIndex(result: String) -> Void
//   // func ReturnHourMinute(result: String) -> Void
//
//}


class UserInputViewController: UIViewController {

  //  var mDelegate : UserInputViewControllerDelegate?
    var mIndex: String = ""
    var mHourMinutes: String = ""
    var SaveDate = String()
    
    
    
 //  let diaryItem = Diary()
    
    
    @IBOutlet weak var mDetail: UITextView!
    @IBOutlet weak var mStatus: UITextView!
    @IBOutlet weak var mTitle: UITextView!
    
    let realm = try! Realm()
    
    var diaryList: Results<Diary>{
        get {
            return realm.objects(Diary.self)
        }
    }
    
    @IBAction func mAddButton(_ sender: Any) {
       let diaryItem = Diary()
        diaryItem.title = mTitle.text
        diaryItem.status = mStatus.text
        diaryItem.detail = mDetail.text
          diaryItem.date = self.mIndex
        diaryItem.HourMinutes = self.mHourMinutes
        Utils.SHOW_LOG(title: "date", content: mIndex)
        Utils.SHOW_LOG(title: "hour", content: mHourMinutes)
        if (mTitle.text != "" || mStatus.text != "" || mDetail.text != "" ) {
            
        try! self.realm.write({
            self.realm.add(diaryItem)
            dismiss(animated: true, completion: nil)
        })
        }
        
        
//        let StoryBoard = UIStoryboard(name: "Diary", bundle: nil)
//        let Diary = StoryBoard.instantiateViewController(withIdentifier: "DiaryViewController") as! DiaryViewController
//        Diary.mDate = mIndex
//        Diary.mHour = mHourMinutes
//        self.navigationController?.pushViewController(Diary, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        Utils.SHOW_LOG(title: "mIndex", content: mIndex)
        Utils.SHOW_LOG(title: "mHourMinute", content: mHourMinutes)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
