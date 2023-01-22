//
//  Flow.swift
//

import UIKit

extension Morph {
    /// Flow represents the overall movement in a transition.
    ///
    /// Flow is normally calculated as an average of the change in position and scale of the morphing views in a transition.
    /// It can then be applied to the entering and exiting views to maintain consistency in motion throughout the transition.
    struct Flow: Comparable {
        let translation: CGVector
        let scale: CGFloat
        
        static func < (lhs: Flow, rhs: Flow) -> Bool {
            lhs.translation < rhs.translation
        }
    }
}
