//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Adland Lee on 1/25/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import AVFoundation

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
        try! audioSession.setCategory(AVAudioSessionCategoryRecord)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        resetView()
    }
    
    func resetView() {
        recordButton.hidden = false
        recordingLabel.text = "Tap to Record"
        recordControls.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        print("recordAudio")
        
        recordButton.hidden = true
        recordingLabel.text = "Recording ..."
        recordControls.hidden = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
//        let session = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func pauseRecordAudio(sender: UIButton) {
        audioRecorder.pause()
        recordingLabel.text = "Paused ..."
        
        // Change to resume button
        pauseResumeButton.setImage(UIImage(named: "resume"), forState: .Normal)
        pauseResumeButton.removeTarget(self, action: "pauseRecordAudio:", forControlEvents: .TouchUpInside)
        pauseResumeButton.addTarget(self, action: "resumeRecordAudio:", forControlEvents: .TouchUpInside)
    }
    
    @IBAction func resumeRecordAudio(sender: UIButton) {
        audioRecorder.record()
        recordingLabel.text = "Recording ..."
        
        // Change to pause button
        pauseResumeButton.setImage(UIImage(named: "pause"), forState: .Normal)
        pauseResumeButton.removeTarget(self, action: "resumeRecordAudio:", forControlEvents: .TouchUpInside)
        pauseResumeButton.addTarget(self, action: "pauseRecordAudio:", forControlEvents: .TouchUpInside)
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
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
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop()
//        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
//        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)

    }
    
}

