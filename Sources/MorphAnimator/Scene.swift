//
//  Scene.swift
//

import Foundation
import UIKit

extension Morph {
    /// A scene is an abstraction of what we need to animate.
    ///
    /// The scene initalizer takes information like the view sources and transition context and queries these objects
    /// to create a collection of views. This view collection reorganises the views into a format that is better suited to the animator. The views in the from and to view controllers
    /// are grouped into pairs. The scene contains the following pairs:
    /// * `baseViews` -  A `Pair<>` containing the two full view controller views (from and to views)
    /// * `morphingViews` - An array of `Pair<>`s that contain views that are common in both view controllers, paired with their counterpart.
    /// * `exitingViews` - An array of views that are present in the `from` view controller, but not the `to` view controller. These will be leaving the scene during the transition.
    /// * `enteringViews`-  An array of views that are present in the `to` view controller, but not the `from` view controller. These will be entering the scene during the transition.
    /// * `portals` - A pair of views that represent the location of the portal in the `from` and `to` view controllers,, if one is used in this transition. A real world example of a portal
    /// is the iOS home screen. When you tap on an app icon, the icon expands to become the app. In this case, the `from` portal is the app icon and the `to` portal is the full screen app view.
    /// * `stage` - This is the view where the transition plays out.
    public class Scene {

        /// Accepts a pair of transition view sources, one from the 'from' view controller and one from the 'to' view controller.
        /// Accepts the transition context object provided by the `UIViewControllerAnimatedTransitioning`.
        /// Optionally accepts a `TransitionKey` that is used to request specific views of interest from the transition view sources.
        /// If one is not provided, all views of interest are requested.
        ///
        /// The initializer takes the provided information and generates a Scene object, which structures the views in a format better suited to how the transition will take place.
        convenience init?(viewSources: Pair<MorphAnimatorViewSource>,
                          transitionContext: UIViewControllerContextTransitioning,
                          direction: Direction,
                          duration: TimeInterval,
                          transitionKey: Morph.TransitionKey = .allTransitions) {
            
            guard let fromBaseView = transitionContext.view(forKey: .from),
                  let toBaseView = transitionContext.view(forKey: .to) else { return nil }
            let baseViews = Pair<UIView>(from: fromBaseView, to: toBaseView)
            let stage = transitionContext.containerView
            
            self.init(viewSources: viewSources, baseViews: baseViews, stageView: stage, direction: direction, duration: duration)
        }
        
        public init?(viewSources: Pair<MorphAnimatorViewSource>,
                     baseViews: Pair<UIView>,
                     stageView: UIView,
                     direction: Direction,
                     duration: TimeInterval,
                     transitionKey: Morph.TransitionKey = .allTransitions) {

            self.baseViews = baseViews
            self.stage = stageView
            let fromViews = viewSources.from.viewsOfInterest(forTransition: transitionKey, transit: .exiting) ?? [String: UIView]()
            let toViews = viewSources.to.viewsOfInterest(forTransition: transitionKey, transit: .entering) ?? [String: UIView]()
            
            let fromViewKeys = Set(fromViews.keys.map { String($0) })
            let toViewKeys = Set(toViews.keys.map { String($0) })
            let intersectingKeys = fromViewKeys.intersection(toViewKeys)
            let exclusiveFromKeys = fromViewKeys.subtracting(intersectingKeys)
            let exclusiveToKeys = toViewKeys.subtracting(intersectingKeys)
            
            var mappingDidSucceed = false
            self.morphingViews = intersectingKeys.map {
                guard let fromView = fromViews[$0], let toView = toViews[$0] else {
                    return Pair<UIView>(from: UIView(), to: UIView())
                }
                mappingDidSucceed = true
                return Pair<UIView>(from: fromView, to: toView)
            }
            
            guard intersectingKeys.isEmpty || mappingDidSucceed else { return nil }
            
            self.exitingViews = exclusiveFromKeys.compactMap { fromViews[$0] }
            self.enteringViews = exclusiveToKeys.compactMap { toViews[$0] }
            
            let exitingPortal: UIView
            let enteringPortal: UIView
            if direction == .forward {
                exitingPortal = viewSources.from.portalView() ?? baseViews.from
                enteringPortal = baseViews.to
            } else {
                exitingPortal = baseViews.from
                enteringPortal = viewSources.to.portalView() ?? baseViews.to
            }
            portals = Pair<UIView>(from: exitingPortal, to: enteringPortal)
            self.animationDirection = direction
            self.animationDuration = duration
            
            precondition(!allAnimatedViews.contains { $0.isHidden }, "One or more animated subviews in the transition has it's `isHidden` property set to true. The behaviour of the transition is undefined. All animated subviews must have their `isHidden` property set to false or be explicity excluded from the transition using a transition hint in the coordinator.")
        }
        
        /* Dev note: These are references to concrete views. In the `MorphAnimator`, we create and use snapshots */
        var baseViews: Morph.ViewPair
        
        var morphingViews: Morph.ViewPairCollection
        var exitingViews: Morph.ViewCollection
        var enteringViews: Morph.ViewCollection
        var portals: Pair<UIView>
        var stage: UIView
        
        var animationDirection: Direction
        var animationDuration: TimeInterval
        
        var allAnimatedViews: [UIView] {
            morphingViews.reduce([], +) + exitingViews + enteringViews
        }
        
    }
    
}

extension Morph.Scene {
    /// Get two rectangles; one that encapsulates all the morphing
    /// views at their start position, the other at their end position.
    /// Calculates the delta and return as a (translation) vector.
    var morphingViewDelta: CGVector {
        if morphingViews.isEmpty { return .zero }
        let startRect =
        morphingViews.compactMap { $0.from.superview?.convert($0.from.frame, to: stage) }
        .reduce(CGRect.null, { $0.union($1) })
        
        let endRect =
        morphingViews.compactMap { $0.to.superview?.convert($0.to.frame, to:stage) }
        .reduce(CGRect.null, { $0.union($1) })
        
        let xTranslation = (startRect.center.x - endRect.center.x)
        let yTranslation = (startRect.center.y - endRect.center.y)
        let translation = CGVector(dx: xTranslation, dy: yTranslation)
        return translation
    }
}
