//
//  Asset.swift
//

import UIKit

extension Morph {
    /// An asset is a view or pair of views that are animated during the transition. They are created from snapshots of the views of interest.
    class Asset: UIView {
        convenience init(snapshotPair: Pair<UIView>) {
            self.init(from: Pair<UIView?>(from: snapshotPair.from, to: snapshotPair.to))
        }
        
        convenience init(from snapshot: UIView, side: Side) {
            switch side {
            case .from:
                self.init(from: Pair<UIView?>(from: snapshot, to: nil))
            case .to:
                self.init(from: Pair<UIView?>(from: nil, to: snapshot))
            }
        }
        
        private init(from snapshot: Pair<UIView?>) {
            if snapshot.compactMap({ $0 }).isEmpty {
                fatalError("An asset must be initialised with at least one snapshot")
            }
            from = snapshot.from
            to = snapshot.to
            super.init(frame: .zero)
            
            if let clone = from {
                clone.translatesAutoresizingMaskIntoConstraints = false
                addSubview(clone)
                NSLayoutConstraint.activate([
                    clone.centerXAnchor.constraint(equalTo: centerXAnchor),
                    clone.centerYAnchor.constraint(equalTo: centerYAnchor),
                    clone.widthAnchor.constraint(equalTo: clone.heightAnchor, multiplier: clone.bounds.aspectRatio)
                ])
                
                switch clone.bounds.minorAxis {
                case .horizontal:
                    clone.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
                case .vertical:
                    clone.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
                }
            }
            
            if let clone = to {
                clone.translatesAutoresizingMaskIntoConstraints = false
                addSubview(clone)
                NSLayoutConstraint.activate([
                    clone.centerXAnchor.constraint(equalTo: centerXAnchor),
                    clone.centerYAnchor.constraint(equalTo: centerYAnchor),
                    clone.widthAnchor.constraint(equalTo: clone.heightAnchor, multiplier: clone.bounds.aspectRatio)
                ])
                
                switch clone.bounds.minorAxis {
                case .horizontal:
                    clone.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
                case .vertical:
                    clone.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
                }
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private(set) var from: UIView?
        private(set) var to: UIView?
        private var content: UIView? { self.from ?? self.to ?? nil }
        
    }
}
