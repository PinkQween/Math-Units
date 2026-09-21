//
//  EmptyConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A ``UnitConverter`` whose output equals its input.
///
/// `EmptyConverter` is the identity conversion. It's useful for units that are
/// defined directly in terms of the base unit—often the base unit itself—or as
/// a placeholder when building up a unit before its real converter is known:
///
/// ```swift
/// let meter = NamedUnit<MathDimension.length>(
///     symbol: "m",
///     dimension: .length,
///     converter: EmptyConverter()
/// )
/// ```
public struct EmptyConverter: UnitConverter {
    /// Creates an identity converter.
    public init() {}

    /// Returns `value` unchanged.
    public func convertToBase(_ value: Double) -> Double {
        value
    }

    /// Returns `value` unchanged.
    public func convertFromBase(_ value: Double) -> Double {
        value
    }
}

extension EmptyConverter: Codable {}