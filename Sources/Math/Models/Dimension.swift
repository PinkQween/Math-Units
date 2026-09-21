//
//  Dimension.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A type representing a physical dimension as a canonical dictionary of base SI dimension exponents.
///
/// A dimension describes *what is being measured*, independent of any unit. For
/// example, `length` and `time` are dimensions, while `meter` and `foot` are
/// units of the `length` dimension.
///
/// Internally, a ``PhysicalDimension`` is a dictionary mapping base dimension
/// names (like `"length"` and `"time"`) to their integer exponent powers.
/// This lets you compose dimensions mathematically: the `+` operator multiplies
/// dimensions (length + length → area), `-` divides them (length − time → speed),
/// and `*` with an `Int` raises a dimension to a power.
///
/// ```swift
/// let speed = PhysicalDimension.length - PhysicalDimension.time
/// let area = PhysicalDimension.length * 2
///
/// // You can also invent entirely new dimensions for your app:
/// let money = PhysicalDimension(exponents: ["USD": 1])
/// ```
///
/// The framework provides standardized values through static members such as
/// ``PhysicalDimension/length``, ``PhysicalDimension/speed``, and
/// ``PhysicalDimension/energy``.
///
/// - SeeAlso: ``MathDimension`` is the compile-time counterpart of this type,
///   used to enforce dimension correctness at build time.
public struct PhysicalDimension: Equatable, Hashable, Sendable, Codable {
    /// A dictionary mapping base dimensions (e.g., `"length"`, `"time"`) to their integer exponent powers.
    public let exponents: [String: Int]
    
    /// Initializes a dimension with an optional exponent mapping.
    ///
    /// Zero exponents are filtered out so that dimensions with the same
    /// physical meaning always compare equal.
    /// - Parameter exponents: A dictionary mapping dimension names to their
    ///   exponent powers, such as `["length": 1, "time": -1]`.
    public init(exponents: [String: Int] = [:]) {
        // Filter out zero exponents to keep representations canonical
        self.exponents = exponents.filter { $0.value != 0 }
    }
    
