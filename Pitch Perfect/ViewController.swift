//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Adland Lee on 1/25/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide stop button
        stopButton.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        // TODO: Show test  "recording in progress"
        // TODO: Record user's voice
        print("recordAudio")
        recordButton.enabled = false
        recordingLabel.hidden = false
        stopButton.hidden = false
    }

    @IBAction func stopRecordAudio(sender: UIButton) {
        print("stopRecordAudio")
        recordButton.enabled = true
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
}

