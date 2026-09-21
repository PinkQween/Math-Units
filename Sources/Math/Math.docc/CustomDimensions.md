# Custom Dimensions and Units

Extend `Math` with your own physical dimensions and units—currency, points, gameplay metrics, or anything else your app measures.

## Overview

`Math` ships with a comprehensive set of base dimensions (``PhysicalDimension/length``, ``PhysicalDimension/time``, and friends) and derived dimensions (``PhysicalDimension/speed``, ``PhysicalDimension/energy``, and more). These cover physics and everyday measurement, but your app almost certainly measures things that aren't in the SI system too: money, hit points, ingredients, resource points, users, and so on.

The good news: ``PhysicalDimension`` is an open system. Because a dimension is *just a dictionary of exponent powers*, you can describe any dimension you can imagine at runtime.

### Define a Custom Dimension

Create a ``PhysicalDimension`` with a dictionary of exponent identifiers. Each key is a dimension name and each value is its power:

```swift
import Math

// A dimension for money, with a single base exponent.
let usdDimension = PhysicalDimension(exponents: ["USD": 1])

// A dimension for "users", used later in per-user metrics.
let userDimension = PhysicalDimension(exponents: ["user": 1])
```

You can build compound custom dimensions with the same arithmetic used
internally: `+` multiplies dimensions, `-` divides them, and `*` with an
`Int` raises a dimension to a power:

```swift
let revenuePerUser = usdDimension - userDimension   // ["USD": 1, "user": -1]
```

### Define Custom Units

Custom dimensions don't have a compile-time type, so use
``MathDimension/unknown`` as the type-level parameter and ``NamedUnit`` to
create units. Pass a ``LinearConverter`` (for a simple scale) or an
``OffsetConverter`` (for a scale plus an offset) to handle conversions:

```swift
let usdUnit = NamedUnit<MathDimension.unknown>(
    symbol: "$",
    dimension: usdDimension,
    converter: LinearConverter(coefficient: 1.0)
)

// EUR is defined relative to the same base dimension.
let eurUnit = NamedUnit<MathDimension.unknown>(
    symbol: "€",
    dimension: usdDimension,
    converter: LinearConverter(coefficient: 1.09)
)
```

> Tip: Keep the same `PhysicalDimension` value (here `usdDimension`) for every
> unit in a family. The framework only converts between units whose dimensions
> match, so sharing the exact same value makes your money interchangeable.

### Convert Between Custom Units

Custom units convert exactly like the built-in ones:

```swift
let walletInEur = Quantity(value: 100.0, unit: eurUnit)
let walletInUsd = walletInEur.converted(to: usdUnit)

print(walletInUsd.value) // 109.0
```

### Combine Custom Units with Built-In Ones

Custom dimensions participate in dimensional arithmetic too. Here a currency
dimension combines with the built-in ``PhysicalDimension/time`` dimension:

```swift
let hourlyRate = Quantity(value: 50.0, unit: usdUnit) / Quantity(value: 1.0, unit: Units.hour)

print(hourlyRate.value)          // 50.0
print(hourlyRate.unit.dimension) // ["USD": 1, "time": -1]
print(hourlyRate.unit.symbol)    // "($/h)"
```

### Use the Currency Dimension

If your custom dimension happens to be currency, `Math` already defines a
``PhysicalDimension/currency`` dimension and a built-in library of world
currencies (and cryptocurrencies) in ``Units``. Currency units automatically
place their symbol before the value when formatting:

```swift
let gift = Quantity(value: 100.0, unit: Units.usd)
print(gift.formatted()) // "$100.00"

// Resolve units from ISO 4217 codes at runtime.
if let currency = Units.currency(for: "SEK") {
    print(currency.symbol) // "kr"
}
```

### What's Next?

- Learn how to lock custom units into a compile-time dimension in
  <doc:CompileTimeSafety>.
- Explore ``Units`` to see the breadth of units provided out of the box.
