//
//  Service.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/17/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Service {
    
    static func getData(complete: @escaping (_ error: Error?,_ resData: [DataVO]) -> Void)  {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()

        let userID = Auth.auth().currentUser?.uid ?? "hi"
        
        ref.child("user").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //var dataVO: DataVO!
            var listData: ListDataVO!
            var myArr = [DataVO]()
            print("userID: " + userID)
            if let datas = snapshot.value as? [String: AnyObject] {
                
                for item in datas {
                   // Utils.SHOW_LOG(title: "data value", content: item.value)
                    if let currently = item.value as? [String: Any] {
                        do {
                            let jsonData = try  JSONSerialization.data(withJSONObject: currently, options: .prettyPrinted)
                            let DataJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                            let result = DataJson as? [String: AnyObject] ?? nil
                            //var CurrentlyData: CurrentlyVO?
                            
                            if result != nil {
                                let  dataVO = DataVO(data: result!)
                                myArr.append(dataVO)
                          //      listData.list.append(dataVO)
                          //     let listDatas = ListDataVO(response: [result!])
                                Utils.SHOW_LOG(title: "listData", content: listData)
                            }

                        }
                        catch {
                            //hendle error
                        }
                    }
                }
              complete(nil, myArr)
          //  Utils.SHOW_LOG(title: "value", content: data)
            Utils.SHOW_LOG(title: "snapshot", content: snapshot)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
