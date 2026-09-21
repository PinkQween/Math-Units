//
//  UnitConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A type that converts numeric values between a unit and the base unit of its
/// dimension.
///
/// The ``Quantity`` and ``MathUnit`` machinery uses a unit's converter whenever
/// it needs to combine or convert quantities: values are first converted *to*
/// the base unit with ``convertToBase(_:)``, combined, and then converted
/// *from* the base unit back into the desired unit.
///
/// `Math` ships with four ready-made converters:
///
/// * ``LinearConverter`` — a simple scale factor, used by most units (e.g. `1 km = 1000 m`).
/// * ``OffsetConverter`` — a scale factor plus an additive offset, used by scales
///   that don't share zero, such as Celsius and Fahrenheit.
/// * ``PowerLawConverter`` — a logarithmic scale where each step of a reading
///   multiplies the base value by a fixed factor, used by decibel units
///   (dimensionless dB, `dBm`, `dBV`, `dB SPL`, ...).
/// * ``EmptyConverter`` — the identity conversion, for units that are already
///   expressed in the base unit.
///
/// The library also exposes all the needed free functions to build your own
/// converters if a unit needs special handling.
///
/// > Tip: You usually don't interact with converters directly. `Math` uses them
/// > automatically inside ``Quantity/converted(to:)`` and the arithmetic operators.
public protocol UnitConverter: Sendable {
    /// Converts a value from this unit to the base unit of the dimension.
    func convertToBase(_ value: Double) -> Double

    /// Converts a value from the base unit of the dimension back to this unit.
    func convertFromBase(_ value: Double) -> Double
}