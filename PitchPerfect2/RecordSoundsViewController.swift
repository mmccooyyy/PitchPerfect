//
//  RecordSoundsViewController.swift
//  PitchPerfect2
//
//  Created by Matthew McCoy on 2/19/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    
    let recordButtonImage = UIImage(named: "RecordButton")
    let stopButtonImage = UIImage(named: "Stop")
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    func setRecordingLabelRecording() {
        recordingLabel.text = "Recording in Progress..."
    }

    func setRecordingLabelNotRecording() {
        recordingLabel.text = "Tap to Record"
    }
    
    func setRecordingButtonRecording() {
        recordingButton.setImage(stopButtonImage , for: UIControl.State.normal)
    }

    func setRecordingButtonNotRecording() {
        recordingButton.setImage(recordButtonImage , for: UIControl.State.normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var counter = 0
    var recordingState = false

    @IBAction func recordAudio(_ sender: Any) {
        if (recordingState) {
            setRecordingLabelNotRecording()
            setRecordingButtonNotRecording()
            recordingState = false
            
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        } else {
            setRecordingLabelRecording()
            setRecordingButtonRecording()
            recordingState = true
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording dun fucked up")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioUrl = recordedAudioUrl
        }
    }

}

