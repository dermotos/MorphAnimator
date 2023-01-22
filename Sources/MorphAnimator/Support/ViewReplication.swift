//
//  Replication.swift
//

import Foundation
import UIKit

extension UIView {
    
    func snapshot(scale: CGFloat = .zero, isOpaque: Bool = false, afterScreenUpdates: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, scale)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    enum CASnapshotLayer: Int {
        case `default`, presentation, model
    }
    
    /// Snapshot a layer to a `UIImage`.
    ///
    /// We need to use a graphics context duplication snapshot method for the base layers, as they are already in an animation commit and cannot be snapshotted using the UIReplicantView method.
    ///
    /// This is less performant than the replicant view approach, and results in a `UIImage` rather than a `UIReplicantView`. However, only the base views are replicated in this way, so complexity
    /// remains close to O(n) for the view replication step in the morph animator, regardless of the number of dynamic/morphing views.
    /// More info: https://stackoverflow.com/a/25704861/1418981
    func coreAnimationSnapshot(scale: CGFloat = .zero, isOpaque: Bool = false, layer layerToUse: CASnapshotLayer = .default) -> UIImage? {
        var isSuccess = false
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, scale)
        if let context = UIGraphicsGetCurrentContext() {
            isSuccess = true
            switch layerToUse {
            case .default:
                layer.render(in: context)
            case .model:
                layer.model().render(in: context)
            case .presentation:
                layer.presentation()?.render(in: context)
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return isSuccess ? image : nil
    }
}
