//
//  UI.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius() {
        self.layer.cornerRadius = 5
    }

    func circle() {
        self.layer.cornerRadius = self.frame.height / 2
    }

    func aroundBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = MyColor.border.value.cgColor
    }

    func dropShadow() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = MyColor.shadow.value.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
}

extension UIImageView {
    func setTintColor(_ color : UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

extension UIButton {
    func setImageAspectFit() {
        self.imageView?.contentMode = .scaleAspectFit
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
    }
}

extension UITextView {
    func setPadding() {
        self.preservesSuperviewLayoutMargins = false
        self.textContainerInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
    }

    func setTopAndBottomBorder() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        topBorder.backgroundColor = MyColor.border.value.cgColor
        self.layer.addSublayer(topBorder)

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 1, width: UIScreen.main.bounds.width, height: 1)
        bottomBorder.backgroundColor = MyColor.border.value.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}

//extension UINavigationItem{
//
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//
//        let backItem = UIBarButtonItem()
//
//        let backIcon = UIImage(named: "navi_arrow_back")
//        backItem.image = backIcon
//
//        self.backBarButtonItem = backItem
//    }
//}

//extension UINavigationController {
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//        let backIcon = UIImage(named: "navi_arrow_back")
//        self.navigationBar.backIndicatorImage = backIcon
//    }
//}

