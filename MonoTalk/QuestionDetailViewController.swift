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
    let notificationID = "dismissedModal"
    var currentIndexTitle: String!
    var question: Question!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        recordButton.clipsToBounds = true
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.dropShadow(isCircle: true)
        
        self.view.bringSubview(toFront: recordButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setPlayerViews), name:NSNotification.Name(rawValue: notificationID), object: nil)
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
            modal.notaificationID = notificationID
        }
    }

    @objc func setPlayerViews() {
        for i in 0..<question.records.count {
            let width = UIScreen.main.bounds.size.width
            let height = 64
            let y = (height + 40) * i
            let playerView = PlayerXibView(frame: CGRect(x: 0, y: y, width: Int(width), height: height), record: question.records[i])
            scrollView.addSubview(playerView)
        }
    }

}



