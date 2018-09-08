//
//  OpeningViewController.swift
//  Project 08 VideoBKG
//
//  Created by Chris on 8/9/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController{

    @IBOutlet weak var fbIcon: UIImageView!
    
    @IBOutlet weak var bkg: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "opening", sender: nil)
    }

}
