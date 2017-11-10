//
//  SortCellXib.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/09.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class SortCellXib: UITableViewCell {

    @IBOutlet weak var sortLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sortLabel.textColor = MyColor.darkText.value
        sortLabel.font = UIFont.systemFont(ofSize: TextSize.heading.rawValue)
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
