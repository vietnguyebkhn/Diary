//
//  InsUpdDel.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/19/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation
import RealmSwift

class InsUpdDel: Object {
    @objc dynamic var uid = UUID().uuidString
     var del = List<String>()
     var upd = List<String>()
     var ins = List<String>()
    override static func primaryKey() -> String? {
        return "uid"
    }
    }


