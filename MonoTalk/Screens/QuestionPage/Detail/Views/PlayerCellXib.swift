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

class PlayerCellXib: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    var audioPlayer: AVAudioPlayer!
    var isPaused = true
    var question: Question!
    var record: Record!
    var recordUrl: URL!
    var timer: Timer!
    let notaificationIdDeleted = "deleted"
    let notaificationIdDeletedUserInfo = "indexOfDletedItem"

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    // MARK: Setup
    internal func setUp() {
        // Get record URL
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordUrl = documentsDirectory.appendingPathComponent(record.id + Record.fileExtension)

        // Set audioPlayer
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: recordUrl)
            audioPlayer.delegate = self
        } catch {
            print(error)
        }

        // Set date
        dateLabel.text = Time.getFormattedDate(date: record.createdDate)

        // Set slider
        slider.maximumValue = Float(Time.getDuration(url: recordUrl))
        slider.setThumbImage(UIImage(named: "icon_player_thumb"), for: .normal)
        slider.tintColor = MyColor.darkText.value

        // Set File size
        fileSizeLabel.text = ByteCountFormatter.string(fromByteCount: record.fileSize, countStyle: .file)
        displayDurationTime()
    }


    private func setUpUI() {
        self.backgroundColor = MyColor.lightGrayBackground.value

        // Text
        timeLabel.textColor = MyColor.lightText.value
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = MyColor.lightText.value
        dateLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)
        fileSizeLabel.textColor = MyColor.lightText.value
        fileSizeLabel.font = UIFont.systemFont(ofSize: TextSize.small.rawValue)

        // Add border
        containerView.aroundBorder()

        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }


    // MARK : Play
    @IBAction func tappedPlayButton(_ sender: Any) {
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

    private func displayDurationTime() {
        var duration = Time.getDuration(url: recordUrl)
        duration.round(.up)
        timeLabel.text = Time.getFormattedTime(timeInterval: duration)
    }

    private func playAudio() {
        audioPlayer.play()
        playButton.setImage(UIImage(named: "icon_pause"), for: .normal)

        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)

        if audioPlayer?.currentTime == 0 {
            timeLabel.text = Time.getFormattedTime(timeInterval: 0)
        }
        isPaused = false
    }

    internal func pauseAudio() {
        audioPlayer?.stop()
        timer.invalidate()
        playButton.setImage(UIImage(named: "icon_play"), for: .normal)
        isPaused = true
    }

    private func resetAudio() {
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
        timeLabel.text = Time.getFormattedTime(timeInterval: audioPlayer.currentTime)
    }

    @IBAction func sliderChanged(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(slider.value)
        audioPlayer?.prepareToPlay()
        if !isPaused {
            audioPlayer?.play()
        }
        timeLabel.text = Time.getFormattedTime(timeInterval: audioPlayer.currentTime)
    }

    // MARK: Delete
    @IBAction func tappedDeleteButton(_ sender: Any) {
        if audioPlayer.isPlaying {
            resetAudio()
        }

        let realm = try! Realm()

        try! realm.write() {
            question.recordsNum -= 1
            realm.delete(record)
        }
    }
}

// MARK: AVAudioPlayerDelegate
extension PlayerCellXib: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetAudio()
    }
}

