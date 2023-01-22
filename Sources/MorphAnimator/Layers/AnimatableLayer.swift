//
//  AnimatableLayer.swift
//

import UIKit

extension Morph {
    /// An animatable layer.
    ///
    ///  This is the most common layer type. It is used for the base, morphing, entering, and exiting views.
    class AnimatableLayer: MorphAnimationLayer, MorphLayerEndPositionable {
        
        required init(content: Asset, constraints: ConstraintSet, scene: Scene) {
            self.content = content
            self.constraints = constraints
        }

        typealias ContentType = Asset
        
        func cleanUp() {
            content.removeFromSuperview()
        }
        
        // MARK: - Factory methods
        //TODO: Change to throws
        static func makeBaseLayer(forSide side: Side, offset: CGVector = .zero, in scene: Scene) -> AnimatableLayer? {
            let originalView: UIView
            switch side {
            case .from:
                originalView = scene.baseViews.from
            case .to:
                originalView = scene.baseViews.to
            }
            
            guard let asset = Self.snapshotBaseView(side: side, in: scene) else { return nil }
            let position = Morph.Position(start: originalView.center.translate(offset), end: originalView.center)
            let constraints = ConstraintSet(constrain: asset, at: position.start, to: originalView.bounds.size, inView: scene.stage)
            let endPlacement = Placement(at: position.end, size: originalView.bounds.size)
            asset.translatesAutoresizingMaskIntoConstraints = false
            let layer = AnimatableLayer(content: asset, constraints: constraints, scene: scene)
            layer.endPlacement = endPlacement
            return layer
        }
        
        static func makeExitingLayer(from view: UIView, in scene: Scene) throws -> AnimatableLayer {
            let tempFlow = Flow(translation: .zero, scale: 1.0)
            let side: Side = .from
            let positions = try Self.positioning(of: view, flow: tempFlow, side: side, within: scene.stage)
            let snapshot = Self.replicate(view)
            let asset = Asset(from: snapshot, side: side)
            
            let constraints = ConstraintSet(constrain: asset, at: positions.start, to: view.bounds.size, inView: scene.stage)
            let endPlacement = Placement(at: positions.end, size: view.bounds.size)

            asset.translatesAutoresizingMaskIntoConstraints = false
            let layer = AnimatableLayer(content: asset, constraints: constraints, scene: scene)
            layer.endPlacement = endPlacement
            return layer
        }
        
        static func makeEnteringLayer(from view: UIView, in scene: Scene) throws -> AnimatableLayer {
            let tempFlow = Flow(translation: .zero, scale: 1.0)
            let side: Side = .to
            let positions = try Self.positioning(of: view, flow: tempFlow, side: side, within: scene.stage)
            let snapshot = Self.replicate(view)
            let asset = Asset(from: snapshot, side: side)
            
            let constraints = ConstraintSet(constrain: asset, at: positions.start, to: view.bounds.size, inView: scene.stage)
            let endPlacement = Placement(at: positions.end, size: view.bounds.size)

            asset.translatesAutoresizingMaskIntoConstraints = false
            let layer = AnimatableLayer(content: asset, constraints: constraints, scene: scene)
            layer.endPlacement = endPlacement
            return layer
        }
        
        static func makeMorphingLayer(from viewPair: Morph.ViewPair, in scene: Scene) throws -> AnimatableLayer {
            let positions = try Self.positioning(of: viewPair, within: scene.stage)
            let snapshotPair = Self.replicate(viewPair)
          
            let asset = Asset(snapshotPair: snapshotPair)
            let constraints = ConstraintSet(constrain: asset, at: positions.start, to: viewPair.from.bounds.size, inView: scene.stage)
            let endPlacement = Placement(at: positions.end, size: viewPair.to.bounds.size)
        
            asset.translatesAutoresizingMaskIntoConstraints = false
            let layer = AnimatableLayer(content: asset, constraints: constraints, scene: scene)
            layer.endPlacement = endPlacement
            return layer
        }
        
        static func replicate(_ views: Morph.ViewPair) -> Morph.SnapshotPair {
            Morph.SnapshotPair(views.map { Self.replicate($0) })
        }
        
        static func replicate(_ view: UIView) -> UIView {
            view.isHidden = false
            guard let snapshot = view.snapshotView(afterScreenUpdates: true) else { fatalError() }
            return snapshot
        }
        
        // MARK: - Internal properties
        
        var content: Asset
        var constraints: ConstraintSet
        var endPlacement: Placement?
        var animator: UIViewPropertyAnimator?
        
        var currentPlacement: Morph.Placement { constraints.placement }
    }
}
