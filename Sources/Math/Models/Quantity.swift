//
//  Quantity.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//
import Foundation

/// A measurement of some physical quantity, made up of a numeric value and a unit.
///
/// ``Quantity`` is the central type in `Math`. You create one by pairing a
/// `value` with a ``MathUnit``, then convert it between units, combine it with
/// other quantities, compare it for physical equivalence, and format it for
/// display.
///
/// The structure mirrors Foundation's `Measurement`, but adds compile-time
/// dimension checking: the `U` generic parameter carries a `Dimension` type
/// (see ``DimensionProtocol``), so Swift can reject quantities of mismatched
/// dimensions before your app runs. Read <doc:CompileTimeSafety> for more.
///
/// ```swift
/// let marathon = Quantity(value: 42.195, unit: Units.kilometer)
/// let inMiles = marathon.converted(to: Units.mile)
/// print(inMiles) // 26.22 mi
/// ```
///
/// - SeeAlso: <doc:WorkingWithQuantity>
public struct Quantity<U: MathUnit>: CustomStringConvertible {
    /// The numeric magnitude of the quantity in `unit`.
    public let value: Double

    /// The unit of measure for `value`.
    public let unit: U

    /// Creates a quantity with a value and a unit.
    /// - Parameters:
    ///   - value: The magnitude of the quantity.
    ///   - unit: The unit of measure for the value.
    public init(value: Double, unit: U) {
        self.value = value
        self.unit = unit
    }

    /// Creates a quantity from a bare value and unit, for one-line construction.
    ///
    /// Use the dimension-scoped namespaces in ``Units`` to stay explicit about
    /// which quantity you mean. This is especially important for mass versus
    /// weight: `Quantity(16, Units.Mass.ounce)` is 16 ounces of mass, while
    /// `Quantity(16, Units.Weight.ounce)` is 16 ounce-force—two entirely
    /// different dimensions that happen to share the name "ounce".
    ///
    /// ```swift
    /// let water = Quantity(2, Units.Volume.cup)
    /// let thrust = Quantity(480, Units.Weight.poundForce)
    /// ```
    public init(_ value: Double, _ unit: U) {
        self.init(value: value, unit: unit)
    }
    
    /// Converts this quantity to another unit of the same dimension.
    ///
    /// This method converts through the unit's base unit, so you can convert
    /// between any two units that share a dimension—even ones that combine
    /// offset converters (like ``Units/fahrenheit``) with linear ones.
    ///
    /// In `Math`, temperature is modeled as the dimension of thermal energy, so
    /// converting between, say, degrees Fahrenheit and joules is a normal
    /// same-dimension conversion. For an explicit way to extract a
    /// temperature's energy, see ``Quantity/thermalEnergy``.
    ///
    /// - Parameters:
    ///   - targetUnit: The unit to convert to. It must have the same dimension
    ///     as this quantity's unit.
    /// - Returns: A new quantity whose value is expressed in `targetUnit`.
    ///
    /// ```swift
    /// let distance = Quantity(value: 10.5, unit: Units.kilometer)
    /// let inMiles = distance.converted(to: Units.mile)
    /// print(inMiles.value) // 6.524...
    /// ```
    public func converted<TargetUnit: MathUnit>(to targetUnit: TargetUnit) -> Quantity<TargetUnit> {
        // If dimensions match, convert normally
        if self.unit.dimension == targetUnit.dimension {
            let baseValue = self.unit.converter.convertToBase(self.value)
            let targetValue = targetUnit.converter.convertFromBase(baseValue)
            return Quantity<TargetUnit>(value: targetValue, unit: targetUnit)
        }
        
        preconditionFailure("Cannot convert quantity to a unit of a different dimension. Source dimension: \(self.unit.dimension), Target dimension: \(targetUnit.dimension)")
    }

