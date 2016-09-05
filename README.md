CHCountingLabel
=====================================
![](https://travis-ci.org/Calvin-Huang/CHCountingLabel.svg?branch=master) ![swift-version](https://img.shields.io/badge/Swfit-2.2-orange.svg) ![platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![pod](https://img.shields.io/badge/pod-1.0.0-blue.svg)

## Snapshot
<img src="https://github.com/Calvin-Huang/CHCountingLabel/blob/master/assets/easeinout_counting_1.gif" alt="snapshot1" width="400">
<img src="https://github.com/Calvin-Huang/CHCountingLabel/blob/master/assets/easeinout_counting_2.gif" alt="snapshot2" width="400">

## About
CHCountingLabel has not only function to do basic counting.<br>
It also can speeding up or slowing down counting.<br>
Use CHCountingLabel to bring more awesome effect for your app.

## Usage
CHCountingLabel is very simple to use.
- Basic counting - Decrease numbers per second
```swift
@IBOutlet weak var countingLabel: CountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countingLabel.textFormatter = { (value: Double) -> String in
            return "\(Int(value))"
        }
        countingLabel.startValue = 50
        // Default stop value is 0.
        // coutingLabel.stopValue = 0
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
```
- Basic counting - Increase numbers per second
```swift
countingLabel.startValue = 0
countingLabel.stopValue = 50
```
- Counint seed up and slow down depends on given bezier path.
```swfit
countingLabel.easing = CubicBezier.Easing.EaseInOut
countingLabel.duration = 5
countingLabel.startValue = 50
// countingLabel.stopValue = 100
```

## Install
##### Via from [CocoaPods](https://github.com/CocoaPods/CocoaPods).
Add `pod 'CHCountingLabel'` to your Podfile and run `pod install`
```ruby
platform :ios, '8.0'

target 'MyApp' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'CHCountingLabel'

  target 'MyAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

```
## Migrate to Objective-C project
Accorading ![Apple's document](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/Migration.html), you need to `Update import statements in your Objective-C code (to #import "ProductModuleName-Swift.h")`.
```objective-c
#import "CHCountingLabel-Swift.h"
// or
@import "CHCountingLabel.h"
```

All done! Start to use CHCountingLabel!

## License
Copyright (c) [Calvin Huang](https://github.com/Calvin-Huang). This software is licensed under the [MIT License](https://github.com/Calvin-Huang/CHCountingLabel/blob/master/LICENSE).