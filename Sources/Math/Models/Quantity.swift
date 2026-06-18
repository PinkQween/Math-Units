//
//  Quantity.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//
import Foundation

public struct Quantity<U: MathUnit>: CustomStringConvertible {
    public let value: Double
    public let unit: U
    
    public init(value: Double, unit: U) {
        self.value = value
        self.unit = unit
    }
    
    /// Converts this quantity to another unit of the same dimension, or converts between
    /// Temperature and Energy using Boltzmann's constant (natural unit conversion).
    public func converted<TargetUnit: MathUnit>(to targetUnit: TargetUnit) -> Quantity<TargetUnit> {
        // If dimensions match, convert normally
        if self.unit.dimension == targetUnit.dimension {
            let baseValue = self.unit.converter.convertToBase(self.value)
            let targetValue = targetUnit.converter.convertFromBase(baseValue)
            return Quantity<TargetUnit>(value: targetValue, unit: targetUnit)
        }
        
        preconditionFailure("Cannot convert quantity to a unit of a different dimension. Source dimension: \(self.unit.dimension), Target dimension: \(targetUnit.dimension)")
    }
    
    public var description: String {
        return self.formatted()
    }
}

// MARK: - Formatting
public extension Quantity {
    /// Formats the quantity value with its unit symbol placed on the correct side (prefix or suffix).
    ///
    /// - Parameters:
    ///   - decimalPlaces: The number of decimal places to format the numeric value to (default is 2).
    ///   - includeSpace: An optional boolean. If true, a space is inserted between the value and symbol.
    ///                   Defaults to `false` for prefix symbols (like `$10.00`), and `true` for suffix symbols
    ///                   (like `10.00 m` or `10.00 kr`), except for the percent symbol (`%`) which defaults to `false`.
    /// - Returns: A formatted string representation.
    func formatted(decimalPlaces: Int = 2, includeSpace: Bool? = nil) -> String {
        let formattedValue = String(format: "%.\(decimalPlaces)f", value)
        
        switch unit.symbolPosition {
        case .prefix:
            let space = includeSpace ?? false ? " " : ""
            return "\(unit.symbol)\(space)\(formattedValue)"
            
        case .suffix:
            let defaultSpace = unit.symbol != "%"
            let space = includeSpace ?? defaultSpace ? " " : ""
            return "\(formattedValue)\(space)\(unit.symbol)"
        }
    }
}

// MARK: - Equatable
extension Quantity: Equatable {
    public static func == (lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
        lhs.value == rhs.value
    }
    
    /// Check if this quantity is physically equivalent to another quantity of a potentially different unit type, within a tolerance.
    public func isEquivalent<U2: MathUnit>(to other: Quantity<U2>, tolerance: Double = 1e-12) -> Bool {
        guard self.unit.dimension == other.unit.dimension else { return false }
        let otherConverted = other.converted(to: self.unit)
        return abs(self.value - otherConverted.value) <= tolerance
    }
}

// MARK: - Arithmetic Operators (Same Dimension Addition & Subtraction)
public extension Quantity {
    static func + <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<U> {
        precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot add quantities of different dimensions: \(lhs.unit.dimension) and \(rhs.unit.dimension)")
        let rhsConverted = rhs.converted(to: lhs.unit)
        return Quantity(value: lhs.value + rhsConverted.value, unit: lhs.unit)
    }
    
    static func - <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<U> {
        precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot subtract quantities of different dimensions: \(lhs.unit.dimension) and \(rhs.unit.dimension)")
        let rhsConverted = rhs.converted(to: lhs.unit)
        return Quantity(value: lhs.value - rhsConverted.value, unit: lhs.unit)
    }
}

// MARK: - Scalar Multiplication & Division
public extension Quantity {
    static func * (lhs: Quantity<U>, rhs: Double) -> Quantity<U> {
        Quantity(value: lhs.value * rhs, unit: lhs.unit)
    }
    
    static func * (lhs: Double, rhs: Quantity<U>) -> Quantity<U> {
        Quantity(value: lhs * rhs.value, unit: rhs.unit)
    }
    
    static func / (lhs: Quantity<U>, rhs: Double) -> Quantity<U> {
        Quantity(value: lhs.value / rhs, unit: lhs.unit)
    }
    
    static func / (lhs: Double, rhs: Quantity<U>) -> Quantity<CompositeUnit> {
        let newDimension = PhysicalDimension.dimensionless - rhs.unit.dimension
        let newSymbol = "(1/\(rhs.unit.symbol))"
        
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = 1.0 / rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = CompositeUnit(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs / rhs.value
        
        return Quantity<CompositeUnit>(value: newValue, unit: newUnit)
    }
}

// MARK: - Dimensional Algebra (Multiplication & Division between Quantities)
public extension Quantity {
    static func * <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<CompositeUnit> {
        let newDimension = lhs.unit.dimension + rhs.unit.dimension
        let newSymbol = "(\(lhs.unit.symbol)*\(rhs.unit.symbol))"
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff * rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = CompositeUnit(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value * rhs.value
        
        return Quantity<CompositeUnit>(value: newValue, unit: newUnit)
    }
    
    static func / <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<CompositeUnit> {
        let newDimension = lhs.unit.dimension - rhs.unit.dimension
        let newSymbol = "(\(lhs.unit.symbol)/\(rhs.unit.symbol))"
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff / rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = CompositeUnit(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value / rhs.value
        
        return Quantity<CompositeUnit>(value: newValue, unit: newUnit)
    }
}

// MARK: - Smart Dimensional Overloads
public extension Quantity where U.Dimension == MathDimension.power {
    static func * <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<NamedUnit<MathDimension.energy>> where U2.Dimension == MathDimension.time {
        let newDimension = MathDimension.energy.dimension
        let newSymbol = "\(lhs.unit.symbol)\(rhs.unit.symbol)"
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff * rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = NamedUnit<MathDimension.energy>(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value * rhs.value
        
        return Quantity<NamedUnit<MathDimension.energy>>(value: newValue, unit: newUnit)
    }
}

public extension Quantity where U.Dimension == MathDimension.time {
    static func * <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<NamedUnit<MathDimension.energy>> where U2.Dimension == MathDimension.power {
        let newDimension = MathDimension.energy.dimension
        // Standard convention puts power before time (e.g., kWh, Ws)
        let newSymbol = "\(rhs.unit.symbol)\(lhs.unit.symbol)"
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff * rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = NamedUnit<MathDimension.energy>(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value * rhs.value
        
        return Quantity<NamedUnit<MathDimension.energy>>(value: newValue, unit: newUnit)
    }
}

public extension Quantity where U.Dimension == MathDimension.energy {
    static func / <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<NamedUnit<MathDimension.power>> where U2.Dimension == MathDimension.time {
        let newDimension = MathDimension.power.dimension
        // Extract the power unit symbol if it ends with the time unit symbol, else fall back to generic (E/T)
        var newSymbol = "(\(lhs.unit.symbol)/\(rhs.unit.symbol))"
        if lhs.unit.symbol.hasSuffix(rhs.unit.symbol) {
            let potentialPowerSymbol = String(lhs.unit.symbol.dropLast(rhs.unit.symbol.count))
            if !potentialPowerSymbol.isEmpty {
                newSymbol = potentialPowerSymbol
            }
        }
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff / rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = NamedUnit<MathDimension.power>(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value / rhs.value
        
        return Quantity<NamedUnit<MathDimension.power>>(value: newValue, unit: newUnit)
    }
}

