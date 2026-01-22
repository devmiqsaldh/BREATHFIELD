//
//  Clamp+Extensions.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import Foundation

/// Utility extension adding a convenience method to clamp values to a range.
extension Comparable {
    /// Returns `self` limited to the given closed range.
    /// - Parameter range: The inclusive range to clamp into.
    /// - Returns: `range.lowerBound` if `self` is below the range, `range.upperBound` if above, otherwise `self`.
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
