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

    func dropShadow(isCircle: Bool) {

        if isCircle {
            self.layer.cornerRadius = self.frame.width / 2
        }

        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
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

