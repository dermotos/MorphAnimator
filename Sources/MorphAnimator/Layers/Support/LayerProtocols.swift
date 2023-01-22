//
//  LayerProtocols.swift
//

import UIKit

protocol MorphLayerAnimatable {
    var animator: UIViewPropertyAnimator? { get set }
}

protocol MorphLayerEndPositionable {
    var endPlacement: Morph.Placement? { get set }
    var currentPlacement: Morph.Placement { get }
}

protocol MorphLayerTransformable {
    var transform: Morph.Transform<CGAffineTransform> { get set }
    var focus: CGPoint { get set }
    
    func applyTransform(_ transformPosition: Morph.Transform<CGAffineTransform>.Position)
    
    func applyFocus()
}
