# Working with Quantity

Create, convert, compare, compute with, and format ``Quantity`` values in your app.

## Overview

``Quantity`` is the type you'll reach for most often. It works the way
Foundation's `Measurement` does, but with compile-time dimension checking: a
quantity always knows its unit, and its unit knows its ``PhysicalDimension``.

This article covers everything you can do with a quantity, grouped the same way
Apple documents its own value types.

### Create a Quantity

Create a quantity with a value and a unit using
``Quantity/init(value:unit:)``:

```swift
import Math

// Distance
let jumpLength = Quantity(value: 8.95, unit: Units.meter)

// Money — currency units place their symbol before the value ($8.95)
let price = Quantity(value: 8.95, unit: Units.usd)

// Temperature — offset units like Celsius convert correctly
let bodyTemp = Quantity(value: 37.0, unit: Units.celsius)
```

> Note: The value is a `Double`, so you can pass integer literals directly:
> `Quantity(value: 42, unit: Units.kilometer)`.

### Convert Between Units

Use ``Quantity/converted(to:)`` to convert to another unit of the *same*
dimension. The framework converts through the unit's base unit, so arbitrary
chains like `nanometer → kilometer` just work:

```swift
let chipFeature = Quantity(value: 5.0, unit: Units.nanometer)
let inMeters = chipFeature.converted(to: Units.meter)
print(inMeters.value) // 5e-09

let marathon = Quantity(value: 42.195, unit: Units.kilometer)
print(marathon.converted(to: Units.mile).value) // 26.218...

let paycheck = Quantity(value: 100.0, unit: Units.eur)
print(paycheck.converted(to: Units.usd).value) // 108.0
```

Because conversions require matching dimensions, converting a `length` to a
`time` doesn't compile (or traps at runtime if the units are fully dynamic).
See <doc:CompileTimeSafety> for details.

### Compare Quantities

Quantities of the same unit type compare by their values with `==`. To compare
quantities expressed in *different* units of the same dimension—or to allow a
small tolerance—use ``Quantity/isEquivalent(to:tolerance:)``:

```swift
let oneMile = Quantity(value: 1.0, unit: Units.mile)
let oneKm    = Quantity(value: 1.0, unit: Units.kilometer)

oneMile.isEquivalent(to: Quantity(value: 1609.344, unit: Units.meter)) // true
oneMile.isEquivalent(to: oneKm)                                        // false
```

### Add and Subtract Quantities

You can add and subtract quantities of the same dimension even when their units
differ. The result keeps the left-hand side's unit; the right-hand side is
converted automatically:

```swift
let dish = Quantity(value: 1.5, unit: Units.kilogram)
let spice = Quantity(value: 350.0, unit: Units.gram)

let total = dish + spice
print(total) // 1.85 kg
```

### Multiply and Divide Quantities

Multiplying or dividing two quantities combines their dimensions. Multiplication
produces a ``CompositeUnit``; division produces a typed ``RatioUnit`` that
remembers which operand was on top. The framework adjusts both the numeric value
and the coefficient so results stay physically correct:

```swift
let area = Quantity(value: 3.0, unit: Units.meter) * Quantity(value: 2.0, unit: Units.meter)
print(area.value)          // 6.0
print(area.unit.symbol)    // "(m*m)"
print(area.unit.dimension) // area

let speed = Quantity(value: 100.0, unit: Units.meter) / Quantity(value: 5.0, unit: Units.second)
print(speed.value)          // 20.0
print(speed.unit.symbol)    // "(m/s)"
print(speed.unit.dimension) // speed
```

You can also multiply and divide a quantity by a plain `Double` scalar, which
keeps the same unit:

```swift
let doubling = Quantity(value: 5.0, unit: Units.meter) * 2
print(doubling) // 10.00 m
```

For common derived dimensions, `Math` produces cleaner units. For example,
multiplying a ``MathDimension/power`` by a ``MathDimension/time`` yields an
energy unit with the conventional symbol ordering:

```swift
let power   = Quantity(value: 2.0, unit: Units.kilowatt)
let runTime = Quantity(value: 3.0, unit: Units.hour)
let energy  = power * runTime    // 6 kWh, dimension = energy
```

### Typed Ratio Units

Sometimes you don't just want a measurement — you want the *type system* to
remember which side of a ratio something is on. A ``CompositeUnit`` like
`(usd/kg)` erases that detail (its compile-time dimension is always
`unknown`), so `USD per kilogram` and `kilogram per USD` become the same type.

``RatioUnit`` keeps the numerator and denominator as two distinct generic
parameters, so `USD / kg` is a *different type* from `kg / USD`. Build one with
``MathUnit/per(_:)`, the initializer, or just divide two quantities:

```swift
let price = Units.usd.per(Units.kilogram)            // (usd/kg)
let hoursPerDollar = Units.hour.per(Units.usd)       // (h/$)
let fromDivision = Quantity(value: 40, unit: Units.usd)
                / Quantity(value: 5, unit: Units.Weight.pound)  // ($/lbf)
```

Because the ordering is baked into the type, a generic function can require a
specific arrangement. Here the denominator must *be* a currency unit:

```swift
func denominatedInCurrency<Num: MathUnit>(
    _ value: Quantity<RatioUnit<Num, NamedUnit<MathDimension.currency>>>
) -> Bool { ... }

denominatedInCurrency(Quantity(value: 2, unit: Units.hour.per(Units.usd)))  // ✔
denominatedInCurrency(Quantity(value: 20, unit: Units.usd.per(Units.hour))) // ✘ won't compile
```

Multiplying a ratio by its denominator cancels the denominator and returns the
numerator: `price * amount → money`. Both operand orders work, and the
math always runs through base units so coefficients stay exact:

```swift
let cost = Quantity(value: 3.5, unit: Units.usd.per(Units.kilogram))
         * Quantity(value: 2, unit: Units.kilogram)   // $7.00
```

### Format Quantities

``Quantity`` conforms to `CustomStringConvertible`, so it prints a formatted
string automatically. Use ``Quantity/formatted(decimalPlaces:includeSpace:)``
to control the decimal places and spacing. Currency symbols are placed before
the value by default; most other symbols follow it:

```swift
let tenDollars = Quantity(value: 10.1234, unit: Units.usd)
print(tenDollars.formatted())                 // "$10.12"
print(tenDollars.formatted(decimalPlaces: 3)) // "$10.123"

let fiveMeters = Quantity(value: 5.5, unit: Units.meter)
print(fiveMeters.formatted())                 // "5.50 m"
print(fiveMeters.formatted(includeSpace: false)) // "5.50m"

let percent = Quantity(value: 75.5, unit: Units.percent)
print(percent.formatted())                    // "75.5%"
```

### What's Next?

- Browse the ready-made units in ``Units`` or define your own named units with
  ``NamedUnit``.
- Build composite units dynamically by combining units with the `*` and `/`
  operators defined for ``MathUnit``.
- Read <doc:CustomDimensions> to define units for your own domain.
- Read <doc:CompileTimeSafety> to make dimension correctness a compile-time
  guarantee.