    /// Combines two dimensions by adding their exponents (dimensional multiplication).
    ///
    /// For example, `PhysicalDimension.length + PhysicalDimension.length`
    /// produces the `area` dimension.
    public static func + (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] += exp
        }
        return Self(exponents: newExponents)
    }
    
    /// Divides two dimensions by subtracting their exponents (dimensional division).
    ///
    /// For example, `PhysicalDimension.length - PhysicalDimension.time`
    /// produces the `speed` dimension.
    public static func - (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] -= exp
        }
        return Self(exponents: newExponents)
    }
    
    /// Scales a dimension's exponents by an integer (raising it to a power).
    ///
    /// For example, `2 * PhysicalDimension.length` produces the `area` dimension.
    public static func * (lhs: Int, rhs: Self) -> Self {
        let newExponents = rhs.exponents.mapValues { $0 * lhs }
        return Self(exponents: newExponents)
    }
    
    /// Commutative exponent scaling (e.g. Length * 2 -> Length^2).
    public static func * (lhs: Self, rhs: Int) -> Self {
        rhs * lhs
    }
    
    /// Reduces a dimension's exponents by an integer.
    public static func / (lhs: Self, rhs: Int) -> Self {
        let newExponents = lhs.exponents.mapValues { $0 / rhs }
        return Self(exponents: newExponents)
    }
    
    /// Multiplies two dimensions by adding their exponents.
    public static func * (lhs: Self, rhs: Self) -> Self {
        var newExponents = lhs.exponents
        for (dim, exp) in rhs.exponents {
            newExponents[dim, default: 0] += exp
        }
        return Self(exponents: newExponents)
    }
    
    /// Divides two dimensions by subtracting their exponents.
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
    private static var _currency: Self { Self(exponents: ["currency": 1]) }


    // SI Base Dimensions
    /// The dimension of dimensionless numbers (no exponents).
    public static var dimensionless: Self { _dimensionless }
    /// The dimension of length (SI base unit: meter).
    public static var length: Self { _length }
    /// The dimension of mass (SI base unit: kilogram).
    public static var mass: Self { _mass }
    /// The dimension of time (SI base unit: second).
    public static var time: Self { _time }
    /// The dimension of electric current (SI base unit: ampere).
    public static var electricCurrent: Self { _electricCurrent }
    /// The dimension of amount of substance (SI base unit: mole).
    public static var amountOfSubstance: Self { _amountOfSubstance }
    /// The dimension of luminous intensity (SI base unit: candela).
    public static var luminousIntensity: Self { _luminousIntensity }
    /// The dimension of digital information (amount of data).
    public static var data: Self { _data }
    
    // Common Derived Dimensions
    /// The dimension of area (`length²`).
    public static var area: Self { _area }
    /// The dimension of volume (`length³`).
    public static var volume: Self { _volume }
    /// The dimension of frequency (`1/time`).
    public static var frequency: Self { _frequency }
    /// The dimension of speed (`length / time`).
    public static var speed: Self { _speed }
    /// The dimension of acceleration (`speed / time`).
    public static var acceleration: Self { _acceleration }
    /// The dimension of force (`mass × acceleration`, SI unit: newton).
    public static var force: Self { _force }
    /// The dimension of energy (`force × length`, SI unit: joule).
    public static var energy: Self { _energy }
    /// The dimension of power (`energy / time`, SI unit: watt).
    public static var power: Self { _power }
    /// The dimension of luminosity (same as power).
    public static var luminosity: Self { _luminosity }
    /// The dimension of pressure (`force / area`, SI unit: pascal).
    public static var pressure: Self { _pressure }
    /// The dimension of electric charge (`time × electricCurrent`, SI unit: coulomb).
    public static var charge: Self { _charge }
    /// The dimension of electric potential (SI unit: volt).
    public static var voltage: Self { _voltage }
    /// The dimension of electrical resistance (SI unit: ohm).
    public static var resistance: Self { _resistance }
    /// The dimension of electrical inductance (SI unit: henry).
    public static var inductance: Self { _inductance }
    /// The dimension of electrical conductance (SI unit: siemens).
    public static var conductance: Self { _conductance }
    /// The dimension of electrical capacitance (SI unit: farad).
    public static var capacitance: Self { _capacitance }
    /// The dimension of area density (`mass / area`).
    public static var areaDensity: Self { _areaDensity }
    /// The dimension of volume density (`mass / volume`).
    public static var volumeDensity: Self { _volumeDensity }
    /// The dimension of surface energy (`energy / area`).
    public static var surfaceEnergy: Self { _surfaceEnergy }
    /// The dimension of specific energy (`energy / mass`).
    public static var specificEnergy: Self { _specificEnergy }
    /// The dimension of surface pressure (`pressure / area`).
    public static var surfacePressure: Self { _surfacePressure }
    /// The dimension of specific volume (`volume / mass`).
    public static var specificVolume: Self { _specificVolume }
    /// The dimension of data rate (`data + frequency`, e.g. bytes/second).
    public static var dataRate: Self { _dataRate }
    /// The dimension of magnetic flux (SI unit: weber).
    public static var magneticFlux: Self { _magneticFlux }
    /// The dimension of magnetic flux density (SI unit: tesla).
    public static var magneticFluxDensity: Self { _magneticFluxDensity }
    /// The dimension of luminous flux (SI unit: lumen).
    public static var luminousFlux: Self { _luminousFlux }
    /// The dimension of illuminance (SI unit: lux).
    public static var illuminance: Self { _illuminance }
    /// The dimension of currency.
    ///
    /// The framework treats currency as a first-class physical dimension so
    /// that unit conversion (and the type system) applies to money the same way
    /// it does to lengths and times. See ``Units`` for the available currencies.
    public static var currency: Self { _currency }
}

