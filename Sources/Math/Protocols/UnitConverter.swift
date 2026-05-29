//
//  UnitConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public protocol UnitConverter: Sendable {
    func convertToBase(_ value: Double) -> Double
    func convertFromBase(_ value: Double) -> Double
}
