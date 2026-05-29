// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Math",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "Math",
            targets: ["Math"]
        ),
    ],
    dependencies: [
        // Depend on swift-syntax for compiler macros
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
        // Apple's Swift DocC plugin for documentation compilation and generation
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        // Macro implementation target
        .macro(
            name: "MathMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        // Core library target depending on the macro plugin
        .target(
            name: "Math",
            dependencies: ["MathMacros"]
        ),
        // Test target
        .testTarget(
            name: "MathTests",
            dependencies: ["Math"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
