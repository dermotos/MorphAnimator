//
//  Pair.swift
//

import Foundation
import UIKit

extension Morph {
    /// A tuple of two views or snapshots; `from` & `to`
    ///
    /// This class is useful for pairing together two views or snapshots representing the two sides of the transition.
    public class Pair<T> {
        public init(from: T, to: T) {
            self.from = from
            self.to = to
        }
        
        public var from: T
        public var to: T
        
    }

    /// Iterator object for a `Pair`
    public struct PairIterator<T>: IteratorProtocol {
        public typealias Element = T
        
        public init(_ pair: Pair<T>) {
            self.pair = pair
        }
        
        public mutating func next() -> T? {
            defer { index += 1 }
            switch index {
            case 0: return pair.from
            case 1: return pair.to
            default: return nil
            }
        }
        
        private let pair: Pair<T>
        private var index = 0
    }
}

/// Adds support for creating a pair from a two element array, and iterating over a pair tyoe.
extension Morph.Pair: Sequence {
    
    public convenience init(_ array: [T]) {
        precondition(array.count == 2, "A pair can only be initialized from an array of exactly two elements")
        self.init(from: array[0], to: array[1])
    }
    
    public func makeIterator() -> Morph.PairIterator<T> {
        Morph.PairIterator(self)
    }
    
    public var count: Int { 2 }
    public var underestimatedCount: Int { count }
    
    public subscript(index: Int) -> T {
        switch index {
        case 0: return from
        case 1: return to
        default:
            assertionFailure("This is a pair of two items. Only indexes 0 and 1 are valid.")
            fatalError()
        }
    }
}
