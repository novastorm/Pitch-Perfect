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
    case Pause
    case Resume
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
    
    override func viewWillAppear(animated: Bool) {
        resetView()
    }

    @IBAction func recordAudio(sender: UIButton) {
        showRecordAudioButton(show: false, text: "Recording ...")

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        try! audioSession.setCategory(AVAudioSessionCategoryRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        audioRecorder.pause()
        recordingLabel.text = "Paused ..."
        
        showPauseResumeAudioButton(image: "resume", currentAction: "pauseRecordAudio:", newAction: #selector(RecordSoundsViewController.resumeRecordAudio(_:)))
    }
    
    @IBAction func resumeRecordAudio(sender: UIButton) {
        audioRecorder.record()
        recordingLabel.text = "Recording ..."
        
        showPauseResumeAudioButton(image: "pause", currentAction: "resumeRecordAudio:", newAction: "pauseRecordAudio:")
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop()
        try! audioSession.setActive(false)
    }
    
    func resetView() {
        showRecordAudioButton(text: "Tap to Record")
        showPauseResumeAudioButton(image: "pause", currentAction: "resumeRecordAudio:", newAction: "pauseRecordAudio:")
    }
    
    func showRecordAudioButton(show show: Bool = true, text: String) {
        recordButton.hidden = !show
        recordingLabel.text = text
        recordControls.hidden = show
    }
    
    func showPauseResumeAudioButton(image imageName: String, currentAction: Selector, newAction: Selector!) {
        pauseResumeButton.setImage(UIImage(named: imageName), forState: .Normal)
        pauseResumeButton.removeTarget(self, action: currentAction, forControlEvents: .TouchUpInside)
        pauseResumeButton.addTarget(self, action: newAction, forControlEvents: .TouchUpInside)
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathURL: recorder.url)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            print("Recording was not successful")
            resetView()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
}

