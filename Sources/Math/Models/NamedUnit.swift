//
//  NamedUnit.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

public struct NamedUnit<Dim: DimensionProtocol>: Unit {
    public typealias Dimension = Dim
    
    public let symbol: String
    public let dimension: PhysicalDimension
    public let converter: any UnitConverter
    
    public init(symbol: String, dimension: PhysicalDimension, converter: any UnitConverter) {
        self.symbol = symbol
        self.dimension = dimension
        self.converter = converter
    }
}
