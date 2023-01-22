//
//  PublicTypes.swift
//

import Foundation

// MARK: - Public

extension Morph {
    /// Defines the transit types for view controllers in a morph transition
    public enum Transit {
        /// The user is exiting the current view controller
        case exiting
        /// The user is entering the current view controller
        case entering
    }
    
    /// The direction of the transition animation.
    public enum Direction {
        /// Forward direction. Analogous to `push` or `present`.
        case forward
        /// Reverse direction. Analogous to `pop` or `dismiss`.
        case reverse
    }
    
    /// Key to identify a View of Interest. If the counterpart view controller uses the same `ViewKey` to identify a view, the animator will morph between the two views during the transition.
    public typealias ViewKey = String
    /// Key to identify a specific transition.
    ///
    /// Allows the view controller developer to only return Views of Interest specific to a particular transition. In most cases this can be ignored as the coordinator developer can specify to ignore certain view keys when they create the transition by using `TransitionGuidance`.
    public typealias TransitionKey = String
}

public extension Morph.TransitionKey {
    /// Specifies that the Views of Interest apply to all transitions.
    static let allTransitions = "_allTransitions"
}
