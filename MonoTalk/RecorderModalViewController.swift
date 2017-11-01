//
//  RecorderModalViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/31.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderModalViewController: UIViewController {

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBAction func deleteButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func okButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func mainButton(_ sender: Any) {
        mainButtonTapped()
    }
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    let fileManager = FileManager()
    let fileName = "sample.caf"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.isHidden = true
        deleteButton.isHidden = true
        
        // TODO: circle
        
        
        //MARK: AV
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
            audioRecorder = try AVAudioRecorder(url: getDocumentFilePath(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getDocumentFilePath() -> URL {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as [NSURL]
        let dirURL = urls[0]
        return dirURL.appendingPathComponent(fileName)!
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        // UI
        okButton.isHidden = false
        deleteButton.isHidden = false
        mainButton.setImage(UIImage(named: "icon_record_play"), for: .normal)
        
        if !success {
            print("recording failed")
        }
    }
    
    @objc func mainButtonTapped() {
        if audioRecorder == nil {
            play()
        } else {
            finishRecording(success: true)
        }
    }
    
    // MARK : Play
    func play() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: self.getDocumentFilePath())
        } catch {
            print("Error to play")
        }
        audioPlayer?.play()
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
