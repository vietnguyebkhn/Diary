//
//  ViewController.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/3/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import RealmSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var mMonthLb: UILabel!
    @IBOutlet weak var mCalendar: UICollectionView!

   
    var ref: DatabaseReference!
    let realm = try! Realm()
    let loginManager = FBSDKLoginManager()
    
    var diaryList: Results<Diary>{
        get {
            return realm.objects(Diary.self)
        }
    }
    
    var ListInsUpdDel: Results<InsUpdDel> {
        get {
            return realm.objects(InsUpdDel.self)
        }
    }

    let MonthInYear = ["January", "February", "March", "April", "May", "June", "July", "August", "Septemper", "October", "November", "December"]
    let DayInWeek = ["Monday", "Tuesday", "Wednesday", "Thusday", "Friday", "Saturday", "Sunday"]
    var DayinMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentMonth = String()
    var NumberofEmptyBox = Int() //the number of "empty box" at the start of the current month
    var NextNumberofEmptyBox = Int() // the same with the next month
    var PreviosofEmptyBox = 0 //the same with the pre month
    var Direction = 0 //=0 if we are at the current month, =1 if at the next month, =-1 if ait the pre month
    var PositionIndex = 0 //here we will store above vars of empty boxes
    var dayCounter = 0
    var DAY = 0
    var MONTH = month + 1
    var YEAR = year
    
    @objc func btnClick(_ sender:UIButton) {
        view.endEditing(true)
        self.revealViewController().revealToggle(sender)
    }
    
    override func viewDidLoad() {
         mCalendar.reloadData()
        super.viewDidLoad()
        let myBtn : UIButton = UIButton()
        myBtn.setImage(UIImage(named: "menu"), for: .normal)
        myBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        myBtn.addTarget(self, action:  #selector(self.btnClick(_:)) , for: .touchUpInside)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: myBtn), animated: true)
        
       // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        currentMonth = MonthInYear[month]
        mMonthLb.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        GetstartDateDayPosition()
        if Utils.checkInternet(viewcontroler: self) {
          
            Service.getData() { [weak self] (error, resData) in
                guard let strongSelf = self else {
                    return
                }
                if resData.count != self?.diaryList.count {
                    for item in resData {
                          let diaryItem = Diary()
                        diaryItem.postid = item.postid
                        diaryItem.date = item.date
                        diaryItem.detail = item.detail
                        diaryItem.HourMinutes = item.hour
                        diaryItem.status = item.status
                        diaryItem.title = item.title
                        try! self?.realm.write({
                            self?.realm.add(diaryItem, update: true)
                            Utils.SHOW_LOG(title: "dỉayList", content: self?.diaryList.count ?? 0)
                            self?.mCalendar.reloadData()
                                //            dismiss(animated: true, completion: nil)
                            })
                    }
                } else if error != nil {
                    let alert = UIAlertController(title: "Thong bao", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dong y", style: .cancel, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
       

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
         mCalendar.reloadData()
    }
    
    @IBAction func mBackButton(_ sender: Any) {
        switch currentMonth {
        case "January":
            Direction = -1
        
            month = 11
            year -= 1
            MONTH = month + 1
            YEAR = year
            if (year % 4 == 0) {
                DayinMonth[1] = 29
            } else {
                DayinMonth[1] = 28
            }
            GetstartDateDayPosition()
            currentMonth = MonthInYear[month]
            mMonthLb.text = "\(currentMonth) \(year)"
            mCalendar.reloadData()
        default:
            Direction = -1
            month -= 1
            MONTH = month + 1
            YEAR = year
            GetstartDateDayPosition()
            currentMonth = MonthInYear[month]
            mMonthLb.text = "\(currentMonth) \(year)"
            mCalendar.reloadData()
        }

    }
    @IBAction func mNextButton(_ sender: Any) {
        switch currentMonth {
        case "December":
            Direction = 1
            month = 0
            year += 1
            MONTH = month + 1
            YEAR = year
            if (year % 4 == 0) {
                DayinMonth[1] = 29
            } else {
                DayinMonth[1] = 28
            }

            GetstartDateDayPosition()
            currentMonth = MonthInYear[month]
            mMonthLb.text = "\(currentMonth) \(year)"
            mCalendar.reloadData()
        default:
            Direction = 1
            GetstartDateDayPosition()
            month += 1
            MONTH = month + 1
            YEAR = year
            currentMonth = MonthInYear[month]
            mMonthLb.text = "\(currentMonth) \(year)"
            mCalendar.reloadData()
        }
    }
    
    func GetstartDateDayPosition() {
        switch Direction {
        case 0:
            NumberofEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                NumberofEmptyBox = NumberofEmptyBox - 1
                dayCounter -= 1
                if NumberofEmptyBox == 0 {
                    NumberofEmptyBox = 7
                }
            }
            if NumberofEmptyBox == 7 {
                NumberofEmptyBox = 0
            }

           PositionIndex = NumberofEmptyBox
        case 1...:
            NextNumberofEmptyBox = (PositionIndex + DayinMonth[month]) % 7
            PositionIndex = NextNumberofEmptyBox
        case -1:
            PreviosofEmptyBox = (7 - (DayinMonth[month] - PositionIndex)%7)
            if PreviosofEmptyBox == 7 {
                PreviosofEmptyBox = 0
            }
            PositionIndex = PreviosofEmptyBox
        default:
            fatalError()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let StoryBoard = UIStoryboard(name: "Diary", bundle: nil)
        let DiaryViewController = StoryBoard.instantiateViewController(withIdentifier: "Diary") as! DiaryViewController
         DAY = indexPath.row + 1 - PositionIndex
     //   UserInputViewController.mDelegate = self
        
        DiaryViewController.mDate = "\(DAY)-\(MONTH)-\(YEAR)"
        DiaryViewController.mHour = "\(hour):\(minutes)"
            print("Hello")
       Utils.SHOW_LOG(title: "date", content: DiaryViewController.mDate)
        Utils.SHOW_LOG(title: "hourminute", content: DiaryViewController.mHour)
       // self.present(DiaryViewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(DiaryViewController, animated: true)
    
 
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction {
        case 0:
            return DayinMonth[month] + NumberofEmptyBox
        case 1:
            return DayinMonth[month] + NextNumberofEmptyBox
        case -1:
            return DayinMonth[month] + PreviosofEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.mDate.textColor = UIColor.black
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch Direction {
        case 0:
            cell.mDate.text = "\(indexPath.row + 1 - NumberofEmptyBox)"
            for diary in diaryList {
                
                let Index = "\(indexPath.row + 1 - NumberofEmptyBox)-\(MONTH)-\(YEAR)"
                if Index == diary.date {
                    let index = indexPath.row
                    switch index {
                    case 1...35:
                        cell.backgroundColor = UIColor(displayP3Red: 0, green: 100, blue: 0, alpha: 0.5)
                        
                    default:
                        break
                    }
                }
                
            }
        case 1...:
            cell.mDate.text = "\(indexPath.row + 1 - NextNumberofEmptyBox)"
            for diary in diaryList {
                
                let Index = "\(indexPath.row + 1 - NextNumberofEmptyBox)-\(MONTH)-\(YEAR)"
                if Index == diary.date {
                    let index = indexPath.row
                    switch index {
                    case 1...35:
                        cell.backgroundColor = UIColor(displayP3Red: 0, green: 100, blue: 0, alpha: 0.5)
                    default:
                        break
                    }
                }
                
            }
        case -1:
            cell.mDate.text = "\(indexPath.row + 1 - PreviosofEmptyBox)"
            for diary in diaryList {
                
                let Index = "\(indexPath.row + 1 - PreviosofEmptyBox)-\(MONTH)-\(YEAR)"
                    if Index == diary.date {
                        let index = indexPath.row
                        switch index {
                        case 1...35:
                           cell.backgroundColor = UIColor(displayP3Red: 0, green: 100, blue: 0, alpha: 0.5)
                            
                        default:
                         break
                        }
                    }
                
            }
        default:
            fatalError()
        }
        
        if Int(cell.mDate.text!)! < 1 {
            cell.isHidden = true
        }

        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.mDate.text!)! > 0 {
                cell.mDate.textColor = UIColor.red
                
            }         
        default:
            cell.mDate.textColor = UIColor.white
           
        }
        if currentMonth == MonthInYear[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row - 4 == day {
            cell.backgroundColor = UIColor(displayP3Red: 100, green: 0, blue: 0, alpha: 0.5)
        }
        
        
        return cell 
    }
    func removeBorderNavigation()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }


}

