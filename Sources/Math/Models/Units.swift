//
//  Units.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

// MARK: - Length
@PrefixedUnits(name: "meter", symbol: "m", dimension: .length)
@PrefixedUnits(name: "inch", symbol: "in", dimension: .length, baseCoefficient: 0.0254)
@PrefixedUnits(name: "foot", symbol: "ft", dimension: .length, baseCoefficient: 0.3048)
@PrefixedUnits(name: "yard", symbol: "yd", dimension: .length, baseCoefficient: 0.9144)
@PrefixedUnits(name: "mile", symbol: "mi", dimension: .length, baseCoefficient: 1609.344)
@PrefixedUnits(name: "thou", symbol: "mil", dimension: .length, baseCoefficient: 0.0000254)
@PrefixedUnits(name: "fathom", symbol: "ftm", dimension: .length, baseCoefficient: 1.8288)
@PrefixedUnits(name: "nauticalMile", symbol: "NM", dimension: .length, baseCoefficient: 1852.0)
@PrefixedUnits(name: "astronomicalUnit", symbol: "au", dimension: .length, baseCoefficient: 149597870700.0)
@PrefixedUnits(name: "lightYear", symbol: "ly", dimension: .length, baseCoefficient: 9460730472580800.0)
@PrefixedUnits(name: "parsec", symbol: "pc", dimension: .length, baseCoefficient: 3.0856775814913673e16)
@PrefixedUnits(name: "angstrom", symbol: "Å", dimension: .length, baseCoefficient: 1e-10)
@PrefixedUnits(name: "hand", symbol: "hand", dimension: .length, baseCoefficient: 0.1016)
@PrefixedUnits(name: "furlong", symbol: "fur", dimension: .length, baseCoefficient: 201.168)
@PrefixedUnits(name: "chain", symbol: "ch", dimension: .length, baseCoefficient: 20.1168)
@PrefixedUnits(name: "link", symbol: "lk", dimension: .length, baseCoefficient: 0.201168)
@PrefixedUnits(name: "beardSecond", symbol: "beard_s", dimension: .length, baseCoefficient: 5e-9)
@PrefixedUnits(name: "poronkusema", symbol: "poronkusema", dimension: .length, baseCoefficient: 7500.0)
@PrefixedUnits(name: "cable", symbol: "cable", dimension: .length, baseCoefficient: 219.456)
@PrefixedUnits(name: "league", symbol: "league", dimension: .length, baseCoefficient: 4828.032)
@PrefixedUnits(name: "point", symbol: "pt_len", dimension: .length, baseCoefficient: 0.000352777778)
@PrefixedUnits(name: "pica", symbol: "pica", dimension: .length, baseCoefficient: 0.00423333333)
@PrefixedUnits(name: "caliber", symbol: "cal_len", dimension: .length, baseCoefficient: 0.000254)
@PrefixedUnits(name: "rod", symbol: "rod", dimension: .length, baseCoefficient: 5.0292)

// MARK: - Time
@PrefixedUnits(name: "second", symbol: "s", dimension: .time)
@PrefixedUnits(name: "minute", symbol: "min", dimension: .time, baseCoefficient: 60.0)
@PrefixedUnits(name: "hour", symbol: "h", dimension: .time, baseCoefficient: 3600.0)
@PrefixedUnits(name: "day", symbol: "d", dimension: .time, baseCoefficient: 86400.0)
@PrefixedUnits(name: "week", symbol: "wk", dimension: .time, baseCoefficient: 604800.0)
@PrefixedUnits(name: "year", symbol: "yr", dimension: .time, baseCoefficient: 31556952.0)
@PrefixedUnits(name: "fortnight", symbol: "fn", dimension: .time, baseCoefficient: 1209600.0)
@PrefixedUnits(name: "century", symbol: "century", dimension: .time, baseCoefficient: 3155695200.0)
@PrefixedUnits(name: "millennium", symbol: "millennium", dimension: .time, baseCoefficient: 31556952000.0)
@PrefixedUnits(name: "shake", symbol: "shake", dimension: .time, baseCoefficient: 1e-8)
@PrefixedUnits(name: "svedberg", symbol: "S_time", dimension: .time, baseCoefficient: 1e-13)
@PrefixedUnits(name: "jiffy", symbol: "jiffy", dimension: .time, baseCoefficient: 1.0 / 60.0)
@PrefixedUnits(name: "physicsJiffy", symbol: "phys_jiffy", dimension: .time, baseCoefficient: 3.33564095198e-11)
@PrefixedUnits(name: "siderealDay", symbol: "sday", dimension: .time, baseCoefficient: 86164.0905)
@PrefixedUnits(name: "siderealYear", symbol: "syr", dimension: .time, baseCoefficient: 31558149.763)
@PrefixedUnits(name: "month", symbol: "mo", dimension: .time, baseCoefficient: 2629743.0)
@PrefixedUnits(name: "decade", symbol: "dec", dimension: .time, baseCoefficient: 315569520.0)

