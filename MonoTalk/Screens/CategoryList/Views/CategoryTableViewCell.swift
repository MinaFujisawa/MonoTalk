//
//  CategoryCell.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadNib()
        setUpUI()
    }

    private func setUpUI() {
        nameLabel.textColor = MyColor.darkText.value
        nameLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)

        questionNumLabel.textColor = MyColor.lightText.value
        questionNumLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)

        fileSizeLabel.textColor = MyColor.lightText.value
        fileSizeLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)

        categoryImageView.setCornerRadius(3)
        categoryImageView.layer.masksToBounds = true
        
        arrowImageView.setTintColor(MyColor.lightText.value)

        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }


    private func loadNib() {
        let view = Bundle.main.loadNibNamed("CategoryCellXib", owner: self, options: nil)?.first as! UIView
        view.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: UIScreen.main.bounds.width, height: self.bounds.height)
        self.addSubview(view)
    }

}
