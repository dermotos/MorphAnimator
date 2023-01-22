//
//  Morph.Transitioning.swift
//

import Foundation
import UIKit
import CoreGraphics

extension Morph {
    class Transitioning: NSObject, UIViewControllerAnimatedTransitioning {
        
        private enum Constants {
            static let animationDuration: TimeInterval = 0.65
        }

        let direction: Direction
        let sources: Pair<MorphAnimatorViewSource>
        let guidance: [TransitionGuidance]
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            Constants.animationDuration
        }
        
        init(transitionDataSources: Pair<MorphAnimatorViewSource>, direction: Direction, guidance: [TransitionGuidance]) {
            self.sources = transitionDataSources
            self.direction = direction
            self.guidance = guidance
            super.init()
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let transitionKey: Morph.TransitionKey = .allTransitions
            let transitionContainer = transitionContext.containerView
            guard
                    let toView = transitionContext.view(forKey: .to),
                    let fromView = transitionContext.view(forKey: .from) else {
                print("Unable to create animation scene.")
                transitionContext.completeTransition(false)
                return
            }
            transitionContainer.addSubview(toView)
            let duration = transitionDuration(using: transitionContext)
            guard let scene = Scene(viewSources: sources, transitionContext: transitionContext, direction: direction, duration: duration, transitionKey: transitionKey) else {
                print("Unable to create animation scene.")
                transitionContext.completeTransition(false)
                return
            }
            
            guard let animator = Morph.Animator(scene: scene, guidance: guidance) else {
                print("Unable to create animation scene.")
                transitionContext.completeTransition(false)
                return
            }
            
            animator.completionTasks.append {
                transitionContext.completeTransition(true)
                toView.isHidden = false
                fromView.isHidden = false
            }
            
            toView.isHidden = true
            fromView.isHidden = true
            
            do {
                try animator.animate()
            } catch {
                transitionContext.completeTransition(false)
            }
            
        }
    }
}
