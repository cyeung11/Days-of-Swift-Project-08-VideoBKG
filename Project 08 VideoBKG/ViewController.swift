//
//  ViewController.swift
//  Project 08 VideoBKG
//
//  Created by Chris on 7/9/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class ViewController: UIViewController {
    
    let playerVC = AVPlayerViewController()
    let url = Bundle.main.url(forResource: "moments", withExtension: "mp4")
    
    @IBOutlet weak var signup: UIButton!{
        didSet{
            signup.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var signin: UIButton!{
        didSet{
            signin.layer.cornerRadius = 5
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url{
            let player = AVPlayer(url: url)
            player.isMuted = true
            player.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTimeMultiplyByFloat64(AVAsset(url: url).duration, 0.99))], queue: DispatchQueue.main, using: {
                player.seek(to: kCMTimeZero)
            })
            playerVC.player = player
            playerVC.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        }
        
        playerVC.view.frame = view.frame
        playerVC.showsPlaybackControls = false
        view.addSubview(playerVC.view)
        view.sendSubview(toBack: playerVC.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerVC.player?.play()
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}

