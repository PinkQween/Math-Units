//
//  EmptyConverter.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct EmptyConverter: UnitConverter {
    public init() {}
    
    public func convertToBase(_ value: Double) -> Double {
        value
    }
    
    public func convertFromBase(_ value: Double) -> Double {
        value
    }
}
