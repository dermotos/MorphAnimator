//
//  PortalLayer.swift
//

import UIKit

extension Morph {
    /// A portal layer is just a single view (used within the animation), which is generated from a pair of concrete views.
    /// It animates from the frame of the first view (within the trainsitionContainer) to the frame of the second view.
    ///
    /// Its contents are masked (clipToBounds = true), however its contents do not constrain themselves to the portal view,
    /// instead they constrain themselves to a common ancestor. This allows the frame of the portal to change without affecting
    /// its decendant views, allowing for more complex animated masking than would otherwise be possible
    /// without having to drop down to CoreAnimation.
    class PortalLayer: MorphAnimationLayer, MorphLayerEndPositionable {
        
        required init(content: UIView, constraints: ConstraintSet, scene: Scene) {
            self.content = content
            self.constraints = constraints
            self.scene = scene
        }

        enum Growth {
            case expanding
            case contracting
            case `static`
        }

        typealias ContentType = UIView
        
        func cleanUp() {
            content.removeFromSuperview()
        }
        
        // MARK: - Factory methods
        
        static func makePortal(for scene: Scene) -> PortalLayer? {
            guard let positions = try? Self.positioning(of: scene.portals, within: scene.stage) else { return nil }
            let portal = UIView()
            
            let constraints = ConstraintSet(constrain: portal, at: positions.start, to: scene.portals.from.bounds.size, inView: scene.stage)
            let endPlacement = Placement(at: positions.end, size: scene.portals.to.bounds.size)
            
            portal.translatesAutoresizingMaskIntoConstraints = false
            portal.clipsToBounds = true
            
            if scene.animationDirection == .forward {
                portal.layer.cornerRadius = scene.portals.from.layer.cornerRadius
                if #available(iOS 13.0, *) {
                    portal.layer.cornerCurve = scene.portals.from.layer.cornerCurve
                }
            } else {
                portal.layer.cornerRadius = scene.portals.to.layer.cornerRadius
                if #available(iOS 13.0, *) {
                    portal.layer.cornerCurve = scene.portals.to.layer.cornerCurve
                }
            }
           
            let layer = PortalLayer(content: portal, constraints: constraints, scene: scene)
            layer.endPlacement = endPlacement
            return layer
        }
        
        func addContent(_ view: UIView) {
            content.addSubview(view)
        }
        
        private var scene: Scene
        
        /// Identifies whether the portal with grow, shrink or remain static during the transition
        var growthDirection: Growth {
            if scene.portals.to.bounds.size.height > scene.portals.from.bounds.size.height {
                return .expanding
            } else if scene.portals.to.bounds.size.height < scene.portals.from.bounds.size.height {
                return .contracting
            } else {
                return .static
            }
        }
        
        var content: UIView
        var constraints: ConstraintSet
        var endPlacement: Placement?
        var animator: UIViewPropertyAnimator?
        
        var currentPlacement: Morph.Placement { constraints.placement }
    }
}
