import Testing
@testable import Math

// Regression tests for leading-dot unit namespaces when the unit type is
// already pinned by surrounding context (SE-0299 implicit member lookup then
// resolves the first member on the concrete type instead of through the
// `where Self ==` protocol proxies, which handle the open-generic case).
@Suite struct PinnedUnitTypeNamespaceLookupTests {
    @Test func explicitConcreteTypeChain() {
        let a: Quantity<NamedUnit<MathDimension.currency>> = Quantity(value: 5, unit: .currency.usd)
        #expect(a.value == 5)
        #expect(a.unit.symbol == "$")
    }

    @Test func pinnedRatioChainMix() {
        let b: Quantity<RatioUnit<NamedUnit<MathDimension.currency>, NamedUnit<MathDimension.force>>> =
            Quantity(4.50, .currency.usd.per(.weight.pound))
        #expect(b.value == 4.50)
        #expect(b.unit.symbol == "($/lbf)")
    }

    @Test func memberwiseInitWithInferredAmount() {
        struct BI<Amount: MathUnit> {
            let amount: Quantity<Amount>
            let cost: Quantity<RatioUnit<NamedUnit<MathDimension.currency>, Amount>>
        }
        let bi = BI(
            amount: Quantity(100, .weight.pound),
            cost: Quantity(4.50, .currency.usd.per(.weight.pound))
        )
        #expect(bi.amount.value == 100)
        #expect(bi.amount.unit.symbol == "lbf")
        #expect(bi.cost.value == 4.50)
        #expect(bi.cost.unit.symbol == "($/lbf)")
    }
}