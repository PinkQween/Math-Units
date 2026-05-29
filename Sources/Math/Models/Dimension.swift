//
//  Dimension.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct PhysicalDimension: Equatable, Hashable, Sendable {
    public let exponents: [String: Int]
    
    public init(exponents: [String: Int] = [:]) {
        // Filter out zero exponents to keep representations canonical
        self.exponents = exponents.filter { $0.value != 0 }
    }
    
    // Combining dimensions (e.g. Length * Length -> Area)
    public static func + (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] += exp
        }
        return Self(exponents: newExponents)
    }
    
    // Dividing dimensions (e.g. Length / Time -> Velocity)
    public static func - (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] -= exp
        }
        return Self(exponents: newExponents)
    }
    
    // Scaling exponents (e.g. 2 * Length -> Length^2)
    public static func * (lhs: Int, rhs: Self) -> Self {
        let newExponents = rhs.exponents.mapValues { $0 * lhs }
        return Self(exponents: newExponents)
    }
    
    // Commutative exponent scaling (e.g. Length * 2 -> Length^2)
    public static func * (lhs: Self, rhs: Int) -> Self {
        rhs * lhs
    }
    
    // Dividing exponents
    public static func / (lhs: Self, rhs: Int) -> Self {
        let newExponents = lhs.exponents.mapValues { $0 / rhs }
        return Self(exponents: newExponents)
    }
    
    // Multiplying two dimensions (adds their exponents)
    public static func * (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] += exp
        }
        return Self(exponents: newExponents)
    }
    
    // Dividing two dimensions (subtracts their exponents)
    public static func / (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] -= exp
        }
        return Self(exponents: newExponents)
    }
    
    // MARK: - Internal Dimension Values
    private static var _dimensionless: Self { Self() }
    private static var _length: Self { Self(exponents: ["length": 1]) }
    private static var _mass: Self { Self(exponents: ["mass": 1]) }
    private static var _time: Self { Self(exponents: ["time": 1]) }
    private static var _electricCurrent: Self { Self(exponents: ["electricCurrent": 1]) }
    private static var _temperature: Self { Self(exponents: ["temperature": 1]) }
    private static var _amountOfSubstance: Self { Self(exponents: ["amountOfSubstance": 1]) }
    private static var _luminousIntensity: Self { Self(exponents: ["luminousIntensity": 1]) }
    private static var _data: Self { Self(exponents: ["data": 1]) }
    
    private static var _area: Self { _length * 2 }
    private static var _volume: Self { _length * 3 }
    private static var _frequency: Self { _dimensionless / _time }
    private static var _speed: Self { _length / _time }
    private static var _acceleration: Self { _speed / _time }
    private static var _force: Self { _mass * _acceleration }
    private static var _energy: Self { _force * _length }
    private static var _power: Self { _energy / _time }
    private static var _luminosity: Self { _power }
    private static var _pressure: Self { _force / _area }
    private static var _charge: Self { _time * _electricCurrent }
    private static var _voltage: Self { (_length * 2) * _mass / (_time * 3) / _electricCurrent }
    private static var _resistance: Self { _voltage / _electricCurrent }
    private static var _inductance: Self { (_voltage * _time) / _electricCurrent }
    private static var _conductance: Self { _dimensionless / _resistance }
    private static var _capacitance: Self { _charge / _voltage }
    private static var _areaDensity: Self { _mass / _area }
    private static var _volumeDensity: Self { _mass / _volume }
    private static var _surfaceEnergy: Self { _energy / _area }
    private static var _specificEnergy: Self { _energy / _mass }
    private static var _surfacePressure: Self { _pressure / _area }
    private static var _specificVolume: Self { _volume / _mass }
    private static var _dataRate: Self { _data + _frequency }
    private static var _magneticFlux: Self { _voltage * _time }
    private static var _magneticFluxDensity: Self { _magneticFlux / _area }
    private static var _luminousFlux: Self { _luminousIntensity }
    private static var _illuminance: Self { _luminousIntensity / _area }

    // SI Base Dimensions
    public static var dimensionless: Self { _dimensionless }
    public static var length: Self { _length }
    public static var mass: Self { _mass }
    public static var time: Self { _time }
    public static var electricCurrent: Self { _electricCurrent }
    public static var temperature: Self { _temperature }
    public static var amountOfSubstance: Self { _amountOfSubstance }
    public static var luminousIntensity: Self { _luminousIntensity }
    public static var data: Self { _data }
    
    // Common Derived Dimensions
    public static var area: Self { _area }
    public static var volume: Self { _volume }
    public static var frequency: Self { _frequency }
    public static var speed: Self { _speed }
    public static var acceleration: Self { _acceleration }
    public static var force: Self { _force }
    public static var energy: Self { _energy }
    public static var power: Self { _power }
    public static var luminosity: Self { _luminosity }
    public static var pressure: Self { _pressure }
    public static var charge: Self { _charge }
    public static var voltage: Self { _voltage }
    public static var resistance: Self { _resistance }
    public static var inductance: Self { _inductance }
    public static var conductance: Self { _conductance }
    public static var capacitance: Self { _capacitance }
    public static var areaDensity: Self { _areaDensity }
    public static var volumeDensity: Self { _volumeDensity }
    public static var surfaceEnergy: Self { _surfaceEnergy }
    public static var specificEnergy: Self { _specificEnergy }
    public static var surfacePressure: Self { _surfacePressure }
    public static var specificVolume: Self { _specificVolume }
    public static var dataRate: Self { _dataRate }
    public static var magneticFlux: Self { _magneticFlux }
    public static var magneticFluxDensity: Self { _magneticFluxDensity }
    public static var luminousFlux: Self { _luminousFlux }
    public static var illuminance: Self { _illuminance }
}

// MARK: - Dimension Namespace Enum for Type-Level Safety
public enum Dimension {
    public struct dimensionless: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.dimensionless }
    }
    public struct length: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.length }
    }
    public struct mass: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.mass }
    }
    public struct time: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.time }
    }
    public struct electricCurrent: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.electricCurrent }
    }
    public struct temperature: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.temperature }
    }
    public struct amountOfSubstance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.amountOfSubstance }
    }
    public struct luminousIntensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.luminousIntensity }
    }
    public struct data: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.data }
    }
    public struct area: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.area }
    }
    public struct volume: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.volume }
    }
    public struct frequency: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.frequency }
    }
    public struct speed: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.speed }
    }
    public struct acceleration: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.acceleration }
    }
    public struct force: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.force }
    }
    public struct energy: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.energy }
    }
    public struct power: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.power }
    }
    public struct luminosity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.luminosity }
    }
    public struct pressure: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.pressure }
    }
    public struct charge: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.charge }
    }
    public struct voltage: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.voltage }
    }
    public struct resistance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.resistance }
    }
    public struct inductance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.inductance }
    }
    public struct conductance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.conductance }
    }
    public struct capacitance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.capacitance }
    }
    public struct areaDensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.areaDensity }
    }
    public struct volumeDensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.volumeDensity }
    }
    public struct surfaceEnergy: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.surfaceEnergy }
    }
    public struct specificEnergy: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.specificEnergy }
    }
    public struct surfacePressure: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.surfacePressure }
    }
    public struct specificVolume: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.specificVolume }
    }
    public struct dataRate: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.dataRate }
    }
    public struct magneticFlux: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.magneticFlux }
    }
    public struct magneticFluxDensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.magneticFluxDensity }
    }
    public struct luminousFlux: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.luminousFlux }
    }
    public struct illuminance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.illuminance }
    }
    public struct unknown: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.dimensionless }
    }
}
