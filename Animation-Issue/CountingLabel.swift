//
//  CountingLabelView.swift
//  Animation-Issue
//
//  Created by Calvin on 9/3/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    enum CountingMode: Int {
        case Decrease = -1
        case Increase = 1
    }
    
    var countingMode: CountingMode = .Decrease
    var isCounting: Bool = false
    var isPause: Bool = false
    var textFormatter: ((value: Int) -> String) = { value -> String in
        return String(value)
    }
    
    private var timer: NSTimer?
    private var startTimeStamp: Int = 0
    private var startCountingValue: Int = 0
    private var countingValue: Int = 0
    
    // MARK: - Selectors
    func updateCountingLabel(_: NSTimer) {
        let currentTimeStamp = Int(NSDate().timeIntervalSince1970)
        let progress = countingValue + (currentTimeStamp - startTimeStamp) * countingMode.rawValue
        
        self.text = textFormatter(value: progress)
    }
    
    // MARK: - Public Methods
    func start() {
        if timer == nil {
            guard let labelText = self.text, let currentValue = Int(labelText) else {
                return
            }
            
            startTimeStamp = Int(NSDate().timeIntervalSince1970)
            
            if !isPause {
                startCountingValue = currentValue
            }
            
            countingValue = currentValue
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(updateCountingLabel(_:)), userInfo: nil, repeats: true)
            
            isCounting = true
            isPause = false
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        
        isCounting = false
        isPause = true
    }
    
    func stop() {
        pause()
        
        isPause = false
        
        self.text = textFormatter(value: startCountingValue)
    }
}
