//
//  CompositeUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct CompositeUnit: Unit {
    public typealias Dimension = Math.Dimension.unknown
    
    public let symbol: String
    public let dimension: PhysicalDimension
    public let converter: any UnitConverter
    
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
    }
}
