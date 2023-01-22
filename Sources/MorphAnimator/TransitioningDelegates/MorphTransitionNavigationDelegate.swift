//
//  MorphTransitionNavigationDelegate.swift
//

import Foundation
import UIKit
import CoreGraphics

extension Morph {
    class TransitionNavigationDelegate: NSObject, UINavigationControllerDelegate {
        
        let transitionDataSources: Pair<MorphAnimatorViewSource>
        let guidance: [TransitionGuidance]
        
        init(transitionDataSources: Pair<MorphAnimatorViewSource>, guidance: [TransitionGuidance] = [TransitionGuidance]() ) {
            self.transitionDataSources = transitionDataSources
            self.guidance = guidance
            super.init()
        }
        
        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            switch operation {
            case .push:
                return Transitioning(transitionDataSources: transitionDataSources, direction: .forward, guidance: guidance)
            case .pop:
                return Transitioning(transitionDataSources: transitionDataSources, direction: .reverse, guidance: guidance)
            default:
                return nil
            }
        }
    }
}
