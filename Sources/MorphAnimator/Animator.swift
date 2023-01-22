//
//  Animator.swift
//

import CoreGraphics
import UIKit

extension Morph {
    enum AnimatorError: Error {
        case snapshotError(message: String)
        case unknownError(message: String)
        case programmingError(message: String)
    }

    public typealias CompletionTask = () -> Void
    
    /// A non-destructive animator.
    ///
    public class Animator {
        
        /// Initialise an animator with a scene, and optional guidance parameters.
        /// - Parameters:
        ///   - scene: The scene of views we wish to animate
        ///   - guidance: Optional animation guidance parameters to adjustf the animation.
        required public init?(scene: Scene, guidance: [TransitionGuidance]) {
            self.scene = scene
            self.stage = scene.stage
            self.guidance = guidance
            
            /// Create layers from the concrete views in the scene.
            /// Layers contain snapshot representations of the concrete views that take part in the transition.
            /// Layers also contain information that informs and assists the animator, such as end positions or animatable constraints.
            
            guard let baseLayerFrom = AnimatableLayer.makeBaseLayer(forSide: .from, in: scene),
                  let baseLayerTo = AnimatableLayer.makeBaseLayer(forSide: .to, offset: scene.morphingViewDelta, in: scene),
                  let portalLayer = PortalLayer.makePortal(for: scene) else { return nil }
            self.baseLayerFrom = baseLayerFrom
            self.baseLayerTo = baseLayerTo
            self.portalLayer = portalLayer
            
            /// Right now these are not used. Ideally they will be used for transforming multiple assets in formation.
            self.exitingLayerAcetate = AcetateLayer.makeExitingLayerAcetate(in: scene, portalLayer: portalLayer)
            self.enteringLayerAcetate = AcetateLayer.makeEnteringLayerAcetate(in: scene, portalLayer: portalLayer)
            
            if portalLayer.growthDirection != .static {
                self.blurLayer = EffectLayer.makeBlurLayer(style: .regular, in: scene)
            }
            // MARK: - Build Layer Hierarchy
            
            /// A portal is something we "pass through" to reach the end state of the transition.
            /// It's like an FPV drone flying through a window, or what you see when passing through a portal in the game "Portal".
            ///
            /// A portal view masks the views within it, but the views within it are constrained to the portal's _superview_.
            /// This allows for animated view masking by utilising the auto layout system, without needing to drop down to
            /// less the abstract `CAAnimation` and frame based approach, which results in more complex code.
            ///
            
            // temporarly moving this from static to all cases:
            self.baseLayerTo.content.alpha = .zero
            self.baseLayerFrom.content.alpha = .one
            
            switch portalLayer.growthDirection {
                
            // There is no portal effect. Only morph effects occur in this animation.
            case .static:
                stage.addSubview(baseLayerFrom.content)
                stage.addSubview(self.portalLayer.content)
                self.portalLayer.addContent(baseLayerTo.content)
                
            // The size of the portal expands through the course of the animation.
            // This is usually used in a `Morph.Direction.forward` direction.
            case .expanding:
                stage.addSubview(baseLayerFrom.content)
                if let blurLayer = self.blurLayer {
                    stage.addSubview(blurLayer.content)
                }
                self.portalShadowLayer = AccessoryLayer.makeShadow(attachedTo: self.portalLayer.content, in: scene)
                guard let portalShadowLayer = portalShadowLayer else { return nil }
                stage.addSubview(portalShadowLayer.content)
                stage.addSubview(self.portalLayer.content)
                self.portalLayer.addContent(baseLayerTo.content)
                
            // The size of the portal contracts through the course of the animation.
            // This is usually used in a `Morph.Direction.backward` direction.
            case .contracting:
                stage.addSubview(baseLayerTo.content)
                if let blurLayer = self.blurLayer {
                    stage.addSubview(blurLayer.content)
                }
                self.portalShadowLayer = AccessoryLayer.makeShadow(attachedTo: self.portalLayer.content, in: scene)
                guard let portalShadowLayer = portalShadowLayer else { return nil }
                stage.addSubview(portalShadowLayer.content)
                stage.addSubview(self.portalLayer.content)
                self.portalLayer.addContent(baseLayerFrom.content)
            }
            
            // Let's do a layout pass before...
            stage.setNeedsLayout()
            stage.layoutIfNeeded()
            
            self.morphingLayers = scene.morphingViews.compactMap { try? AnimatableLayer.makeMorphingLayer(from: $0, in: scene) }
            self.exitingLayers = scene.exitingViews.compactMap {  try? AnimatableLayer.makeExitingLayer(from: $0, in: scene) }
            self.enteringLayers = scene.enteringViews.compactMap { try? AnimatableLayer.makeEnteringLayer(from: $0, in: scene) }
            
            // Make sure nothing went wrong...
            
            guard
                self.morphingLayers.count == scene.morphingViews.count,
                self.exitingLayers.count == scene.exitingViews.count,
                self.enteringLayers.count == scene.enteringViews.count else {
                preconditionFailure("Failure to successfully replicate one or more dynamic views.")
                return nil
            }
          
            describe(scene)
            //TODO: This check needs to be recursive, as the view may be added to a subview.
           // precondition(scene.baseViews.to.superview == stage && scene.baseViews.from.superview == stage,
            //             "Both the 'from' and 'to' views must be added to the stage view prior to initializing the animator.")
        }
        
