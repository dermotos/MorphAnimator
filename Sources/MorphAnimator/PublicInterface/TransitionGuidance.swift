//
//  TransitionGuidance.swift
//

import Foundation
import UIKit

public protocol TransitionGuidance { }

extension Morph {
    public enum Side {
        case from
        case to
    }

    /// Remap keys specified in the transitioning view controllers to be better suited to the desired transition.
    public struct KeyRemapGuidance: TransitionGuidance {
        /// Views with keys in the `remove` property will be removed from the morph animation, and will behave like the view controller never nominated them as `viewsOfInterest`.
        /// /// Specify a `side` to apply the guidance to a single side of the transition, or pass nil to apply to both sides.
        public let remove: [(viewKey: Morph.ViewKey, side: Side?)]
        
        /// Remap one or more views into a new, single view key. This allows changing the view keys to be something else, or to treat multiple discrete views as a single view in the animation.
        /// Specify a `side` to apply the guidance to a single side of the transition, or pass nil to apply to both sides.
        public let remap: [(from: [Morph.ViewKey], to: Morph.ViewKey, side: Side?)]
    }

    /// Adjust the speed of the transition, within an allowable range
    public struct TimingGuidance: TransitionGuidance {
        private enum Limits {
            static let range: ClosedRange<CGFloat> = 0.5...1.5
        }
        
        var multiplier: CGFloat {
            willSet {
                assert(Limits.range.contains(multiplier), "TimingGuidance multipler outside allowable range. You can adjust the transition speed between \(Limits.range.lowerBound) and \(Limits.range.upperBound) of its native speed.")
            }
        }
    }

    struct PortalGuidance: TransitionGuidance {
        let cornerRadius: CGFloat
        let disableShadow: Bool
    }
}
