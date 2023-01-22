//
//  Transform.swift
//

import Foundation

extension Morph {
    /// Represents a transform from a start and end position on a type `T` , where `T` is usually a geometric property.
    ///
    /// Examples for use include `CGPoint`, `CGSize`, `CGAffineTransform`.
     class Transform<T> {
         enum Position {
            case start
            case end
        }
        
         init(start: T, end: T) {
            self.start = start
            self.end = end
        }
        
         var start: T
         var end: T
        
         func transform(for position: Position) -> T {
            switch position {
            case .start:
                return start
            case .end:
                return end
            }
        }
    }

    /// Allow iteration of the start and end values.
    ///
     struct TransformIterator<T>: IteratorProtocol {
         typealias Element = T
        
         init(_ transform: Transform<T>) {
            self.transform = transform
        }
        
         mutating func next() -> T? {
            defer { index += 1 }
                switch index {
                case 0: return transform.start
                case 1: return transform.end
                default: return nil
            }
        }
        
        private let transform: Transform<T>
        private var index = 0
    }
}

/// Adds support for creating a transform from a two element array, and iterating over a Transform tyoe.
///
extension Morph.Transform: Sequence {
     convenience init?(_ array: [T]) {
        if array.count == 2 {
            self.init(start: array[0], end: array[1])
        } else {
            assertionFailure("Attempted to create a Transform object with an array of \(array.count) elements.")
            return nil
        }
    }
    
    func makeIterator() -> Morph.TransformIterator<T> {
        Morph.TransformIterator(self)
    }
    
     var count: Int { 2 }
     var underestimatedCount: Int { count }
    
     subscript(index: Int) -> T {
        switch index {
        case 0: return start
        case 1: return end
        default:
            assertionFailure("Index out of bounds. Transform object has a maxiumum of 2 elements (start and end)")
            fatalError()
        }
    }
}
