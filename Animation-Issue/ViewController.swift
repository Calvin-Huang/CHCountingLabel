//
//  ViewController.swift
//  Animation-Issue
//
//  Created by Calvin on 9/3/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var countingLabel: CountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startCountingButtonClicked(_: AnyObject) {
        countingLabel.start()
    }
    
    @IBAction func pauseCountingButtonClicked(_: AnyObject) {
        countingLabel.pause()
    }
    
    @IBAction func stopCoutingButtonClicked(_: AnyObject) {
        countingLabel.stop()
    }
}