    /// Returns this quantity restated in the unit that gives the *cleanest*
    /// reading, chosen automatically from the dimension's catalog.
    ///
    /// The picker scans ``Units/units(for:)`` for the quantity's dimension —
    /// including the SI-prefixed metric siblings of every unit, so `1000 m`
    /// can become `1 km` — and prefers, in order:
    ///
    /// 1. A reading that is a **whole number**, and when the amount is positive
    ///    the **smallest** positive whole number (e.g. `1 km` rather than
    ///    `1000 m` or `0.001 Mm`). Any whole reading beats every fractional one,
    ///    so a huge unit like the parsec can never steal the win.
    /// 2. Otherwise the reading **closest to a whole number** (fewest decimal
    ///    places), breaking ties by smallest magnitude.
    ///
    /// The value is never rounded or truncated — only the *unit* is chosen, and
    /// the conversion stays exact. A zero quantity returns the base unit, and a
    /// quantity whose dimension has no catalog lookup converts to a unit with
    /// the same symbol and coefficient as its current one.
    ///
    /// ```swift
    /// let rope = Quantity(value: 1000, unit: Units.meter)
    /// rope.simplified()                   // 1 km
    ///
    /// let thrust = Quantity(value: 2000, unit: Units.poundForce)
    /// thrust.simplified()                 // 1 shortTonForce
    ///
    /// let ride = Quantity(value: 3600, unit: Units.second)
    /// ride.simplified()                   // 1 hour
    /// ```
    public func simplified() -> Quantity<NamedUnit<U.Dimension>> {
        if value == 0 {
            let base = baseNamedUnit()
            return Quantity<NamedUnit<U.Dimension>>(value: 0, unit: base.unit)
        }

        let tolerance = 1e-9
        let baseValue = unit.converter.convertToBase(value)
        let candidates = simplifiedCandidates()

        // Whole-number readings are absolutely preferred; among them pick the
        // smallest magnitude (smallest positive whole for a positive amount).
        var whole: (unit: NamedUnit<U.Dimension>, reading: Double)?
        var wholeMagnitude = Double.infinity

        // Only when NO unit reads as a whole number does the fallback run:
        // closest to a whole number (fewest decimals), then smallest magnitude.
        var fractional: (unit: NamedUnit<U.Dimension>, reading: Double)?
        var fractionalDistance = Double.infinity
        var fractionalMagnitude = Double.infinity

        for candidate in candidates {
            let reading = candidate.converter.convertFromBase(baseValue)
            let rounded = reading.rounded()
            let distance = abs(reading - rounded)
            let isWhole = distance <= tolerance * max(1.0, abs(rounded))
            let magnitude = abs(reading)

            if isWhole && magnitude >= 1 {
                if magnitude < wholeMagnitude { // prefer smallest |n|
                    wholeMagnitude = magnitude
                    whole = (candidate, reading)
                }
            } else if distance < fractionalDistance - tolerance
                || (abs(distance - fractionalDistance) <= tolerance && magnitude < fractionalMagnitude) {
                fractionalDistance = distance
                fractionalMagnitude = magnitude
                fractional = (candidate, reading)
            }
        }

        if let whole {
            return Quantity<NamedUnit<U.Dimension>>(value: whole.reading, unit: whole.unit)
        }
        if let fractional {
            return Quantity<NamedUnit<U.Dimension>>(value: fractional.reading, unit: fractional.unit)
        }
        let base = baseNamedUnit()
        return Quantity<NamedUnit<U.Dimension>>(value: base.reading, unit: base.unit)
    }

