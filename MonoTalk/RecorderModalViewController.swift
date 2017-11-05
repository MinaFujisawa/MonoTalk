//
//  RecorderModalViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/31.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class RecorderModalViewController: UIViewController {
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    let fileManager = FileManager()
    let fileExtension = ".caf"
    let id = UUID().uuidString
    var startTime: Date!
    var recordingTimer: Timer?
    var playTimer: Timer?

    var realm: Realm!
    var questionId: String!
    var notaificationID : String!

    @IBAction func deleteButton(_ sender: Any) {
        stopAudio()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func okButton(_ sender: Any) {
        stopAudio()
        // MARK: Save the record to DB
        do {
            let newRecord = Record()
//            let recordData = try Data(contentsOf: getFileURL(), options: .alwaysMapped)
            newRecord.id = id
            
            realm = try! Realm()
            
            // add new record to the question obj
            if let question = realm.object(ofType: Question.self, forPrimaryKey: questionId) {
                try! realm.write() {
                    question.records.append(newRecord)
                }
            }
        } catch {
            print(error)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notaificationID), object: nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func mainButton(_ sender: Any) {

        // Recorder
        if audioRecorder != nil {
            finishRecording(success: true)
        } else {
            togglePlayOrStop()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.isHidden = true
        deleteButton.isHidden = true

        // TODO: circle

        //add event to the button
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecording()
                    } else {
                        print("failed to record!")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
    }

    // MARK: Record
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: getFileURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

        } catch {
            finishRecording(success: false)
        }

        // Display recording time
        startTime = Date()
        recordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayRecordingTime), userInfo: nil, repeats: true)
    }

    func getFileURL() -> URL {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [NSURL]
        let dirURL = urls[0]
        return dirURL.appendingPathComponent(id + fileExtension)!
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        // UI
        okButton.isHidden = false
        deleteButton.isHidden = false
        mainButton.setImage(UIImage(named: "icon_record_play"), for: .normal)

        // Stop timer
        recordingTimer?.invalidate()

        if !success {
            print("recording failed")
        }

    }

    @objc func displayRecordingTime() {
        let interval = Date().timeIntervalSince(startTime)
        timeLabel.text = Time.getFormatedTime(interval)
    }

    func displayDurationTime() {
        let duration = Time.getDuration(url: getFileURL())
        timeLabel.text = Time.getFormatedTime(duration)
    }


    // MARK : Play
    func playAudio() {
        mainButton.setImage(UIImage(named: "icon_record_stop"), for: .normal)

        // Display playing time
        playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayPlayingTime), userInfo: nil, repeats: true)
        audioPlayer?.play()
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        playTimer?.invalidate()
        mainButton.setImage(UIImage(named: "icon_record_play"), for: .normal)
        displayDurationTime()
    }

    @objc func displayPlayingTime() {
        timeLabel.text = Time.getFormatedTime(audioPlayer!.currentTime)
    }

    func togglePlayOrStop() {
        if audioPlayer == nil {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: self.getFileURL())
                audioPlayer?.delegate = self
            } catch {
                print("Error to play")
            }
        }

        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                stopAudio()
            } else {
                playAudio()
            }
        }
    }

    // Close this view
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension RecorderModalViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension RecorderModalViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudio()
    }
}
