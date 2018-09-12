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

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UITextFieldDelegate{
    
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
    
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!{
        didSet{
            emailField.delegate = self
            emailField.returnKeyType = .next
        }
    }
    @IBOutlet weak var passwordField: UITextField!{
        didSet{
            passwordField.delegate = self
            passwordField.returnKeyType = .continue
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
            return false
        case passwordField:
            passwordField.resignFirstResponder()
            return false
        default:
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
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
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            
            if emailField.isEditing{
                let bottomSpace = view.bounds.height - emailField.frame.maxY - inputStackView.frame.minY
                
                if  bottomSpace < keyboardHeight{
                    UIView.animate(withDuration: 0.2) {
                        self.view.frame.origin.y = bottomSpace - keyboardHeight - 5
                    }
                }
            } else if passwordField.isEditing{
                let bottomSpace = view.bounds.height - passwordField.frame.maxY - inputStackView.frame.minY
                
                if  bottomSpace < keyboardHeight{
                    UIView.animate(withDuration: 0.2) {
                        self.view.frame.origin.y = bottomSpace - keyboardHeight - 5
                    }
                    
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        if view.frame.origin.y < 0{
            UIView.animate(withDuration: 0.2) {
                self.view.frame.origin.y = 0
            }
        }
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