    /// The catalog units for this dimension plus every SI-prefixed metric
    /// sibling of the base catalog units (kilo-, milli-, …). The synthesized
    /// units use the same symbols and coefficients as the generated
    /// ``Units.kilometer``-style statics, so they compare equal to them.
    private func simplifiedCandidates() -> [NamedUnit<U.Dimension>] {
        // Mirror the metric prefixes and symbols used by the unit generator
        // (see Sources/Math/units.sh: si_prefixes).
        let prefixes: [(symbol: String, value: Double)] = [
            ("Q", 1e30), ("R", 1e27), ("Y", 1e24), ("Z", 1e21), ("E", 1e18),
            ("P", 1e15), ("T", 1e12), ("G", 1e9), ("M", 1e6), ("k", 1e3),
            ("h", 1e2), ("da", 1e1), ("d", 1e-1), ("c", 1e-2), ("m", 1e-3),
            ("u", 1e-6), ("n", 1e-9), ("p", 1e-12), ("f", 1e-15), ("a", 1e-18),
            ("z", 1e-21), ("y", 1e-24), ("r", 1e-27), ("q", 1e-30)
        ]

        var seen = Set<String>()
        var result: [NamedUnit<U.Dimension>] = []

        func add(_ unit: NamedUnit<U.Dimension>) {
            guard !seen.contains(unit.symbol) else { return }
            seen.insert(unit.symbol)
            result.append(unit)
        }

        for candidate in Units.units(for: unit.dimension) {
            guard let named = candidate as? NamedUnit<U.Dimension> else { continue }
            add(named)

            // Only genuine metric base units (a power-of-ten coefficient, like
            // "m", "g", "s", "N", "J", "Pa", "W") get SI siblings. Folding a
            // hundredweight or a poronkusema would only fabricate nonsense
            // symbols that can never beat a real reading.
            let baseCoefficient = named.converter.convertToBase(1.0)
            guard isMetricPowerOfTen(baseCoefficient) else { continue }
            for prefix in prefixes {
                add(NamedUnit<U.Dimension>(
                    symbol: prefix.symbol + named.symbol,
                    dimension: named.dimension,
                    converter: LinearConverter(coefficient: baseCoefficient * prefix.value)
                ))
            }
        }
        return result
    }

    private func isMetricPowerOfTen(_ value: Double) -> Bool {
        guard value > 0 else { return false }
        let exponent = log10(value)
        return abs(exponent - exponent.rounded()) < 1e-9
    }

    private func baseNamedUnit() -> (unit: NamedUnit<U.Dimension>, reading: Double) {
        let base = Units.units(for: unit.dimension).first as? NamedUnit<U.Dimension>
        if let base {
            return (base, base.converter.convertFromBase(unit.converter.convertToBase(value)))
        }
        let named = NamedUnit<U.Dimension>(symbol: unit.symbol, dimension: unit.dimension, converter: unit.converter)
        return (named, value)
    }

    public var description: String {
        return self.formatted()
    }
}

// MARK: - Codable
extension Quantity: Codable where U: Codable {
    /// Encodes this quantity's value and unit. The unit is encoded with its
    /// symbol, dimension, symbol position, and a tagged converter, so decoding
    /// reconstructs an identical unit. Requires the unit type `U` to be
    /// `Codable` (``NamedUnit``, ``CompositeUnit``, and the built-in units all
    /// are).
    ///
    /// ```swift
    /// let distance = Quantity(value: 26.2, unit: Units.mile)
    /// let data = try JSONEncoder().encode(distance)
    /// let decoded = try JSONDecoder().decode(
    ///     Quantity<NamedUnit<MathDimension.length>>.self, from: data)
    /// decoded == distance // true
    /// ```
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
    ///
    /// ```swift
    /// let price = Quantity(value: 10.1234, unit: Units.usd)
    /// price.formatted()                  // "$10.12"
    /// price.formatted(decimalPlaces: 3)  // "$10.123"
    ///
    /// let length = Quantity(value: 5.5, unit: Units.meter)
    /// length.formatted()                 // "5.50 m"
    /// ```
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

// MARK: - Equatable & Hashable
extension Quantity: Equatable {
    /// Returns a Boolean value indicating whether two quantities have the same
    /// value *and* the same unit (symbol and dimension). To compare quantities
    /// in different units of the same dimension—for example, one mile versus
    /// 1609.344 meters—use ``Quantity/isEquivalent(to:tolerance:)``.
    public static func == (lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
        lhs.value == rhs.value &&
        lhs.unit.symbol == rhs.unit.symbol &&
        lhs.unit.dimension == rhs.unit.dimension
    }
    
