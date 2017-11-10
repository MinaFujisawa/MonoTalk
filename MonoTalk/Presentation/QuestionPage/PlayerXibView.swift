//
//  PlayerXibView.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/31.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class PlayerXibView: UIView {

    

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tappableView: UIView!
    @IBOutlet weak var playButton: UIButton!

    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!

    var audioPlayer: AVAudioPlayer!
    let fileExtension = ".caf"
    var isPaused = true
    var questionID : String!
    var record: Record!
    var recordUrl: URL!
    var timer: Timer!
    let notaificationIdDeleted = "deleted"
    let notaificationIdDeletedUserInfo = "indexOfDletedItem"

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    init(frame: CGRect, record: Record, questionID: String) {
        super.init(frame: frame)
        loadNib()

        self.record = record
        self.questionID = questionID

        // Get record URL
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordUrl = documentsDirectory.appendingPathComponent(record.id + fileExtension)

        // Set date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateLabel.text = dateFormatter.string(from: record.date)

        // Set audioPlayer
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: recordUrl)
            audioPlayer?.delegate = self
        } catch {
            print(error)
        }

        // Set slider
        slider.maximumValue = Float(Time.getDuration(url: recordUrl))

        slider.setThumbImage(UIImage(named: "icon_player_thumb"), for: .normal)

        displayDurationTime()
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector (self.tapped (_:)))
        tappableView.addGestureRecognizer(gestureRec)
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        
//        togglePlayOrStop()
    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("PlayerXibView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    // MARK : Play
    @IBAction func playButton(_ sender: Any) {
        togglePlayOrStop()
    }

    func togglePlayOrStop() {
        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                pauseAudio()
            } else {
                playAudio()
            }
        }
    }

    func displayDurationTime() {
        var duration = Time.getDuration(url: recordUrl)
        duration.round(.up)
        timeLabel.text = Time.getFormatedTime(timeInterval: duration)
    }

    func playAudio() {
        audioPlayer.play()
        playButton.setImage(UIImage(named: "icon_pause"), for: .normal)

        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)

        if audioPlayer?.currentTime == 0 {
            timeLabel.text = Time.getFormatedTime(timeInterval: 0)
        }
        isPaused = false
    }

    func pauseAudio() {
        audioPlayer?.stop()
        timer.invalidate()
        playButton.setImage(UIImage(named: "icon_play"), for: .normal)
        isPaused = true
    }

    func resetAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPaused = true
        playButton.setImage(UIImage(named: "icon_play"), for: .normal)
        displayDurationTime()
        slider.value = 0
        timer.invalidate()
    }

    @objc func updateSlider() {
        slider.value = Float(audioPlayer!.currentTime)
        timeLabel.text = Time.getFormatedTime(timeInterval: audioPlayer.currentTime)
    }

    @IBAction func sliderChanged(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(slider.value)
        audioPlayer?.prepareToPlay()
        if !isPaused {
            audioPlayer?.play()
        }
        timeLabel.text = Time.getFormatedTime(timeInterval: audioPlayer.currentTime)
    }
    
    // MARK: Delete
    @IBAction func trashButton(_ sender: Any) {
        let realm = try! Realm()
        
        // Get current index of records
        let parentQuestion = realm.object(ofType: Question.self, forPrimaryKey: questionID)
        let currentRecord = realm.object(ofType: Record.self, forPrimaryKey: record.id)
        let indexOfRecord = parentQuestion?.records.index(of: currentRecord!)
        
        try! realm.write() {
            parentQuestion?.recordsNum -= 1
            realm.delete(record)
            if let indexOfRecord = indexOfRecord {
                let positionYDict:[String: Int] = [notaificationIdDeletedUserInfo: indexOfRecord]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notaificationIdDeleted),
                                                object: nil, userInfo: positionYDict)
            }
        }
    }
}

extension PlayerXibView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetAudio()
    }
}
