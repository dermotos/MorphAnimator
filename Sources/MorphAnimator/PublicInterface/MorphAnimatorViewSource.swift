//
//  ViewControllerExtensions.swift
//

import UIKit

// MARK: - Public Interface

/// MorphAnimatorViewSource
///
/// Conform to this protocol to provide support for morph transitions.
public protocol MorphAnimatorViewSource {
    
    /// Use this method to provide the MorphAnimator transition system with views which it will
    /// animate during transitions.
    ///
    /// The MorphAnimator will use the views provided here by the origin and destination view controllers
    /// to create a fluid animation between the two screens.
    /// The view controllers that take part in the transition should provide the views that would be of interest to the animator in
    /// a dictionary. The keys (identifiers) for the views can be any string. If the same identifer is used for a view in both view controllers
    /// taking part in the transition, the animator will attempt to fluidly animate the origin view to the destination view of the same identifier
    /// during the transition. It will also use the position and scaling deltas of common views to animate the other views of interest in a fluid way.
    /// Views that are not nominated as views of interest will be faded.
    ///
    /// - Parameters:
    ///   - forTransition: The coordinator may provide a `TransitionKey`. You can use this to conditionally provide different views
    ///   of interest for different transitions. In most cases, you can simply provide all views of interest for all transitions.
    ///   - transit: The `transit` parameter identifies whether this view controller is `entering` or `exiting` in the  imminent transition.
    ///   You can optionally use this parameter to return different views depending on the transit direction of the transition.
    ///
    /// - Returns: Return a dictionary of identifiers and views of interest
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String: UIView]?
    
    /// Use this method to provide the MorphAnimator with the portal view of an animation.
    ///
    /// The portal view, for example in the `exiting` view controller,  is the view which is expanded or "entered" when the user
    /// taps on it. For the `entering` view controller, this is often, but not always the entire window.
    ///
    /// Some pre-existing examples in iOS to help understand this:
    /// * On the iOS homescreen, when a user taps an icon to open an app:
    ///   * The frame of the icon on the home screen is the `exiting` portal view.
    ///   * The full screen window of the resulting app is the `entering` portal view.
    ///
    /// * On the iOS homescreen, when a user taps on a folder of apps:
    ///   * The small, icon-sized folder on the home screen is the `exiting` portal view.
    ///   * The expanded folder view containing 3 rows of 3 apps that fills the centre of the view  is the `entering` portal view.
    ///   * Incidentially, in this example, the individual app icons within the folder could be
    ///   automatically morphed by including them in the `viewsOfInterest`.
    ///
    ///   - The portal view for `exiting` view controllers is most commonly the selected icon, row or item that initiated the transition to the next screen.
    ///   To support this, in most cases you would need to have a weak property in which you assign a reference to the most recently tapped item/row/button
    ///   on your view as soon as the object is touched. You can then return this property in this method
    ///   - The portal view for the `entering` view controller is most commonly, but not always the full screen/window of the destination view controller.
    ///    It can, however, be a smaller area of the destination view controller.
    ///
    ///    If a portal view is provided for the `exiting` but not the `entering` view controller, the animator will assume the `entering` portal view
    ///    is the entire screen.
    ///
    ///    If no portal view is provided for the `exiting` view controller, no portal animation will occur.
    ///
    ///    In general, you should use a portal animation if the user is following a path that is becoming more specific (forward) or general (backward).
    ///    For example tapping an agreement to see the agreements transactions, or tapping a transaction to see transition details. Morph transitions
    ///    without a portal are better for situations where the user is conceptually on the same level as they move between screens. For example morphing
    ///    between the splash screen of the app and the PIN entry screen, or moving between screens in a setup wizard.
    ///
    ///    Developers should note that if portal views are provided for a transition, then any `viewsOfInterest` that are common in both views must
    ///    be positioned within the frame of the portal views. Failing to observe this rule would cause visually jarring animations. If this rule is violated,
    ///    the animator will fail back to a simpler animation by ignoring one or more pieces of information provided to it.
    ///
    /// - Returns: Returns the portal view for the specified transition key and transit.
    func portalView() -> UIView?
}

public extension MorphAnimatorViewSource {
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String: UIView]? { nil }
    
    func portalView() -> UIView? { nil }
}

/// The transition type
public enum TransitionAnimationType {
    /// A default `UINavigationController` push transition
    case `default`
    /// A "morph" transition
    case morph
    /// No transition
    case none
}