    /// Check if this quantity is physically equivalent to another quantity of a potentially different unit type, within a tolerance.
    ///
    /// Unlike `==`, which compares raw values, this method converts `other` to
    /// this quantity's unit first—so quantities in different units of the same
    /// dimension can be compared for physical equality.
    ///
    /// - Parameters:
    ///   - other: The quantity to compare against. It must share this
    ///     quantity's dimension.
    ///   - tolerance: The maximum absolute difference (in this quantity's
    ///     unit) for the values to be considered equivalent. Defaults to `1e-12`.
    /// - Returns: `true` if the quantities are physically equal within
    ///   `tolerance`.
    ///
    /// ```swift
    /// let mile = Quantity(value: 1.0, unit: Units.mile)
    /// mile.isEquivalent(to: Quantity(value: 1609.344, unit: Units.meter)) // true
    /// ```
    public func isEquivalent<U2: MathUnit>(to other: Quantity<U2>, tolerance: Double = 1e-12) -> Bool {
        guard self.unit.dimension == other.unit.dimension else { return false }
        let otherConverted = other.converted(to: self.unit)
        return abs(self.value - otherConverted.value) <= tolerance
    }
}

extension Quantity: Hashable {
    /// Hashes the value and unit identity (symbol and dimension), matching
    /// ``Quantity/==(_:_:)`` so quantities work correctly as dictionary keys
    /// and set members.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(unit.symbol)
        hasher.combine(unit.dimension)
    }
}

// MARK: - Arithmetic Operators (Same Dimension Addition & Subtraction)
public extension Quantity {
    /// Adds two quantities of the same dimension, converting `rhs` to the
    /// left-hand side's unit. The result keeps `lhs`'s unit. Requires matching
    /// dimensions at runtime (or compile time, for statically-dimensioned units).
    /// - Warning: Traps with a `preconditionFailure` if the dimensions differ.
    static func + <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<U> {
        precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot add quantities of different dimensions: \(lhs.unit.dimension) and \(rhs.unit.dimension)")
        let rhsConverted = rhs.converted(to: lhs.unit)
        return Quantity(value: lhs.value + rhsConverted.value, unit: lhs.unit)
    }
    
    /// Subtracts a quantity of the same dimension from another, converting
    /// `rhs` to the left-hand side's unit. The result keeps `lhs`'s unit.
    /// Requires matching dimensions.
    /// - Warning: Traps with a `preconditionFailure` if the dimensions differ.
    static func - <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<U> {
        precondition(lhs.unit.dimension == rhs.unit.dimension, "Cannot subtract quantities of different dimensions: \(lhs.unit.dimension) and \(rhs.unit.dimension)")
        let rhsConverted = rhs.converted(to: lhs.unit)
        return Quantity(value: lhs.value - rhsConverted.value, unit: lhs.unit)
    }
}

// MARK: - Scalar Multiplication & Division
public extension Quantity {
    /// Scales a quantity by a `Double`, preserving its unit.
    static func * (lhs: Quantity<U>, rhs: Double) -> Quantity<U> {
        Quantity(value: lhs.value * rhs, unit: lhs.unit)
    }
    
    /// Scales a quantity by a `Double` on the left, preserving its unit.
    static func * (lhs: Double, rhs: Quantity<U>) -> Quantity<U> {
        Quantity(value: lhs * rhs.value, unit: rhs.unit)
    }
    
    /// Divides a quantity by a `Double`, preserving its unit.
    static func / (lhs: Quantity<U>, rhs: Double) -> Quantity<U> {
        Quantity(value: lhs.value / rhs, unit: lhs.unit)
    }
    
    /// Returns the reciprocal dimension of a quantity (a `Double` divided by a
    /// quantity), producing a ``CompositeUnit`` (for example `1 / time`).
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
    /// Multiplies two quantities, combining their dimensions. The result is a
    /// ``CompositeUnit`` (for example `(m*s)` when multiplying meters by seconds),
    /// and both the value and the unit coefficient are adjusted correctly.
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
    
