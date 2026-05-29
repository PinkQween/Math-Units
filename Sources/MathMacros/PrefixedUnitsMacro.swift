import SwiftSyntax
import SwiftSyntaxMacros

enum MacroError: Error, CustomStringConvertible {
    case missingArguments
    case invalidArgument(String)
    
    var description: String {
        switch self {
        case .missingArguments:
            return "Missing arguments for PrefixedUnits macro."
        case .invalidArgument(let name):
            return "Invalid or missing argument '\(name)'."
        }
    }
}

struct Prefix {
    let name: String
    let symbol: String
    let multiplier: String
    let isFractional: Bool
}

public struct PrefixedUnitsMacro: MemberMacro {
    
    private static let decimalPrefixes = [
        Prefix(name: "yotta", symbol: "Y", multiplier: "1e24", isFractional: false),
        Prefix(name: "zetta", symbol: "Z", multiplier: "1e21", isFractional: false),
        Prefix(name: "exa", symbol: "E", multiplier: "1e18", isFractional: false),
        Prefix(name: "peta", symbol: "P", multiplier: "1e15", isFractional: false),
        Prefix(name: "tera", symbol: "T", multiplier: "1e12", isFractional: false),
        Prefix(name: "giga", symbol: "G", multiplier: "1e9", isFractional: false),
        Prefix(name: "mega", symbol: "M", multiplier: "1e6", isFractional: false),
        Prefix(name: "kilo", symbol: "k", multiplier: "1e3", isFractional: false),
        Prefix(name: "hecto", symbol: "h", multiplier: "1e2", isFractional: false),
        Prefix(name: "deca", symbol: "da", multiplier: "10.0", isFractional: false),
        Prefix(name: "deci", symbol: "d", multiplier: "0.1", isFractional: true),
        Prefix(name: "centi", symbol: "c", multiplier: "0.01", isFractional: true),
        Prefix(name: "milli", symbol: "m", multiplier: "1e-3", isFractional: true),
        Prefix(name: "micro", symbol: "µ", multiplier: "1e-6", isFractional: true),
        Prefix(name: "nano", symbol: "n", multiplier: "1e-9", isFractional: true),
        Prefix(name: "pico", symbol: "p", multiplier: "1e-12", isFractional: true),
        Prefix(name: "femto", symbol: "f", multiplier: "1e-15", isFractional: true),
        Prefix(name: "atto", symbol: "a", multiplier: "1e-18", isFractional: true),
        Prefix(name: "zepto", symbol: "z", multiplier: "1e-21", isFractional: true),
        Prefix(name: "yocto", symbol: "y", multiplier: "1e-24", isFractional: true)
    ]
    
    private static let binaryPrefixes = [
        Prefix(name: "kibi", symbol: "Ki", multiplier: "1024.0", isFractional: false),
        Prefix(name: "mebi", symbol: "Mi", multiplier: "1048576.0", isFractional: false),
        Prefix(name: "gibi", symbol: "Gi", multiplier: "1073741824.0", isFractional: false),
        Prefix(name: "tebi", symbol: "Ti", multiplier: "1099511627776.0", isFractional: false),
        Prefix(name: "pebi", symbol: "Pi", multiplier: "1125899906842624.0", isFractional: false),
        Prefix(name: "exbi", symbol: "Ei", multiplier: "1152921504606846976.0", isFractional: false)
    ]
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // Ensure we have a list of labeled arguments
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else {
            throw MacroError.missingArguments
        }
        
        // Parse "name"
        guard let nameExpr = arguments.first(where: { $0.label?.text == "name" })?.expression,
              let nameLiteral = nameExpr.as(StringLiteralExprSyntax.self),
              let nameSegment = nameLiteral.segments.first?.as(StringSegmentSyntax.self) else {
            throw MacroError.invalidArgument("name")
        }
        let name = nameSegment.content.text
        
        // Parse "symbol"
        guard let symbolExpr = arguments.first(where: { $0.label?.text == "symbol" })?.expression,
              let symbolLiteral = symbolExpr.as(StringLiteralExprSyntax.self),
              let symbolSegment = symbolLiteral.segments.first?.as(StringSegmentSyntax.self) else {
            throw MacroError.invalidArgument("symbol")
        }
        let symbol = symbolSegment.content.text
        
        // Parse "dimension"
        guard let dimensionExpr = arguments.first(where: { $0.label?.text == "dimension" })?.expression else {
            throw MacroError.invalidArgument("dimension")
        }
        let dimension = dimensionExpr.description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse "baseCoefficient" (optional, default to 1.0)
        let baseCoefficient = arguments.first(where: { $0.label?.text == "baseCoefficient" })?.expression.description
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? "1.0"
        
        // Parse "supportsFractionalPrefixes" (optional, default to true)
        var supportsFractionalPrefixes = true
        if let expr = arguments.first(where: { $0.label?.text == "supportsFractionalPrefixes" })?.expression {
            if expr.description.contains("false") {
                supportsFractionalPrefixes = false
            }
        }
        
        // Parse "supportsBinaryPrefixes" (optional, default to false)
        var supportsBinaryPrefixes = false
        if let expr = arguments.first(where: { $0.label?.text == "supportsBinaryPrefixes" })?.expression {
            if expr.description.contains("true") {
                supportsBinaryPrefixes = true
            }
        }
        
        // Map dimension string (e.g. .length) to the type (e.g. MathDimension.length)
        let dimensionTypeName: String
        if dimension.hasPrefix(".") {
            dimensionTypeName = "MathDimension." + dimension.dropFirst()
        } else {
            dimensionTypeName = dimension
        }
        
        var members: [DeclSyntax] = []
        
        // 1. Base Unit
        let baseDecl = """
        public static let \(name) = NamedUnit<\(dimensionTypeName)>(
            symbol: "\(symbol)",
            dimension: \(dimension),
            converter: LinearConverter(coefficient: \(baseCoefficient))
        )
        """
        members.append(DeclSyntax(stringLiteral: baseDecl))
        
        // 2. Decimal Prefixes
        for pref in decimalPrefixes {
            if pref.isFractional && !supportsFractionalPrefixes {
                continue
            }
            let propName = "\(pref.name)\(name)"
            let prefSymbol = "\(pref.symbol)\(symbol)"
            let coeffExpr = "(\(baseCoefficient) * \(pref.multiplier))"
            let decl = """
            public static let \(propName) = NamedUnit<\(dimensionTypeName)>(
                symbol: "\(prefSymbol)",
                dimension: \(dimension),
                converter: LinearConverter(coefficient: \(coeffExpr))
            )
            """
            members.append(DeclSyntax(stringLiteral: decl))
        }
        
        // 3. Binary Prefixes
        if supportsBinaryPrefixes {
            for pref in binaryPrefixes {
                let propName = "\(pref.name)\(name)"
                let prefSymbol = "\(pref.symbol)\(symbol)"
                let coeffExpr = "(\(baseCoefficient) * \(pref.multiplier))"
                let decl = """
                public static let \(propName) = NamedUnit<\(dimensionTypeName)>(
                    symbol: "\(prefSymbol)",
                    dimension: \(dimension),
                    converter: LinearConverter(coefficient: \(coeffExpr))
                )
                """
                members.append(DeclSyntax(stringLiteral: decl))
            }
        }
        
        return members
    }
}
