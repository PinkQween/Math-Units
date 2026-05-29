//
//  LinearConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct LinearConverter: UnitConverter {
    
    public let coefficient: Double
    
    public init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    public func convertToBase(_ value: Double) -> Double {
        value * coefficient
    }
    
    public func convertFromBase(_ value: Double) -> Double {
        value / coefficient
    }
}
