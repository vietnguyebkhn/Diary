//
//  DataVO.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/12/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation

class DataVO {
    var postid = ""
   var title = ""
  var  status = ""
  var  detail = ""
   var date = ""
    var  hour = ""
    
    init()  {}

    
    init(data: [String: AnyObject]) {
        postid = data["postid"] as? String ?? ""
        title = data["title"] as? String ?? ""
        status = data["status"] as? String ?? ""
        detail = data["detail"] as? String ?? ""
        date = data["date"] as? String ?? ""
        hour = data["hour"] as? String ?? ""


    }
    
    
    
//    postid = 1536661322.84193;
//    title = nxnxnxn;
//    status = Đau đớn;
//    detail = ncncncnc;
//    date = 14-9-2018;
//    HourMinutes = 17:21;
}
