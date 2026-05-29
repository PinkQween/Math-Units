//
//  Macros.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

@attached(member, names: arbitrary)
public macro PrefixedUnits(
    name: String,
    symbol: String,
    dimension: Dimension,
    baseCoefficient: Double = 1.0,
    supportsFractionalPrefixes: Bool = true,
    supportsBinaryPrefixes: Bool = false
) = #externalMacro(module: "MathMacros", type: "PrefixedUnitsMacro")
