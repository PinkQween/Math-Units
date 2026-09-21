//
//  OffsetConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A ``UnitConverter`` that scales values by a coefficient and adds a constant
/// offset.
///
/// Use an `OffsetConverter` for units whose zero point doesn't match the base
/// unit, such as temperature scales. In `Math`, temperature is a thermal-energy
/// dimension whose base unit is the kelvin, so Celsius and Fahrenheit need both
/// a scale and an offset:
///
/// ```swift
/// let celsius = NamedUnit<MathDimension.energy>(
///     symbol: "°C",
///     dimension: .energy,
///     converter: OffsetConverter(
///         coefficient: 1.380649e-23,     // scale: kelvin ↔ energy
///         constant: 3.7712427435e-21     // offset: 0 °C ↔ 273.15 K
///     )
/// )
/// ```
///
/// A value converts to the base unit with `(value * coefficient) + constant`.
public struct OffsetConverter: UnitConverter {

    /// The scale factor applied to the value.
    public let coefficient: Double

    /// The offset added after scaling.
    public let constant: Double

    /// Creates an offset converter from a scale factor and a constant offset.
    ///
    /// - Parameters:
    ///   - coefficient: The scale factor to the base unit.
    ///   - constant: The value added after scaling.
    public init(coefficient: Double, constant: Double) {
        self.coefficient = coefficient
        self.constant = constant
    }

    /// Converts `value` to the base unit: `(value * coefficient) + constant`.
    public func convertToBase(_ value: Double) -> Double {
        (value * coefficient) + constant
    }

    /// Converts `value` from the base unit: `(value - constant) / coefficient`.
    public func convertFromBase(_ value: Double) -> Double {
        (value - constant) / coefficient
    }
}