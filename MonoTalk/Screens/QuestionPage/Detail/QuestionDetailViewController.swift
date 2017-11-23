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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionAreaView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!

    var notificationToken: NotificationToken? = nil
    var notificationTokenForRecords: NotificationToken? = nil
    var balloonView = UIView()
    let cellID = "PlayerCell"
    var question: Question!
    var records: Results<Record>!
    var realm: Realm!
    var isShowingBalloon = false
    var speachGestureReconizer: UITapGestureRecognizer!
    var synthesizer: AVSpeechSynthesizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupTableView()
        realm = try! Realm()

        // Gesture to Close the Rate Balloon
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRateBalloon)))

        // Speach
        speachGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(speach))
        questionAreaView.addGestureRecognizer(speachGestureReconizer)
        synthesizer = AVSpeechSynthesizer()

        // MARK:Observe Results Notifications For Question
        notificationToken = question.observe { [weak self] (changes: ObjectChange) in
            switch changes {
            case .error(let error):
                fatalError("\(error)")
            case .change(_):
                self?.setNoteButtonIcon()
                self?.setRateButtonIcon()
            case .deleted:
                break
            }
        }

        // MARK:Observe Results Notifications For Records
        notificationTokenForRecords = question.records.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                if !insertions.isEmpty {
                    tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                }
                let i = (self?.question.records.count)!
                tableView.deleteRows(at: deletions.map({ IndexPath(row: abs($0 - i), section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }

    }

    deinit {
        notificationToken?.invalidate()
        notificationTokenForRecords?.invalidate()
    }

    // MARK: Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        records = question.records.sorted(byKeyPath: SortMode.date.rawValue, ascending: SortMode.date.acsending)

        tableView.estimatedRowHeight = 88
        tableView.backgroundColor = MyColor.lightGrayBackground.value
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 88, 0)
        tableView.allowsSelection = false

        let nib = UINib(nibName: "PlayerXibView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }

    private func setUpUI() {
        // Record Button
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.circle()
        recordButton.dropShadow()
        recordButton.imageView?.contentMode = .scaleAspectFit
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
        setRateButtonIcon()

        // Note
        noteButton.setImageAspectFit()
        setNoteButtonIcon()

        // Text
        questionLabel.textColor = MyColor.darkText.value
        questionLabel.font = UIFont.systemFont(ofSize: TextSize.questionBody.rawValue)
        categoryLabel.textColor = MyColor.lightText.value
        categoryLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
    }
    
    private func setRateButtonIcon() {
        rateButton.setImage(Question.Rate.allValues[question.rate].rateImage, for: .normal)
    }

    private func setNoteButtonIcon() {
        if question.note != nil {
            noteButton.setImage(UIImage(named: "icon_note_badge"), for: .normal)
        } else {
            noteButton.setImage(UIImage(named: "icon_note_badge_none"), for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // Init contents
        questionLabel.text = question.questionBody
        let category = realm.object(ofType: Category.self, forPrimaryKey: question.categoryID)
        categoryLabel.text = category?.name
        tableView.tableFooterView = UIView()
    }


    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToNote" {
            let nav = segue.destination as! UINavigationController
            let noteVC = nav.topViewController as! NoteViewController
            noteVC.question = question
        }
    }

    // MARK: Answer Button
    @IBAction func answerButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let modal = storyboard.instantiateViewController(withIdentifier: "ModalViewController") as! RecorderModalViewController
        modal.question = question
        self.present(modal, animated: true, completion: nil)
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

    private func showRateBaloon() {
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
        addBalloonSubView()

        // Constraints
        balloonView.widthAnchor.constraint(equalToConstant: baloonWidth).isActive = true
        balloonView.heightAnchor.constraint(equalToConstant: baloonHeight).isActive = true

        NSLayoutConstraint(item: balloonView, attribute: .top, relatedBy: .equal, toItem: rateButton,
                           attribute: .bottom, multiplier: 1.0, constant: marginTop).isActive = true

        NSLayoutConstraint(item: balloonView, attribute: .right, relatedBy: .equal, toItem: self.view,
                           attribute: .right, multiplier: 1.0, constant: marginRight * -1).isActive = true


        // Add Rate Buttons
        for index in 0..<5 {
            let y = (baloonHeight / 2) + (7 / 2) - (iconButtonSize / 2) // 7 = height of the triangle
            let rateButton = UIButton(frame: CGRect(x: 0, y: y, width: iconButtonSize, height: iconButtonSize))
            rateButton.setImage(Question.Rate.allValues[index].rateImage, for: .normal)
            rateButton.frame.origin.x = iconButtonMargin * CGFloat(index + 1) + iconButtonSize * CGFloat(index)
            rateButton.addTarget(self, action: #selector(tappedRateButtonFromBalloon), for: .touchUpInside)
            rateButton.tag = index
            balloonView.addSubview(rateButton)
        }
    }


    @objc private func tappedRateButtonFromBalloon(_ sender: UIButton) {
        try! realm.write {
            question.rate = Question.Rate.allValues[sender.tag].rawValue
        }
        rateButton.setImage(Question.Rate.allValues[question.rate].rateImage, for: .normal)
        closeRateBalloon()
    }

    @objc private func closeRateBalloon() {
        removeBalloonSubView()
        isShowingBalloon = false
        questionAreaView.addGestureRecognizer(speachGestureReconizer)
    }

    // MARK: Animation for Balloon
    private func addBalloonSubView() {
        self.view.addSubview(balloonView)
        balloonView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.balloonView.alpha = 1
            self.balloonView.transform = CGAffineTransform.identity
        }
    }

    func removeBalloonSubView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.balloonView.alpha = 0
        }) { (success: Bool) in
            self.balloonView.removeFromSuperview()
        }
    }


    //MARK: Speach Question
    @objc private func speach() {
        if !self.synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: self.question.questionBody)
            synthesizer.speak(utterance)
        }
    }
}

// MARK: UITableViewDataSource
extension QuestionDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // MARK: Set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlayerCellXib
        let record = records[indexPath.row]
        cell.record = record
        cell.question = question
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(playButtontapped(_:)), for: .touchUpInside)
        cell.setUp()
        return cell
    }
}

// MARK: Manipulate Cell
extension QuestionDetailViewController {
    private func stopAudioCompulsory(tappedPlayButtonAt: Int?) {
        for i in 0..<records.count {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                let cell = cell as! PlayerCellXib
                
                if cell.audioPlayer.isPlaying && i != tappedPlayButtonAt {
                    cell.pauseAudio()
                }
            }
        }
    }

    @objc func playButtontapped(_ sender: UIButton) {
        stopAudioCompulsory(tappedPlayButtonAt: sender.tag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAudioCompulsory(tappedPlayButtonAt: nil)
    }
}

// MARK: UITableViewDelegate
extension QuestionDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
