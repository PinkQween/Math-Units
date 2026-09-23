//
//  Units.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

/// A namespace of ready-made units for every dimension in the framework.
///
/// ``Units`` provides hundreds of predefined `NamedUnit` values—from base SI
/// units (`Units.meter`, `Units.second`, `Units.kelvin`) through derived units
/// (`Units.newton`, `Units.joule`, `Units.watt`), imperial and customary units
/// (`Units.inch`, `Units.mile`, `Units.pound`, `Units.gallon`), astronomy and
/// physics constants (`Units.lightYear`, `Units.planckLength`), digital data
/// (`Units.byte`, `Units.gibibyte`), world currencies (`Units.usd`), and even
/// a few playful ones (`Units.beardSecond`, `Units.micromort`).
///
/// Every unit is also grouped under a dimension-named namespace, so you can
/// browse or build a picker for a single dimension: ``Units/Volume`` contains
/// the volume units (`Units.Volume.cup`, `Units.Volume.liter`), ``Units/Mass``
/// the mass units, and ``Units/Weight`` the force units. `Units.units(for:)`
/// lists them at runtime. Inside a ``Quantity`` initializer you can reach the
/// same groups with leading-dot syntax: `Quantity(value: 1, unit: .volume.cup)`.
///
/// The namespaces keep mass and weight explicitly separate: `Units.Mass.ounce`
/// is the ounce of mass, while `Units.Weight.ounce` is the ounce-force. Every
/// avoirdupois mass unit has a matching force reading in ``Units/Weight``
/// (`pound`, `ounce`, `stone`, `shortTon`, `longTon`, `hundredweight`, ...),
/// and any mass quantity's weight can be computed as a force with
/// ``Quantity/weight`` — see <doc:UnitsByDimension>.
///
/// Use a unit to create a ``Quantity``:
///
/// ```swift
/// let marathon = Quantity(value: 42.195, unit: Units.kilometer)
/// let inMiles  = marathon.converted(to: Units.mile)
/// ```
///
/// Each unit is parameterized by its compile-time dimension type, so
/// `Units.meter` is a `NamedUnit<MathDimension.length>` and `Units.hour` is a
/// `NamedUnit<MathDimension.time>`—the compiler can catch mismatched dimensions
/// before your app runs (see <doc:CompileTimeSafety>).
public struct Units {
    // MARK: - Offset and Constant-based Units
    /// Degrees Celsius, modeled as a thermal-energy unit.
    ///
    /// The symbol is `°C`. Because temperature is an energy dimension, a Celsius
    /// quantity converts directly into joules (see ``Quantity/thermalEnergy``).
    public static let celsius = NamedUnit<MathDimension.energy>(
        symbol: "°C",
        dimension: .energy,
        converter: OffsetConverter(
            coefficient: 1.380649e-23,
            constant: 3.7712427435e-21
        )
    )

    /// Degrees Fahrenheit, modeled as a thermal-energy unit. The symbol is `°F`.
    public static let fahrenheit = NamedUnit<MathDimension.energy>(
        symbol: "°F",
        dimension: .energy,
        converter: OffsetConverter(
            coefficient: 7.6702722222e-24,
            constant: 3.5257930491e-21
        )
    )

    public static let planckLength = NamedUnit<MathDimension.length>(
        symbol: "l_P",
        dimension: .length,
        converter: LinearConverter(coefficient: 1.616255e-35)
    )
    
    public static let planckTime = NamedUnit<MathDimension.time>(
        symbol: "t_P",
        dimension: .time,
        converter: LinearConverter(coefficient: 5.391247e-44)
    )
    
    public static let planckMass = NamedUnit<MathDimension.mass>(
        symbol: "m_P",
        dimension: .mass,
        converter: LinearConverter(coefficient: 2.176434e-8)
    )
    
    public static let planckTemperature = NamedUnit<MathDimension.energy>(
        symbol: "T_P",
        dimension: .energy,
        converter: LinearConverter(coefficient: 1.9561e9)
    )
    
    // MARK: - Currencies
    
    public static let usd = NamedUnit<MathDimension.currency>(
        symbol: "$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 1.0)
    )
    
    public static let eur = NamedUnit<MathDimension.currency>(
        symbol: "€",
        dimension: .currency,
        converter: LinearConverter(coefficient: 1.08)
    )
    