    /// Divides two quantities, dividing their dimensions. The result is a
    /// ``CompositeUnit`` (for example `(m/s)` when dividing meters by seconds),
    /// and both the value and the unit coefficient are adjusted correctly.
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
    /// Multiplies a power quantity by a time quantity, producing an energy
    /// quantity with the conventional symbol ordering (for example `kWh`).
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
    /// Multiplies a time quantity by a power quantity, producing an energy
    /// quantity with the conventional symbol ordering (for example `kWh`).
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
    /// Divides an energy quantity by a time quantity, producing a power quantity
    /// with a cleaned-up symbol when possible (for example `kW` from `kWh / h`).
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

// MARK: - Force from Mass × Acceleration (F = ma)

public extension Quantity where U.Dimension == MathDimension.mass {
    /// Multiplies a mass quantity by an acceleration quantity, producing a force
    /// quantity whose unit is the standard `F = ma` composite (for example
    /// `(kg*(m/s²))`). This overload lets you write
    /// `mass * Units.gravity` and get a real force reading:
    ///
    /// ```swift
    /// let bag = Quantity(value: 5, unit: Units.kilogram)
    /// let pull = bag * Quantity(value: 1, unit: Units.gravity)
    /// pull.converted(to: Units.newton).value // ≈ 49.03
    /// ```
    static func * <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<NamedUnit<MathDimension.force>> where U2.Dimension == MathDimension.acceleration {
        let newDimension = MathDimension.force.dimension
        let newSymbol = "(\(lhs.unit.symbol)*\(rhs.unit.symbol))"
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff * rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = NamedUnit<MathDimension.force>(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value * rhs.value
        
        return Quantity<NamedUnit<MathDimension.force>>(value: newValue, unit: newUnit)
    }
}

public extension Quantity where U.Dimension == MathDimension.acceleration {
    /// Multiplies an acceleration quantity by a mass quantity, producing a force
    /// quantity (commutative form of `F = ma`).
    static func * <U2: MathUnit>(lhs: Quantity<U>, rhs: Quantity<U2>) -> Quantity<NamedUnit<MathDimension.force>> where U2.Dimension == MathDimension.mass {
        let newDimension = MathDimension.force.dimension
        let newSymbol = "(\(lhs.unit.symbol)*\(rhs.unit.symbol))"
        
        let lhsCoeff = lhs.unit.converter.convertToBase(1.0)
        let rhsCoeff = rhs.unit.converter.convertToBase(1.0)
        let compositeCoeff = lhsCoeff * rhsCoeff
        
        let newConverter = LinearConverter(coefficient: compositeCoeff)
        let newUnit = NamedUnit<MathDimension.force>(symbol: newSymbol, dimension: newDimension, converter: newConverter)
        let newValue = lhs.value * rhs.value
        
        return Quantity<NamedUnit<MathDimension.force>>(value: newValue, unit: newUnit)
    }
}

// MARK: - Thermal Energy (Natural Units)
public extension Quantity where U.Dimension == MathDimension.energy {
    /// The thermal energy equivalent of this quantity, in joules.
    ///
    /// `Math` models temperature using the dimension of thermal energy, where the
    /// base unit is the joule and one kelvin equals `1.380649 × 10⁻²³`
    /// joules (Boltzmann's constant). This property expresses the quantity as an
    /// energy in joules directly:
    ///
    /// ```swift
    /// let roomTemp = Quantity(value: 293.15, unit: Units.kelvin)
    /// print(roomTemp.thermalEnergy) // 0.00 J  (≈ 4.0468 × 10⁻²¹ J)
    /// ```
    ///
    /// Use ``thermalEnergy(in:)`` to get the value in a specific energy unit.
    /// - SeeAlso: ``converted(to:)``
    var thermalEnergy: Quantity<NamedUnit<MathDimension.energy>> {
        converted(to: Units.joule)
    }
    
