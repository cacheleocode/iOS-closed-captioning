//
//  ViewController.swift
//  volume
//
//  Created by DOMINGUEZ, LEO on 11/19/18.
//  Copyright © 2018 mopro. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var audioSession = AVAudioSession()

    @IBOutlet weak var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        debugPrint("5")
        listenVolumeButton()
    }

    func listenVolumeButton() {
        do {
            try audioSession.setActive(true)
        } catch {
            print("some error")
        }
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "outputVolume" {
            
            print("got in here")
            print(audioSession.outputVolume)

            if (audioSession.outputVolume >= 0.5) {
                testView.backgroundColor = UIColor.green
            } else if (audioSession.outputVolume < 0.5 && audioSession.outputVolume > 0.25) {
                testView.backgroundColor = UIColor.yellow
            } else {
                testView.backgroundColor = UIColor.red
            }

        }
    }
}

