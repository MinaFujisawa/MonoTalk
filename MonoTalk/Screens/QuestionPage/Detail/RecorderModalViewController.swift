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
    let id = UUID().uuidString
    var startTime: Date!
    var recordingTimer: Timer?
    var playTimer: Timer?
    var question: Question!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRecordingSession()
    }
    
    // MARK: Setup
    private func setupRecordingSession() {
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

    private func setupUI() {
        okButton.isHidden = true
        deleteButton.isHidden = true
        
        mainButton.circle()
        okButton.circle()
        deleteButton.circle()
        mainButton.aroundBorder()
        okButton.aroundBorder()
        deleteButton.aroundBorder()

        timeLabel.textColor = MyColor.darkText.value
        timeLabel.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
    }
    
    // MARK: Helper functions
    private func getFileURL() -> URL {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [NSURL]
        let dirURL = urls[0]
        return dirURL.appendingPathComponent(id + Record.fileExtension)!
    }
    
    private func displayDurationTime() {
        let duration = Time.getDuration(url: getFileURL())
        timeLabel.text = Time.getFormattedTime(timeInterval: duration)
    }
    
    // MARK: Main button
    @IBAction private func mainButton(_ sender: Any) {
        if audioRecorder != nil {
            finishRecording(success: true)
        } else {
            togglePlayOrStop()
        }
    }
    
    // MARK: Delete button
    @IBAction private func deleteButton(_ sender: Any) {
        stopAudio()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: OK button
    @IBAction private func okButton(_ sender: Any) {
        stopAudio()
        let newRecord = Record()
        newRecord.id = id
        do {
            let resources = try getFileURL().resourceValues(forKeys: [.fileSizeKey])
            newRecord.fileSize = Int64(resources.fileSize!)
        } catch {
            print("Error: \(error)")
        }
        
        let realm = try! Realm()
        
        try! realm.write() {
            question.records.append(newRecord)
            question.recordsNum += 1
        }
        
        dismiss(animated: true, completion: {
            // MARK: Display Rate Tutorial
            // TODO: only first time
            let storyboard = UIStoryboard(name: "RateTutorial", bundle: Bundle.main)
            let rateTutorialModal = storyboard.instantiateViewController(withIdentifier: "RateTutorial") as! RateTutorialViewController
            rateTutorialModal.question = self.question
            
            let additionalTime = DispatchTimeInterval.milliseconds(800)
            DispatchQueue.main.asyncAfter(deadline: .now() + additionalTime) {
                UIApplication.topViewController()?.present(rateTutorialModal, animated: true, completion: nil)
            }
        })
    }
    
}

// MARK: Record
extension RecorderModalViewController {
    private func startRecording() {
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
        recordingTimer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(displayRecordingTime), userInfo: nil, repeats: true)
    }
    
    private func finishRecording(success: Bool) {
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
    
    @objc private func displayRecordingTime() {
        let interval = Date().timeIntervalSince(startTime)
        timeLabel.text = Time.getFormattedTime(timeInterval: interval)
    }
}

// MARK: Play
extension RecorderModalViewController {
    // MARK : Play methods
    private func playAudio() {
        mainButton.setImage(UIImage(named: "icon_record_stop"), for: .normal)
        
        // Display playing time
        playTimer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(displayPlayingTime), userInfo: nil, repeats: true)
        audioPlayer?.play()
    }
    
    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        playTimer?.invalidate()
        mainButton.setImage(UIImage(named: "icon_record_play"), for: .normal)
        displayDurationTime()
    }
    
    @objc func displayPlayingTime() {
        timeLabel.text = Time.getFormattedTime(timeInterval: audioPlayer!.currentTime)
    }
    
    private func togglePlayOrStop() {
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
}

// MARK: AVAudioRecorderDelegate
extension RecorderModalViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

// MARK: AVAudioPlayerDelegate
extension RecorderModalViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudio()
    }
}

// MARK: UIApplication
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
