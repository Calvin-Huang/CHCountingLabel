//
//  CubicBezier.swift
//  CHCubicBezier
//
//  Created by Calvin on 6/23/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

//  Reference from https://github.com/gre/bezier-easing

import Foundation

private let newtownIterations: Int = 4
private let newtownMinSlope: Double = 0.001
private let subdevusuibPrecision: Double = 0.0000001
private let subdevisionMaxInterations: Int = 10

private let kSplineTableSize: Int = 11
private let kSampleStepSize: Double = 1.0 / (Double(kSplineTableSize) - 1.0)

public class CubicBezier {
    public enum Easing {
        case Ease
        case EaseIn
        case EaseOut
        case EaseInOut
        case Linear
        
        public func toControlPoints() -> (Double, Double, Double, Double) {
            switch self {
            case .Ease:
                return (0.25, 0.1, 0.25, 0.1)
            case .EaseIn:
                return (0.42, 0.0, 1.0, 1.0)
            case .EaseOut:
                return (0.0, 0.0, 0.58, 1.0)
            case .EaseInOut:
                return (0.42, 0.0, 0.58, 1.0)
            case .Linear:
                return (0, 0, 1, 1)
            }
        }
    }

    private let A: ((aA1: Double, aA2: Double) -> Double) = { return 1.0 - 3.0 * $1 + 3.0 * $0 }
    private let B: ((aA1: Double, aA2: Double) -> Double) = { return 3.0 * $1 - 6.0 * $0 }
    private let C: ((aA1: Double) -> Double) = { return 3.0 * $0 }
    
    // Hmmmmm, Actually, I don't know why the source code have samples table
    // Or it should be removed?
    private lazy var sampleValues: [Double] = {
        if self.controlPoints.x1 != self.controlPoints.y1 || self.controlPoints.x2 != self.controlPoints.y2 {
            return (0..<kSplineTableSize).map { self.calcBezier(Double($0) * kSampleStepSize, aA1: self.controlPoints.x1, aA2: self.controlPoints.x2) }
        } else {
            return [Double](count: kSplineTableSize, repeatedValue: 0)
        }
    }()
    
    public let controlPoints: (x1: Double, x2: Double, y1: Double, y2: Double)
    
    public init(mX1 outerMX1: Double, mY1 outerMY1: Double, mX2 outerMX2: Double, mY2 outerMY2: Double) {
        assert((outerMX1 >= 0 && outerMX1 <= 1 && outerMX2 >= 0 && outerMX2 <= 1), "Bezier x values must be in [0, 1] range")
        
        controlPoints = (outerMX1, outerMX2, outerMY1, outerMY2)
    }
    
    public init(controlPoints: (x1: Double, y1: Double, x2: Double, y2: Double)) {
        assert((controlPoints.x1 >= 0 && controlPoints.x1 <= 1 && controlPoints.x2 >= 0 && controlPoints.x2 <= 1), "Bezier x values must be in [0, 1] range")
        
        self.controlPoints = controlPoints
    }
    
    public convenience init(easing: Easing) {
        self.init(controlPoints: easing.toControlPoints())
    }
    
    // MARK: - Private Methods
    /**
     Returns x(t) given t, x2, and x2 or y(t) given t y1, and y2.
     */
    private func calcBezier(aT: Double, aA1: Double, aA2: Double) -> Double {
        return ((A(aA1: aA1, aA2: aA2) * aT + B(aA1: aA1, aA2: aA2)) * aT + C(aA1: aA1)) * aT
    }
    
    /**
     Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
     */
    private func getSlope(aT: Double, aA1: Double, aA2: Double) -> Double {
        return 3.0 * A(aA1: aA1, aA2: aA2) * aT * aT + 2.0 * B(aA1: aA1, aA2: aA2) * aT + C(aA1: aA1)
    }
    
    private func binarySubdivide(aX: Double, aA: Double, aB: Double, mX1: Double, mX2: Double) -> Double {
        var currentX: Double = 0
        var currentT: Double = 0
        var index: Int = 0
        var innerAA = aA
        var innerAB = aB
        
        repeat {
            currentT = innerAA + (innerAB - innerAA) / 2.0
            currentX = calcBezier(currentT, aA1: mX1, aA2: mX2) - aX
            
            if currentX > 0.0 {
                innerAB = currentT
            } else {
                innerAA = currentT
            }
            
            index += 1
        } while (abs(currentX) > subdevusuibPrecision && index < subdevisionMaxInterations)
        
        return currentT
    }
    
    private func newtownRaphsonIterate(aX: Double, aGuessT: Double, mX1: Double, mX2: Double) -> Double {
        for _ in 0..<newtownIterations {
            let currentSlope = getSlope(aGuessT, aA1: mX1, aA2: mX2)
            if currentSlope == 0 {
                return aGuessT
            }
            
            let currentX = calcBezier(aGuessT, aA1: mX1, aA2: mX2) - aX
            
            return aGuessT - currentX / currentSlope
        }
        
        return aGuessT
    }
    
    private func getTForX(aX: Double) -> Double {
        var intervalStart: Double = 0
        var currentSample = 1
        let lastSample = kSplineTableSize - 1
        
        while(currentSample != lastSample && sampleValues[currentSample] <= aX) {
            currentSample += 1
            
            intervalStart += kSampleStepSize
        }
        
        currentSample -= 1
        
        // Interpolate to provide an initial guess for t
        let dist = (aX - sampleValues[currentSample]) / (sampleValues[currentSample + 1] - sampleValues[currentSample])
        let guessForT = intervalStart + dist * kSampleStepSize
        
        let initialSlope = getSlope(guessForT, aA1: controlPoints.x1, aA2: controlPoints.x2)
        
        if initialSlope >= newtownMinSlope {
            return newtownRaphsonIterate(aX, aGuessT: guessForT, mX1: controlPoints.x1, mX2: controlPoints.x2)
        } else if initialSlope == 0 {
            return guessForT
        } else {
            return binarySubdivide(aX, aA: intervalStart, aB: intervalStart + kSampleStepSize, mX1: controlPoints.x1, mX2: controlPoints.x2)
        }
    }
    
    // MARK: - Public Methods
    public func easing(x: Double) -> Double {
        if (controlPoints.x1 == controlPoints.y1 && controlPoints.x2 == controlPoints.y2) || x == 0 || x == 1 {
            return x
        }
        
        return calcBezier(getTForX(x), aA1: controlPoints.y1, aA2: controlPoints.y2)
    }
}