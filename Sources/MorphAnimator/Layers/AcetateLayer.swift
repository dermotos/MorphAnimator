//
//  AcetateLayer.swift
//

import UIKit

extension Morph {
    /// A layer that contains other animatable layers, allowing them to be animated in unision.
    ///
    /// Originates from the animation technique of placing one or more aniamted characters on an cellulose acetate sheet,
    /// a transparent piece of plastic that is used in early animation techniques to animate characters separately from the background layer.
    /// In this usage, the actetate layer contains a number of sub layers. The acetate layer's animation affects all its sub-layers.
    class AcetateLayer: MorphAnimationLayer, MorphLayerTransformable {

        typealias ContentType = UIView
        
        var content: UIView
        var constraints: ConstraintSet
        var transform: Transform<CGAffineTransform>
        var focus: CGPoint
        var animator: UIViewPropertyAnimator?
        
        required init(content: UIView, constraints: ConstraintSet, scene: Scene) {
            fatalError("Not supported")
        }
        
        init(content: UIView, constraints: ConstraintSet, transform: Transform<CGAffineTransform>, focus: CGPoint) {
            self.content = content
            self.constraints = constraints
            self.transform = transform
            self.focus = focus
        }
        
        func addContent(_ view: UIView) {
            content.addSubview(view)
        }
        
        func applyFocus() {
            precondition(!content.frame.isEmpty, "View requires a layout pass prior to setting focus.")
            content.setAnchorPoint(toViewAnchor: focus, movingView: false)
        }
        
        func cleanUp() {
            content.removeFromSuperview()
        }
        
        func applyTransform(_ position: Transform<CGAffineTransform>.Position) {
            content.transform = transform.transform(for: position)
        }
        
        // MARK: Factory methods
        
        static func makeEnteringLayerAcetate(in scene: Scene, portalLayer: PortalLayer? = nil) -> AcetateLayer {
            let contentView = UIView()
            let constraints = ConstraintSet(constrain: contentView, to: scene.stage, enable: false)
            let flowVector = flow(in: scene, portalLayer: portalLayer)
            
            let startTranslate = CGAffineTransform(translationX: flowVector.dx, y: flowVector.dy)
            let startScale = CGAffineTransform(scaleX: Constants.Flow.entryScaling, y: Constants.Flow.entryScaling)
            let startTransform = startTranslate.concatenating(startScale)
            let endTransform: CGAffineTransform = .identity
            let transform = Transform<CGAffineTransform>(start: startTransform, end: endTransform)
            
            let focus = scene.stage.center
            let layer = AcetateLayer(content: contentView, constraints: constraints, transform: transform, focus: focus)
            return layer
        }
        
        static func makeExitingLayerAcetate(in scene: Scene, portalLayer: PortalLayer? = nil) -> AcetateLayer {
            let contentView = UIView()
            let constraints = ConstraintSet(constrain: contentView, to: scene.stage, enable: false)
            let flowVector = flow(in: scene, portalLayer: portalLayer)
            
            let startTransform: CGAffineTransform = .identity
            // Note that we invert the exiting layer's translation vector, as we are applying it *before* the animation, and animating to the
            // normal end state (identity transform).
            let endTranslate = CGAffineTransform(translationX: flowVector.dx  * -1, y: flowVector.dy  * -1)
            let endScale = CGAffineTransform(scaleX: Constants.Flow.entryScaling, y: Constants.Flow.entryScaling)
            let endTransform = endTranslate.concatenating(endScale)
            let transform = Transform<CGAffineTransform>(start: startTransform, end: endTransform)
            
            let focus = scene.stage.center
            let layer = AcetateLayer(content: contentView, constraints: constraints, transform: transform, focus: focus)
            return layer
        }
        
        private static func flow(in scene: Scene, portalLayer: PortalLayer?) -> CGVector {
            guard let portalLayer = portalLayer else {
                return morphingViewFlow(in: scene)
            }
            if portalLayer.growthDirection == .static {
                return morphingViewFlow(in: scene)
            } else {
                return portalFlow(in: scene)
            }
        }
        
        private static func morphingViewFlow(in scene: Scene) -> CGVector {
            scene.morphingViewDelta.applyingMultiplier(Constants.Flow.translationMultiplier)
        }
        
        private static func portalFlow(in scene: Scene) -> CGVector {
            let startRect = scene.portals.from.frame
            let endRect = scene.portals.from.frame
            
            let xTranslation = (startRect.center.x - endRect.center.x) * Constants.Flow.translationMultiplier
            let yTranslation = (startRect.center.y - endRect.center.y) * Constants.Flow.translationMultiplier
            let translation = CGVector(dx: xTranslation, dy: yTranslation)
            return translation
        }
    }
}
