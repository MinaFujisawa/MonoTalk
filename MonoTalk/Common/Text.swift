//
//  Text.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/09.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import UIKit

enum TextSize: CGFloat {
    case normal = 16
    case heading = 14
    case small = 11
    case questionBody = 18
}

extension String {
    // Check if the String doen't have only spaces
    func isValidString() -> Bool {
        for char in self {
            if char != " " {
                return true
            }
        }
        return false
    }
}

// MARK: Place holder
extension UITextView {
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    /// Add following code to VC
//    public func textViewDidChange(_ textView: UITextView) {
//        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
//            placeholderLabel.isHidden = textView.text.characters.count > 0
//        }
//    }

    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainerInset.left + 4
            let labelY = self.textContainerInset.top
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }

    /// Adds a placeholder UILabel to this UITextView
    public func addPlaceholder(_ placeholderText: String) {
        
        // Remove PH label if it exists already
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.removeFromSuperview()
        }

        let placeholderLabel = UILabel()

        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()

        placeholderLabel.font = self.font
        placeholderLabel.textColor = MyColor.placeHolderText.value
        placeholderLabel.tag = 100

        placeholderLabel.isHidden = self.text.count > 0

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
    }
}

