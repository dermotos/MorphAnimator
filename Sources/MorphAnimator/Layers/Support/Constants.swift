//
//  AnimationContext.swift
//

import Foundation
import UIKit

extension Morph {
    enum Constants {
        enum Stretch {
            static let expansionMultiplier: CGFloat = 1.05
            static let contractionMultiplier: CGFloat = 0.95
        }
        
        enum Flow {
            static let translationMultiplier: CGFloat = 0.3
            static let entryScaling: CGFloat = 0.8
            static let exitScaling: CGFloat = 1.2
        }
        
        enum Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let opacity: Float = 0.6
            static let offset: CGSize = .zero
            static let radius: CGFloat = 60
        }
    }
}
