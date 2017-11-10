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
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsets.zero
        
        numTextView.textColor = MyColor.theme.value
        numTextView.textContainerInset = UIEdgeInsetsMake(1, 0, 0, 0);
        numTextView.font = UIFont.systemFont(ofSize: 14)
        numTextView.backgroundColor = MyColor.paledTheme.value
        numTextView.layer.cornerRadius = 10.0
        numTextView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("CategoryCellXib", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}
