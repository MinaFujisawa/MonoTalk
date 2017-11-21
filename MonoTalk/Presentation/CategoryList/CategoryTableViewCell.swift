//
//  CategoryCell.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var startTextLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNib()

        // UI
        nameLabel.textColor = MyColor.darkText.value
        nameLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
        
        questionNumLabel.textColor = MyColor.lightText.value
        questionNumLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        
        fileSizeLabel.textColor = MyColor.lightText.value
        fileSizeLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        
        categoryImageView.setCornerRadius()
        categoryImageView.layer.masksToBounds = true
        
        startTextLabel.textColor = MyColor.theme.value
        startTextLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        startTextLabel.backgroundColor = MyColor.paledTheme.value
        startTextLabel.layer.cornerRadius = startTextLabel.frame.height / 2
        startTextLabel.layer.masksToBounds = true
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("CategoryCellXib", owner: self, options: nil)?.first as! UIView
        view.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: UIScreen.main.bounds.width, height: self.bounds.height)
        self.addSubview(view)
    }

}
