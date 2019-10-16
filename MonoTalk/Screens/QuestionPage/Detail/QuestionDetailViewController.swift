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
    var speechGestureReconizer: UITapGestureRecognizer!
    var synthesizer: AVSpeechSynthesizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupTableView()
        realm = try! Realm()

        // Gesture to Close the Rate Balloon
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeRateBalloon)))

        // Speech
        speechGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(speech))
        questionAreaView.addGestureRecognizer(speechGestureReconizer)
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
            guard let this = self else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                if !insertions.isEmpty {
                    tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                }
                let i = this.question.records.count
                tableView.deleteRows(at: deletions.map({ IndexPath(row: abs($0 - i), section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                this.setTagsToPlayerButtons()
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
        records = question.records.sorted(byKeyPath: SortMode.createdDate.rawValue, ascending: SortMode.createdDate.acsending)

        tableView.estimatedRowHeight = 88
        tableView.backgroundColor = MyColor.lightGrayBackground.value
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 88, right: 0)
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
        self.view.bringSubviewToFront(recordButton)

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

        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)

        if status == .authorized {
            showRecordModal()
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.showRecordModal()
                    }
                }
            }
        } else {
            // Open setting page
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                _ = UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    private func showRecordModal() {
        stopAudioCompulsory(tappedPlayButtonAt: nil)
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
        questionAreaView.removeGestureRecognizer(speechGestureReconizer)
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
        questionAreaView.addGestureRecognizer(speechGestureReconizer)
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


    //MARK: Speech Question
    @objc private func speech() {
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
        cell.playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        cell.setUp()
        return cell
    }
}

// MARK: Manipulate Player Cell
extension QuestionDetailViewController {

    @objc private func playButtonTapped(_ sender: UIButton) {
        if let cell = self.getCell(row: sender.tag) {
            cell.togglePlayOrStop()
        }
        stopAudioCompulsory(tappedPlayButtonAt: sender.tag)
    }

    @objc private func deleteButtonTapped(_ sender: UIButton) {

        let message = "Delete this Record?"
        let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let delete: UIAlertAction = UIAlertAction(title: "Delete Record", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            if let cell = self.getCell(row: sender.tag) {
                cell.tappedDeleteButton()
            }
        })

        alert.addAction(cancel)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }

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

    private func getCell(row: Int) -> PlayerCellXib? {
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath) {
            return cell as? PlayerCellXib
        }
        return nil
    }

    private func setTagsToPlayerButtons() {
        for i in 0..<records.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) {
                let cell = cell as! PlayerCellXib
                cell.playButton.tag = i
                cell.deleteButton.tag = i
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        stopAudioCompulsory(tappedPlayButtonAt: nil)
    }
}

// MARK: UITableViewDelegate
extension QuestionDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
