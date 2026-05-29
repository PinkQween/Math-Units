//
//  OffsetConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct OffsetConverter: UnitConverter {
    
    public let coefficient: Double
    public let constant: Double
    
    public init(coefficient: Double, constant: Double) {
        self.coefficient = coefficient
        self.constant = constant
    }
    
    public func convertToBase(_ value: Double) -> Double {
        (value * coefficient) + constant
    }
    
    public func convertFromBase(_ value: Double) -> Double {
        (value - constant) / coefficient
    }
}
