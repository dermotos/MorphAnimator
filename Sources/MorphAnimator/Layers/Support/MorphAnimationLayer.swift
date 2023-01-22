//
//  MorphAnimationLayer.swift
//

import UIKit

protocol MorphAnimationLayer: MorphLayerAnimatable {
    associatedtype ContentType
    
    var content: ContentType { get set }
    var constraints: Morph.ConstraintSet { get set }
   
    init(content: ContentType, constraints: Morph.ConstraintSet, scene: Morph.Scene)
    
    func cleanUp()
}

extension MorphAnimationLayer {
    
    static func snapshotBaseView(side: Morph.Side, in scene: Morph.Scene) -> Morph.Asset? {
        precondition(scene.allAnimatedViews.allSatisfy { !$0.isHidden })
        scene.baseViews.to.alpha = .one
        
        // Hide all animated views first before snapshotting the base view.
        scene.allAnimatedViews.forEach { $0.isHidden = true }
        
        let snapshotImage: UIImage
        switch side {
        case .from:
            guard let image = scene.baseViews.from.coreAnimationSnapshot(layer: .default) else { return nil }
            snapshotImage = image
        case .to:
            guard let image = scene.baseViews.to.coreAnimationSnapshot(layer: .default) else { return nil }
            snapshotImage = image
        }
        
        let snapshotView = UIImageView(image: snapshotImage)

        snapshotView.clipsToBounds = true
        snapshotView.contentMode = .scaleAspectFit
    
        // Revert the concrete counterpart views to their original non-hidden state
        scene.allAnimatedViews.forEach { $0.isHidden = false  }
        return Morph.Asset(from: snapshotView, side: side)
    }
    
    static func add(baseViewSnapshots: Morph.SnapshotPair, to scene: Morph.Scene) {
        // Set the frames of the snapshots to that of their view counterparts
        for elements in zip(scene.baseViews, baseViewSnapshots).map({ (view: $0, snapshot: $1) }) {
            elements.snapshot.frame = elements.view.frame
            scene.stage.addSubview(elements.snapshot)
        }
    }
    
    /// Returns the start and end positioning of a view pair at the beginning and end of the transition.
    static func positioning(of viewPair: Morph.ViewPair, within transitionContainer: UIView) throws -> Morph.Position {
        guard let startPoint = viewPair.from.superview?.convert(viewPair.from.center, to: transitionContainer),
              let endPoint = viewPair.to.superview?.convert(viewPair.to.center, to: transitionContainer) else {
            let errorMessage = "Unable to calculate position of view. Subview is not part of the transitionContainer view hierarchy."
            assertionFailure(errorMessage)
            throw Morph.AnimatorError.programmingError(message: errorMessage)
        }
        return Morph.Transform<CGPoint>(start: startPoint, end: endPoint)
    }
    
    /// Returns the start and end positioning of a view at the beginning and end of the transition.
    static func positioning(of view: UIView, flow: Morph.Flow, side: Morph.Side, within transitionContainer: UIView) throws -> Morph.Position {
        guard let currentPoint = view.superview?.convert(view.center, to: transitionContainer) else {
            let errorMessage = "Unable to calculate position of view. Subview is not part of the transitionContainer view hierarchy."
            assertionFailure(errorMessage)
            throw Morph.AnimatorError.programmingError(message: errorMessage)
        }
        
        switch side {
        case .from:
            let startPoint = currentPoint
            let endPoint = startPoint.translate(flow.translation, reverse: false)
            return Morph.Transform<CGPoint>(start: startPoint, end: endPoint)
        case .to:
            let endPoint = currentPoint
            let startPoint = endPoint.translate(flow.translation, reverse: true)
            return Morph.Transform<CGPoint>(start: startPoint, end: endPoint)
        }
    }
    
    private func makeSnapshot(view: UIView, snapshotLayer: UIView.CASnapshotLayer) -> UIView? {
        //TODO: Confirm this is only used for the base layers
        // More info on why this is necessary for the base layers: https://stackoverflow.com/a/29676207/1418981
        if let image = view.coreAnimationSnapshot(layer: snapshotLayer) {
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
        return nil
    }
}
