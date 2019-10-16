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
    @IBOutlet weak var microphoneIcon: UIImageView!
    @IBOutlet weak var recordNumLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Label
        questionLabel.textColor = MyColor.darkText.value
        questionLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)

        recordNumLabel.textColor = MyColor.lightText.value
        recordNumLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        
        fileSizeLabel.textColor = MyColor.lightText.value
        fileSizeLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        
        // Icon
        noteIcon.image = noteIcon.image?.withRenderingMode(.alwaysTemplate)
        noteIcon.tintColor = MyColor.lightText.value
        microphoneIcon.image = microphoneIcon.image?.withRenderingMode(.alwaysTemplate)
        microphoneIcon.tintColor = MyColor.lightText.value
        
        // Margin
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsets.zero
    }
}