// MARK: - Mass
@PrefixedUnits(name: "gram", symbol: "g", dimension: .mass, baseCoefficient: 1e-3)
@PrefixedUnits(name: "grain", symbol: "gr", dimension: .mass, baseCoefficient: 0.00006479891)
@PrefixedUnits(name: "ounce", symbol: "oz", dimension: .mass, baseCoefficient: 0.028349523125)
@PrefixedUnits(name: "pound", symbol: "lb", dimension: .mass, baseCoefficient: 0.45359237)
@PrefixedUnits(name: "stone", symbol: "st", dimension: .mass, baseCoefficient: 6.35029318)
@PrefixedUnits(name: "shortTon", symbol: "ton", dimension: .mass, baseCoefficient: 907.18474)
@PrefixedUnits(name: "longTon", symbol: "lton", dimension: .mass, baseCoefficient: 1016.0469088)
@PrefixedUnits(name: "slug", symbol: "slug", dimension: .mass, baseCoefficient: 14.5939029)
@PrefixedUnits(name: "carat", symbol: "ct", dimension: .mass, baseCoefficient: 0.0002)
@PrefixedUnits(name: "dram", symbol: "dr", dimension: .mass, baseCoefficient: 0.0017718451953125)
@PrefixedUnits(name: "troyDram", symbol: "dr_t", dimension: .mass, baseCoefficient: 0.0038879346)
@PrefixedUnits(name: "troyOunce", symbol: "oz_t", dimension: .mass, baseCoefficient: 0.0311034768)
@PrefixedUnits(name: "troyPound", symbol: "lb_t", dimension: .mass, baseCoefficient: 0.3732417216)
@PrefixedUnits(name: "pennyweight", symbol: "dwt", dimension: .mass, baseCoefficient: 0.00155517384)
@PrefixedUnits(name: "hundredweight", symbol: "cwt", dimension: .mass, baseCoefficient: 45.359237)
@PrefixedUnits(name: "longHundredweight", symbol: "lcwt", dimension: .mass, baseCoefficient: 50.80234544)
@PrefixedUnits(name: "dalton", symbol: "Da", dimension: .mass, baseCoefficient: 1.6605390666111e-27)
@PrefixedUnits(name: "electronRestMass", symbol: "m_e", dimension: .mass, baseCoefficient: 9.1093837015e-31)
@PrefixedUnits(name: "protonRestMass", symbol: "m_p", dimension: .mass, baseCoefficient: 1.67262192369e-27)
@PrefixedUnits(name: "solarMass", symbol: "M_S", dimension: .mass, baseCoefficient: 1.98847e30)

// MARK: - Area
@PrefixedUnits(name: "squareMeter", symbol: "m²", dimension: .area)
@PrefixedUnits(name: "acre", symbol: "ac", dimension: .area, baseCoefficient: 4046.8564224)
@PrefixedUnits(name: "hectare", symbol: "ha", dimension: .area, baseCoefficient: 10000.0)
@PrefixedUnits(name: "barn", symbol: "b_area", dimension: .area, baseCoefficient: 1e-28)
@PrefixedUnits(name: "squareMile", symbol: "mi²", dimension: .area, baseCoefficient: 2589988.110336)
@PrefixedUnits(name: "squareYard", symbol: "yd²", dimension: .area, baseCoefficient: 0.83612736)
@PrefixedUnits(name: "squareFoot", symbol: "ft²", dimension: .area, baseCoefficient: 0.09290304)
@PrefixedUnits(name: "squareInch", symbol: "in²", dimension: .area, baseCoefficient: 0.00064516)

