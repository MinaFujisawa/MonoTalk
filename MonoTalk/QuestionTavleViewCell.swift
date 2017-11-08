//
//  QuestionCell.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class QuestionTavleViewCell: UITableViewCell {

    @IBOutlet weak var starIcon: UIImageView!
    @IBOutlet weak var noteIcon: UIImageView!
    @IBOutlet weak var rateIcon: UIImageView!
    @IBOutlet weak var recordNumLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
