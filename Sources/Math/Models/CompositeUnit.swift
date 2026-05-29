//
//  CompositeUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A unit type representing derived or dynamically created composite units (e.g. from multiplication/division).
///
/// Composite units do not enforce a specific statically defined compile-time dimension type and default
/// to the type-level `Dimension.unknown` dimension.
public struct CompositeUnit: Unit {
    /// The compile-time dimension type associated with this unit, defaults to `unknown`.
    public typealias Dimension = Math.Dimension.unknown
    
    /// The symbol representing the composite unit, e.g. `"(m/s)"`.
    public let symbol: String
    
    /// The underlying physical dimension of this unit.
    public let dimension: PhysicalDimension
    
    /// The unit converter used to transform values of this unit to and from base units.
    public let converter: any UnitConverter
    
    /// Initializes a new composite unit with a symbol, underlying physical dimension, and converter.
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
    }
}
