//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Adland Lee on 1/26/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!

    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    
    var pitch: AVAudioUnitTimePitch!
    var echo: AVAudioUnitDelay!
    var reverb: AVAudioUnitReverb!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        pitch = AVAudioUnitTimePitch()
        audioEngine.attach(pitch)
        
        echo = AVAudioUnitDelay()
        audioEngine.attach(echo)
        
        reverb = AVAudioUnitReverb()
        audioEngine.attach(reverb)
        
        audioEngine.connect(audioPlayerNode, to: pitch, format: nil)
        audioEngine.connect(pitch, to: reverb, format: nil)
        audioEngine.connect(reverb, to: echo, format: nil)
        audioEngine.connect(echo, to: audioEngine.outputNode, format: nil)
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL as URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func playSlowAudio(_ sender: UIButton) {
        playAudioEffects(rate:0.5)
    }
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        playAudioEffects(rate:1.5)
    }

    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioEffects(pitch:1000)
    }
    
    @IBAction func playVaderAudio(_ sender: UIButton) {
        playAudioEffects(pitch:-1000)
    }
    
    @IBAction func playEchoAudio(_ sender: UIButton) {
        playAudioEffects(echoDelay:1, echoFeedBack: 34)
    }
    
    @IBAction func playReverbAudio(_ sender: UIButton) {
        playAudioEffects(reverbMix:80, preset: .cathedral)
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        stopAudio()
    }

    func stopAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode.stop()
    }
    
    func playAudioEffects(rate: Float = 1.0, pitch: Float = 0.0,
        echoDelay: Float = 0.0, echoFeedBack: Float = 50,
        reverbMix: Float = 0.0, preset: AVAudioUnitReverbPreset = .mediumHall) {

        stopAudio()
            
        self.pitch.rate = rate
        self.pitch.pitch = pitch
        self.reverb.loadFactoryPreset(preset)
        self.reverb.wetDryMix = reverbMix
        self.echo.delayTime = TimeInterval(echoDelay)
        self.echo.feedback = echoFeedBack
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
}
