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

    @IBAction func playButton(_ sender: Any) {
        togglePlayOrStop()
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tappableView: UIView!
    @IBOutlet weak var playButton: UIButton!

    @IBAction func trashButton(_ sender: Any) {
    }
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!

    var audioPlayer: AVAudioPlayer?
    var playTimer: Timer?
    let fileExtension = ".caf"

    var record: Record!
    var recordUrl: URL!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    init(frame: CGRect, record: Record) {
        super.init(frame: frame)
        loadNib()

        self.record = record

        // Get record URL
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordUrl = documentsDirectory.appendingPathComponent(record.id + fileExtension)

        // Set date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"

        dateLabel.text = dateFormatter.string(from: record.date)
        displayDurationTime()
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector (self.tapped (_:)))
        tappableView.addGestureRecognizer(gestureRec)
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        togglePlayOrStop()
    }

    func loadNib() {
        let view = Bundle.main.loadNibNamed("PlayerXibView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    // MARK : Play

    func togglePlayOrStop() {
        if audioPlayer == nil {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: recordUrl)
                audioPlayer?.delegate = self
            } catch {
                print(error)
            }
        }

        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                pauseAudio()
            } else {
                playAudio()
            }
        }
    }

    func displayDurationTime() {
        let duration = Time.getDuration(url: recordUrl)
        timeLabel.text = Time.getFormatedTime(duration)
    }

    func playAudio() {
        playButton.setImage(UIImage(named: "icon_pause"), for: .normal)

        // Display playing time
        playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayPlayingTime), userInfo: nil, repeats: true)
        audioPlayer?.play()
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        playTimer?.invalidate()
        playButton.setImage(UIImage(named: "icon_play"), for: .normal)
        displayDurationTime()
    }

    func pauseAudio() {
        audioPlayer?.stop()
        playTimer?.invalidate()
        playButton.setImage(UIImage(named: "icon_play"), for: .normal)
    }

    @objc func displayPlayingTime() {
        timeLabel.text = Time.getFormatedTime(audioPlayer!.currentTime)
    }


}

extension PlayerXibView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudio()
    }
}
