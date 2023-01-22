//
//  EffectLayer.swift
//

import UIKit

extension Morph {
    /// A layer that applies a `UIVisualEffect` to underlying layers.
    class EffectLayer: MorphAnimationLayer {

        typealias ContentType = UIVisualEffectView
        
        var effect: UIVisualEffect
        var content: UIVisualEffectView
        var constraints: ConstraintSet
        var animator: UIViewPropertyAnimator?
        
        required init(content: UIVisualEffectView, constraints: ConstraintSet, scene: Scene) {
            fatalError("Not Implemented")
        }
        
        private init(content: UIVisualEffectView, blurEffect: UIBlurEffect, constraints: ConstraintSet) {
            self.content = content
            self.constraints = constraints
            effect = blurEffect
        }
        
        var isActive: Bool {
            get { content.effect == effect }
            set { content.effect = newValue ? effect : nil }
        }
        
        func cleanUp() {
            content.removeFromSuperview()
        }
        
        static func makeBlurLayer(style: UIBlurEffect.Style, in scene: Scene) -> EffectLayer {
            let effect = UIBlurEffect(style: style)
            let effectView = UIVisualEffectView()
            let constraints = ConstraintSet(constrain: effectView, to: scene.stage, enable: false)
            let layer = EffectLayer(content: effectView, blurEffect: effect, constraints: constraints)
            return layer
        }
    }
}
