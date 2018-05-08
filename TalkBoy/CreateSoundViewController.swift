//
//  CreateSoundViewController.swift
//  TalkBoy
//
//  Created by John Rooney on 2018-05-04.
//  Copyright © 2018 John Rooney. All rights reserved.
//

import UIKit
import AVFoundation

class CreateSoundViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create audiosession
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        //URL or path to save the audio
        if let basepath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        {
            let pathComponents = [basepath, "audio.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents){
                //create some settings
                self.audioURL = audioURL
                var settings:[String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                //create the audio recorder
                try? audioRecorder = AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
        }
        playButton.isEnabled = false
        textField.isEnabled = false
        addButton.isEnabled = false
        
    }
    
    @IBAction func recordSomething(_ sender: Any) {
        //get recording done
        if let audioRecorder = self.audioRecorder
        {
            if audioRecorder.isRecording{
                audioRecorder.stop()
                recordButton.setTitle("Record", for: .normal)
                playButton.isEnabled = true
                textField.isEnabled = true
                addButton.isEnabled = true
            }else{
              audioRecorder.record()
               recordButton.setTitle("Stop", for: .normal)
                playButton.isEnabled = true
                textField.isEnabled = true
                addButton.isEnabled = true
            }
    
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if let audioURL  = self.audioURL{
        audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
        audioPlayer?.play()
        }
        
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let sound = Sound(entity: Sound.entity(), insertInto: context)
            sound.name = textField.text
            if let audioURL = self.audioURL {
            sound.audioData = try? Data(contentsOf: audioURL)
            try? context.save()
            navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    
    
    
        
      
       
}