    public static let jpy = NamedUnit<MathDimension.currency>(
        symbol: "¥",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.0064)
    )
    
    public static let gbp = NamedUnit<MathDimension.currency>(
        symbol: "£",
        dimension: .currency,
        converter: LinearConverter(coefficient: 1.27)
    )
    
    public static let aud = NamedUnit<MathDimension.currency>(
        symbol: "A$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.66)
    )
    
    public static let cad = NamedUnit<MathDimension.currency>(
        symbol: "C$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.73)
    )
    
    public static let chf = NamedUnit<MathDimension.currency>(
        symbol: "CHF",
        dimension: .currency,
        converter: LinearConverter(coefficient: 1.11)
    )
    
    public static let cny = NamedUnit<MathDimension.currency>(
        symbol: "¥",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.14)
    )
    
    public static let sek = NamedUnit<MathDimension.currency>(
        symbol: "kr",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.094),
        symbolPosition: .suffix
    )
    
    public static let nzd = NamedUnit<MathDimension.currency>(
        symbol: "NZ$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.61)
    )
    
    public static let mxn = NamedUnit<MathDimension.currency>(
        symbol: "$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.059)
    )
    
    public static let sgd = NamedUnit<MathDimension.currency>(
        symbol: "S$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.74)
    )
    
    public static let hkd = NamedUnit<MathDimension.currency>(
        symbol: "HK$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.13)
    )
    
    public static let nok = NamedUnit<MathDimension.currency>(
        symbol: "kr",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.094),
        symbolPosition: .suffix
    )
    
    public static let krw = NamedUnit<MathDimension.currency>(
        symbol: "₩",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.00073)
    )
    
    public static let `try` = NamedUnit<MathDimension.currency>(
        symbol: "₺",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.031)
    )
    
    public static let inr = NamedUnit<MathDimension.currency>(
        symbol: "₹",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.012)
    )
    
    public static let rub = NamedUnit<MathDimension.currency>(
        symbol: "₽",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.011)
    )
    
    public static let brl = NamedUnit<MathDimension.currency>(
        symbol: "R$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.19)
    )
    
    public static let zar = NamedUnit<MathDimension.currency>(
        symbol: "R",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.054)
    )
    
    public static let dkk = NamedUnit<MathDimension.currency>(
        symbol: "kr",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.15),
        symbolPosition: .suffix
    )
    
    public static let pln = NamedUnit<MathDimension.currency>(
        symbol: "zł",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.25),
        symbolPosition: .suffix
    )
    
    public static let twd = NamedUnit<MathDimension.currency>(
        symbol: "NT$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.031)
    )
    
    public static let thb = NamedUnit<MathDimension.currency>(
        symbol: "฿",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.027)
    )
    
    public static let idr = NamedUnit<MathDimension.currency>(
        symbol: "Rp",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.000062)
    )
    
    public static let huf = NamedUnit<MathDimension.currency>(
        symbol: "Ft",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.0028),
        symbolPosition: .suffix
    )
    
    public static let czk = NamedUnit<MathDimension.currency>(
        symbol: "Kč",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.043),
        symbolPosition: .suffix
    )
    
    public static let ils = NamedUnit<MathDimension.currency>(
        symbol: "₪",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.27)
    )
    
    public static let clp = NamedUnit<MathDimension.currency>(
        symbol: "$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.0011)
    )
    
    public static let php = NamedUnit<MathDimension.currency>(
        symbol: "₱",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.017)
    )
    
    public static let aed = NamedUnit<MathDimension.currency>(
        symbol: "AED",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.27)
    )
    
    public static let cop = NamedUnit<MathDimension.currency>(
        symbol: "$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.00026)
    )
    
    public static let sar = NamedUnit<MathDimension.currency>(
        symbol: "SR",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.27)
    )
    
    public static let myr = NamedUnit<MathDimension.currency>(
        symbol: "RM",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.21)
    )
    
    public static let ron = NamedUnit<MathDimension.currency>(
        symbol: "lei",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.22),
        symbolPosition: .suffix
    )
    
    public static let vnd = NamedUnit<MathDimension.currency>(
        symbol: "₫",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.000039)
    )
    
    public static let ars = NamedUnit<MathDimension.currency>(
        symbol: "$",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.0011)
    )
    
    public static let btc = NamedUnit<MathDimension.currency>(
        symbol: "₿",
        dimension: .currency,
        converter: LinearConverter(coefficient: 68000.0)
    )
    
    public static let eth = NamedUnit<MathDimension.currency>(
        symbol: "Ξ",
        dimension: .currency,
        converter: LinearConverter(coefficient: 3800.0)
    )

    // MARK: - Common-Name Currency Aliases

    // Colloquial names for currencies whose common name is unambiguous. Ambiguous
    // names such as "dollar" (USD/CAD/AUD/...) or "peso" (MXN/CLP/.../PHP) stay
    // explicit: use `Units.usd`, `Units.cad`, and so on.

    public static let pounds = gbp
    public static let poundsSterling = gbp
    public static let poundSterling = gbp
    public static let sterling = gbp
    public static let yen = jpy
    public static let yuan = cny
    public static let renminbi = cny
    public static let franc = chf
    public static let francs = chf
    public static let won = krw
    public static let rupee = inr
    public static let ruble = rub
    public static let rand = zar
    public static let real = brl
    public static let zloty = pln
    public static let baht = thb
    public static let koruna = czk
    public static let shekel = ils
    public static let dirham = aed
    public static let ringgit = myr
    public static let forint = huf
    public static let lira = `try`

    // MARK: - Context-Dependent Units

    // A single colloqial name can mean different physical things depending on
    // context, so the same word is available per dimension: `dram` is mass in
    // `Units.Mass`, the weight (force) equivalent in `Units.Weight`, and a
    // volume (`fluid dram`) in `Units.Volume`. Same for `ounce`/`pound` in Mass
    // vs Weight.

    /// The unit of force equal to the weight of one avoirdupois dram, i.e.
    /// 1/256 of a pound-force. The "weight" reading of `dram`, mirroring
    /// `Units.Mass.dram` (mass).
    public static let dramForce = NamedUnit<MathDimension.force>(
        symbol: "dramf",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.017375865684611328),
        symbolPosition: .suffix
    )

    // MARK: - Weight (Force) Readings of the Avoirdupois Mass Family

    // Weight is a force: W = mg. Each unit below is the standard-gravity weight
    // of its mass counterpart in `Units.Mass`, so `stoneForce` is the weight of
    // one stone (14 lbf), `hundredweightForce` of one short hundredweight
    // (100 lbf), and `longTonForce` of one long ton (2240 lbf). `Units.Weight`
    // exposes them so every common "weight" name has a force reading that is
    // genuinely in the force dimension instead of only existing as a mass.

    /// The force exerted by one gram at standard gravity — `0.001 kg × 9.80665 m/s²`
    /// = 9.80665 millinewton. The "weight" reading of `gram`.
    public static let gramForce = NamedUnit<MathDimension.force>(
        symbol: "gf",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.00980665),
        symbolPosition: .suffix
    )

    /// The force exerted by one avoirdupois grain at standard gravity, i.e.
    /// 1/7000 of a pound-force. The "weight" reading of `grain`.
    public static let grainForce = NamedUnit<MathDimension.force>(
        symbol: "grf",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.0006354602307515),
        symbolPosition: .suffix
    )

    /// The force exerted by one stone at standard gravity — 14 pound-force.
    /// The "weight" reading of `stone`.
    public static let stoneForce = NamedUnit<MathDimension.force>(
        symbol: "stf",
        dimension: .force,
        converter: LinearConverter(coefficient: 62.275102613647),
        symbolPosition: .suffix
    )

    /// The US short ton-force (2000 pound-force). Identical to ``Units/tonForce``
    /// and exposed under the mass name `shortTon` for symmetry.
    public static let shortTonForce = NamedUnit<MathDimension.force>(
        symbol: "stnf",
        dimension: .force,
        converter: LinearConverter(coefficient: 8896.443230521),
        symbolPosition: .suffix
    )

    /// The long (imperial) ton-force (2240 pound-force). The "weight" reading of
    /// ``Units/longTon``.
    public static let longTonForce = NamedUnit<MathDimension.force>(
        symbol: "ltnf",
        dimension: .force,
        converter: LinearConverter(coefficient: 9964.01641818352),
        symbolPosition: .suffix
    )

    /// The short (US) hundredweight-force — 100 pound-force. The "weight"
    /// reading of ``Units/hundredweight``.
    public static let hundredweightForce = NamedUnit<MathDimension.force>(
        symbol: "cwtf",
        dimension: .force,
        converter: LinearConverter(coefficient: 444.82216152605),
        symbolPosition: .suffix
    )

    /// The long (imperial) hundredweight-force — 112 pound-force. The "weight"
    /// reading of ``Units/longHundredweight``.
    public static let longHundredweightForce = NamedUnit<MathDimension.force>(
        symbol: "lcwtf",
        dimension: .force,
        converter: LinearConverter(coefficient: 498.200820909176),
        symbolPosition: .suffix
    )

    // MARK: - Weight (Force) Readings of the Troy and Jewelry Weight Families

    /// The force exerted by one troy ounce (31.1034768 g) at standard gravity.
    /// The "weight" reading of ``Units/troyOunce``.
    public static let troyOunceForce = NamedUnit<MathDimension.force>(
        symbol: "ozf_t",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.305020910760720),
        symbolPosition: .suffix
    )

    /// The force exerted by one troy pound (12 troy ounces) at standard gravity.
    /// The "weight" reading of ``Units/troyPound``.
    public static let troyPoundForce = NamedUnit<MathDimension.force>(
        symbol: "lbf_t",
        dimension: .force,
        converter: LinearConverter(coefficient: 3.660250929128640),
        symbolPosition: .suffix
    )

    /// The force exerted by one troy dram at standard gravity. The "weight"
    /// reading of ``Units/troyDram``.
    public static let troyDramForce = NamedUnit<MathDimension.force>(
        symbol: "drf_t",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.038127613845090),
        symbolPosition: .suffix
    )

    /// The force exerted by one pennyweight (24 troy grains) at standard
    /// gravity. The "weight" reading of ``Units/pennyweight``.
    public static let pennyweightForce = NamedUnit<MathDimension.force>(
        symbol: "dwtf",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.0152510455380360),
        symbolPosition: .suffix
    )

    /// The force exerted by one carat (200 milligrams) at standard gravity. The
    /// "weight" reading of ``Units/carat``.
    public static let caratForce = NamedUnit<MathDimension.force>(
        symbol: "ctf",
        dimension: .force,
        converter: LinearConverter(coefficient: 0.00196133),
        symbolPosition: .suffix
    )

    /// The US fluid dram, one eighth of a US fluid ounce (~3.7 mL).
    public static let fluidDram = NamedUnit<MathDimension.volume>(
        symbol: "fl_dr",
        dimension: .volume,
        converter: LinearConverter(coefficient: 3.6966911953125e-6),
        symbolPosition: .suffix
    )

    // MARK: - Explicit Mass Aliases

    // The avoirdupois pound and ounce really are units of mass (1 lb ≡ exactly
    // 0.45359237 kg), so the plain `Units.pound`/`Units.ounce` stay mass and
    // `Units.Weight.pound`/`Units.Weight.ounce` are pound-force/ounce-force.
    // These aliases make the mass reading unmistakable in code: `poundMass` is
    // `lbm` (pound-mass), distinct from `lbf` (pound-force).

    /// The avoirdupois pound-mass (`lbm`), exactly 0.45359237 kg. Same
    /// conversion as ``Units/pound``, with a name that cannot be confused with
    /// ``Units/poundForce``.
    public static let poundMass = NamedUnit<MathDimension.mass>(
        symbol: "lbm",
        dimension: .mass,
        converter: LinearConverter(coefficient: 0.45359237),
        symbolPosition: .suffix
    )

    /// The avoirdupois ounce-mass (`ozm`), exactly 1/16 of a pound-mass. Same
    /// conversion as ``Units/ounce``, with a name that cannot be confused with
    /// ``Units/ounceForce``.
    public static let ounceMass = NamedUnit<MathDimension.mass>(
        symbol: "ozm",
        dimension: .mass,
        converter: LinearConverter(coefficient: 0.028349523125),
        symbolPosition: .suffix
    )

    // MARK: - Decibel (Logarithmic) Units

    // Decibels are logarithmic, so every one of these uses a power-law
    // converter rather than a linear scale. Relative decibels are dimensionless
    // power ratios (10·log10); absolute scales fix a reference at the zero
    // reading, so converting dB → the linear base (ratio, watt, volt, pascal)
    // stays exact. Field (amplitude) decibels step by 10^(1/20) instead of the
    // 10^(1/10) used by power-ratio decibels.

    /// The bel, a dimensionless logarithmic power ratio: one bel is a factor of
    /// ten in power (`1 B = 10·log10(P₁/P₂)`).
    public static let bel = NamedUnit<MathDimension.dimensionless>(
        symbol: "B",
        dimension: .dimensionless,
        converter: PowerLawConverter(base: 10.0, reference: 1.0)
    )

    /// The decibel, one tenth of a bel — a dimensionless power ratio of
    /// `10·log10(P₁/P₂)`, so `10 dB` is a tenfold power increase.
    public static let decibel = NamedUnit<MathDimension.dimensionless>(
        symbol: "dB",
        dimension: .dimensionless,
        converter: PowerLawConverter(base: 1.2589254117941673, reference: 1.0)
    )

    /// The `dBm` scale: power in decibels relative to one milliwatt
    /// (`0 dBm = 1 mW`, `30 dBm = 1 W`).
    public static let decibelMilliwatt = NamedUnit<MathDimension.power>(
        symbol: "dBm",
        dimension: .power,
        converter: PowerLawConverter(base: 1.2589254117941673, reference: 1e-3)
    )

    /// The `dBW` scale: power in decibels relative to one watt (`0 dBW = 1 W`).
    public static let decibelWatt = NamedUnit<MathDimension.power>(
        symbol: "dBW",
        dimension: .power,
        converter: PowerLawConverter(base: 1.2589254117941673, reference: 1.0)
    )

    /// The `dBV` scale: voltage in decibels relative to one volt, using the
    /// field convention `20·log10(V)` (`0 dBV = 1 V`, `20 dBV = 10 V`).
    public static let decibelVolt = NamedUnit<MathDimension.voltage>(
        symbol: "dBV",
        dimension: .voltage,
        converter: PowerLawConverter(base: 1.1220184543019633, reference: 1.0)
    )

    /// The `dBµV` scale: voltage in decibels relative to one microvolt
    /// (`0 dBµV = 1 µV`, `120 dBµV = 1 V`), the basis of receiver and
    /// antenna sensitivity measurements.
    public static let decibelMicrovolt = NamedUnit<MathDimension.voltage>(
        symbol: "dBµV",
        dimension: .voltage,
        converter: PowerLawConverter(base: 1.1220184543019633, reference: 1e-6)
    )

    /// The `dB SPL` scale: sound pressure level in decibels relative to the
    /// reference pressure of 20 µPa (`0 dB SPL` is the threshold of hearing,
    /// `94 dB SPL ≈ 1 Pa`).
    public static let decibelSoundPressureLevel = NamedUnit<MathDimension.pressure>(
        symbol: "dBSPL",
        dimension: .pressure,
        converter: PowerLawConverter(base: 1.1220184543019633, reference: 2e-5)
    )

    // Convenience abbreviations for the absolute scales.
    public static let dBm = decibelMilliwatt
    public static let dBW = decibelWatt
    public static let dBV = decibelVolt
    public static let dBSPL = decibelSoundPressureLevel

    // MARK: - Currency Resolution

    /// A dictionary mapping ISO 4217 uppercase currency codes to their corresponding ``NamedUnit``.
    ///
    /// Includes both fiat currencies (`"USD"`, `"EUR"`, ...) and cryptocurrencies
    /// (`"BTC"`, `"ETH"`).
    public static let currencyByCode: [String: NamedUnit<MathDimension.currency>] = [
        "USD": usd, "EUR": eur, "JPY": jpy, "GBP": gbp, "AUD": aud, "CAD": cad,
        "CHF": chf, "CNY": cny, "SEK": sek, "NZD": nzd, "MXN": mxn, "SGD": sgd,
        "HKD": hkd, "NOK": nok, "KRW": krw, "TRY": `try`, "INR": inr, "RUB": rub,
        "BRL": brl, "ZAR": zar, "DKK": dkk, "PLN": pln, "TWD": twd, "THB": thb,
        "IDR": idr, "HUF": huf, "CZK": czk, "ILS": ils, "CLP": clp, "PHP": php,
        "AED": aed, "COP": cop, "SAR": sar, "MYR": myr, "RON": ron, "VND": vnd,
        "ARS": ars, "BTC": btc, "ETH": eth
    ]

    /// Resolves an ISO 4217 currency code (case-insensitive) to a ``NamedUnit``
    /// for the currency dimension.
    ///
    /// Use this when you receive a currency code at runtime, for example from a
    /// `Locale` or a server response:
    ///
    /// ```swift
    /// if let unit = Units.currency(for: "SEK") {
    ///     let amount = Quantity(value: 250, unit: unit)
    ///     print(amount.formatted()) // "250.00 kr"
    /// }
    /// ```
    ///
    /// - Parameter code: An ISO 4217 currency code such as `"USD"`, `"eur"`,
    ///   or `"BTC"`. The lookup is case-insensitive.
    /// - Returns: The matching currency unit, or `nil` if the code is unknown.
    public static func currency(for code: String) -> NamedUnit<MathDimension.currency>? {
        currencyByCode[code.uppercased()]
    }

    private init() {}
}

