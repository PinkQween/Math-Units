//
//  Dimension.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct Dimension: Equatable, Hashable, Sendable {
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
    
    // SI Base Dimensions
    public static var dimensionless: Self { Self() }
    public static var length: Self { Self(exponents: ["length": 1]) }
    public static var mass: Self { Self(exponents: ["mass": 1]) }
    public static var time: Self { Self(exponents: ["time": 1]) }
    public static var electricCurrent: Self { Self(exponents: ["electricCurrent": 1]) }
    public static var temperature: Self { Self(exponents: ["temperature": 1]) }
    public static var amountOfSubstance: Self { Self(exponents: ["amountOfSubstance": 1]) }
    public static var luminousIntensity: Self { Self(exponents: ["luminousIntensity": 1]) }
    public static var data: Self { Self(exponents: ["data": 1]) }
    
    // Common Derived Dimensions
    public static var area: Self { length * 2 }
    public static var volume: Self { length * 3 }
    public static var frequency: Self { dimensionless / time }
    public static var speed: Self { length / time }
    public static var acceleration: Self { speed / time }
    public static var force: Self { mass * acceleration }
    public static var energy: Self { force * length }
    public static var power: Self { energy / time }
    public static var luminosity: Self { power }
    public static var pressure: Self { force / area }
    public static var charge: Self { time * electricCurrent }
    public static var voltage: Self { (length * 2) * mass / (time * 3) / electricCurrent }
    public static var resistance: Self { voltage / electricCurrent }
    public static var inductance: Self { (voltage * time) / electricCurrent }
    public static var conductance: Self { dimensionless / resistance }
    public static var capacitance: Self { charge / voltage }
    public static var areaDensity: Self { mass / area }
    public static var volumeDensity: Self { mass / volume }
    public static var surfaceEnergy: Self { energy / area }
    public static var specificEnergy: Self { energy / mass }
    public static var surfacePressure: Self { pressure / area }
    public static var specificVolume: Self { volume / mass }
    public static var dataRate: Self { data + frequency }
    public static var magneticFlux: Self { voltage * time }
    public static var magneticFluxDensity: Self { magneticFlux / area }
    public static var luminousFlux: Self { luminousIntensity }
    public static var illuminance: Self { luminousIntensity / area }
}