// MARK: - Data
@PrefixedUnits(name: "byte", symbol: "B", dimension: .data, baseCoefficient: 1.0, supportsFractionalPrefixes: false, supportsBinaryPrefixes: true)
@PrefixedUnits(name: "bit", symbol: "b", dimension: .data, baseCoefficient: 0.125, supportsFractionalPrefixes: false, supportsBinaryPrefixes: true)

// MARK: - Temperature (Absolute scale)
@PrefixedUnits(name: "kelvin", symbol: "K", dimension: .temperature)
@PrefixedUnits(name: "rankine", symbol: "R", dimension: .temperature, baseCoefficient: 5.0 / 9.0)

// MARK: - Force
@PrefixedUnits(name: "newton", symbol: "N", dimension: .force)
@PrefixedUnits(name: "dyne", symbol: "dyn", dimension: .force, baseCoefficient: 1e-5)
@PrefixedUnits(name: "poundal", symbol: "pdl", dimension: .force, baseCoefficient: 0.138254954376)
@PrefixedUnits(name: "poundForce", symbol: "lbf", dimension: .force, baseCoefficient: 4.4482216152605)
@PrefixedUnits(name: "ounceForce", symbol: "ozf", dimension: .force, baseCoefficient: 0.27801385095378125)
@PrefixedUnits(name: "kip", symbol: "kip", dimension: .force, baseCoefficient: 4448.2216152605)
@PrefixedUnits(name: "tonForce", symbol: "tnf", dimension: .force, baseCoefficient: 8896.44323)
@PrefixedUnits(name: "kilogramForce", symbol: "kgf", dimension: .force, baseCoefficient: 9.80665)

// MARK: - Pressure
@PrefixedUnits(name: "pascal", symbol: "Pa", dimension: .pressure)
@PrefixedUnits(name: "bar", symbol: "bar", dimension: .pressure, baseCoefficient: 1e5)
@PrefixedUnits(name: "atmosphere", symbol: "atm", dimension: .pressure, baseCoefficient: 101325.0)
@PrefixedUnits(name: "torr", symbol: "Torr", dimension: .pressure, baseCoefficient: 133.322387415)
@PrefixedUnits(name: "psi", symbol: "psi", dimension: .pressure, baseCoefficient: 6894.757293168361)
@PrefixedUnits(name: "barye", symbol: "Ba_pres", dimension: .pressure, baseCoefficient: 0.1)
@PrefixedUnits(name: "millimeterOfMercury", symbol: "mmHg", dimension: .pressure, baseCoefficient: 133.322387415)
@PrefixedUnits(name: "inchOfMercury", symbol: "inHg", dimension: .pressure, baseCoefficient: 3386.389)

// MARK: - Energy
@PrefixedUnits(name: "joule", symbol: "J", dimension: .energy)
@PrefixedUnits(name: "erg", symbol: "erg", dimension: .energy, baseCoefficient: 1e-7)
@PrefixedUnits(name: "calorie", symbol: "cal", dimension: .energy, baseCoefficient: 4.184)
@PrefixedUnits(name: "britishThermalUnit", symbol: "BTU", dimension: .energy, baseCoefficient: 1055.05585262)
@PrefixedUnits(name: "electronVolt", symbol: "eV", dimension: .energy, baseCoefficient: 1.602176634e-19)
@PrefixedUnits(name: "footPound", symbol: "ft·lb", dimension: .energy, baseCoefficient: 1.3558179483314004)
@PrefixedUnits(name: "wattHour", symbol: "Wh", dimension: .energy, baseCoefficient: 3600.0)
@PrefixedUnits(name: "therm", symbol: "thm", dimension: .energy, baseCoefficient: 105480400.0)
@PrefixedUnits(name: "tonOfTNT", symbol: "tTNT", dimension: .energy, baseCoefficient: 4.184e9)
@PrefixedUnits(name: "hartree", symbol: "E_h", dimension: .energy, baseCoefficient: 4.3597447222071e-18)
@PrefixedUnits(name: "rydberg", symbol: "Ry", dimension: .energy, baseCoefficient: 2.1798723611035e-18)

