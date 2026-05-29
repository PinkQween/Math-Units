//
//  Unit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public protocol Unit: Sendable {
    var symbol: String { get }
    var dimension: Dimension { get }
    var converter: any UnitConverter { get }
}

public func * <U1: Unit, U2: Unit>(lhs: U1, rhs: U2) -> CompositeUnit {
    let newDimension = lhs.dimension * rhs.dimension
    let newSymbol = "(\(lhs.symbol)*\(rhs.symbol))"
    let lhsCoeff = lhs.converter.convertToBase(1.0)
    let rhsCoeff = rhs.converter.convertToBase(1.0)
    let compositeCoeff = lhsCoeff * rhsCoeff
    return CompositeUnit(
        symbol: newSymbol,
        dimension: newDimension,
        converter: LinearConverter(coefficient: compositeCoeff)
    )
}

public func / <U1: Unit, U2: Unit>(lhs: U1, rhs: U2) -> CompositeUnit {
    let newDimension = lhs.dimension / rhs.dimension
    let newSymbol = "(\(lhs.symbol)/\(rhs.symbol))"
    let lhsCoeff = lhs.converter.convertToBase(1.0)
    let rhsCoeff = rhs.converter.convertToBase(1.0)
    let compositeCoeff = lhsCoeff / rhsCoeff
    return CompositeUnit(
        symbol: newSymbol,
        dimension: newDimension,
        converter: LinearConverter(coefficient: compositeCoeff)
    )
}
