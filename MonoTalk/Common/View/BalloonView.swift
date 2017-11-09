//
//  BalloonView.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/08.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

//@IBDesignable
class BalloonView: UIView {
    var triangleTopCornerX : CGFloat!
    let triangleWidth: CGFloat = 10
    let triangleHeight: CGFloat = 7
    
    init(topCornerX : CGFloat) {
        super.init(frame: UIScreen.main.bounds)
        self.triangleTopCornerX = topCornerX
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        triangleTopCornerX = 80 //test
        
        // Set triangle's corners
        let triangleTopCorner = CGPoint(x:triangleTopCornerX, y: 0)
        let triangleRightCorner = (x: triangleTopCorner.x + (triangleWidth / 2), y: triangleTopCorner.y + triangleHeight)
        let triangleLeftCorner = (x: triangleTopCorner.x - (triangleWidth / 2), y: triangleTopCorner.y + triangleHeight)
        
        // Fill
        let rect = CGRect(x: 0, y: triangleHeight, width: rect.width, height: rect.size.height - triangleHeight)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        path.fill()
        path.move(to: CGPoint(x: triangleLeftCorner.x, y: triangleLeftCorner.y))
        path.addLine(to: CGPoint(x: triangleTopCorner.x, y: triangleTopCorner.y))
        path.addLine(to: CGPoint(x: triangleRightCorner.x, y: triangleRightCorner.y))
        MyColor.border.value.setStroke()
        UIColor.white.setFill()
        path.stroke()
        path.fill()
        
        // Drop shadow
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowPath = path.cgPath
    }
}