// MARK: - Power
@PrefixedUnits(name: "watt", symbol: "W", dimension: .power)
@PrefixedUnits(name: "horsepower", symbol: "hp", dimension: .power, baseCoefficient: 745.69987158227022)

// MARK: - Velocity / Speed
@PrefixedUnits(name: "meterPerSecond", symbol: "m/s", dimension: .speed)
@PrefixedUnits(name: "kilometerPerHour", symbol: "km/h", dimension: .speed, baseCoefficient: 1.0 / 3.6)
@PrefixedUnits(name: "milePerHour", symbol: "mph", dimension: .speed, baseCoefficient: 0.44704)
@PrefixedUnits(name: "knot", symbol: "kt", dimension: .speed, baseCoefficient: 1852.0 / 3600.0)
@PrefixedUnits(name: "speedOfLight", symbol: "c", dimension: .speed, baseCoefficient: 299792458.0)

// MARK: - Acceleration
@PrefixedUnits(name: "meterPerSecondSquared", symbol: "m/s^2", dimension: .acceleration)
@PrefixedUnits(name: "gravity", symbol: "g", dimension: .acceleration, baseCoefficient: 9.80665)

// MARK: - Electricity
@PrefixedUnits(name: "ampere", symbol: "A", dimension: .electricCurrent)
@PrefixedUnits(name: "coulomb", symbol: "C", dimension: .charge)
@PrefixedUnits(name: "volt", symbol: "V", dimension: .voltage)
@PrefixedUnits(name: "ohm", symbol: "Ω", dimension: .resistance)
@PrefixedUnits(name: "farad", symbol: "F", dimension: .capacitance)
@PrefixedUnits(name: "henry", symbol: "H", dimension: .inductance)
@PrefixedUnits(name: "siemens", symbol: "S", dimension: .conductance)

// MARK: - Frequency & Luminous Intensity
@PrefixedUnits(name: "hertz", symbol: "Hz", dimension: .frequency)
@PrefixedUnits(name: "candela", symbol: "cd", dimension: .luminousIntensity)

// MARK: - Electromagnetism
@PrefixedUnits(name: "weber", symbol: "Wb", dimension: .magneticFlux)
@PrefixedUnits(name: "maxwell", symbol: "Mx", dimension: .magneticFlux, baseCoefficient: 1e-8)
@PrefixedUnits(name: "tesla", symbol: "T", dimension: .magneticFluxDensity)
@PrefixedUnits(name: "gauss", symbol: "G", dimension: .magneticFluxDensity, baseCoefficient: 1e-4)

// MARK: - Photometry
@PrefixedUnits(name: "lumen", symbol: "lm", dimension: .luminousFlux)
@PrefixedUnits(name: "lux", symbol: "lx", dimension: .illuminance)
@PrefixedUnits(name: "phot", symbol: "ph", dimension: .illuminance, baseCoefficient: 10000.0)
@PrefixedUnits(name: "footCandle", symbol: "fc", dimension: .illuminance, baseCoefficient: 10.7639104)

// MARK: - Radiation
@PrefixedUnits(name: "becquerel", symbol: "Bq", dimension: .frequency)
@PrefixedUnits(name: "curie", symbol: "Ci", dimension: .frequency, baseCoefficient: 3.7e10)
@PrefixedUnits(name: "gray", symbol: "Gy", dimension: .specificEnergy)
@PrefixedUnits(name: "rad", symbol: "rad_dose", dimension: .specificEnergy, baseCoefficient: 0.01)
@PrefixedUnits(name: "sievert", symbol: "Sv", dimension: .specificEnergy)
@PrefixedUnits(name: "rem", symbol: "rem_dose", dimension: .specificEnergy, baseCoefficient: 0.01)

