//
//  ConstraintSet.swift
//

import UIKit

extension Morph {
    /// Stores references to constraints that can be animated. Can store position or size constraints.
    struct ConstraintSet {
        
        /// Initialize a constraint set that constrains one asset to another.
        /// - Parameters:
        ///   - view: The parent view
        ///   - otherView: The child view
        ///   - enable: Whether the constraints should be enabled immediately.
        ///
        /// Do not enable constraints unless the views are already part of the same view hierarchy!
        init(constrain asset: UIView, to otherAsset: UIView, enable: Bool) {
            asset.translatesAutoresizingMaskIntoConstraints = false
            self.x = asset.centerXAnchor.constraint(equalTo: otherAsset.centerXAnchor)
            self.y = asset.centerYAnchor.constraint(equalTo: otherAsset.centerYAnchor)
            self.width = asset.widthAnchor.constraint(equalTo: otherAsset.widthAnchor)
            self.height = asset.heightAnchor.constraint(equalTo: otherAsset.heightAnchor)
            
            if enable { self.activate() }
        }
        
        /// Initialize a constraint set that constrains one asset to the reference view, with specific size and location set.
        /// - Parameters:
        ///   - asset: Asset view comprising of one or two snapshots.
        ///   - center: The initial center point of the asset within the reference view
        ///   - size: The initial size of the asset
        ///   - referenceView: Reference view, aka the stage.
        ///   - enable: Whether the constraints should be enabled immediately.
        ///
        /// Do not enable constraints unless the views are already part of the same view hierarchy!
        init(constrain asset: UIView, at center: CGPoint, to size: CGSize, inView referenceView: UIView, enable: Bool = false) {
            asset.translatesAutoresizingMaskIntoConstraints = false
            
            self.x = asset.centerXAnchor.constraint(equalTo: referenceView.leadingAnchor, constant: center.x)
            self.y = asset.centerYAnchor.constraint(equalTo: referenceView.topAnchor, constant: center.y)
            
            self.width = asset.widthAnchor.constraint(equalToConstant: size.width)
            self.height = asset.heightAnchor.constraint(equalToConstant: size.height)
            
            if enable { self.activate() }
        }
        
        private let x: NSLayoutConstraint
        private let y: NSLayoutConstraint
        private let width: NSLayoutConstraint
        private let height: NSLayoutConstraint
        
        var placement: Placement {
            set {
                x.constant = newValue.x
                y.constant = newValue.y
                width.constant = newValue.width
                height.constant = newValue.height
            }
            get {
                Placement(x: x.constant, y: y.constant, width: width.constant, height: height.constant)
            }
        }
        
        var layoutConstraints: [NSLayoutConstraint] { [x, y, width, height] }
        
        var isActive: Bool { layoutConstraints.allSatisfy { $0.isActive } }
        
        func activate() { layoutConstraints.forEach { $0.isActive = true } }
    }
}
