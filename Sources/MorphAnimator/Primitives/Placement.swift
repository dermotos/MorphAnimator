//
//  Placement.swift
//

import UIKit

extension Morph {
    
    /// Represents the placement of an asset in a morph animation
    ///
    /// Placement of all assets is via their width, height and the x,y position of the centre point.
    /// Using the centre point and width & height, rather than leading, top, trailing, bottom, or the x/y position of the top left
    /// corner plus width & height allows for modification of the position or size independently.
    struct Placement {
        init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
            self.x = x
            self.y = y
            self.width = width
            self.height = height
        }
        
        init(at position: CGPoint, size: CGSize) {
            self.x = position.x
            self.y = position.y
            self.width = size.width
            self.height = size.height
        }
        
        /// Centre X coordinate
        let x: CGFloat
        /// Centre Y coordinate
        let y: CGFloat
        let width: CGFloat
        let height: CGFloat
    }
}

extension Morph.Placement: CustomStringConvertible {
    var description: String {
        "(\(x - (width / 2)), \(y - (height / 2)), \(width), \(height)"
    }
    
    
}
