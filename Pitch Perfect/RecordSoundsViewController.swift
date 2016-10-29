//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Adland Lee on 1/25/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import AVFoundation

enum PauseReusumeState {
    case pause
    case resume
}

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var audioSession: AVAudioSession!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordControls: UIStackView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioSession = AVAudioSession.sharedInstance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetView()
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        showRecordAudioButton(show: false, text: "Recording ...")

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        try! audioSession.setCategory(AVAudioSessionCategoryRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecordAudio(_ sender: UIButton) {
        audioRecorder.pause()
        recordingLabel.text = "Paused ..."
        
        showPauseResumeAudioButton(image: "resume", currentAction: #selector(RecordSoundsViewController.pauseRecordAudio(_:)), newAction: #selector(RecordSoundsViewController.resumeRecordAudio(_:)))
    }
    
    @IBAction func resumeRecordAudio(_ sender: UIButton) {
        audioRecorder.record()
        recordingLabel.text = "Recording ..."
        
        showPauseResumeAudioButton(image: "pause", currentAction: #selector(RecordSoundsViewController.resumeRecordAudio(_:)), newAction: #selector(RecordSoundsViewController.pauseRecordAudio(_:)))
    }
    
    @IBAction func stopRecordAudio(_ sender: UIButton) {
        audioRecorder.stop()
        try! audioSession.setActive(false)
    }
    
    func resetView() {
        showRecordAudioButton(text: "Tap to Record")
        showPauseResumeAudioButton(image: "pause", currentAction: #selector(RecordSoundsViewController.resumeRecordAudio(_:)), newAction: #selector(RecordSoundsViewController.pauseRecordAudio(_:)))
    }
    
    func showRecordAudioButton(show: Bool = true, text: String) {
        recordButton.isHidden = !show
        recordingLabel.text = text
        recordControls.isHidden = show
    }
    
    func showPauseResumeAudioButton(image imageName: String, currentAction: Selector, newAction: Selector!) {
        pauseResumeButton.setImage(UIImage(named: imageName), for: UIControlState())
        pauseResumeButton.removeTarget(self, action: currentAction, for: .touchUpInside)
        pauseResumeButton.addTarget(self, action: newAction, for: .touchUpInside)
        
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathURL: recorder.url)
            
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }
        else {
            print("Recording was not successful")
            resetView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
}

