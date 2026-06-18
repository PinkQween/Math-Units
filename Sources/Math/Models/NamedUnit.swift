//
//  NamedUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A generic unit implementation representing a measurement unit associated with a specific compile-time dimension type.
public struct NamedUnit<Dim: DimensionProtocol>: MathUnit {
    /// The compile-time dimension type associated with this unit.
    public typealias Dimension = Dim
    
    /// The symbol representing the unit, e.g. `"m"`.
    public let symbol: String
    
    /// The underlying physical dimension of this unit.
    public let dimension: PhysicalDimension
    
    /// The unit converter used to transform values of this unit to and from base units.
    public let converter: any UnitConverter
    
    /// The position where the unit symbol should be placed when formatting.
    public let symbolPosition: SymbolPosition
    
    /// Initializes a new unit with a symbol, underlying physical dimension, and converter.
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter, symbolPosition: SymbolPosition? = nil) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
        self.symbolPosition = symbolPosition ?? (dimension == .currency ? .prefix : .suffix)
    }
    
    public var base: NamedUnit<Dim> {
        NamedUnit(symbol: symbol, dimension: dimension, converter: LinearConverter(coefficient: 1.0), symbolPosition: symbolPosition)
    }
}

extension NamedUnit: Equatable {
    public static func == (lhs: NamedUnit<Dim>, rhs: NamedUnit<Dim>) -> Bool {
        lhs.symbol == rhs.symbol &&
        lhs.dimension == rhs.dimension
    }
}

extension NamedUnit: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(dimension)
    }
}