    /// The thermal energy equivalent of this quantity, expressed in a given energy unit.
    ///
    /// - Parameter unit: An energy unit to express the result in, such as
    ///   ``Units/britishThermalUnit``.
    /// - Returns: This quantity converted to `unit`.
    ///
    /// ```swift
    /// let hotDay = Quantity(value: 310.0, unit: Units.kelvin)
    /// print(hotDay.thermalEnergy(in: Units.britishThermalUnit)) // 0.00 BTU
    /// ```
    func thermalEnergy(in unit: NamedUnit<MathDimension.energy>) -> Quantity<NamedUnit<MathDimension.energy>> {
        thermalEnergy.converted(to: unit)
    }
}

// MARK: - Weight (W = mg)
public extension Quantity where U.Dimension == MathDimension.mass {
    /// The weight of this mass: the force gravity exerts on it, `W = mg`.
    ///
    /// Weight is a **force**, not a mass. This property computes
    /// `W = m × g` for this quantity of mass at standard gravity
    /// (`g = 9.80665 m/s²`) and returns the result as a force quantity in
    /// newtons:
    ///
    /// ```swift
    /// let sack = Quantity(value: 10, unit: Units.kilogram)
    /// sack.weight.converted(to: Units.newton).value // ≈ 98.0665
    ///
    /// // One pound-mass weighs exactly one pound-force on Earth:
    /// let pound = Quantity(value: 1, unit: Units.poundMass)
    /// pound.weight.converted(to: Units.poundForce).value // 1.0
    /// ```
    ///
    /// Use ``weight(on:)`` for a non-standard gravitational field and
    /// ``weight(in:)`` to express the result in a specific force unit (such as
    /// ``Units/poundForce``).
    ///
    /// The base unit of this force quantity is the newton (kg·m/s²).
    var weight: Quantity<NamedUnit<MathDimension.force>> {
        weight(on: 9.80665)
    }

    /// The weight of this mass under a gravitational acceleration, `W = mg`.
    ///
    /// - Parameter g: The local gravitational acceleration in meters per
    ///   second squared. Defaults to the standard gravity `9.80665` via the
    ///   ``Quantity/weight`` property.
    /// - Returns: This quantity of mass converted to the force it weighs.
    ///
    /// ```swift
    /// let probe = Quantity(value: 100, unit: Units.kilogram)
    /// probe.weight(on: 1.62).converted(to: Units.newton).value // ≈ 162 (Moon)
    /// ```
    func weight(on g: Double) -> Quantity<NamedUnit<MathDimension.force>> {
        weight(on: Quantity<NamedUnit<MathDimension.acceleration>>(value: g, unit: Units.meterPerSecondSquared))
    }

    /// The weight of this mass under a given gravitational acceleration
    /// quantity, `W = mg`.
    ///
    /// - Parameter g: A gravitational acceleration quantity such as
    ///   ``Units/gravity`` (standard gravity) or ``Units/meterPerSecondSquared``.
    /// - Returns: This quantity of mass converted to the force it weighs.
    func weight(on g: Quantity<NamedUnit<MathDimension.acceleration>>) -> Quantity<NamedUnit<MathDimension.force>> {
        let massInKilograms = unit.converter.convertToBase(value)
        let acceleration = g.unit.converter.convertToBase(g.value)
        return Quantity<NamedUnit<MathDimension.force>>(value: massInKilograms * acceleration, unit: Units.newton)
    }

    /// The weight of this mass, expressed in a given force unit.
    ///
    /// - Parameter unit: A force unit to express the result in, such as
    ///   ``Units/poundForce`` or ``Units/newton``.
    /// - Returns: This quantity's weight at standard gravity, converted to `unit`.
    func weight(in unit: NamedUnit<MathDimension.force>) -> Quantity<NamedUnit<MathDimension.force>> {
        weight.converted(to: unit)
    }
}