        func describe(_ scene: Scene) {
            print(
            """

            ############# Scene ##############
            stage:\t\(self.frameInWindow(view: stage))
            fromView:\t\(self.frameInWindow(view: scene.baseViews.from))
            toView:\t\(self.frameInWindow(view: scene.baseViews.to))
            portalFrom:\t\(self.portalLayer.currentPlacement)
            portalTo:\t\(self.portalLayer.endPlacement)
            """
            )
        }
        
        func frameInWindow(view: UIView) -> CGRect {
            guard let window = view.window else { return .null }
            return view.convert(view.bounds, to: view.window)
        }
        
        public func animate() throws {
            prepare()
            addAnimations()
            // Decide on a "master animator" which we'll use as the source of truth for the animation timing.
            guard let masterAnimator = portalLayer.growthDirection == .static ? baseLayerTo.animator : portalLayer.animator else {
                fatalError()
            }
            masterAnimator.addCompletion { position in
                self.cleanUp(stopAnimators: position == .end)
            }
            DispatchQueue.main.async {
                self.animators.forEach { $0.startAnimation() }
            }
            
        }
        /// Any closures to be called (on the main thread) directly after the transition ends.
        ///
        /// You can use this to sequence animations.
        public var completionTasks = [CompletionTask]()
        
        private func prepare() {
            baseLayerFrom.constraints.activate()
            baseLayerTo.constraints.activate()
            portalLayer.constraints.activate()
            portalShadowLayer?.constraints.activate()
            
            switch portalLayer.growthDirection {
            case .expanding:
                blurLayer?.isActive = false
            case .contracting:
                blurLayer?.isActive = true
            default: break
            }
            blurLayer?.constraints.activate()
            
            if let portalShadowLayer = portalShadowLayer {
                portalShadowLayer.content.alpha = .zero
            }
            switch scene.animationDirection {
            case .forward:
                stage.addSubview(exitingLayerAcetate.content)
                portalLayer.addContent(enteringLayerAcetate.content)
            case .reverse:
                stage.addSubview(enteringLayerAcetate.content)
                portalLayer.addContent(exitingLayerAcetate.content)
            }
            
            exitingLayerAcetate.constraints.activate()
            exitingLayerAcetate.applyTransform(.start)
            
            enteringLayerAcetate.constraints.activate()
            enteringLayerAcetate.applyTransform(.start)
            
            exitingLayers.forEach {
                exitingLayerAcetate.addContent($0.content)
                $0.constraints.activate()
                $0.content.alpha = .one
            }
            
            morphingLayers.forEach {
                portalLayer.addContent($0.content)
                $0.constraints.activate()
                $0.content.from?.alpha = .one
                $0.content.to?.alpha = .zero
            }
            
            enteringLayers.forEach {
                enteringLayerAcetate.addContent($0.content)
                $0.constraints.activate()
                $0.content.alpha = .zero
            }

            stage.setNeedsLayout()
            stage.layoutIfNeeded()
            
            //enteringLayerAcetate.applyFocus()
            //exitingLayerAcetate.applyFocus()
        }

        private func makeAnimator() -> UIViewPropertyAnimator {
            let timingCurve = TimingProvider()
            let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingCurve)
            return animator
        }
        

        // TODO: Refactor this method.
        private func addAnimations() {
            if scene.animationDirection == .reverse {
                baseLayerFrom.animator = makeAnimator()
                baseLayerFrom.animator?.addAnimations {
                    self.baseLayerFrom.content.alpha = .zero
                }
            }
            
            baseLayerTo.animator = makeAnimator()
            baseLayerTo.animator?.addAnimations {
                
                // Fade the base layer into view if we're not using a portal effect
               // if self.portalLayer.growthDirection == .static {
         
                self.baseLayerTo.content.alpha = .one
                
                // If the base layer has an end placement, animate to it
                if let endPlacement = self.baseLayerTo.endPlacement {
                    self.baseLayerTo.constraints.placement = endPlacement
                }
                
            }
            
            if let endPlacement = self.portalLayer.endPlacement {
                portalLayer.animator = makeAnimator()
                portalLayer.animator?.addAnimations {
                    self.portalLayer.constraints.placement = endPlacement
                    self.portalLayer.content.superview?.layoutIfNeeded()
                }
            }
            
            if let portalShadowLayer = portalShadowLayer {
                portalShadowLayer.animator = makeAnimator()
                portalShadowLayer.animator?.addAnimations {
                    
                    /// `UIView` animations are nestable. How cool is that?!
                    /// 
                    /// You can nest animations within an outer animation block, the inner animations will
                    /// occur over the duration and timing curve of the outer animation. This includes situations where
                    /// the outer animation is being controlled via a percent driven animation.
                    ///

                    UIView.animateKeyframes(withDuration: .zero, delay: .zero, options: []) {
                        UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 0.33) {
                            portalShadowLayer.content.alpha = .one
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33) {
                            portalShadowLayer.content.alpha = .zero
                        }
                    }
                }
            }
          
