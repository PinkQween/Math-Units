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

### Mass versus weight

Mass and weight are different things, and the namespaces make the distinction
explicit so the two can never be mixed up.

- ``Units/Mass`` contains the mass units — `Units.Mass.ounce` is the ounce of
  mass (symbol `oz`).
- ``Units/Weight`` contains the force units, the physics-correct meaning of
  "weight" — `Units.Weight.ounce` is the ounce-force (symbol `ozf`), and
  `Units.Weight.pound` is the pound-force (symbol `lbf`).

Because they live in different namespaces, the compiler keeps the two apart:

```swift
let flour = Quantity(16, Units.Mass.ounce)   // 16 oz of mass
let force = Quantity(16, Units.Weight.ounce) // 16 ozf of force
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