# ``Math``

A robust, type-safe dimensional analysis and unit conversion library for Swift.

## Overview

The `Math` library provides a powerful system for working with physical quantities, units, and dimensions in a type-safe manner. It allows you to perform arithmetic on quantities while automatically verifying physical dimensions at runtime, and now also supports compile-time constraints on unit dimensions.

### Core Concepts

* ``Quantity``: A value combined with a unit of measurement (e.g., `5.0 m`).
* ``Unit``: A protocol representing a unit of measurement.
* ``PhysicalDimension``: A representation of physical dimensions using base SI dimension exponents.
* ``Dimension``: A compile-time namespace representing dimension types (e.g., `Dimension.length`, `Dimension.time`).

## Topics

### Core Types

- ``Quantity``
- ``PhysicalDimension``
- ``Dimension``

### Protocols

- ``Unit``
- ``DimensionProtocol``
- ``UnitConverter``

### Concrete Units and Converters

- ``NamedUnit``
- ``CompositeUnit``
- ``LinearConverter``
- ``OffsetConverter``
