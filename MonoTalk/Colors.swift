//
//  Colors.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {

        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }


}
enum MyColor {

    case theme
    case paledTheme
    case border
    case shadow

    case bluishGrayBackground
    case lightGrayBackground

    case darkText
    case lightText
    case placeHolderText

    case red

    // to get UIColor values other than the previous ones
    case custom(hexString: String, alpha: Double)

    // enables me to add transparency to an existing colour case.
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension MyColor {

    var value: UIColor {
        var instanceColor = UIColor.clear

        switch self {
        case .theme:
            instanceColor = UIColor(hexString: "#2EA1F2")
        case .paledTheme:
            instanceColor = UIColor(hexString: "#DFF1FF")
        case .border:
            instanceColor = UIColor(hexString: "#EAEAEA")
        case .shadow:
            instanceColor = UIColor(hexString: "#000000")
        case .bluishGrayBackground:
            instanceColor = UIColor(hexString: "#F3F3F7")
        case .lightGrayBackground:
            instanceColor = UIColor(hexString: "#F7F7F7")
        case .darkText:
            instanceColor = UIColor(hexString: "#4A4A4A")
        case .lightText:
            instanceColor = UIColor(hexString: "#A6ACB4")
        case .placeHolderText:
            instanceColor = UIColor(hexString: "#A6ACB4")
        case .red:
            instanceColor = UIColor(hexString: "#FD344C")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
            
        }
        return instanceColor
    }
}


