//
//  ListDataVO.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/17/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation

class ListDataVO {
    var list: [DataVO]
    init(response: [[String: AnyObject]]) {
        var listData = [DataVO]()
        for item in response {
            listData.append(DataVO.init(data: item))
        }
        self.list = listData
        Utils.SHOW_LOG(content: "Post list has been inited")
    }
    
}
