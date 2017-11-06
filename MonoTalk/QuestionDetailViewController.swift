//
//  ItemViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionAreaView: UIView!
    @IBAction func noteButton(_ sender: Any) {
    }
    @IBOutlet weak var sampleButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBAction func starButton(_ sender: Any) {
    }
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!

    let cellID = "PlayerCell"
    let notificationIdDismssedModel = "dismissedModal"
    let notaificationIdDeleted = "deleted"
    let notaificationIdDeletedUserInfo = "indexOfDletedItem"
    var currentIndexTitle: String!
    var question: Question!

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        recordButton.clipsToBounds = true
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.dropShadow(isCircle: true)

        self.view.bringSubview(toFront: recordButton)

        // From model
        NotificationCenter.default.addObserver(self, selector: #selector(self.setPlayerViews), name: NSNotification.Name(rawValue: notificationIdDismssedModel), object: nil)

        // From player xib
        NotificationCenter.default.addObserver(self, selector: #selector(self.rearrangePlayerViews(_:)), name: NSNotification.Name(rawValue: notaificationIdDeleted), object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        // Init contents
        questionLabel.text = question.questionBody
        self.title = currentIndexTitle

        setPlayerViews()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recoder") {
            let modal = segue.destination as! RecorderModalViewController
            modal.questionId = question.id
            modal.notificationIdDismssedModel = notificationIdDismssedModel
        }
    }

    @objc func setPlayerViews() {
        // remove all subviews
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        for i in 0..<question.records.count {
            let width = UIScreen.main.bounds.size.width
            let height = 64
            let y = (height + 40) * i
            let playerView = PlayerXibView(frame: CGRect(x: 0, y: y, width: Int(width), height: height),
                                           record: question.records[i], questionID:question.id)
            playerView.tag = 100
            scrollView.addSubview(playerView)
        }
    }

    @objc func rearrangePlayerViews(_ notification: NSNotification) {

        if let indexOfDeletedItem = notification.userInfo?[notaificationIdDeletedUserInfo] as? Int {
            var playerViews = getPlayerViews()
            playerViews[indexOfDeletedItem].removeFromSuperview()

            // Close the space
            for i in indexOfDeletedItem + 1..<playerViews.count {
                let x = playerViews[i].frame.origin.x
                let y = playerViews[i].frame.origin.y - 64 - 40
                let width = playerViews[i].frame.size.width
                let height = playerViews[i].frame.size.height

                UIView.animate(withDuration: 0.5, animations: {
                    playerViews[i].frame = CGRect(x: x, y: y, width: width, height: height)

                })
            }
        }
    }

    func getPlayerViews() -> [UIView] {
        var result = [UIView]()
        var playViews = scrollView.subviews.filter({ $0 is PlayerXibView })
        for view in playViews {
            if view.tag == 100 {
                result.append(view)
            }
        }
        return result
    }


}