            if let blurLayer = blurLayer {
                blurLayer.animator = makeAnimator()
                blurLayer.animator?.addAnimations {
                    switch self.portalLayer.growthDirection {
                    case .expanding:
                        blurLayer.isActive = true
                    case .contracting:
                        blurLayer.isActive = false
                    default: break
                    }
                }
            }
            
            enteringLayerAcetate.animator = makeAnimator()
            enteringLayerAcetate.animator?.addAnimations({
                self.enteringLayerAcetate.applyTransform(.end)
            })

            exitingLayerAcetate.animator = makeAnimator()
            exitingLayerAcetate.animator?.addAnimations({
                self.exitingLayerAcetate.applyTransform(.end)
            })
           
            for layer in morphingLayers {
                if let endPlacement = layer.endPlacement {
                    layer.animator = makeAnimator()
                    layer.animator?.addAnimations({
                        layer.constraints.placement = endPlacement
                        layer.content.superview?.layoutIfNeeded()
                    })
                }
            }
            
            for layer in exitingLayers {
                if let endPlacement = layer.endPlacement {
                    layer.animator = makeAnimator()
                    layer.animator?.addAnimations {
                        layer.constraints.placement = endPlacement
                        layer.content.superview?.layoutIfNeeded()
                    }
                    
                    layer.animator?.addAnimations {
                        UIView.animateKeyframes(withDuration: .zero, delay: .zero, options: []) {
                            UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 0.3) {
                                layer.content.alpha = .zero
                            }
                        }
                    }
                }
            }
            
            for layer in enteringLayers {
                if let endPlacement = layer.endPlacement {
                    layer.animator = makeAnimator()
                    layer.animator?.addAnimations {
                        layer.constraints.placement = endPlacement
                        layer.content.superview?.layoutIfNeeded()
                    }
                }
                layer.animator?.addAnimations {
                    UIView.animateKeyframes(withDuration: .zero, delay: .zero, options: []) {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
                            layer.content.alpha = .one
                        }
                    }
                }
            }
        }
        
        private func cleanUp(stopAnimators: Bool = false) {
            if stopAnimators {
                animators.forEach { $0.stopAnimation(true) }
            }
            
            scene.baseViews.from.removeFromSuperview()
            baseLayerFrom.content.removeFromSuperview()
            baseLayerTo.content.removeFromSuperview()
            portalLayer.content.removeFromSuperview()
            portalShadowLayer?.content.removeFromSuperview()
            enteringLayerAcetate.content.removeFromSuperview()
            exitingLayerAcetate.content.removeFromSuperview()
            blurLayer?.content.removeFromSuperview()
            morphingLayers.forEach { $0.content.removeFromSuperview() }
            
            completionTasks.forEach { $0() }
            scene.baseViews.to.alpha = .one
        }

        // MARK: - Private properties
        
        private var duration: TimeInterval { scene.animationDuration }
        private var stage: UIView
        private var scene: Scene
        private var guidance: [TransitionGuidance]
        
        private var direction: Direction { scene.animationDirection }
        
        private var layers: [MorphLayerAnimatable] {
            var layers: [MorphLayerAnimatable] = [baseLayerFrom, baseLayerTo, exitingLayerAcetate, enteringLayerAcetate, portalLayer] + morphingLayers + exitingLayers + enteringLayers
            if let blurLayer = blurLayer {
                layers.append(blurLayer)
            }
            return layers
        }
        
        private var animators: [UIViewPropertyAnimator] {
            layers.compactMap { $0.animator }
        }
        private var baseLayerFrom: AnimatableLayer
        private var baseLayerTo: AnimatableLayer
        private var exitingLayerAcetate: AcetateLayer
        private var enteringLayerAcetate: AcetateLayer
       
        private var morphingLayers: [AnimatableLayer]
        private var exitingLayers: [AnimatableLayer]
        private var enteringLayers: [AnimatableLayer]

        private var blurLayer: EffectLayer?
        private var portalLayer: PortalLayer
        private var portalShadowLayer: AccessoryLayer?
    }
}
