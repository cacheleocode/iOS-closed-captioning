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
import QuartzCore


class ViewController: UIViewController {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var testView: UIView!
    
    // dispatch queue
    
    let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    var pendingTask: DispatchWorkItem?
    
    var audioSession = AVAudioSession()
    
    // player layer
    
    var playerLayer: AVPlayerLayer?
    
    // players
    
    var player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "commercials", ofType:"mp4")!))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initialize players
        
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player.seek(to: CMTime.zero)
                self.player.play()
            }
        })
        
        self.player.isMuted = false
        self.player.play()
        
        // resume playback upon app focus
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification , object: nil)
        
        debugPrint("5")
        listenVolumeButton()
        

        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer!.frame = self.playerView.frame
        playerLayer!.frame.origin.y = 0

        self.playerView.layer.addSublayer(playerLayer!)
        
    }

    @objc func appWillEnterForegroundNotification() {
        player.play()
        
        print("forced an exit, now wer're back")
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

            if (audioSession.outputVolume >= 0.25) {
                testView.alpha = 0
            } else {
                testView.alpha = 1
            }

        }
    }
}

