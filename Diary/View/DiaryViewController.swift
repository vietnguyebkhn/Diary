//
//  DiaryViewController.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import Firebase


class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   var ref: DatabaseReference!
    //let diaryItem = Diary()
    var mDate = String()
    var mHour = String()
   // var SaveDate = String()
     let realm = try! Realm()
    var diaryList: Results<Diary>{
        get {
            return realm.objects(Diary.self)
           
        }
    }
    
    var templist = [Diary]()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func mAddDiaryButton(_ sender: Any) {
        let StoryBoard = UIStoryboard(name: "Diary", bundle: nil)
        let UserInput = StoryBoard.instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
        UserInput.mIndex = mDate
        UserInput.mHourMinutes = mHour
        self.navigationController?.pushViewController(UserInput, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //   print(diaryList.index(matching: mDate)!)
      //  Utils.SHOW_LOG(title: "Number of date", content: diaryList.filter)
       var i = 0
        for diary in diaryList {
            if diary.date == mDate {
                i += 1
            }
        }
        return i
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryItem = Diary()
        let StoryBoard = UIStoryboard(name: "Diary", bundle: nil)
        let UserInput = StoryBoard.instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
     // UserInput.setData(data: templist[indexPath.row])
        
        self.navigationController?.pushViewController(UserInput, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDiary", for: indexPath) as! ListDiary
        cell.setData(data: templist[indexPath.row])

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // [2]
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
         //   templist.removeAll()
            
            
            
            let item = templist[indexPath.row]
            Utils.SHOW_LOG(title: "item", content: item)
//            if !item.isInvalidated {
                try! self.realm.write({
                    Utils.remove(child1: "user", child2: (Auth.auth().currentUser?.uid)!, child3: item.postid)
                    self.realm.delete(item)
                })
                
            
                templist.remove(at: indexPath.row)
//                tableView.deleteRows(at:[indexPath], with: .automatic)
          
            //                                 mTableView.reloadData()
                
//            } else {
//                print("khong the xoa")
//            }
            
           
            
          
            
        }
        mTableView.reloadData()
    }
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        mTableView.register(UINib(nibName: "ListDiary", bundle: nil), forCellReuseIdentifier: "ListDiary")
    //    mTableView.reloadData()
//        ref.child("user").observe(.childAdded, with: {(snapshot) in
//            Utils.SHOW_LOG(title: "Snapsshot", content: snapshot)
//        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        templist.removeAll()
        
        for diary in diaryList {
            if diary.date == mDate {
                templist.append(diary)
            }
        }
        
        if templist.count > 0 {
            mTableView.reloadData()
        }
    }
    
}
