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
        recordButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
    }
    
    //abstration based on suggestion of code review, org enum/switch can be seen in git repo
    func recordingControls(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
        recordButton.isEnabled = isRecording ? false : true
        stopRecordingButton.isEnabled = isRecording ? true : false
    }
    
    @IBAction func recordAudio(_ sender: Any) {
       
        recordingControls(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let reordingName = "recordedVoice.wav"
        let pathArray = [dirPath, reordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        //while not a requirement I am working on code suggestion for using do{try..} catch{displayAlert} in RecordSoundsViewController
        //first couple of implementation broke the app (lines 46 - 50(?))
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        recordingControls(isRecording: false)
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