// MARK: - Units by Dimension

// The generated namespace groups (Units.Volume, Units.Length, Units.Energy, ...)
// are produced by units.sh for the units in units.txt. The currency dimension is
// hand-maintained below. Offset/temperature units (celsius, fahrenheit, and the
// planck constants) are added to their generated dimension namespaces by hand.

public extension Units {
    /// Units of the `currency` dimension, indexed by ISO code.
    ///
    /// Conforms to `MathUnit` only so leading-dot lookups like
    /// `Quantity(value: 100, unit: .currency.usd)` resolve; the instance members
    /// are never used.
    enum Currency: MathUnit {
        public typealias Dimension = MathDimension.currency

        // Browse-only marker; never instantiated.
        public var symbol: String { "" }
        public var dimension: PhysicalDimension { .currency }
        public var converter: any UnitConverter { EmptyConverter() }
        public var base: Self { fatalError("Unit namespaces cannot be used as standalone units") }

        public static let usd = Units.usd
        public static let eur = Units.eur
        public static let jpy = Units.jpy
        public static let gbp = Units.gbp
        public static let aud = Units.aud
        public static let cad = Units.cad
        public static let chf = Units.chf
        public static let cny = Units.cny
        public static let sek = Units.sek
        public static let nzd = Units.nzd
        public static let mxn = Units.mxn
        public static let sgd = Units.sgd
        public static let hkd = Units.hkd
        public static let nok = Units.nok
        public static let krw = Units.krw
        public static let `try` = Units.`try`
        public static let inr = Units.inr
        public static let rub = Units.rub
        public static let brl = Units.brl
        public static let zar = Units.zar
        public static let dkk = Units.dkk
        public static let pln = Units.pln
        public static let twd = Units.twd
        public static let thb = Units.thb
        public static let idr = Units.idr
        public static let huf = Units.huf
        public static let czk = Units.czk
        public static let ils = Units.ils
        public static let clp = Units.clp
        public static let php = Units.php
        public static let aed = Units.aed
        public static let cop = Units.cop
        public static let sar = Units.sar
        public static let myr = Units.myr
        public static let ron = Units.ron
        public static let vnd = Units.vnd
        public static let ars = Units.ars
        public static let btc = Units.btc
        public static let eth = Units.eth

