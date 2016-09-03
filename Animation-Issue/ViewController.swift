//
//  ViewController.swift
//  Animation-Issue
//
//  Created by Calvin on 9/3/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var countingLabel: UILabel!

    private var timer: NSTimer?
    private var startTimeStamp: Int = 0
    private var startCountingValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startCountingButtonClicked(_: AnyObject) {
        if timer == nil {
            guard let labelText = self.countingLabel.text, let currentValue = Int(labelText) else {
                return
            }
            
            startTimeStamp = Int(NSDate().timeIntervalSince1970)
            startCountingValue = currentValue
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(updateCountingLabel(_:)), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: - Selectors
    func updateCountingLabel(_: NSTimer) {
        let currentTimeStamp = Int(NSDate().timeIntervalSince1970)
        
        self.countingLabel.text = String(startCountingValue - (currentTimeStamp - startTimeStamp))
    }
}

