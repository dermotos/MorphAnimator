//
//  UINavigationControllerExtension.swift
//

import UIKit

public extension UINavigationController {
    
    /// This convenience extension is a drop in replacement for the existing UINavigationController push/pop methods.
    ///
    /// Simply replace
    ///   ```
    ///   navigationController.push(viewController, animated: true
    ///   ```
    ///   with
    ///   ```
    ///   navigationController.push(viewController, animated: .morph
    ///   ```
    ///   to quickly add morph transitions to your flow.
    ///   Note that the current top view controller on the navigationController stack, and the new view controller that you wish to push must conform to `MorphAnimatorViewSource`.
    ///   For more advanced scenarios, use the methods available in `Morph.Factory`.
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack. Must conform to `MorphAnimatorViewSource`.
    ///   - animated: Animation type enumeration. Set to `.morph` to use a morph transition.
    ///   - guidance: Optional `TransitionGuidance` array to guide the animator into creating a transition that better suits your flow.
    func pushViewController(_ viewController: UIViewController, animated: TransitionAnimationType, guidance: [TransitionGuidance] = [TransitionGuidance]()) {
    
        switch animated {
        case .`default`:
            pushViewController(viewController, animated: true)
            return
        case .none:
            pushViewController(viewController, animated: false)
            return
        case .morph:
            break
        }
        
        guard
            let fromViewSource = self.topViewController as? MorphAnimatorViewSource,
            let toViewSource = viewController as? MorphAnimatorViewSource else {
                assertionFailure("The current or presented view controller does not conform to `MorphTransitionViewSource`. Failing back to default UINavigationController push transition.")
                self.pushViewController(viewController, animated: true)
                return
            }
        
        let viewSources = Morph.Pair<MorphAnimatorViewSource>(from: fromViewSource, to: toViewSource)
        let transitionDelegate = Morph.TransitionNavigationDelegate(transitionDataSources: viewSources, guidance: guidance)
        let originalDelegate = self.delegate
        self.delegate = transitionDelegate
        self.pushViewController(viewController, animated: true)
        self.delegate = originalDelegate
    }
    
    @discardableResult
    /// /// This convenience extension is a drop in replacement for the existing UINavigationController push/pop methods.
    ///
    /// Simply replace
    ///   ```
    ///   navigationController.push(viewController, animated: true
    ///   ```
    ///   with
    ///   ```
    ///   navigationController.push(viewController, animated: .morph
    ///   ```
    ///   to quickly add morph transitions to your flow.
    ///   Note that the current top view controller on the navigationController stack, and the new view controller that you wish to push must conform to `MorphTransitionViewSource`.
    ///   For more advanced scenarios, use the methods available in `Morph.Factory`.
    /// - Parameters:
    ///   - animated: Animation type enumeration. Set to `.morph` to use a morph transition.
    ///   - guidance: Optional `TransitionGuidance` array to guide the animator into creating a transition that better suits your flow.
    /// - Returns: The view controller that is removed from the navigation stack.
    func popViewController(animated: TransitionAnimationType, guidance: [TransitionGuidance] = [TransitionGuidance]()) -> UIViewController? {
        
        guard animated == .morph else {
            return popViewController(animated: animated == .default)
        }
       
        guard
            let fromViewSource = self.topViewController as? MorphAnimatorViewSource,
            let toViewSource = self.viewControllers[self.viewControllers.count - 2] as? MorphAnimatorViewSource else {
                assertionFailure("The current and/or previous view controller does not conform to `MorphTransitionViewSource`. Failing back to default UINavigationController pop transition.")
                return self.popViewController(animated: true)
            }
        
        let viewSources = Morph.Pair<MorphAnimatorViewSource>(from: fromViewSource, to: toViewSource)
        let transitionDelegate = Morph.TransitionNavigationDelegate(transitionDataSources: viewSources, guidance: guidance)
        
        let originalDelegate = self.delegate
        self.delegate = transitionDelegate
        defer { self.delegate = originalDelegate }
        return self.popViewController(animated: true)
    }
}
