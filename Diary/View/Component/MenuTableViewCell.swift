//
//  MenuTableViewCell.swift
//  Diary
//
//  Created by Nguyễn Việt on 9/21/18.
//  Copyright © 2018 Việt Nguyễn. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setdata(label: String, image: String) {
        
        mLabel.text = label
        Utils.SHOW_LOG(title: "mLabel", content: mLabel.text)
        mImage.image = UIImage(named: image)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
