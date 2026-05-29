//
//  NamedUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A generic unit implementation representing a measurement unit associated with a specific compile-time dimension type.
public struct NamedUnit<Dim: DimensionProtocol>: Unit {
    /// The compile-time dimension type associated with this unit.
    public typealias Dimension = Dim
    
    /// The symbol representing the unit, e.g. `"m"`.
    public let symbol: String
    
    /// The underlying physical dimension of this unit.
    public let dimension: PhysicalDimension
    
    /// The unit converter used to transform values of this unit to and from base units.
    public let converter: any UnitConverter
    
    /// Initializes a new unit with a symbol, underlying physical dimension, and converter.
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
    }
}
