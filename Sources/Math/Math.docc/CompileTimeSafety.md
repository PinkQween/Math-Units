# Compile-Time Dimension Type Safety

Use generic constraints to make sure your APIs only ever receive the right kind of quantity.

## Overview

Every ``MathUnit`` carries a compile-time dimension type through its
`Dimension` associated type. That type is a ``DimensionProtocol``-conforming
struct from the ``MathDimension`` namespace, such as ``MathDimension/length``
or ``MathDimension/time``. Because the compiler can see this type, it can
reject dimension mismatches *when you build your app* instead of when it runs.

Historically, dimensions were only checked at runtime. With compile-time
constraints, a function that declares *"only lengths, please"* is enforced by
the Swift type checker.

### Constrain a Generic to a Dimension

Write a generic function or protocol requirement over a unit type `U: MathUnit`,
then constrain `U.Dimension` with a `where` clause:

```swift
import Math

// This method only accepts quantities of length.
func measureDistance<U: MathUnit>(_ distance: Quantity<U>) -> Bool
where U.Dimension == MathDimension.length {
    distance.value > 0
}
```

### Passing the Correct Units

The built-in units in ``Units`` are already parameterized by their dimension.
Passing a length unit compiles cleanly:

```swift
let radius = Quantity(value: 500, unit: Units.meter)
measureDistance(radius) // Compiles perfectly! ✅
```

### Preventing Mismatched Units

Passing a quantity of a different dimension is a compile-time error:

```swift
let timeLimit = Quantity(value: 30, unit: Units.minute)
measureDistance(timeLimit) // ✗ ERROR: 'time' is not 'length'
```

### Runtime Checks for Dynamic Dimensions

Not every quantity has a static dimension. Custom dimensions created at runtime
(see <doc:CustomDimensions>) use ``MathDimension/unknown`` as their type-level
parameter. For those, the compiler can't help—so ``Math`` keeps its runtime
safety net. Operations that combine quantities verify that dimensions match and
raise a runtime `preconditionFailure` if they don't:

```swift
let usdDimension = PhysicalDimension(exponents: ["USD": 1])
let usdUnit = NamedUnit<MathDimension.unknown>(
    symbol: "$", dimension: usdDimension, converter: LinearConverter(coefficient: 1.0)
)

let userDimension = PhysicalDimension(exponents: ["user": 1])
let userUnit = NamedUnit<MathDimension.unknown>(
    symbol: "user", dimension: userDimension, converter: LinearConverter(coefficient: 1.0)
)

// Traps at runtime: USD ≠ users
let revenue = Quantity(value: 100, unit: usdUnit) + Quantity(value: 3, unit: userUnit)
```

### Applying Constraints at the Protocol Level

You can attach the same constraint to a protocol so every conformer enforces it:

```swift
protocol DistanceMeasurer {
    func measure<U: MathUnit>(_ distance: Quantity<U>) -> Double
    where U.Dimension == MathDimension.length
}

// All built-in length units satisfy this automatically:
struct RangeFinder: DistanceMeasurer {
    func measure<U: MathUnit>(_ distance: Quantity<U>) -> Double
    where U.Dimension == MathDimension.length {
        distance.converted(to: Units.meter).value
    }
}

let width = Quantity(value: 10, unit: Units.foot)
RangeFinder().measure(width) // 3.048
```

### What's Next?

- See the full list of compile-time dimensions in ``MathDimension``.
- Combine compile-time safety with your own domain in <doc:CustomDimensions>.
