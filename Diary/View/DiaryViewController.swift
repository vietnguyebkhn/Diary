//
//  DiaryViewController.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit
import RealmSwift


class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDiary", for: indexPath) as! ListDiary
            for diary in diaryList {
            if diary.date == mDate {
               
                cell.setData(data: diaryList[diaryList.index(of: diary)!])
            }
        }
        
        return cell
        
    }
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        mTableView.register(UINib(nibName: "ListDiary", bundle: nil), forCellReuseIdentifier: "ListDiary")
    //    mTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        mTableView.reloadData()
    }
    
}
