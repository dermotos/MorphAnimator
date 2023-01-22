//
//  Typealiases.swift
//

import UIKit

/// Namespace to contain types used by the MorphAnimator
extension Morph {

    // MARK: - Internal
    
    typealias ViewPair = Pair<UIView>
    typealias SnapshotPair = Pair<UIView>
    typealias Position = Transform<CGPoint>
    typealias PositionSet = [Position]
    typealias ScaleItem = Transform<CGAffineTransform>
    typealias Scale = Pair<ScaleItem>
    typealias ScaleSet = [Scale]
    typealias ViewCollection = [UIView]
    typealias ViewPairCollection = [ViewPair]
    typealias SnapshotPairCollection = [SnapshotPair]
    typealias SnapshotCollection = [UIView]
}


