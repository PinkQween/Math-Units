//
//  CompositeUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A unit type representing derived or dynamically created composite units (e.g. from multiplication/division).
///
/// Composite units do not enforce a specific statically defined compile-time dimension type and default
/// to the type-level `MathDimension.unknown` dimension.
public struct CompositeUnit: MathUnit, CustomStringConvertible {
    /// The compile-time dimension type associated with this unit, defaults to `unknown`.
    public typealias Dimension = MathDimension.unknown
    
    /// The symbol representing the composite unit, e.g. `"(m/s)"`.
    public let symbol: String
    
    /// The underlying physical dimension of this unit.
    public let dimension: PhysicalDimension
    
    /// The unit converter used to transform values of this unit to and from base units.
    public let converter: any UnitConverter
    
    /// The position where the unit symbol should be placed when formatting.
    public var symbolPosition: SymbolPosition { .suffix }
    
    /// Initializes a new composite unit with a symbol, underlying physical dimension, and converter.
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
    }
    
    public var base: CompositeUnit {
        CompositeUnit(symbol: symbol, dimension: dimension, converter: LinearConverter(coefficient: 1.0))
    }
    
    public var description: String {
        return symbol
    }
}

extension CompositeUnit: Equatable {
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
