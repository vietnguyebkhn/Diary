//
//  DiaryItem.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation
import RealmSwift

class Diary: Object {
    @objc dynamic var title = ""
    @objc dynamic var status = ""
    @objc dynamic var detail = ""
    @objc dynamic var date = ""
    @objc dynamic var HourMinutes = ""

   // @objc dynamic var index = 0

}
