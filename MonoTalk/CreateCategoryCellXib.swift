//
//  AddCategoryCellXib.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/07.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class CreateCategoryCellXib: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