// MARK: - Amount of Substance
@PrefixedUnits(name: "mole", symbol: "mol", dimension: .amountOfSubstance)

// MARK: - Angles
@PrefixedUnits(name: "radian", symbol: "rad", dimension: .dimensionless)
@PrefixedUnits(name: "degree", symbol: "deg", dimension: .dimensionless, baseCoefficient: 0.017453292519943295)
@PrefixedUnits(name: "gradian", symbol: "grad", dimension: .dimensionless, baseCoefficient: 0.015707963267948967)
@PrefixedUnits(name: "arcminute", symbol: "arcmin", dimension: .dimensionless, baseCoefficient: 0.0002908882086657216)
@PrefixedUnits(name: "arcsecond", symbol: "arcsec", dimension: .dimensionless, baseCoefficient: 4.84813681109536e-6)

// MARK: - Dimensionless & Probability
@PrefixedUnits(name: "percent", symbol: "%", dimension: .dimensionless, baseCoefficient: 0.01)
@PrefixedUnits(name: "partsPerMillion", symbol: "ppm", dimension: .dimensionless, baseCoefficient: 1e-6)
@PrefixedUnits(name: "partsPerBillion", symbol: "ppb", dimension: .dimensionless, baseCoefficient: 1e-9)
@PrefixedUnits(name: "micromort", symbol: "micromort", dimension: .dimensionless, baseCoefficient: 1e-6)

// MARK: - Volume
@PrefixedUnits(name: "liter", symbol: "L", dimension: .volume, baseCoefficient: 0.001)
@PrefixedUnits(name: "fluidOunce", symbol: "fl_oz", dimension: .volume, baseCoefficient: 2.95735295625e-5)
@PrefixedUnits(name: "usFluidOunce", symbol: "us_fl_oz", dimension: .volume, baseCoefficient: 2.95735295625e-5)
@PrefixedUnits(name: "imperialFluidOunce", symbol: "imp_fl_oz", dimension: .volume, baseCoefficient: 2.84130625e-5)
@PrefixedUnits(name: "cup", symbol: "cup", dimension: .volume, baseCoefficient: 0.0002365882365)
@PrefixedUnits(name: "usCup", symbol: "us_cup", dimension: .volume, baseCoefficient: 0.0002365882365)
@PrefixedUnits(name: "usLegalCup", symbol: "us_legal_cup", dimension: .volume, baseCoefficient: 0.00024)
@PrefixedUnits(name: "metricCup", symbol: "metric_cup", dimension: .volume, baseCoefficient: 0.00025)
@PrefixedUnits(name: "imperialCup", symbol: "imp_cup", dimension: .volume, baseCoefficient: 0.000284130625)
@PrefixedUnits(name: "britishBreakfastCup", symbol: "breakfast_cup", dimension: .volume, baseCoefficient: 0.0002273045)
@PrefixedUnits(name: "japaneseCup", symbol: "jp_cup", dimension: .volume, baseCoefficient: 0.0002)
@PrefixedUnits(name: "pint", symbol: "pt", dimension: .volume, baseCoefficient: 0.000473176473)
@PrefixedUnits(name: "usPint", symbol: "us_pt", dimension: .volume, baseCoefficient: 0.000473176473)
@PrefixedUnits(name: "imperialPint", symbol: "imp_pt", dimension: .volume, baseCoefficient: 0.00056826125)
@PrefixedUnits(name: "quart", symbol: "qt", dimension: .volume, baseCoefficient: 0.000946352946)
@PrefixedUnits(name: "usQuart", symbol: "us_qt", dimension: .volume, baseCoefficient: 0.000946352946)
@PrefixedUnits(name: "imperialQuart", symbol: "imp_qt", dimension: .volume, baseCoefficient: 0.0011365225)
@PrefixedUnits(name: "gallon", symbol: "gal", dimension: .volume, baseCoefficient: 0.003785411784)
@PrefixedUnits(name: "usGallon", symbol: "us_gal", dimension: .volume, baseCoefficient: 0.003785411784)
@PrefixedUnits(name: "imperialGallon", symbol: "imp_gal", dimension: .volume, baseCoefficient: 0.00454609)
@PrefixedUnits(name: "teaspoon", symbol: "tsp", dimension: .volume, baseCoefficient: 4.92892159375e-6)
@PrefixedUnits(name: "tablespoon", symbol: "tbsp", dimension: .volume, baseCoefficient: 1.478676478125e-5)
@PrefixedUnits(name: "barrel", symbol: "bbl", dimension: .volume, baseCoefficient: 0.158987294928)
@PrefixedUnits(name: "imperialBarrel", symbol: "imp_bbl", dimension: .volume, baseCoefficient: 0.16365924)
@PrefixedUnits(name: "peck", symbol: "pk", dimension: .volume, baseCoefficient: 0.00880976754172)
@PrefixedUnits(name: "bushel", symbol: "bu", dimension: .volume, baseCoefficient: 0.03523907016688)
@PrefixedUnits(name: "tablespoonMetric", symbol: "tbsp_m", dimension: .volume, baseCoefficient: 1.5e-5)
@PrefixedUnits(name: "teaspoonMetric", symbol: "tsp_m", dimension: .volume, baseCoefficient: 5e-6)
@PrefixedUnits(name: "butt", symbol: "butt", dimension: .volume, baseCoefficient: 0.49097772)

