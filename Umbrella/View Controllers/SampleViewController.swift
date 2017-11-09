//
//  SampleViewController.swift
//  Umbrella
//
//  Created by Jonathan Jones on 6/30/17.
//  Copyright © 2017 The Nerdery. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    var sourceFrame: CGRect?
    @IBOutlet var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