        // Common-name aliases for currencies whose name is unambiguous. Ambiguous
        // names ("dollar", "peso", "krona") stay explicit: use `usd`, `cad`, ...
        public static let pounds = Units.pounds
        public static let poundsSterling = Units.poundsSterling
        public static let poundSterling = Units.poundSterling
        public static let sterling = Units.sterling
        public static let yen = Units.yen
        public static let yuan = Units.yuan
        public static let renminbi = Units.renminbi
        public static let franc = Units.franc
        public static let francs = Units.francs
        public static let won = Units.won
        public static let rupee = Units.rupee
        public static let ruble = Units.ruble
        public static let rand = Units.rand
        public static let real = Units.real
        public static let zloty = Units.zloty
        public static let baht = Units.baht
        public static let koruna = Units.koruna
        public static let shekel = Units.shekel
        public static let dirham = Units.dirham
        public static let ringgit = Units.ringgit
        public static let forint = Units.forint
        public static let lira = Units.lira

        /// All currency units.
        public static let all: [any MathUnit] = [
            usd, eur, jpy, gbp, aud, cad, chf, cny, sek, nzd, mxn, sgd, hkd,
            nok, krw, `try`, inr, rub, brl, zar, dkk, pln, twd, thb, idr, huf,
            czk, ils, clp, php, aed, cop, sar, myr, ron, vnd, ars, btc, eth
        ]
    }

    /// Returns every base unit of a dimension, for pickers and listings. The
    /// list is dimension-scoped and split so that mass and weight (force) can
    /// never be mixed up: `Units.units(for:)` only returns mass units when asked
    /// for the mass dimension, and only force (weight) units when asked for the
    /// force dimension.
    public static func units(for dimension: PhysicalDimension) -> [any MathUnit] {
        if dimension == .length { return Units.Length.all }
        if dimension == .time { return Units.Time.all }
        if dimension == .mass { return Units.Mass.all + Units.Mass.extras }
        if dimension == .area { return Units.Area.all }
        if dimension == .data { return Units.Data.all }
        if dimension == .energy { return Units.Energy.all + Units.Energy.extras }
        if dimension == .force { return Units.Weight.all + Units.Weight.extras }
        if dimension == .pressure { return Units.Pressure.all + Units.Pressure.extras }
        if dimension == .power { return Units.Power.all + Units.Power.extras }
        if dimension == .speed { return Units.Speed.all }
        if dimension == .acceleration { return Units.Acceleration.all }
        if dimension == .electricCurrent { return Units.ElectricCurrent.all }
        if dimension == .charge { return Units.Charge.all }
        if dimension == .voltage { return Units.Voltage.all + Units.Voltage.extras }
        if dimension == .resistance { return Units.Resistance.all }
        if dimension == .capacitance { return Units.Capacitance.all }
        if dimension == .inductance { return Units.Inductance.all }
        if dimension == .conductance { return Units.Conductance.all }
        if dimension == .frequency { return Units.Frequency.all }
        if dimension == .luminousIntensity { return Units.LuminousIntensity.all }
        if dimension == .magneticFlux { return Units.MagneticFlux.all }
        if dimension == .magneticFluxDensity { return Units.MagneticFluxDensity.all }
        if dimension == .luminousFlux { return Units.LuminousFlux.all }
        if dimension == .illuminance { return Units.Illuminance.all }
        if dimension == .specificEnergy { return Units.SpecificEnergy.all }
        if dimension == .amountOfSubstance { return Units.AmountOfSubstance.all }
        if dimension == .dimensionless { return Units.Dimensionless.all + Units.Dimensionless.extras }
        if dimension == .volume { return Units.Volume.all + Units.Volume.extras }
        if dimension == .currency { return Units.Currency.all }
        return []
    }
}

