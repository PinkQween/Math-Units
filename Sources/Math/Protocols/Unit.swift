//
//  Unit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A protocol representing a type-level identifier for a physical dimension.
/// Conforming types provide the underlying runtime `PhysicalDimension` value.
public protocol DimensionProtocol {
    /// The runtime `PhysicalDimension` value represented by this type.
    static var dimension: PhysicalDimension { get }
}

/// A protocol representing a unit of measurement.
///
/// A unit has a symbol (e.g. `"m"`), a physical dimension (e.g. `PhysicalDimension.length`),
/// and a converter to transform values to/from the base unit.
public protocol MathUnit: Sendable {
    /// The compile-time dimension type associated with this unit.
    associatedtype Dimension: DimensionProtocol
    
    /// The symbol representing the unit, e.g. `"m"`.
    var symbol: String { get }
    
    /// The underlying physical dimension of this unit.
    var dimension: PhysicalDimension { get }
    
    /// The unit converter used to transform values of this unit to and from base units.
    var converter: any UnitConverter { get }
}

/// Multiplies two units, returning a new `CompositeUnit` whose dimension is the sum of their exponents.
public func * <U1: MathUnit, U2: MathUnit>(lhs: U1, rhs: U2) -> CompositeUnit {
    let newDimension = lhs.dimension * rhs.dimension
    let newSymbol = "(\(lhs.symbol)*\(rhs.symbol))"
    let lhsCoeff = lhs.converter.convertToBase(1.0)
    let rhsCoeff = rhs.converter.convertToBase(1.0)
    let compositeCoeff = lhsCoeff * rhsCoeff
    return CompositeUnit(
        symbol: newSymbol,
        dimension: newDimension,
        converter: LinearConverter(coefficient: compositeCoeff)
    )
}

/// Divides two units, returning a new `CompositeUnit` whose dimension is the difference of their exponents.
public func / <U1: MathUnit, U2: MathUnit>(lhs: U1, rhs: U2) -> CompositeUnit {
    let newDimension = lhs.dimension / rhs.dimension
    let newSymbol = "(\(lhs.symbol)/\(rhs.symbol))"
    let lhsCoeff = lhs.converter.convertToBase(1.0)
    let rhsCoeff = rhs.converter.convertToBase(1.0)
    let compositeCoeff = lhsCoeff / rhsCoeff
    return CompositeUnit(
        symbol: newSymbol,
        dimension: newDimension,
        converter: LinearConverter(coefficient: compositeCoeff)
    )
}
