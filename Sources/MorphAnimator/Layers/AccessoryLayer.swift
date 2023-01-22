//
//  AccessoryLayer.swift
//

import UIKit

extension Morph {
    /// Accessory layers are attached to other layers. One such example is a shadow layer.
    class AccessoryLayer: MorphAnimationLayer {

        typealias ContentType = UIView
        
        var content: UIView
        var constraints: ConstraintSet
        var animator: UIViewPropertyAnimator?
        
        required init(content: UIView, constraints: ConstraintSet, scene: Scene) {
            self.content = content
            self.constraints = constraints
        }
        
        func cleanUp() {
            content.removeFromSuperview()
        }
        
        /// Create an accessory layer that represents a shadow of another layer
        /// - Parameters:
        ///   - masterView: The view/layer this shadow is attached to.
        ///   - scene: The scene object
        /// - Returns: An initialized accessory layer, constrained to its `masterView`.
        static func makeShadow(attachedTo masterView: UIView, in scene: Scene) -> AccessoryLayer {
            let shadowView = UIView()
            shadowView.backgroundColor = .white // A shadow will not be applied unless a view is opaque
            shadowView.clipsToBounds = false
            shadowView.layer.shadowColor = Constants.Shadow.color
            shadowView.layer.shadowOpacity = Constants.Shadow.opacity
            shadowView.layer.shadowOffset = Constants.Shadow.offset
            shadowView.layer.shadowRadius = Constants.Shadow.radius
            
            let constraints = ConstraintSet(constrain: shadowView, to: masterView, enable: false)
            
            return AccessoryLayer(content: shadowView, constraints: constraints, scene: scene)
            
        }
    }
}
