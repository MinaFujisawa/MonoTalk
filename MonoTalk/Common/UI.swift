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

