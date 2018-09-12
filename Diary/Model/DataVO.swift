//
//  DataVO.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/12/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation

class DataVO {
    var postid = 0.0
   var title = ""
  var  status = ""
  var  detail = ""
   var date = ""
    var  HourMinutes = ""
    
    init(data: [String: AnyObject]) {
        postid = data["postid"] as? Double ?? 0.0
        title = data["title"] as? String ?? ""
        title = data["status"] as? String ?? ""
        title = data["detail"] as? String ?? ""
        title = data["date"] as? String ?? ""
        title = data["HourMinutes"] as? String ?? ""


    }
    
    
    
//    postid = 1536661322.84193;
//    title = nxnxnxn;
//    status = Đau đớn;
//    detail = ncncncnc;
//    date = 14-9-2018;
//    HourMinutes = 17:21;
}