// Planck constants are part of their dimension namespaces even though the
// generated catalog keeps them separate.
public extension Units.Length {
    static let planckLength = Units.planckLength
}

public extension Units.Time {
    static let planckTime = Units.planckTime
}

public extension Units.Mass {
    static let planckMass = Units.planckMass
}

/// The generated ``Units.Energy`` namespace holds the catalog energy units
/// (joule, calorie, ...). The temperature scales use offset converters, so they
/// are added by hand here, complete with an `extras` list for
/// `Units.units(for:)`.
public extension Units.Energy {
    static let celsius = Units.celsius
    static let fahrenheit = Units.fahrenheit
    static let planckTemperature = Units.planckTemperature

    /// The temperature-scale units not represented in ``Units/Energy/all``.
    static let extras: [any MathUnit] = [celsius, fahrenheit, planckTemperature]
}

/// Colloquial weight names. Every one is a force unit, not mass: `ounce` here is
/// ounce-force, `pound` is pound-force, `stone` is stone-force, and so on. For
/// the mass units use the sibling namespace `Units.Mass` — `Units.Mass.ounce`,
/// `Units.Mass.pound`, `Units.Mass.stone`, … The weight of any mass is `W = mg`
/// (see ``Quantity/weight``).
public extension Units.Weight {
    static let gram = Units.gramForce
    static let ounce = Units.ounceForce
    static let pound = Units.poundForce
    static let dram = Units.dramForce
    static let grain = Units.grainForce
    static let stone = Units.stoneForce
    static let shortTon = Units.shortTonForce
    static let longTon = Units.longTonForce
    static let hundredweight = Units.hundredweightForce
    static let longHundredweight = Units.longHundredweightForce
    static let troyOunce = Units.troyOunceForce
    static let troyPound = Units.troyPoundForce
    static let troyDram = Units.troyDramForce
    static let pennyweight = Units.pennyweightForce
    static let carat = Units.caratForce

    /// The colloquial weight-force units not represented in ``Units/Weight/all``.
    static let extras: [any MathUnit] = [
        gram, dram, grain, stone, shortTon, longTon, hundredweight, longHundredweight,
        troyOunce, troyPound, troyDram, pennyweight, carat
    ]
}

/// Explicit mass aliases for the pounds and ounces that share a name with their
/// force readings. `poundMass` is `lbm`, `ounceMass` is `ozm`.
public extension Units.Mass {
    static let poundMass = Units.poundMass
    static let ounceMass = Units.ounceMass

    /// The explicit mass aliases not represented in ``Units/Mass/all``.
    static let extras: [any MathUnit] = [poundMass, ounceMass]
}

/// The volume reading of dram. `Units.Volume.dram` (and `.fluidDram`) is the US
/// fluid dram, one eighth of a US fluid ounce — distinct from the mass `dram`
/// in ``Units.Mass`` and the weight (force) `dram` in ``Units.Weight``.
public extension Units.Volume {
    static let fluidDram = Units.fluidDram
    static let dram = Units.fluidDram

    /// The hand-built volume units not represented in ``Units/Volume/all``.
    static let extras: [any MathUnit] = [fluidDram]
}

// MARK: - Decibel Namespaces

// Relative decibels are dimensionless; the absolute scales belong to their
// physical dimension (power, voltage, pressure). Each namespace gets an
// `extras` list so ``Units.units(for:)`` pickers include them.

public extension Units.Dimensionless {
    static let bel = Units.bel
    static let decibel = Units.decibel

    /// The dimensionless decibel scales not represented in ``Units/Dimensionless/all``.
    static let extras: [any MathUnit] = [bel, decibel]
}

public extension Units.Power {
    static let decibelMilliwatt = Units.decibelMilliwatt
    static let decibelWatt = Units.decibelWatt

    /// The logarithmic power scales not represented in ``Units/Power/all``.
    static let extras: [any MathUnit] = [decibelMilliwatt, decibelWatt]
}

public extension Units.Voltage {
    static let decibelVolt = Units.decibelVolt
    static let decibelMicrovolt = Units.decibelMicrovolt

    /// The logarithmic voltage scales not represented in ``Units/Voltage/all``.
    static let extras: [any MathUnit] = [decibelVolt, decibelMicrovolt]
}

public extension Units.Pressure {
    static let decibelSoundPressureLevel = Units.decibelSoundPressureLevel

    /// The logarithmic pressure scales not represented in ``Units/Pressure/all``.
    static let extras: [any MathUnit] = [decibelSoundPressureLevel]
}

// MARK: - Dimension-Scoped Member Lookup

// The generated namespaces (Units.Length, Units.Volume, ...) emit a
// `where Self == Units.X` proxy on MathUnit from units.sh, so leading-dot unit
// access like `Quantity(value: 2, unit: .volume.fluidOunce)` type-checks: the
// `unit:` parameter is a generic `U: MathUnit`, and Swift's implicit member
// lookup (SE-0299) resolves the first member (`.volume`) through the constrained
// extension, returning the namespace metatype for the second member
// (`.fluidOunce`) to chain onto. The hand-maintained currency namespace gets its
// proxy here.

public extension MathUnit where Self == Units.Currency {
    /// The `currency` unit namespace, e.g. `Units.Currency.usd`.
    static var currency: Units.Currency.Type { Units.Currency.self }

