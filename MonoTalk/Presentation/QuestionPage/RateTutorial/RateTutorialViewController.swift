//
//  RateTutorialViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/16.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class RateTutorialViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    var question : Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "How difficult was this question to answer?"
        titleLabel.textColor = MyColor.darkText.value
        titleLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
        setUpButtons()
        baseView.setCornerRadius()
    }

    func setUpButtons() {
        for rate in Question.Rate.allValues {
            
            // Load nib as RateTutorialItemView
            let allViewsInXibArray = Bundle.main.loadNibNamed("RateTutorialItem", owner: self, options: nil)
            let itemView = allViewsInXibArray?.first as! RateTutorialItemView
            itemView.widthAnchor.constraint(equalToConstant: 62).isActive = true
            
            // Set items
            itemView.rateButton.setImage(rate.rateImage, for: .normal)
            itemView.rateButton.tag = rate.rawValue
            itemView.rateButton.addTarget(self, action: #selector(tappedRate), for: .touchUpInside)
            itemView.label.text = rate.tutorialText
            
            // UI
            itemView.label.textColor = MyColor.darkText.value
            itemView.label.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
            
            stackView.addArrangedSubview(itemView)
        }

        self.view.tag = 200
    }

    @objc func tappedRate(sender: UIButton) {
        let realm = try! Realm()
        try! realm.write {
            question.rate = Question.Rate.allValues[sender.tag].rawValue
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 200 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
