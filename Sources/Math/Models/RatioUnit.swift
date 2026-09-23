//
//  RatioUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A manually-constructed unit expressing the *ratio* of one unit to another,
/// carrying both units as type parameters so the compiler can enforce which
/// side is which.
///
/// Unlike the dynamically-typed ``CompositeUnit`` — whose type-level dimension
/// is always ``MathDimension/unknown`` — a `RatioUnit` keeps its numerator and
/// denominator as two distinct generic parameters. That makes `USD / kg` a
/// different type from `kg / USD`, so a function can demand, for example, that
/// its denominator is a currency:
///
/// ```swift
/// let price = Units.usd.per(Units.kilogram)              // RatioUnit<…currency, …mass>
///
/// func totalCost<Num: MathUnit, Den: MathUnit>(
///     price: Quantity<RatioUnit<Num, Den>>,
///     amount: Quantity<Den>
/// ) -> Quantity<Num> where Num.Dimension == MathDimension.currency {
///     price * amount
/// }
///
/// let bill = totalCost(price: Quantity(value: 3.5, unit: price),
///                      amount: Quantity(value: 2, unit: Units.kilogram))
/// // Quantity<NamedUnit<MathDimension.currency>>: $7.00
/// ```
///
/// Building a ratio does not change values: the ratio's converter is the
/// numerator's base coefficient divided by the denominator's, so `3 USD / 2 kg`
/// retains its exact meaning when the unit is decomposed.
public struct RatioUnit<Numerator: MathUnit, Denominator: MathUnit>: MathUnit, CustomStringConvertible {
    /// The ratio's type-level dimension is `unknown`; the real constraint lives
    /// in the `Numerator` and `Denominator` generic parameters.
    public typealias Dimension = MathDimension.unknown

    /// The numerator unit of the ratio, e.g. `Units.usd`.
    public let numerator: Numerator

    /// The denominator unit of the ratio, e.g. `Units.kilogram`.
    public let denominator: Denominator

    /// Creates a ratio unit from an explicit numerator and denominator.
    ///
    /// - Parameters:
    ///   - numerator: The unit on the top of the ratio.
    ///   - denominator: The unit on the bottom of the ratio.
    public init(numerator: Numerator, denominator: Denominator) {
        self.numerator = numerator
        self.denominator = denominator
    }

    /// The composite symbol, e.g. `"(usd/kg)"`.
    public var symbol: String {
        "(\(numerator.symbol)/\(denominator.symbol))"
    }

    /// The ratio's physical dimension: the numerator's minus the denominator's.
    public var dimension: PhysicalDimension {
        numerator.dimension / denominator.dimension
    }

    /// The numerator's base coefficient divided by the denominator's.
    public var converter: any UnitConverter {
        LinearConverter(
            coefficient: numerator.converter.convertToBase(1.0)
                / denominator.converter.convertToBase(1.0)
        )
    }

    /// The ratio places its symbol after the value, like any composite unit.
    public var symbolPosition: SymbolPosition { .suffix }

    /// The base ratio: the same units with identity converters.
    public var base: RatioUnit {
        RatioUnit(numerator: numerator.base, denominator: denominator.base)
    }

    /// The ratio's symbol, e.g. `"(usd/kg)"`.
    public var description: String {
        return symbol
    }
}

public extension MathUnit {
    /// Returns this unit as the numerator of a ``RatioUnit`` over `denominator`.
    ///
    /// ```swift
    /// let pricePerMass = Units.usd.per(Units.kilogram)   // (usd/kg)
    /// let pricePerHour = Units.usd.per(Units.hour)       // (usd/hr)
    /// ```
    func per<Denominator: MathUnit>(_ denominator: Denominator) -> RatioUnit<Self, Denominator> {
        RatioUnit(numerator: self, denominator: denominator)
    }
}

extension RatioUnit: Equatable {
    /// Two ratio units are equal when they share a symbol and dimension.
    public static func == (lhs: RatioUnit, rhs: RatioUnit) -> Bool {
        lhs.symbol == rhs.symbol &&
        lhs.dimension == rhs.dimension
    }
}

extension RatioUnit: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(dimension)
    }
}

extension RatioUnit: Codable where Numerator: Codable, Denominator: Codable {
    private enum CodingKeys: String, CodingKey {
        case numerator
        case denominator
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let numerator = try container.decode(Numerator.self, forKey: .numerator)
        let denominator = try container.decode(Denominator.self, forKey: .denominator)
        self.init(numerator: numerator, denominator: denominator)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(numerator, forKey: .numerator)
        try container.encode(denominator, forKey: .denominator)
    }
}