//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by knax on 1/2/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    //check which audio button is pressed to determine event action
    enum recordingState: Int { case startRecording = 0, stopRecording }

    func recordingControls(audioRecordState: recordingState) {
        let audioSetting: (recordSetting: Bool,recordLabel: String,stopSetting: Bool)
        
        switch(audioRecordState){
            case .startRecording:
                audioSetting = (recordSetting: false, recordLabel: "Recoding in Progress",stopSetting: true)
            case .stopRecording:
                audioSetting = (recordSetting: true,recordLabel: "Tap to Record",stopSetting: false)
        }
        
        recordButton.isEnabled = audioSetting.recordSetting
        recordingLabel.text = audioSetting.recordLabel
        stopRecordingButton.isEnabled = audioSetting.stopSetting
    }
    
    @IBAction func recordAudio(_ sender: Any) {
       
        recordingControls(audioRecordState: recordingState.startRecording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let reordingName = "recordedVoice.wav"
        let pathArray = [dirPath, reordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        recordingControls(audioRecordState: recordingState.stopRecording)
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