    static var usd: NamedUnit<MathDimension.currency> { Units.usd }
    static var eur: NamedUnit<MathDimension.currency> { Units.eur }
    static var jpy: NamedUnit<MathDimension.currency> { Units.jpy }
    static var gbp: NamedUnit<MathDimension.currency> { Units.gbp }
    static var aud: NamedUnit<MathDimension.currency> { Units.aud }
    static var cad: NamedUnit<MathDimension.currency> { Units.cad }
    static var chf: NamedUnit<MathDimension.currency> { Units.chf }
    static var cny: NamedUnit<MathDimension.currency> { Units.cny }
    static var sek: NamedUnit<MathDimension.currency> { Units.sek }
    static var nzd: NamedUnit<MathDimension.currency> { Units.nzd }
    static var mxn: NamedUnit<MathDimension.currency> { Units.mxn }
    static var sgd: NamedUnit<MathDimension.currency> { Units.sgd }
    static var hkd: NamedUnit<MathDimension.currency> { Units.hkd }
    static var nok: NamedUnit<MathDimension.currency> { Units.nok }
    static var krw: NamedUnit<MathDimension.currency> { Units.krw }
    static var `try`: NamedUnit<MathDimension.currency> { Units.`try` }
    static var inr: NamedUnit<MathDimension.currency> { Units.inr }
    static var rub: NamedUnit<MathDimension.currency> { Units.rub }
    static var brl: NamedUnit<MathDimension.currency> { Units.brl }
    static var zar: NamedUnit<MathDimension.currency> { Units.zar }
    static var dkk: NamedUnit<MathDimension.currency> { Units.dkk }
    static var pln: NamedUnit<MathDimension.currency> { Units.pln }
    static var twd: NamedUnit<MathDimension.currency> { Units.twd }
    static var thb: NamedUnit<MathDimension.currency> { Units.thb }
    static var idr: NamedUnit<MathDimension.currency> { Units.idr }
    static var huf: NamedUnit<MathDimension.currency> { Units.huf }
    static var czk: NamedUnit<MathDimension.currency> { Units.czk }
    static var ils: NamedUnit<MathDimension.currency> { Units.ils }
    static var clp: NamedUnit<MathDimension.currency> { Units.clp }
    static var php: NamedUnit<MathDimension.currency> { Units.php }
    static var aed: NamedUnit<MathDimension.currency> { Units.aed }
    static var cop: NamedUnit<MathDimension.currency> { Units.cop }
    static var sar: NamedUnit<MathDimension.currency> { Units.sar }
    static var myr: NamedUnit<MathDimension.currency> { Units.myr }
    static var ron: NamedUnit<MathDimension.currency> { Units.ron }
    static var vnd: NamedUnit<MathDimension.currency> { Units.vnd }
    static var ars: NamedUnit<MathDimension.currency> { Units.ars }
    static var btc: NamedUnit<MathDimension.currency> { Units.btc }
    static var eth: NamedUnit<MathDimension.currency> { Units.eth }

    // Common-name aliases. Ambiguous names ("dollar", "peso", "krona") are left
    // out on purpose: use `.usd`, `.cad`, or `.currency.usd` for those.
    static var pounds: NamedUnit<MathDimension.currency> { Units.pounds }
    static var poundsSterling: NamedUnit<MathDimension.currency> { Units.poundsSterling }
    static var poundSterling: NamedUnit<MathDimension.currency> { Units.poundSterling }
    static var sterling: NamedUnit<MathDimension.currency> { Units.sterling }
    static var yen: NamedUnit<MathDimension.currency> { Units.yen }
    static var yuan: NamedUnit<MathDimension.currency> { Units.yuan }
    static var renminbi: NamedUnit<MathDimension.currency> { Units.renminbi }
    static var franc: NamedUnit<MathDimension.currency> { Units.franc }
    static var francs: NamedUnit<MathDimension.currency> { Units.francs }
    static var won: NamedUnit<MathDimension.currency> { Units.won }
    static var rupee: NamedUnit<MathDimension.currency> { Units.rupee }
    static var ruble: NamedUnit<MathDimension.currency> { Units.ruble }
    static var rand: NamedUnit<MathDimension.currency> { Units.rand }
    static var real: NamedUnit<MathDimension.currency> { Units.real }
    static var zloty: NamedUnit<MathDimension.currency> { Units.zloty }
    static var baht: NamedUnit<MathDimension.currency> { Units.baht }
    static var koruna: NamedUnit<MathDimension.currency> { Units.koruna }
    static var shekel: NamedUnit<MathDimension.currency> { Units.shekel }
    static var dirham: NamedUnit<MathDimension.currency> { Units.dirham }
    static var ringgit: NamedUnit<MathDimension.currency> { Units.ringgit }
    static var forint: NamedUnit<MathDimension.currency> { Units.forint }
    static var lira: NamedUnit<MathDimension.currency> { Units.lira }
}

// MARK: - Decibel Leading-Dot Lookup

public extension MathUnit where Self == Units.Dimensionless {
    static var bel: NamedUnit<MathDimension.dimensionless> { Units.bel }
    static var decibel: NamedUnit<MathDimension.dimensionless> { Units.decibel }
}

// MARK: - Mass Alias Leading-Dot Lookup

public extension MathUnit where Self == Units.Mass {
    static var poundMass: NamedUnit<MathDimension.mass> { Units.poundMass }
    static var ounceMass: NamedUnit<MathDimension.mass> { Units.ounceMass }
}

public extension MathUnit where Self == Units.Power {
    static var decibelMilliwatt: NamedUnit<MathDimension.power> { Units.decibelMilliwatt }
    static var decibelWatt: NamedUnit<MathDimension.power> { Units.decibelWatt }
}

public extension MathUnit where Self == Units.Voltage {
    static var decibelVolt: NamedUnit<MathDimension.voltage> { Units.decibelVolt }
    static var decibelMicrovolt: NamedUnit<MathDimension.voltage> { Units.decibelMicrovolt }
}

public extension MathUnit where Self == Units.Pressure {
    static var decibelSoundPressureLevel: NamedUnit<MathDimension.pressure> { Units.decibelSoundPressureLevel }
}

// MARK: - Concrete Unit Type Namespace Lookup

