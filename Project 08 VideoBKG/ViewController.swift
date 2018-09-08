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

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning  {
    
    let playerVC = AVPlayerViewController()
    let url = Bundle.main.url(forResource: "moments", withExtension: "mp4")
    
    @IBOutlet weak var fbIcon: UIImageView!
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
        transitioningDelegate = self
        
        if let url = url{
            let player = AVPlayer(url: url)
            player.isMuted = true
            player.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTimeMultiplyByFloat64(AVAsset(url: url).duration, 0.98))], queue: DispatchQueue.main, using: {
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromOpeningVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? OpeningViewController,
            let toMainVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? ViewController{
            let containerView = transitionContext.containerView
            containerView.addSubview(toMainVC.view)
            containerView.addSubview(fromOpeningVC.view)
            
            let fromIconX = fromOpeningVC.fbIcon.frame.minX
            let fromIconY = fromOpeningVC.fbIcon.frame.minY
            let toIconX = toMainVC.fbIcon.frame.minX
            let toIconY = toMainVC.fbIcon.frame.minY
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromOpeningVC.fbIcon.transform = CGAffineTransform(translationX: toIconX - fromIconX, y: toIconY - fromIconY)
                fromOpeningVC.bkg.alpha = 0
            }){ finished in
                transitionContext.completeTransition(true)
                UIApplication.shared.keyWindow?.addSubview(toMainVC.view)
            }
        }
    }
}

