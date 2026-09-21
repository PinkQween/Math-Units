//
//  UnitCodable.swift
//  Math
//
//  Created by Hanna Skairipa on 5/29/26.
//

import Foundation

/// Keys used when encoding a `UnitConverter` inside a unit.
private enum UnitConverterCodingKey: String, CodingKey {
    case kind
    case coefficient
    case constant
}

/// Discriminator for the concrete ``UnitConverter`` type.
private enum UnitConverterKind: String, Codable {
    case linear
    case offset
    case empty
    case powerLaw
}

/// A `Codable` box around the erased `any UnitConverter` value. Encoding tags
/// the concrete converter with a `kind` so it can be reconstructed on decode.
private struct AnyUnitConverterCodable: Codable {
    let converter: any UnitConverter

    init(_ converter: any UnitConverter) {
        self.converter = converter
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UnitConverterCodingKey.self)
        switch try container.decode(UnitConverterKind.self, forKey: .kind) {
        case .linear:
            converter = LinearConverter(coefficient: try container.decode(Double.self, forKey: .coefficient))
        case .offset:
            converter = OffsetConverter(
                coefficient: try container.decode(Double.self, forKey: .coefficient),
                constant: try container.decode(Double.self, forKey: .constant)
            )
        case .empty:
            converter = EmptyConverter()
        case .powerLaw:
            converter = PowerLawConverter(
                base: try container.decode(Double.self, forKey: .coefficient),
                reference: try container.decode(Double.self, forKey: .constant)
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UnitConverterCodingKey.self)
        switch converter {
        case let linear as LinearConverter:
            try container.encode(UnitConverterKind.linear, forKey: .kind)
            try container.encode(linear.coefficient, forKey: .coefficient)
        case let offset as OffsetConverter:
            try container.encode(UnitConverterKind.offset, forKey: .kind)
            try container.encode(offset.coefficient, forKey: .coefficient)
            try container.encode(offset.constant, forKey: .constant)
        case let empty as EmptyConverter:
            try container.encode(UnitConverterKind.empty, forKey: .kind)
        case let powerLaw as PowerLawConverter:
            try container.encode(UnitConverterKind.powerLaw, forKey: .kind)
            try container.encode(powerLaw.base, forKey: .coefficient)
            try container.encode(powerLaw.reference, forKey: .constant)
        default:
            throw EncodingError.invalidValue(
                converter,
                EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unsupported UnitConverter type: \(type(of: converter))"
                )
            )
        }
    }
}

extension NamedUnit: Codable {
    private enum CodingKeys: String, CodingKey {
        case symbol
        case dimension
        case converter
        case symbolPosition
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let dimension = try container.decode(PhysicalDimension.self, forKey: .dimension)
        let converter = try container.decode(AnyUnitConverterCodable.self, forKey: .converter).converter
        let symbolPosition = try container.decode(SymbolPosition.self, forKey: .symbolPosition)
        self.init(symbol: symbol, dimension: dimension, converter: converter, symbolPosition: symbolPosition)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(dimension, forKey: .dimension)
        try container.encode(AnyUnitConverterCodable(converter), forKey: .converter)
        try container.encode(symbolPosition, forKey: .symbolPosition)
    }
}

extension CompositeUnit: Codable {
    private enum CodingKeys: String, CodingKey {
        case symbol
        case dimension
        case converter
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let symbol = try container.decode(String.self, forKey: .symbol)
        let dimension = try container.decode(PhysicalDimension.self, forKey: .dimension)
        let converter = try container.decode(AnyUnitConverterCodable.self, forKey: .converter).converter
        self.init(symbol: symbol, dimension: dimension, converter: converter)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(dimension, forKey: .dimension)
        try container.encode(AnyUnitConverterCodable(converter), forKey: .converter)
    }
}