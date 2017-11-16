//
//  CategoryCell.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var numTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNib()

        // UI
        nameLabel.textColor = MyColor.darkText.value
        nameLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)

        numTextView.textColor = MyColor.theme.value
        numTextView.textContainerInset = UIEdgeInsetsMake(1, 3, 0, 3)
        numTextView.font = UIFont.systemFont(ofSize: 14)
        numTextView.backgroundColor = MyColor.paledTheme.value
        numTextView.layer.cornerRadius = numTextView.frame.height / 2
        numTextView.layer.masksToBounds = true

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
