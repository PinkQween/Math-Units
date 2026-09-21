# Looking Up Units by Dimension

Browse the unit catalog one dimension at a time, and keep mass and weight straight.

## Overview

Every unit in ``Units`` is defined twice: once as a flat, ready-made value
(`Units.cup`, `Units.newton`), and once under a namespace named after its
dimension (`Units.Volume.cup`, `Units.Weight.newton`). The namespaces give you
a way to see, enumerate, and pick from just one dimension.

## The dimension namespaces

The generated namespaces mirror the framework's dimensions:

| Namespace | Dimension | Example units |
|-----------|-----------|---------------|
| ``Units/Length`` | `length` | `meter`, `mile`, `lightYear` |
| ``Units/Time`` | `time` | `second`, `hour`, `day` |
| ``Units/Mass`` | `mass` | `gram`, `pound`, `slug` |
| ``Units/Volume`` | `volume` | `cup`, `liter`, `gallon` |
| ``Units/Data`` | `data` | `byte`, `gibibyte` |
| ``Units/Energy`` | `energy` | `kelvin`, `joule`, `calorie` |
| ``Units/Currency`` | `currency` | `usd`, `eur`, `btc` |
| ...and more | ... | ... |

Each namespace also exposes `all`, an array of every base unit in its dimension,
which is handy for building menus and pickers:

```swift
for unit in Units.Volume.all {
    print(unit.symbol)
}
```

#### Currency common names

The currency dimension is special: most names are only meaningful with their
country code, so the explicit spellings stay (`Units.usd`, `Units.cad`,
`Units.currency.mxn`, ...). Currencies whose common name is unambiguous get
colloquial aliases in every access style — `Units.pounds`, `Units.Currency.sterling`,
and `Quantity(value: 100, unit: .poundsSterling)` all refer to the British pound
(GBP), `.yen` to JPY, `.franc` to CHF, `.rupee` to INR, and so on. There is
deliberately no bare `.dollar` or `.peso`, because those names span several
currencies.

#### Decibels

Decibels are logarithmic, so they are modeled with a
``PowerLawConverter`` rather than a linear scale. Relative decibels are
dimensionless power ratios (`10 dB = 10·log10(P₁/P₂)`, i.e. a tenfold power
increase) and live in ``Units/Dimensionless`` as `bel` and `decibel`.
Absolute scales pin a reference at the zero reading and belong to the
dimension they measure, so they convert exactly to the linear units of that
dimension:

```swift
let power = Quantity(value: 30, unit: .decibelMilliwatt) // 30 dBm
print(power.converted(to: .watt).value)                  // 1.0  (0 dBm = 1 mW)

let voltage = Quantity(value: 120, unit: .decibelMicrovolt)
print(voltage.converted(to: .volt).value)                // 1.0  (120 dBµV = 1 V)

let quiet = Quantity(value: 0, unit: .decibelSoundPressureLevel)
print(quiet.converted(to: .pascal).value)                // 2e-5 (0 dB SPL = 20 µPa)
```

Power-ratio scales (`decibelMilliwatt`, `decibelWatt`, the dimensionless
`decibel`) step by `10^(1/10)`; voltage and pressure scales
(`decibelVolt`, `decibelMicrovolt`, `decibelSoundPressureLevel`) use the
field convention `10^(1/20)` since they are squared into power.

### Mass versus weight

Mass and weight are different things, and the namespaces make the distinction
explicit so the two can never be mixed up.

- ``Units/Mass`` contains the mass units — `Units.Mass.ounce` is the ounce of
  mass (symbol `oz`).
- ``Units/Weight`` contains the force units, the physics-correct meaning of
  "weight" — `Units.Weight.ounce` is the ounce-force (symbol `ozf`), and
  `Units.Weight.pound` is the pound-force (symbol `lbf`).

Some words mean different physical things in different contexts. Beyond
`ounce` and `pound`, `dram` is available as a mass unit (`Units.Mass.dram`),
a weight/force unit (`Units.Weight.dram`, the dram-force), and a volume unit
(`Units.Volume.dram`, the US fluid dram, one eighth of a US fluid ounce).

Because they live in different namespaces, the compiler keeps the two apart:

```swift
let flour = Quantity(16, Units.Mass.ounce)   // 16 oz of mass
let force = Quantity(16, Units.Weight.ounce) // 16 ozf of force
let sack = Quantity(2, Units.Mass.dram)      // 2 dr of mass
let pull = Quantity(2, Units.Weight.dram)    // 2 dram-force
let dose = Quantity(2, Units.Volume.dram)    // 2 fl dr of volume
```

## Leading-dot lookup

Inside a `Quantity` initializer — whose `unit:` parameter is a generic
`U: MathUnit` — the dimensions are available as leading-dot namespaces:

```swift
let oil = Quantity(value: 10, unit: .volume.fluidOunce)
let punch = Quantity(value: 2, unit: .volume.liter).converted(to: .volume.cup)
let force = Quantity(value: 150, unit: .weight.pound)
```

The first member (`.volume`, `.mass`, `.weight`, ...) resolves to that
dimension's namespace, and the second member chains onto any of its units —
base or prefixed. The mass-versus-weight rule still applies: `.mass.pound` is a
mass unit and `.weight.pound` is a force unit.

```swift
let precise = Quantity(value: 1, unit: .voltage.nanovolt) // nV
let sticky  = Quantity(value: 500, unit: .volume.milliliter)
let disk    = Quantity(value: 1, unit: .data.gibibyte)    // GiB
```

Every unit is also available bare, without the dimension name: `.nanovolt` and
`.voltage.nanovolt` are the same unit. The `Units.units(for:)` catalog keeps
listing just the base units of each dimension, so the pickers stay compact.

### Looking units up at runtime

`Units.units(for:)` returns every base unit of a dimension as `[any MathUnit]`:

```swift
let volumeUnits = Units.units(for: .volume) // [Units.Volume.all]
let forceUnits  = Units.units(for: .force)  // never contains mass units
```