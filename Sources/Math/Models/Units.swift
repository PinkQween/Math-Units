//
//  Units.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct Units {
    // MARK: - Offset and Constant-based Units
    public static let celsius = NamedUnit<MathDimension.energy>(
        symbol: "°C",
        dimension: .energy,
        converter: OffsetConverter(
            coefficient: 1.380649e-23,
            constant: 3.7712427435e-21
        )
    )

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
    
    private init() {}
}
