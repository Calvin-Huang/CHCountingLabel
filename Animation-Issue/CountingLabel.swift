//
//  CountingLabelView.swift
//  Animation-Issue
//
//  Created by Calvin on 9/3/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit
import CHCubicBezier

class CountingLabel: UILabel {
    var duration: Float = 0
    var easingControlPoints: (x1: Double, y1: Double, x2: Double, y2: Double)? {
        didSet {
            cubicBezier = CubicBezier(controlPoints: easingControlPoints!)
        }
    }
    
    var easing: CubicBezier.Easing? {
        didSet {
            easingControlPoints = easing?.toControlPoints()
        }
    }
    
    var isCounting: Bool = false
    var isPause: Bool = false
    var textFormatter: ((value: Double) -> String) = { value -> String in
        return String(value)
    }
    
    var startValue: Double = 0 {
        didSet {
            startCountingValue = startValue
            self.text = textFormatter(value: startValue)
        }
    }
    var stopValue: Double = 0
    
    private var cubicBezier: CubicBezier?
    private var timer: CADisplayLink?
    private var startTimeStamp: Double = 0
    private var startCountingValue: Double = 0
    private var currentCountingValue: Double = 0
    
    convenience init(easing: CubicBezier.Easing, startValue: Double, stopValue: Double, frame: CGRect = CGRectZero) {
        self.init(frame: frame)
        
        self.startValue = startValue
        self.stopValue = stopValue
        self.easing = easing
    }
    
    convenience init(controlPoints: (Double, Double, Double, Double), startValue: Double, stopValue: Double, frame: CGRect = CGRectZero) {
        self.init(frame: frame)
        
        self.startValue = startValue
        self.stopValue = stopValue
        self.easingControlPoints = controlPoints
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initPropertiesDefaultValue()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initPropertiesDefaultValue()
    }
    
    // MARK: - Selectors
    func updateCountingLabel(_: AnyObject) {
        guard let cubicBezier = cubicBezier else {
            return
        }
        
        let duration: Double = (self.duration <= 0) ? fabs(stopValue - startCountingValue) : Double(self.duration)
        
        // If duration is equal to zero, change time is stopValue reduce to startCountingValue means update text per seconds.
        let changeTime = NSDate.timeIntervalSinceReferenceDate() - startTimeStamp
        let changeValue = stopValue - startCountingValue
        var t = 1.0
        
        if changeTime >= duration {
            timer?.invalidate()
            timer = nil
        } else {
            t = changeTime / duration
        }
        
        currentCountingValue = startCountingValue + changeValue * cubicBezier.easing(t)
        
        self.text = textFormatter(value: currentCountingValue)
    }
    
    // MARK: - Public Methods
    func start() {
        if timer == nil {
            startTimeStamp = NSDate.timeIntervalSinceReferenceDate()
            
            if isPause {
                startCountingValue = currentCountingValue
            }
            
            timer = CADisplayLink(target: self, selector: #selector(updateCountingLabel(_:)))
            timer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            
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
        
        startCountingValue = startValue
        self.text = textFormatter(value: startValue)
    }
    
    // MARK: - Private Methods
    private func initPropertiesDefaultValue() {
        easing = .Linear
    }
}
