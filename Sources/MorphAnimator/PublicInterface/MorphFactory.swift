//
//  MorphTransitionFactory.swift
//

import UIKit

extension Morph {
    /// Makes a navigation controller delegate object which supports a morph animation.
    /// - Returns: Navigation controller delegate. Set this as the Navigation
    /// controllers `navigationDelegate` prior to calling the system `push` or `pop`
    /// methods.
    ///
    /// Note that if you push a view controller, then subsequently pop it again, you
    /// should update the navigation delegate accordingly. In a `push`, the `from` view
    /// source will be the view controller currently on the top of the navigaiton view
    /// controller stack, and the `to` view source will be the new view controller.
    ///
    /// For a `pop` behaviour, the `from` view controller is still the view currently on
    /// the navigation stack, however the `to` view controller is view controller
    /// underneath it in the view controller stack
    /// (`navigationController.viewControllers[viewControllers.count - 2]`). Be sure to
    /// update the navigation delegate object accordingly so the correct view
    /// controllers are provided to the animator for the different push and pop actions.
    public static func makeNavigationDelegate(viewSources: Pair<MorphAnimatorViewSource>,
                                              guidance: [TransitionGuidance] = [TransitionGuidance]()) -> UINavigationControllerDelegate {
        let transitionDelegate = TransitionNavigationDelegate(transitionDataSources: viewSources, guidance: guidance)
        return transitionDelegate
    }
    
    /// Makes a view controller delegate object which supports a morph animation.
    /// - Returns: Transitioning delegate. Set this as the view
    /// controllers `transitioningDelegate` prior to calling the `UIViewController.transition()` method.
    ///
    public static func makeTransitionDelegate(viewSources: Pair<MorphAnimatorViewSource>,
                                              guidance: [TransitionGuidance] = [TransitionGuidance]()) -> UIViewControllerTransitioningDelegate {
        let transitionDelegate = ViewControllerTransitionDelegate(transitionDataSources: viewSources, guidance: guidance)
        return transitionDelegate
    }
}
