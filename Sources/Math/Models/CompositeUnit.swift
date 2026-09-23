//
//  CompositeUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A unit representing a derived, dynamically-created combination of other units.
///
/// Multiplying quantities (or units) produces a `CompositeUnit`. For example,
/// multiplying two meters yields `(m*m)` with an area dimension. Dividing
/// quantities produces the typed ``RatioUnit`` instead, so the numerator and
/// denominator units stay on the correct sides.
///
/// Composite units carry no specific compile-time dimension: their type-level
/// dimension is always ``MathDimension/unknown``. You typically encounter them
/// as the result of multiplication and then convert the result into a named
/// unit when you know what it should be:
///
/// ```swift
/// let area = width * height          // Quantity<CompositeUnit>, (m*m)
/// let inSquareFeet = area.converted(to: Units.squareFoot)
/// ```
public struct CompositeUnit: MathUnit, CustomStringConvertible {
    /// The compile-time dimension type associated with this unit, defaults to `unknown`.
    public typealias Dimension = MathDimension.unknown

    /// The symbol representing the composite unit, e.g. `"(m/s)"`.
    public let symbol: String

    /// The underlying physical dimension of this unit.
    public let dimension: PhysicalDimension

    /// The unit converter used to transform values of this unit to and from base units.
    public let converter: any UnitConverter

    /// Composite units always place their symbol after the value.
    public var symbolPosition: SymbolPosition { .suffix }

    /// Creates a composite unit from a symbol, dimension, and converter.
    ///
    /// - Parameters:
    ///   - symbol: The textual representation, e.g. `"(m/s)"`.
    ///   - dimension: The physical dimension of the combined unit.
    ///   - converter: How values convert to and from the base unit.
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
    }

    /// The base unit for this symbol: the same symbol and dimension with an
    /// identity ``LinearConverter``.
    public var base: CompositeUnit {
        CompositeUnit(symbol: symbol, dimension: dimension, converter: LinearConverter(coefficient: 1.0))
    }

    /// The composite unit's symbol, e.g. `"(m/s)"`.
    public var description: String {
        return symbol
    }
}

extension CompositeUnit: Equatable {
    /// Two composite units are equal when they share a symbol and dimension.
    public static func == (lhs: CompositeUnit, rhs: CompositeUnit) -> Bool {
        lhs.symbol == rhs.symbol &&
        lhs.dimension == rhs.dimension
    }
}

extension CompositeUnit: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(dimension)
    }
}