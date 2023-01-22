//
//  CommonLiterals.swift
//

import Foundation
import CoreGraphics

/// Adds commonly used string literals to the String type.
extension String {
    
    /// An empty string literal. Equilivent to "".
    ///
    /// Example usage:
    /// ```
    ///    let myString = searchBar.text ?? .empty
    /// ```
    public static let empty: String = ""
    
    /// A string literal for a space character. Equilivent to " ".
    ///
    /// Example usage:
    /// ```
    ///    let myString = user.firstName + .space + user.lastName
    /// ```
    public static let space: String = " "
}

/// Adds a `.one` value as a static property to the `CGFloat` type.
/// This is as a complement to the Swift provided `.zero`. and is useful when dealing with values represented by unit intervals (numbers between 0.0 and 1.0).
extension CGFloat {
    
    /// The CGFloat value 1.0
    ///
    /// Example usage:
    /// ```
    ///    let alpha: CGFloat = viewIsVisible ? .one : .zero
    /// ```
    /// ```
    ///    let constraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: .one, constant: .zero)
    /// ```
    public static let one: CGFloat = 1.0
}
