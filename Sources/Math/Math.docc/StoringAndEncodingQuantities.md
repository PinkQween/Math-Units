# Storing and Encoding Quantities

Use ``Quantity`` as a dictionary key, in sets, and with `Codable` so measurements
round-trip cleanly through JSON and other formats.

## Overview

`Math`'s ``Quantity`` conforms to `Hashable` and, when its unit type does,
`Codable`. That makes three everyday tasks straightforward:

* Use quantities directly as dictionary keys or set members.
* Encode a single quantity — or a whole recipe, order, or measurement log — to
  JSON.
* Decode it back into a fully functional quantity that can still be converted
  and combined.

## Using Quantities as Keys

Because ``Quantity`` is `Hashable`, you can store measurements in dictionaries
and sets. Equality is *unit-aware*: two quantities are equal only when they share
the same value **and** the same unit (symbol and dimension), so five meters and
five miles are different keys.

```swift
let laps: [Quantity<NamedUnit<MathDimension.time>>: String] = [
    Quantity(value: 74.2, unit: Units.second): "best lap",
]

let best = laps[Quantity(value: 74.2, unit: Units.second)] // "best lap"
```

## Encoding and Decoding

Encode a quantity as you would any `Codable` value. The unit is stored with its
symbol, dimension, and a tagged ``UnitConverter``, so decoding reconstructs an
identical unit — including offset converters such as Fahrenheit.

```swift
let marathon = Quantity(value: 42.195, unit: Units.kilometer)
let data = try JSONEncoder().encode(marathon)

let decoded = try JSONDecoder().decode(
    Quantity<NamedUnit<MathDimension.length>>.self,
    from: data
)
decoded == marathon // true
```

The decoded quantity is fully functional: it can still be converted, compared
with ``Quantity/isEquivalent(to:tolerance:)``, and combined with arithmetic.

## Encoding Collections of Quantities

Because quantities are `Codable`, collections of them are too. This is handy for
persisting a recipe, cart, or measurement table:

```swift
let recipe: [String: Quantity<NamedUnit<MathDimension.mass>>] = [
    "flour": Quantity(value: 500.0, unit: Units.gram),
    "sugar": Quantity(value: 200.0, unit: Units.gram),
]

let data = try JSONEncoder().encode(recipe)
let decoded = try JSONDecoder().decode(
    [String: Quantity<NamedUnit<MathDimension.mass>>].self,
    from: data
)
```

> Note: decoding requires you to specify the concrete unit type (such as
> `Quantity<NamedUnit<MathDimension.length>>`). The library keeps its
> compile-time dimension checks even across a JSON round-trip.

## Requirements

`Quantity` conforms to `Hashable` unconditionally. It conforms to `Codable`
whenever its unit type does — ``NamedUnit``, ``CompositeUnit``, and every
built-in unit already conform, so no extra work is needed for the standard
`Units`.