// The `Self == Units.X` proxies above let a leading-dot chain start from an
// open generic `U: MathUnit`. When the unit type is *already decided* (an
// annotated constant, or a generic parameter pinned by surrounding code like
// `Quantity<RatioUnit<NamedUnit<...>, Amount>>`), SE-0299 instead looks the
// first member up on the concrete type — so the three library unit types get
// the same namespace accessors directly. This is what lets
// `.currency.usd.per(.weight.pound)` type-check in a fully-typed context.
public extension NamedUnit {
    /// The `Length` unit namespace, e.g. `Units.Length.all`.
    static var length: Units.Length.Type { Units.Length.self }
    /// The `Time` unit namespace, e.g. `Units.Time.all`.
    static var time: Units.Time.Type { Units.Time.self }
    /// The `Mass` unit namespace, e.g. `Units.Mass.all`.
    static var mass: Units.Mass.Type { Units.Mass.self }
    /// The `Weight` (force) unit namespace, e.g. `Units.Weight.all`.
    static var weight: Units.Weight.Type { Units.Weight.self }
    /// The `Currency` unit namespace, e.g. `Units.Currency.usd`.
    static var currency: Units.Currency.Type { Units.Currency.self }
    /// The `Area` unit namespace, e.g. `Units.Area.all`.
    static var area: Units.Area.Type { Units.Area.self }
    /// The `Data` unit namespace, e.g. `Units.Data.all`.
    static var data: Units.Data.Type { Units.Data.self }
    /// The `Energy` unit namespace, e.g. `Units.Energy.all`.
    static var energy: Units.Energy.Type { Units.Energy.self }
    /// The `Pressure` unit namespace, e.g. `Units.Pressure.all`.
    static var pressure: Units.Pressure.Type { Units.Pressure.self }
    /// The `Power` unit namespace, e.g. `Units.Power.all`.
    static var power: Units.Power.Type { Units.Power.self }
    /// The `Speed` unit namespace, e.g. `Units.Speed.all`.
    static var speed: Units.Speed.Type { Units.Speed.self }
    /// The `Acceleration` unit namespace, e.g. `Units.Acceleration.all`.
    static var acceleration: Units.Acceleration.Type { Units.Acceleration.self }
    /// The `ElectricCurrent` unit namespace, e.g. `Units.ElectricCurrent.all`.
    static var electricCurrent: Units.ElectricCurrent.Type { Units.ElectricCurrent.self }
    /// The `Charge` unit namespace, e.g. `Units.Charge.all`.
    static var charge: Units.Charge.Type { Units.Charge.self }
    /// The `Voltage` unit namespace, e.g. `Units.Voltage.all`.
    static var voltage: Units.Voltage.Type { Units.Voltage.self }
    /// The `Resistance` unit namespace, e.g. `Units.Resistance.all`.
    static var resistance: Units.Resistance.Type { Units.Resistance.self }
    /// The `Capacitance` unit namespace, e.g. `Units.Capacitance.all`.
    static var capacitance: Units.Capacitance.Type { Units.Capacitance.self }
    /// The `Inductance` unit namespace, e.g. `Units.Inductance.all`.
    static var inductance: Units.Inductance.Type { Units.Inductance.self }
    /// The `Conductance` unit namespace, e.g. `Units.Conductance.all`.
    static var conductance: Units.Conductance.Type { Units.Conductance.self }
    /// The `Frequency` unit namespace, e.g. `Units.Frequency.all`.
    static var frequency: Units.Frequency.Type { Units.Frequency.self }
    /// The `LuminousIntensity` unit namespace, e.g. `Units.LuminousIntensity.all`.
    static var luminousIntensity: Units.LuminousIntensity.Type { Units.LuminousIntensity.self }
    /// The `MagneticFlux` unit namespace, e.g. `Units.MagneticFlux.all`.
    static var magneticFlux: Units.MagneticFlux.Type { Units.MagneticFlux.self }
    /// The `MagneticFluxDensity` unit namespace, e.g. `Units.MagneticFluxDensity.all`.
    static var magneticFluxDensity: Units.MagneticFluxDensity.Type { Units.MagneticFluxDensity.self }
    /// The `LuminousFlux` unit namespace, e.g. `Units.LuminousFlux.all`.
    static var luminousFlux: Units.LuminousFlux.Type { Units.LuminousFlux.self }
    /// The `Illuminance` unit namespace, e.g. `Units.Illuminance.all`.
    static var illuminance: Units.Illuminance.Type { Units.Illuminance.self }
    /// The `SpecificEnergy` unit namespace, e.g. `Units.SpecificEnergy.all`.
    static var specificEnergy: Units.SpecificEnergy.Type { Units.SpecificEnergy.self }
    /// The `AmountOfSubstance` unit namespace, e.g. `Units.AmountOfSubstance.all`.
    static var amountOfSubstance: Units.AmountOfSubstance.Type { Units.AmountOfSubstance.self }
    /// The `Dimensionless` unit namespace, e.g. `Units.Dimensionless.all`.
    static var dimensionless: Units.Dimensionless.Type { Units.Dimensionless.self }
    /// The `Volume` unit namespace, e.g. `Units.Volume.all`.
    static var volume: Units.Volume.Type { Units.Volume.self }
}

public extension RatioUnit {
    /// The `Length` unit namespace, e.g. `Units.Length.all`.
    static var length: Units.Length.Type { Units.Length.self }
    /// The `Time` unit namespace, e.g. `Units.Time.all`.
    static var time: Units.Time.Type { Units.Time.self }
    /// The `Mass` unit namespace, e.g. `Units.Mass.all`.
    static var mass: Units.Mass.Type { Units.Mass.self }
    /// The `Weight` (force) unit namespace, e.g. `Units.Weight.all`.
    static var weight: Units.Weight.Type { Units.Weight.self }
    /// The `Currency` unit namespace, e.g. `Units.Currency.usd`.
    static var currency: Units.Currency.Type { Units.Currency.self }
    /// The `Area` unit namespace, e.g. `Units.Area.all`.
    static var area: Units.Area.Type { Units.Area.self }
    /// The `Data` unit namespace, e.g. `Units.Data.all`.
    static var data: Units.Data.Type { Units.Data.self }
    /// The `Energy` unit namespace, e.g. `Units.Energy.all`.
    static var energy: Units.Energy.Type { Units.Energy.self }
    /// The `Pressure` unit namespace, e.g. `Units.Pressure.all`.
    static var pressure: Units.Pressure.Type { Units.Pressure.self }
    /// The `Power` unit namespace, e.g. `Units.Power.all`.
    static var power: Units.Power.Type { Units.Power.self }
    /// The `Speed` unit namespace, e.g. `Units.Speed.all`.
    static var speed: Units.Speed.Type { Units.Speed.self }
    /// The `Acceleration` unit namespace, e.g. `Units.Acceleration.all`.
    static var acceleration: Units.Acceleration.Type { Units.Acceleration.self }
    /// The `ElectricCurrent` unit namespace, e.g. `Units.ElectricCurrent.all`.
    static var electricCurrent: Units.ElectricCurrent.Type { Units.ElectricCurrent.self }
    /// The `Charge` unit namespace, e.g. `Units.Charge.all`.
    static var charge: Units.Charge.Type { Units.Charge.self }
    /// The `Voltage` unit namespace, e.g. `Units.Voltage.all`.
    static var voltage: Units.Voltage.Type { Units.Voltage.self }
    /// The `Resistance` unit namespace, e.g. `Units.Resistance.all`.
    static var resistance: Units.Resistance.Type { Units.Resistance.self }
    /// The `Capacitance` unit namespace, e.g. `Units.Capacitance.all`.
    static var capacitance: Units.Capacitance.Type { Units.Capacitance.self }
    /// The `Inductance` unit namespace, e.g. `Units.Inductance.all`.
    static var inductance: Units.Inductance.Type { Units.Inductance.self }
    /// The `Conductance` unit namespace, e.g. `Units.Conductance.all`.
    static var conductance: Units.Conductance.Type { Units.Conductance.self }
    /// The `Frequency` unit namespace, e.g. `Units.Frequency.all`.
    static var frequency: Units.Frequency.Type { Units.Frequency.self }
    /// The `LuminousIntensity` unit namespace, e.g. `Units.LuminousIntensity.all`.
    static var luminousIntensity: Units.LuminousIntensity.Type { Units.LuminousIntensity.self }
    /// The `MagneticFlux` unit namespace, e.g. `Units.MagneticFlux.all`.
    static var magneticFlux: Units.MagneticFlux.Type { Units.MagneticFlux.self }
    /// The `MagneticFluxDensity` unit namespace, e.g. `Units.MagneticFluxDensity.all`.
    static var magneticFluxDensity: Units.MagneticFluxDensity.Type { Units.MagneticFluxDensity.self }
    /// The `LuminousFlux` unit namespace, e.g. `Units.LuminousFlux.all`.
    static var luminousFlux: Units.LuminousFlux.Type { Units.LuminousFlux.self }
    /// The `Illuminance` unit namespace, e.g. `Units.Illuminance.all`.
    static var illuminance: Units.Illuminance.Type { Units.Illuminance.self }
    /// The `SpecificEnergy` unit namespace, e.g. `Units.SpecificEnergy.all`.
    static var specificEnergy: Units.SpecificEnergy.Type { Units.SpecificEnergy.self }
    /// The `AmountOfSubstance` unit namespace, e.g. `Units.AmountOfSubstance.all`.
    static var amountOfSubstance: Units.AmountOfSubstance.Type { Units.AmountOfSubstance.self }
    /// The `Dimensionless` unit namespace, e.g. `Units.Dimensionless.all`.
    static var dimensionless: Units.Dimensionless.Type { Units.Dimensionless.self }
    /// The `Volume` unit namespace, e.g. `Units.Volume.all`.
    static var volume: Units.Volume.Type { Units.Volume.self }
}

