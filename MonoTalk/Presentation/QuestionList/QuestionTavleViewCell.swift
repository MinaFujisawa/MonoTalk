//
//  QuestionCell.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class QuestionTavleViewCell: UITableViewCell {

    @IBOutlet weak var starLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starIcon: UIImageView!
    @IBOutlet weak var noteIcon: UIImageView!
    @IBOutlet weak var rateIcon: UIImageView!
    @IBOutlet weak var recordNumLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        questionLabel.textColor = MyColor.darkText.value
        questionLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
        questionLabel.font = UIFont.boldSystemFont(ofSize: questionLabel.font.pointSize)

        recordNumLabel.textColor = MyColor.lightText.value
        recordNumLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func repositionStarIcon(hasNote: Bool) {
        starLeadingConstraint.isActive = false
        if hasNote {
            starLeadingConstraint = NSLayoutConstraint(item: starIcon, attribute: .leading, relatedBy: .equal, toItem: noteIcon, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        } else {
            starLeadingConstraint = NSLayoutConstraint(item: starIcon, attribute: .leading, relatedBy: .equal, toItem: recordNumLabel, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        }

        starLeadingConstraint.isActive = true
    }

}
