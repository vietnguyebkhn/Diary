//
//  CalendarVars.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/4/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import Foundation

var date = Date()
var calendar = Calendar.current
var day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
let hour = calendar.component(.hour, from: date)
let minutes = calendar.component(.minute, from: date)