public extension CompositeUnit {
    /// The `Length` unit namespace, e.g. `Units.Length.all`.
    static var length: Units.Length.Type { Units.Length.self }
    /// The `Time` unit namespace, e.g. `Units.Time.all`.
    static var time: Units.Time.Type { Units.Time.self }
    /// The `Mass` unit namespace, e.g. `Units.Mass.all`.
    static var mass: Units.Mass.Type { Units.Mass.self }
    /// The `Weight` (force) unit namespace, e.g. `Units.Weight.all`.
    static var weight: Units.Weight.Type { Units.Weight.self }
    /// The `Currency` unit namespace, e.g. `Units.Currency.usd`.
    static var currency: Units.Currency.Type { Units.Currency.self }
    /// The `Area` unit namespace, e.g. `Units.Area.all`.
    static var area: Units.Area.Type { Units.Area.self }
    /// The `Data` unit namespace, e.g. `Units.Data.all`.
    static var data: Units.Data.Type { Units.Data.self }
    /// The `Energy` unit namespace, e.g. `Units.Energy.all`.
    static var energy: Units.Energy.Type { Units.Energy.self }
    /// The `Pressure` unit namespace, e.g. `Units.Pressure.all`.
    static var pressure: Units.Pressure.Type { Units.Pressure.self }
    /// The `Power` unit namespace, e.g. `Units.Power.all`.
    static var power: Units.Power.Type { Units.Power.self }
    /// The `Speed` unit namespace, e.g. `Units.Speed.all`.
    static var speed: Units.Speed.Type { Units.Speed.self }
    /// The `Acceleration` unit namespace, e.g. `Units.Acceleration.all`.
    static var acceleration: Units.Acceleration.Type { Units.Acceleration.self }
    /// The `ElectricCurrent` unit namespace, e.g. `Units.ElectricCurrent.all`.
    static var electricCurrent: Units.ElectricCurrent.Type { Units.ElectricCurrent.self }
    /// The `Charge` unit namespace, e.g. `Units.Charge.all`.
    static var charge: Units.Charge.Type { Units.Charge.self }
    /// The `Voltage` unit namespace, e.g. `Units.Voltage.all`.
    static var voltage: Units.Voltage.Type { Units.Voltage.self }
    /// The `Resistance` unit namespace, e.g. `Units.Resistance.all`.
    static var resistance: Units.Resistance.Type { Units.Resistance.self }
    /// The `Capacitance` unit namespace, e.g. `Units.Capacitance.all`.
    static var capacitance: Units.Capacitance.Type { Units.Capacitance.self }
    /// The `Inductance` unit namespace, e.g. `Units.Inductance.all`.
    static var inductance: Units.Inductance.Type { Units.Inductance.self }
    /// The `Conductance` unit namespace, e.g. `Units.Conductance.all`.
    static var conductance: Units.Conductance.Type { Units.Conductance.self }
    /// The `Frequency` unit namespace, e.g. `Units.Frequency.all`.
    static var frequency: Units.Frequency.Type { Units.Frequency.self }
    /// The `LuminousIntensity` unit namespace, e.g. `Units.LuminousIntensity.all`.
    static var luminousIntensity: Units.LuminousIntensity.Type { Units.LuminousIntensity.self }
    /// The `MagneticFlux` unit namespace, e.g. `Units.MagneticFlux.all`.
    static var magneticFlux: Units.MagneticFlux.Type { Units.MagneticFlux.self }
    /// The `MagneticFluxDensity` unit namespace, e.g. `Units.MagneticFluxDensity.all`.
    static var magneticFluxDensity: Units.MagneticFluxDensity.Type { Units.MagneticFluxDensity.self }
    /// The `LuminousFlux` unit namespace, e.g. `Units.LuminousFlux.all`.
    static var luminousFlux: Units.LuminousFlux.Type { Units.LuminousFlux.self }
    /// The `Illuminance` unit namespace, e.g. `Units.Illuminance.all`.
    static var illuminance: Units.Illuminance.Type { Units.Illuminance.self }
    /// The `SpecificEnergy` unit namespace, e.g. `Units.SpecificEnergy.all`.
    static var specificEnergy: Units.SpecificEnergy.Type { Units.SpecificEnergy.self }
    /// The `AmountOfSubstance` unit namespace, e.g. `Units.AmountOfSubstance.all`.
    static var amountOfSubstance: Units.AmountOfSubstance.Type { Units.AmountOfSubstance.self }
    /// The `Dimensionless` unit namespace, e.g. `Units.Dimensionless.all`.
    static var dimensionless: Units.Dimensionless.Type { Units.Dimensionless.self }
    /// The `Volume` unit namespace, e.g. `Units.Volume.all`.
    static var volume: Units.Volume.Type { Units.Volume.self }
}
