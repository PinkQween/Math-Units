//
//  Quantity.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct Quantity<U: MathUnit> {
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
        
        // If converting temperature to energy (natural units conversion)
        if self.unit.dimension == .temperature && targetUnit.dimension == .energy {
            let tempK = self.converted(to: Units.kelvin)
            let boltzmannJ = tempK.value * 1.380649e-23
            let jouleQty = Quantity<NamedUnit<MathDimension.energy>>(value: boltzmannJ, unit: Units.joule)
            return jouleQty.converted(to: targetUnit)
        }
        
        // If converting energy to temperature (natural units conversion)
        if self.unit.dimension == .energy && targetUnit.dimension == .temperature {
            let energyJ = self.converted(to: Units.joule)
            let tempKVal = energyJ.value / 1.380649e-23
            let kelvinQty = Quantity<NamedUnit<MathDimension.temperature>>(value: tempKVal, unit: Units.kelvin)
            return kelvinQty.converted(to: targetUnit)
        }
        
        preconditionFailure("Cannot convert quantity to a unit of a different dimension. Source dimension: \(self.unit.dimension), Target dimension: \(targetUnit.dimension)")
    }
}

// MARK: - Thermal Energy Helpers
public extension Quantity {
    /// The thermal energy equivalent of this temperature quantity (E = k_B * T) in Joules.
    /// Precondition: This quantity must be a temperature.
    var thermalEnergy: Quantity<NamedUnit<MathDimension.energy>> {
        precondition(self.unit.dimension == .temperature, "Thermal energy can only be calculated for temperature quantities.")
        let tempK = self.converted(to: Units.kelvin)
        return Quantity<NamedUnit<MathDimension.energy>>(value: tempK.value * 1.380649e-23, unit: Units.joule)
    }
    
    /// The thermal energy equivalent of this temperature quantity (E = k_B * T) in the specified energy unit.
    /// Precondition: This quantity must be a temperature and the target unit must be an energy unit.
    func thermalEnergy<TargetUnit: MathUnit>(in targetUnit: TargetUnit) -> Quantity<TargetUnit> {
        precondition(self.unit.dimension == .temperature, "Thermal energy can only be calculated for temperature quantities.")
        precondition(targetUnit.dimension == .energy, "Target unit must be an energy unit.")
        return self.converted(to: targetUnit)
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
