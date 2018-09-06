//
//  ListDiary.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/5/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit

class ListDiary: UITableViewCell {

    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var mHourMinutes: UILabel!
    @IBOutlet weak var mDetails: UILabel!
    @IBOutlet weak var mStatus: UILabel!
    @IBOutlet weak var mTitile: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: Diary) {
        mHourMinutes.text = data.HourMinutes
        mDate.text = data.date
        mTitile.text = data.title
        mStatus.text = data.status
        mDetails.text = data.detail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
