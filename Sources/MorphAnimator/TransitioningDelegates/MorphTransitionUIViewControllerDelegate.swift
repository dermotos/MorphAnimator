//
//  MorphTransitionUIViewControllerDelegate.swift
//

import Foundation
import UIKit
import CoreGraphics

extension Morph {
    class ViewControllerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
        let transitionDataSources: Pair<MorphAnimatorViewSource>
        let guidance: [TransitionGuidance]
        
        init(transitionDataSources: Pair<MorphAnimatorViewSource>, guidance: [TransitionGuidance] = [TransitionGuidance]() ) {
            self.transitionDataSources = transitionDataSources
            self.guidance = guidance
            super.init()
        }
        
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            Transitioning(transitionDataSources: transitionDataSources, direction: .forward, guidance: guidance)
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            Transitioning(transitionDataSources: transitionDataSources, direction: .reverse, guidance: guidance)
        }
    }
}
