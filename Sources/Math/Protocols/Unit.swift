//
//  Unit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A protocol representing a type-level identifier for a physical dimension.
///
/// Conforming types provide the underlying runtime ``PhysicalDimension`` value.
/// The ``MathDimension`` namespace provides the built-in conforming types, such
/// as ``MathDimension/length`` and ``MathDimension/time``. Because the conforming
/// type is used as a generic parameter, you can attach "this dimension only"
/// constraints to generic code with `where U.Dimension == MathDimension.length`.
///
/// See <doc:CompileTimeSafety> to learn how to use these constraints.
public protocol DimensionProtocol {
    /// The runtime `PhysicalDimension` value represented by this type.
    static var dimension: PhysicalDimension { get }
}

/// The position where a unit's symbol is placed when formatting a quantity.
///
/// * ``SymbolPosition/prefix`` — the symbol comes before the value (e.g. `$10.00`).
/// * ``SymbolPosition/suffix`` — the symbol comes after the value (e.g. `10.00 m`).
///
/// Currency units default to `.prefix`; all other units default to `.suffix`.
public enum SymbolPosition: String, Sendable, Codable {
    /// The symbol appears before the value, like `$10.00`.
    case prefix
    /// The symbol appears after the value, like `10.00 m`.
    case suffix
}

/// A unit of measurement, such as a meter, a second, or a US dollar.
///
/// A unit is the "what" of a measurement. It pairs three pieces of information:
///
/// * ``symbol`` — the textual representation, e.g. `"m"` for meters.
/// * ``dimension`` — the physical property it measures, e.g. ``PhysicalDimension/length``.
/// * ``converter`` — how values in this unit relate to the base unit, so
///   quantities in different units can be converted freely.
///
/// You usually work with concrete units from the ``Units`` type rather than
/// conforming to `MathUnit` yourself. To define a unit for a custom dimension,
/// use ``NamedUnit``:
///
/// ```swift
/// let usd = NamedUnit<MathDimension.unknown>(
///     symbol: "$",
///     dimension: PhysicalDimension(exponents: ["USD": 1]),
///     converter: LinearConverter(coefficient: 1.0)
/// )
/// ```
///
/// - AssociatedType: `Dimension` — the compile-time dimension type, used for
///   type-safe generics. See ``DimensionProtocol``.
public protocol MathUnit: Sendable {
    /// The compile-time dimension type associated with this unit.
    associatedtype Dimension: DimensionProtocol

    /// The symbol representing the unit, e.g. `"m"`.
    var symbol: String { get }

    /// The underlying physical dimension of this unit.
    var dimension: PhysicalDimension { get }

    /// The unit converter used to transform values of this unit to and from base units.
    var converter: any UnitConverter { get }

    /// The position where the unit symbol should be placed when formatting.
    var symbolPosition: SymbolPosition { get }

    /// The base unit for this unit's dimension.
    var base: Self { get }
}

public extension MathUnit {
    /// Currency units place their symbol before the value; everything else
    /// places it after.
    var symbolPosition: SymbolPosition {
        dimension == .currency ? .prefix : .suffix
    }
}

/// Multiplies two units, returning a new ``CompositeUnit`` whose dimension is the
/// sum of their exponents.
///
/// For example, multiplying a meter by a second produces a `(m*s)` unit with a
/// `length + time` dimension.
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

/// Divides two units, returning a new ``CompositeUnit`` whose dimension is the
/// difference of their exponents.
///
/// For example, dividing a meter by a second produces a `(m/s)` unit with a
/// `length - time` (speed) dimension.
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