# Custom Dimensions and Units

How to extend the library with your own custom physical dimensions and units at runtime.

## Overview

While the `Math` library defines a comprehensive set of standard SI dimensions (like `length`, `time`) and derived dimensions (like `velocity`, `energy`), you may want to define your own custom dimensions—such as currency, resource points, or custom gameplay metrics.

### Defining a Custom Dimension

To define a custom dimension at runtime, instantiate ``PhysicalDimension`` with a dictionary of custom exponent identifiers:

```swift
let usdDimension = PhysicalDimension(exponents: ["USD": 1])
```

### Defining Custom Units

Once you have a dimension, you can construct custom ``NamedUnit`` instances. Because custom dimensions do not have a pre-defined static type, use the `MathDimension.unknown` compile-time type-level parameter:

```swift
let usdUnit = NamedUnit<MathDimension.unknown>(
    symbol: "$",
    dimension: usdDimension,
    converter: LinearConverter(coefficient: 1.0)
)

let eurUnit = NamedUnit<MathDimension.unknown>(
    symbol: "€",
    dimension: usdDimension,
    converter: LinearConverter(coefficient: 1.09) // Conversion rate relative to USD base
)
```

### Dynamic Conversion

You can perform conversions between custom units just like standard units:

```swift
let walletInEur = Quantity(value: 100.0, unit: eurUnit)
let walletInUsd = walletInEur.converted(to: usdUnit)
print(walletInUsd.value) // 109.0
```