// MARK: - Dimension Namespace Enum for Type-Level Safety
/// A namespace containing type-level structures for compile-time physical dimension verification.
///
/// Every nested type conforms to ``DimensionProtocol`` and corresponds to a
/// ``PhysicalDimension``. Because each type is unique, you can parameterize
/// generic code (like ``NamedUnit``) with a dimension type and let the Swift
/// compiler enforce that only quantities of the matching dimension are accepted.
///
/// ```swift
/// func measure<U: MathUnit>(_ length: Quantity<U>)
/// where U.Dimension == MathDimension.length
/// ```
///
/// Prefer these types over the runtime ``PhysicalDimension`` values whenever you
/// want compile-time guarantees. See <doc:CompileTimeSafety> for a full guide.
public enum MathDimension {
    /// The compile-time dimension type representing dimensionless quantities.
    public struct dimensionless: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.dimensionless }
    }
    /// The compile-time dimension type representing length.
    public struct length: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.length }
    }
    /// The compile-time dimension type representing mass.
    public struct mass: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.mass }
    }
    /// The compile-time dimension type representing time.
    public struct time: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.time }
    }
    /// The compile-time dimension type representing electric current.
    public struct electricCurrent: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.electricCurrent }
    }
    /// The compile-time dimension type representing amount of substance.
    public struct amountOfSubstance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.amountOfSubstance }
    }
    /// The compile-time dimension type representing luminous intensity.
    public struct luminousIntensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.luminousIntensity }
    }
    /// The compile-time dimension type representing digital data.
    public struct data: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.data }
    }
    /// The compile-time dimension type representing area.
    public struct area: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.area }
    }
    /// The compile-time dimension type representing volume.
    public struct volume: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.volume }
    }
    /// The compile-time dimension type representing frequency.
    public struct frequency: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.frequency }
    }
    /// The compile-time dimension type representing speed.
    public struct speed: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.speed }
    }
    /// The compile-time dimension type representing acceleration.
    public struct acceleration: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.acceleration }
    }
    /// The compile-time dimension type representing force.
    public struct force: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.force }
    }
    /// The compile-time dimension type representing energy.
    public struct energy: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.energy }
    }
    /// The compile-time dimension type representing power.
    public struct power: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.power }
    }
    /// The compile-time dimension type representing luminosity.
    public struct luminosity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.luminosity }
    }
    /// The compile-time dimension type representing pressure.
    public struct pressure: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.pressure }
    }
    /// The compile-time dimension type representing electric charge.
    public struct charge: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.charge }
    }
    /// The compile-time dimension type representing electric potential (voltage).
    public struct voltage: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.voltage }
    }
    /// The compile-time dimension type representing electrical resistance.
    public struct resistance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.resistance }
    }
    /// The compile-time dimension type representing electrical inductance.
    public struct inductance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.inductance }
    }
    /// The compile-time dimension type representing electrical conductance.
    public struct conductance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.conductance }
    }
    /// The compile-time dimension type representing electrical capacitance.
    public struct capacitance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.capacitance }
    }
    /// The compile-time dimension type representing area density.
    public struct areaDensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.areaDensity }
    }
    /// The compile-time dimension type representing volume density.
    public struct volumeDensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.volumeDensity }
    }
    /// The compile-time dimension type representing surface energy.
    public struct surfaceEnergy: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.surfaceEnergy }
    }
    /// The compile-time dimension type representing specific energy.
    public struct specificEnergy: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.specificEnergy }
    }
    /// The compile-time dimension type representing surface pressure.
    public struct surfacePressure: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.surfacePressure }
    }
    /// The compile-time dimension type representing specific volume.
    public struct specificVolume: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.specificVolume }
    }
    /// The compile-time dimension type representing data rate.
    public struct dataRate: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.dataRate }
    }
    /// The compile-time dimension type representing magnetic flux.
    public struct magneticFlux: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.magneticFlux }
    }
    /// The compile-time dimension type representing magnetic flux density.
    public struct magneticFluxDensity: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.magneticFluxDensity }
    }
    /// The compile-time dimension type representing luminous flux.
    public struct luminousFlux: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.luminousFlux }
    }
    /// The compile-time dimension type representing illuminance.
    public struct illuminance: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.illuminance }
    }
    /// The compile-time dimension type representing currency.
    public struct currency: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.currency }
    }
    /// The compile-time dimension type used for dimensions that don't have a
    /// static type, such as custom dimensions created at runtime.
    ///
    /// See <doc:CustomDimensions> for examples.
    public struct unknown: DimensionProtocol {
        public static var dimension: PhysicalDimension { PhysicalDimension.dimensionless }
    }
}