public enum Units {
    // MARK: - Offset and Constant-based Units
    
    public static let celsius = NamedUnit<MathDimension.temperature>(
        symbol: "°C",
        dimension: .temperature,
        converter: OffsetConverter(coefficient: 1.0, constant: 273.15)
    )
    
    public static let fahrenheit = NamedUnit<MathDimension.temperature>(
        symbol: "°F",
        dimension: .temperature,
        converter: OffsetConverter(coefficient: 5.0 / 9.0, constant: 255.37222222222222)
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
    
    public static let planckTemperature = NamedUnit<MathDimension.temperature>(
        symbol: "T_P",
        dimension: .temperature,
        converter: LinearConverter(coefficient: 1.416784e32)
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
        converter: LinearConverter(coefficient: 0.094)
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
        converter: LinearConverter(coefficient: 0.094)
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
        converter: LinearConverter(coefficient: 0.15)
    )
    
    public static let pln = NamedUnit<MathDimension.currency>(
        symbol: "zł",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.25)
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
        converter: LinearConverter(coefficient: 0.0028)
    )
    
    public static let czk = NamedUnit<MathDimension.currency>(
        symbol: "Kč",
        dimension: .currency,
        converter: LinearConverter(coefficient: 0.043)
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
        converter: LinearConverter(coefficient: 0.22)
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
    
    // MARK: - Currency Resolution
    
    /// A dictionary mapping ISO 4217 uppercase currency codes to their corresponding NamedUnit.
    public static let currencyByCode: [String: NamedUnit<MathDimension.currency>] = [
        "USD": usd, "EUR": eur, "JPY": jpy, "GBP": gbp, "AUD": aud, "CAD": cad,
        "CHF": chf, "CNY": cny, "SEK": sek, "NZD": nzd, "MXN": mxn, "SGD": sgd,
        "HKD": hkd, "NOK": nok, "KRW": krw, "TRY": `try`, "INR": inr, "RUB": rub,
        "BRL": brl, "ZAR": zar, "DKK": dkk, "PLN": pln, "TWD": twd, "THB": thb,
        "IDR": idr, "HUF": huf, "CZK": czk, "ILS": ils, "CLP": clp, "PHP": php,
        "AED": aed, "COP": cop, "SAR": sar, "MYR": myr, "RON": ron, "VND": vnd,
        "ARS": ars, "BTC": btc, "ETH": eth
    ]
    
    /// Resolves an ISO 4217 currency code (case-insensitive) to a NamedUnit.
    public static func currency(for code: String) -> NamedUnit<MathDimension.currency>? {
        currencyByCode[code.uppercased()]
    }
}
