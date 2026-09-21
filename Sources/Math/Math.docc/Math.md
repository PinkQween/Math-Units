# ``Math``

Perform type-safe dimensional analysis and unit conversion in your Swift app.

## Overview

`Math` is a dimensional analysis library that makes working with physical
quantities—length, time, mass, energy, currency, and more—safe, readable, and
fun. Instead of juggling raw `Double` values and hoping your calculations are
physically consistent, you work with a ``Quantity``: a numeric value paired with
a ``MathUnit``.

At the heart of the framework is the ``Quantity`` type, which behaves like
Foundation's `Measurement`. You can create one, convert it between units,
combine quantities with arithmetic, and format it for display—all while the
framework verifies that your dimensions (lengths, times, energies, ...) stay
consistent.

```swift
import Math

// Create a quantity with a value and a unit.
let marathon = Quantity(value: 42.195, unit: Units.kilometer)

// Convert it to another unit of the same dimension.
let marathonInMiles = marathon.converted(to: Units.mile)

// Combine quantities and let the framework derive the result's dimension.
let speed = Quantity(value: 42.195, unit: Units.kilometer) / Quantity(value: 3, unit: Units.hour)

// Format quantities for display.
print(marathon) // 42.20 km
print(speed)    // 14.07 (km/h)
```

### The Quantity Type

``Quantity`` is generic over the compile-time dimension of its unit
(`Quantity<NamedUnit<MathDimension.length>>`), which lets the Swift compiler
reject mismatched dimensions when you build your app—not when it runs. Read
<doc:CompileTimeSafety> to see how this works, or look at Foundation's own
`Measurement` for a mental model of how ``Quantity`` behaves.

### Units and Dimensions

- A ``PhysicalDimension`` is a mathematical description of a physical property
  (for example, `length` or `speed`) stored as a set of base-SI exponent powers.
- A ``MathDimension`` type (such as ``MathDimension/length``) is the compile-time
  twin of a dimension that enforces type safety.
- A ``MathUnit`` (such as the ``NamedUnit`` or ``CompositeUnit`` types) pairs a
  ``PhysicalDimension`` with a symbol and a ``UnitConverter`` so the framework
  can freely convert between units of the same dimension.
- ``Units`` provides hundreds of ready-made units, from Planck lengths and parsecs
  to teaspoons, slugs, and bitcoins.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:WorkingWithQuantity>
- <doc:StoringAndEncodingQuantities>
- ``Quantity``

### Creating and Converting Quantities

- ``Quantity/init(value:unit:)``
- ``Quantity/converted(to:)``
- ``Quantity/isEquivalent(to:tolerance:)``

### Arithmetic

- ``Quantity/+(_:_:)``
- ``Quantity/-(_:_:)``
- ``Quantity/*(_:_:)-(_,Double)``
- ``Quantity/*(_:_:)-(Double,_)``
- ``Quantity/*(_:_:)->Quantity<CompositeUnit>``
- ``Quantity//(_:_:)->Quantity<U>``
- ``Quantity//(_:_:)-(Double,_)``
- ``Quantity//(_:_:)-(Quantity<U>,_)->Quantity<CompositeUnit>``
- ``Quantity/thermalEnergy``
- ``Quantity/thermalEnergy(in:)``

### Formatting Quantities

- ``Quantity/formatted(decimalPlaces:includeSpace:)``

### Dimensions

- ``PhysicalDimension``
- ``MathDimension``

### Units

- ``MathUnit``
- ``NamedUnit``
- ``CompositeUnit``
- ``Units``

### Protocols

- ``DimensionProtocol``
- ``UnitConverter``

### Converters

- ``LinearConverter``
- ``OffsetConverter``
- ``EmptyConverter``

### Extending the Framework

- <doc:CustomDimensions>
- <doc:CompileTimeSafety>
