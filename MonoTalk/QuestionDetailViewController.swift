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
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    var balloonView = UIView()

    let cellID = "PlayerCell"
    let notificationIdDismssedModel = "dismissedModal"
    let notaificationIdDeleted = "deleted"
    let notaificationIdDeletedUserInfo = "indexOfDletedItem"
    var currentIndexTitle: String!
    var question: Question!
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        realm = try! Realm()

        // From model
        NotificationCenter.default.addObserver(self, selector: #selector(self.setPlayerViews), name: NSNotification.Name(rawValue: notificationIdDismssedModel), object: nil)

        // From player xib
        NotificationCenter.default.addObserver(self, selector: #selector(self.rearrangePlayerViews(_:)), name: NSNotification.Name(rawValue: notaificationIdDeleted), object: nil)

        // Close Rate Balloon
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRateBalloon)))
    }



    override func viewWillAppear(_ animated: Bool) {
        // Init contents
        questionLabel.text = question.questionBody
        print(question.categoryID)
        let category = realm.object(ofType: Category.self, forPrimaryKey: question.categoryID)
        categoryLabel.text = category?.name
        self.title = currentIndexTitle

        setPlayerViews()
    }

    func setUpUI() {
        // Record Button
        recordButton.clipsToBounds = true
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.dropShadow(isCircle: true)
        self.view.bringSubview(toFront: recordButton)

        // Star
        if question.isFavorited {
            starButton.setImage(UIImage(named: "icon_star_filled"), for: .normal)
        } else {
            starButton.setImage(UIImage(named: "icon_star_outline"), for: .normal)
        }

        // Rate
        rateButton.setImage(Question.Rate.allValues[question.rate].rateImage, for: .normal)
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
                                           record: question.records[i], questionID: question.id)
            playerView.tag = 100
            scrollView.addSubview(playerView)
        }
    }

    @objc func rearrangePlayerViews(_ notification: NSNotification) {

        if let indexOfDeletedItem = notification.userInfo?[notaificationIdDeletedUserInfo] as? Int {
            var playerViews = getPlayerViews()
            playerViews[indexOfDeletedItem].removeFromSuperview()

            // Relocate playerViews
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
        let playViews = scrollView.subviews.filter({ $0 is PlayerXibView })
        for view in playViews {
            if view.tag == 100 {
                result.append(view)
            }
        }
        return result
    }

    // MARK: Star button
    @IBAction func starButton(_ sender: Any) {
        if question.isFavorited {
            starButton.setImage(UIImage(named: "icon_star_outline"), for: .normal)
            try! realm.write {
                question.isFavorited = false
            }
        } else {
            starButton.setImage(UIImage(named: "icon_star_filled"), for: .normal)
            try! realm.write {
                question.isFavorited = true
            }
        }
    }

    // MARK: Rate button
    @IBAction func rateButtonAction(_ sender: Any) {
        addBaloonView()

    }

    func addBaloonView() {
        // Set up Baloon view base
        guard let rateButtonframe = rateButton.superview?.convert(rateButton.frame, to: nil) else { return }
        let iconButtonSize: CGFloat = 28
        let iconButtonMargin: CGFloat = 20
        let baloonWidth: CGFloat = (iconButtonSize * 5) + (iconButtonMargin * 6)
        let baloonHeight: CGFloat = 68
        let marginRight: CGFloat = 40
        let marginTop: CGFloat = 6
        let widthOfScreen = self.view.bounds.width

        let diff = widthOfScreen - marginRight - rateButtonframe.maxX + rateButtonframe.width / 2
        balloonView = BalloonView(topCornerX: baloonWidth - diff)
        balloonView.backgroundColor = UIColor.clear
        balloonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(balloonView)

        // Constraints
        balloonView.widthAnchor.constraint(equalToConstant: baloonWidth).isActive = true
        balloonView.heightAnchor.constraint(equalToConstant: baloonHeight).isActive = true

        NSLayoutConstraint(item: balloonView, attribute: .top, relatedBy: .equal, toItem: rateButton,
                           attribute: .bottom, multiplier: 1.0, constant: marginTop).isActive = true

        NSLayoutConstraint(item: balloonView, attribute: .right, relatedBy: .equal, toItem: self.view,
                           attribute: .right, multiplier: 1.0, constant: marginRight * -1).isActive = true


        // Add Rate Buttons
        for index in 0..<5 {
            let y = (baloonHeight / 2) + (7 / 2) - (iconButtonSize / 2) // 7 = height of triangle
            let rateButton = UIButton(frame: CGRect(x: 0, y: y, width: iconButtonSize, height: iconButtonSize))
            rateButton.setImage(Question.Rate.allValues[index].rateImage, for: .normal)
            rateButton.frame.origin.x = iconButtonMargin * CGFloat(index + 1) + iconButtonSize * CGFloat(index)
            rateButton.addTarget(self, action: #selector(tappedRateButton), for: .touchUpInside)
            rateButton.tag = index
            balloonView.addSubview(rateButton)
        }
    }

    @objc func tappedRateButton(_ sender: UIButton) {
        try! realm.write {
            question.rate = Question.Rate.allValues[sender.tag].rawValue
        }
        rateButton.setImage(Question.Rate.allValues[question.rate].rateImage, for: .normal)
        closeRateBalloon()
    }

    @objc func closeRateBalloon() {
        balloonView.removeFromSuperview()
    }
}
