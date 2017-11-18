//
//  ItemViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class QuestionDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionAreaView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    var notificationToken: NotificationToken? = nil
    var balloonView = UIView()
    
    
    let cellID = "PlayerCell"
    let notificationIdDismssedModel = "dismissedModal"
    let notaificationIdDeleted = "deleted"
    let notaificationIdDeletedUserInfo = "indexOfDletedItem"
    var currentIndexTitle: String!
    var question: Question!
    var realm: Realm!
    var isShowingBalloon = false
    var speachGestureReconizer: UITapGestureRecognizer!
    var synthesizer: AVSpeechSynthesizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        realm = try! Realm()

        // Notification From model
        NotificationCenter.default.addObserver(self, selector: #selector(self.setPlayerViews), name: NSNotification.Name(rawValue: notificationIdDismssedModel), object: nil)

        // From player xib
        NotificationCenter.default.addObserver(self, selector: #selector(self.rearrangePlayerViews(_:)), name: NSNotification.Name(rawValue: notaificationIdDeleted), object: nil)

        // Gesture to Close Rate Balloon
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRateBalloon)))


        // Speach
        speachGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(speach))
        questionAreaView.addGestureRecognizer(speachGestureReconizer)
        synthesizer = AVSpeechSynthesizer()
        
        // MARK:Observe Results Notifications
        notificationToken = question.observe { [weak self] (changes: ObjectChange) in
            switch changes {
            case .error(let error):
                fatalError("\(error)")
            case .change(_):
                self?.setNoteButtonIcon()
            case .deleted:
                break
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
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
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.circle()
        recordButton.dropShadow()
        self.view.bringSubview(toFront: recordButton)

        let origImage = UIImage(named: "icon_microphone")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        recordButton.setImage(tintedImage, for: .normal)
        recordButton.tintColor = .white

        // Star
        starButton.setImageAspectFit()
        if question.isFavorited {
            starButton.setImage(UIImage(named: "icon_star_filled"), for: .normal)
        } else {
            starButton.setImage(UIImage(named: "icon_star_outline"), for: .normal)
        }

        // Rate
        rateButton.setImage(Question.Rate.allValues[question.rate].rateImage, for: .normal)
        
        // Note
        noteButton.setImageAspectFit()
        setNoteButtonIcon()

        // Text
        questionLabel.textColor = MyColor.theme.value
        questionLabel.font = UIFont.systemFont(ofSize: TextSize.questionBody.rawValue)
        categoryLabel.textColor = MyColor.darkText.value
        categoryLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
    }
    
    func setNoteButtonIcon() {
        if question.note != nil {
            noteButton.setImage(UIImage(named: "icon_note_badge"), for: .normal)
        } else {
            noteButton.setImage(UIImage(named: "icon_note_badge_none"), for: .normal)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recoder") {
            let modal = segue.destination as! RecorderModalViewController
            modal.questionId = question.id
            modal.notificationIdDismssedModel = notificationIdDismssedModel
        }
        if segue.identifier == "GoToNote" {
            let nav = segue.destination as! UINavigationController
            let noteVC = nav.topViewController as! NoteViewController
            noteVC.question = question
        }
    }

    @objc func setPlayerViews() {
        // remove all subviews
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }

        let width = UIScreen.main.bounds.size.width
        let height = 64
        let marginBottom = 24
        for i in 0..<question.records.count {
            let y = (height + marginBottom) * i
            let playerView = PlayerXibView(frame: CGRect(x: 0, y: y, width: Int(width), height: height),
                                           record: question.records[i], questionID: question.id)
            playerView.tag = 100
            scrollView.addSubview(playerView)
        }
        let contentSizeHieght: CGFloat = CGFloat((height + marginBottom) * question.records.count) + 100
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: contentSizeHieght)
    }

    @objc func rearrangePlayerViews(_ notification: NSNotification) {

        if let indexOfDeletedItem = notification.userInfo?[notaificationIdDeletedUserInfo] as? Int {
            var playerViews = getPlayerViews()
            playerViews[indexOfDeletedItem].removeFromSuperview()

            // Relocate playerViews
            for i in indexOfDeletedItem + 1..<playerViews.count {
                let x = playerViews[i].frame.origin.x
                let y = playerViews[i].frame.origin.y - 64 - 24
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
        if isShowingBalloon {
            closeRateBalloon()
        } else {
            showRateBaloon()
        }
    }

    func showRateBaloon() {
        questionAreaView.removeGestureRecognizer(speachGestureReconizer)
        isShowingBalloon = true

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
        isShowingBalloon = false
        questionAreaView.addGestureRecognizer(speachGestureReconizer)
    }

    //MARK: Speach Question
    @objc func speach() {
        if !self.synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: self.question.questionBody)
            synthesizer.speak(utterance)
        }
    }
}
