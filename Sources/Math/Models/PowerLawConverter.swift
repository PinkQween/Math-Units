//
//  PowerLawConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

import Foundation

/// A converter for logarithmic ("power-law") scales, where each step of the
/// reading multiplies the underlying base quantity by a fixed factor.
///
/// This is exactly what decibels need. A reading `x` maps to the base unit with
///
/// ```swift
/// base = reference * baseFactor ^ x
/// ```
///
/// and back with `x = log(base / reference) / log(baseFactor)`. The
/// `reference` places the zero of the scale — for absolute scales like `dBm`
/// it is 1 mW, for `dB V` it is 1 V, for sound pressure level it is 20 µPa —
/// and `baseFactor` encodes the step, `10^(1/10)` for power-ratio decibels or
/// `10^(1/20)` for amplitude (field) decibels. Relative decibels (the
/// dimensionless `dB`) use a reference of `1`.
///
/// ```swift
/// let dBW = NamedUnit<MathDimension.power>(
///     symbol: "dBW",
///     dimension: .power,
///     converter: PowerLawConverter(base: pow(10, 0.1), reference: 1.0)
/// )
/// let watts = Quantity(value: 0, unit: dBW).converted(to: Units.watt)
/// // 0 dBW == 1 W
/// ```
///
/// - Note: Only linear base units participate safely in arithmetic. Converting
///   a logarithmic unit *to* the linear base of its dimension (or another unit)
///   is always well-defined; adding, multiplying, or composing logarithmic
///   units directly across each other is not physically meaningful.
public struct PowerLawConverter: UnitConverter {

    /// The multiplicative step per unit of reading, e.g. `10^(1/10)` for
    /// power-ratio decibels.
    public let base: Double

    /// The base-unit value that corresponds to a reading of zero, e.g. `0.001`
    /// (watts) for `dBm`.
    public let reference: Double

    /// Creates a logarithmic ("power-law") converter.
    ///
    /// - Parameters:
    ///   - base: The base-unit factor applied per unit of reading.
    ///   - reference: The base-unit value at a reading of zero. Defaults to `1`.
    public init(base: Double, reference: Double = 1.0) {
        self.base = base
        self.reference = reference
    }

    /// Converts `value` to the base unit: `reference * base^value`.
    public func convertToBase(_ value: Double) -> Double {
        reference * pow(base, value)
    }

    /// Converts `value` from the base unit: `log(value / reference) / log(base)`.
    public func convertFromBase(_ value: Double) -> Double {
        log(value / reference) / log(base)
    }
}

extension PowerLawConverter: Codable {}