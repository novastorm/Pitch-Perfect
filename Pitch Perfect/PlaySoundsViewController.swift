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
        audioEngine.attachNode(audioPlayerNode)
        
        pitch = AVAudioUnitTimePitch()
        audioEngine.attachNode(pitch)
        
        echo = AVAudioUnitDelay()
        audioEngine.attachNode(echo)
        
        reverb = AVAudioUnitReverb()
        audioEngine.attachNode(reverb)
        
        audioEngine.connect(audioPlayerNode, to: pitch, format: nil)
        audioEngine.connect(pitch, to: reverb, format: nil)
        audioEngine.connect(reverb, to: echo, format: nil)
        audioEngine.connect(echo, to: audioEngine.outputNode, format: nil)
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioEffects(rate:0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioEffects(rate:1.5)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioEffects(pitch:1000)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioEffects(pitch:-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioEffects(echoDelay:1, echoFeedBack: 34)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioEffects(reverbMix:50, preset: .Cathedral)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }

    func stopAllAudio() {
        audioPlayerNode.stop()
    }
    
    func playAudioEffects(rate rate: Float = 1.0, pitch: Float = 0.0, echoDelay: Float = 0.0, echoFeedBack: Float = 50, reverbMix: Float = 0.0, preset: AVAudioUnitReverbPreset = .MediumHall) {
        audioEngine.stop()
        audioEngine.reset()
        
        self.pitch.rate = rate
        self.pitch.pitch = pitch
        self.reverb.loadFactoryPreset(preset)
        self.reverb.wetDryMix = reverbMix
        self.echo.delayTime = NSTimeInterval(echoDelay)
        self.echo.feedback = echoFeedBack
        
    
        audioPlayerNode.stop()
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
}
