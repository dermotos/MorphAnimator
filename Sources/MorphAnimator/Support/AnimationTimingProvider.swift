//
//  AnimationTimingProvider.swift
//

import Foundation
import UIKit

extension Morph {
    /// Custom timing curve provider for morph animations. Creates a composed timing curve that uses both spring timing and a bezier curve timing.
    @objc(MorphTimingProvider)
    class TimingProvider: NSObject, NSCoding, NSCopying, UITimingCurveProvider {
        func encode(with coder: NSCoder) { }
        
        override init() { }
        
        required init?(coder: NSCoder) {
            nil
        }
        
        func copy(with zone: NSZone? = nil) -> Any {
            TimingProvider()
        }
        
        private enum Constants {
            static let damping: CGFloat = 1.0
            static let controlPoint1 = CGPoint(x: 0.46, y: 0.02)
            static let controlPoint2 = CGPoint(x: 0, y: 1)
        }
        
        var timingCurveType: UITimingCurveType {
            .composed
        }

        var cubicTimingParameters: UICubicTimingParameters? {
            let bezierTiming = UICubicTimingParameters(controlPoint1: Constants.controlPoint1, controlPoint2: Constants.controlPoint2)
            return bezierTiming
        }

        var springTimingParameters: UISpringTimingParameters? {
            let springTiming = UISpringTimingParameters(dampingRatio: Constants.damping)
            return springTiming
        }
    }
}
