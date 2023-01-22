//
//  GeometryHelpers.swift
//

import Foundation
import UIKit

/// Adds convenience properties and functions that are used by the MorphAnimator.
extension UIView {

///     Get absolute anchor for the given view.
///     Anchors on a CALayer are usually expressed in unit coordinate space. e.g.: the centre of a view is [0.5, 0.5]
///     This property provides the ability to read the anchor point on the underlying layer using the view's coordinate space. For example,
///     if the view's bounds are [100, 100], and the underlying layer's anchor
///     is at its default position of [0.5, 0.5], this property will return [50, 50].
///
///     Given that:
///     ```
///     Size of view (sV)
///     Layer anchor (lA)
///     View anchor  (vA)
///
///     vA = sV * lA
///     sV = vA * lA
///     lA = vA / sV
///     ```
    var viewAnchorPoint: CGPoint {
        let unitAnchor = layer.anchorPoint
        let viewXAnchor = bounds.width * unitAnchor.x
        let viewYAnchor = bounds.height * unitAnchor.y
        return CGPoint(x: viewXAnchor, y: viewYAnchor)
    }
    
    /// Change the anchor point to a new layer anchor point using the unit coordinate space (between [0,0] and [1,1])
    /// - Parameters:
    ///   - toLayerAnchor: The new layer anchor point (between [0,0] and [1,1])
    ///   - movingView: Move the view and keep the anchor at the same position, or move the anchor and keep the view at the same position.
    func setAnchorPoint(toLayerAnchor layerAnchor: CGPoint, movingView: Bool) {
        if movingView {
            layer.anchorPoint = layerAnchor
        } else {
            var newPoint = CGPoint(x: bounds.size.width * layerAnchor.x, y: bounds.size.height * layerAnchor.y)
            var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            
            newPoint = newPoint.applying(transform)
            oldPoint = oldPoint.applying(transform)
            
            var position = layer.position
            
            position.x -= oldPoint.x
            position.x += newPoint.x
            
            position.y -= oldPoint.y
            position.y += newPoint.y
            
            layer.position = position
            layer.anchorPoint = layerAnchor
        }
    }
    
    /// Change the anchor point to a new view anchor point using the views coordinate space.
    /// - Parameters:
    ///   - toViewAnchor: The new view anchor point (between [0,0] and [1,1])
    ///   - movingView: Move the view and keep the anchor at the same position, or move the anchor and keep the view at the same position.
    func setAnchorPoint(toViewAnchor viewAnchor: CGPoint, movingView: Bool) {
        let layerAnchor = convertToLayerAnchor(viewAnchor)
        setAnchorPoint(toLayerAnchor: layerAnchor, movingView: movingView)
    }

    /// Convert a view anchor (a set of coordinates that represent the anchor point within the view coordinate space) to a layer anchor (the normal way anchors are defined)
    /// - Parameter viewAnchor: The view anchor
    /// - Returns: The resulting layer anchor (between [0,0] and [1,1])
    func convertToLayerAnchor(_ viewAnchor: CGPoint) -> CGPoint {
        let layerAnchorX = viewAnchor.x / bounds.width
        let layerAnchorY = viewAnchor.y / bounds.height
        let layerAnchor = CGPoint(x: layerAnchorX, y: layerAnchorY)
        return layerAnchor
    }
    
    /// Convert a layer anchor (the normal way anchors are defined) to a view anchor (a set of coordinates that represent the anchor point within the view coordinate space)
    /// - Parameter layerAnchor: The layer anchor
    /// - Returns: The resulting view anchor (within the coordinate space of the current view).
    func convertToViewAnchor(_ layerAnchor: CGPoint) -> CGPoint {
        let viewAnchorX = layerAnchor.x * bounds.width
        let viewAnchorY = layerAnchor.y * bounds.height
        let viewAnchor = CGPoint(x: viewAnchorX, y: viewAnchorY)
        return viewAnchor
    }
}

/// Adds convenience properties and functions that are used by the MorphAnimator.
extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    func translate(_ vector: CGVector, reverse: Bool = false) -> CGPoint {
        if reverse {
            return CGPoint(x: self.x - vector.dx, y: self.y - vector.dy)
        } else {
            return CGPoint(x: self.x + vector.dx, y: self.y + vector.dy)
        }
       
    }
}

/// Adds convenience properties and functions that are used by the MorphAnimator.
extension CGRect {
    enum Axis {
        case horizontal
        case vertical
    }
    
    func offset(by point: CGPoint) -> CGRect {
        self.offsetBy(dx: point.x, dy: point.y)
    }
    
    var majorAxis: Axis {
        height > width ? .vertical : .horizontal
    }
    
    var minorAxis: Axis {
        majorAxis == .horizontal ? .vertical : .horizontal
    }
    
    func axisSize(_ axis: Axis) -> CGFloat {
        axis == .vertical ? height : width
    }
    
    /// Width to height aspect ratio.
    var aspectRatio: CGFloat {
        self.width / self.height
    }
    
    /** The coordinates of this rectangles center */
    var center: CGPoint {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    /** The x-coordinate of this rectangles center
    - note: Acts as a settable midX
    - returns: The x-coordinate of the center
     */
    var centerX: CGFloat {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }
    
    /** The y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
}

extension CGVector: Comparable {
    public static func < (lhs: CGVector, rhs: CGVector) -> Bool {
        (lhs.dx + lhs.dy) < (rhs.dx + rhs.dy)
    }
    
    public func applyingMultiplier(_ multiplier: CGFloat) -> CGVector {
        CGVector(dx: self.dx * multiplier, dy: self.dx * multiplier)
    }
}
