# Getting Started with Math

Learn how to add `Math` to your project and create your first ``Quantity``.

## Overview

`Math` is a Swift package, so you add it like any other Swift package: through
Xcode's package manager or directly in your `Package.swift` manifest.

### Add the Package Dependency

In Xcode, choose **File > Add Package Dependencies…** and enter the package's
repository URL, then add the **Math** product to your target.

If you manage dependencies with Swift Package Manager, add it to your package's
dependencies:

```swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/your-org/Math-Units", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: ["Math"]
        )
    ]
)
```

### Create Your First Quantity

A ``Quantity`` stores a numeric `value` together with a ``MathUnit``. The
library ships with hundreds of predefined units in the ``Units`` type, so you
rarely need to define your own.

```swift
import Math

// A value in kilometers.
let distance = Quantity(value: 10.5, unit: Units.kilometer)

// The unit knows everything about the quantity's dimension, so the
// compiler can help you stay physically consistent.
print(distance.unit.symbol) // "km"
```

### Convert Between Units

Every quantity can be converted to another unit of the same dimension using
``Quantity/converted(to:)``:

```swift
let distanceInMiles = distance.converted(to: Units.mile)
print(distanceInMiles.value)       // 6.524...
print(distanceInMiles.unit.symbol) // "mi"
```

### Combine Quantities

`Math` supports dimensional arithmetic. When you multiply or divide two
quantities, the framework combines their dimensions and produces a new
``CompositeUnit``:

```swift
// 10.5 km in 1.5 hours
let duration = Quantity(value: 1.5, unit: Units.hour)
let speed = distance / duration

print(speed.value)           // 7.0
print(speed.unit.symbol)     // "(km/h)"
print(speed.unit.dimension)  // speed
```

### What's Next?

- Read <doc:WorkingWithQuantity> to explore conversion, comparison, arithmetic,
  and formatting in depth.
- Read <doc:CompileTimeSafety> to learn how the compiler prevents dimension
  mismatches.
- Read <doc:CustomDimensions> to define your own units and dimensions for your
  app's domain—currencies, points, gameplay metrics, and more.
