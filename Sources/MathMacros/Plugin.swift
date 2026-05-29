import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MathMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PrefixedUnitsMacro.self
    ]
}
