//
//  AddCategoryCellXib.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/07.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class CreateCategoryCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = MyColor.theme.value
        label.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
        
        iconImage.setTintColor(MyColor.theme.value)
    }
}
