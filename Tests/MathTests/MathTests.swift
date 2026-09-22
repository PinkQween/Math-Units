import Testing
@testable import Math
import Foundation

@Suite struct MathTests {
    
    @Test func testBaseConversion() {
        let fiveKm = Quantity(value: 5.0, unit: Units.kilometer)
        let inMeters = fiveKm.converted(to: Units.meter)
        #expect(inMeters.value == 5000.0)
        
        let meters = Quantity(value: 2000.0, unit: Units.meter)
        let inKm = meters.converted(to: Units.kilometer)
        #expect(inKm.value == 2.0)
    }
    
    @Test func testEmptyConverter() {
        let converter = EmptyConverter()
        #expect(converter.convertToBase(5.0) == 5.0)
        #expect(converter.convertFromBase(10.0) == 10.0)
    }
    
    @Test func testPlanckToCosmologicalScales() {
        // 1 Megaparsec
        let oneMpc = Quantity(value: 1.0, unit: Units.megaparsec)
        
        // Convert to meters
        let inMeters = oneMpc.converted(to: Units.meter)
        #expect(abs(inMeters.value - 3.0856775814913673e22) < 1.0)
        
        // Convert to Planck lengths
        let inPlanckLengths = oneMpc.converted(to: Units.planckLength)
        let expectedPlanckLengths = 3.0856775814913673e22 / 1.616255e-35
        
        // Let's do a relative error expectation
        let relativeError = abs(inPlanckLengths.value - expectedPlanckLengths) / expectedPlanckLengths
        #expect(relativeError < 1e-12)
        
        // Convert 1 Planck length to meters
        let onePlanck = Quantity(value: 1.0, unit: Units.planckLength)
        let planckInMeters = onePlanck.converted(to: Units.meter)
        #expect(planckInMeters.value == 1.616255e-35)
    }
    
    @Test func testOffsetTemperature() {
        // Celsius to Kelvin
        let zeroCelsius = Quantity(value: 0.0, unit: Units.celsius)
        let kelvin = zeroCelsius.converted(to: Units.kelvin)
        #expect(kelvin.value == 273.15)
        
        let hotCelsius = Quantity(value: 100.0, unit: Units.celsius)
        let boilingKelvin = hotCelsius.converted(to: Units.kelvin)
        #expect(abs(boilingKelvin.value - 373.15) < 1e-9)
        
        // Kelvin to Celsius
        let roomKelvin = Quantity(value: 293.15, unit: Units.kelvin)
        let roomCelsius = roomKelvin.converted(to: Units.celsius)
        #expect(abs(roomCelsius.value - 20.0) < 1e-9)
    }
    
    @Test func testDimensionalAdditionSubtraction() {
        let length1 = Quantity(value: 5.0, unit: Units.meter)
        let length2 = Quantity(value: 2.0, unit: Units.kilometer) // 2000 m
        
        let sum = length1 + length2
        #expect(sum.value == 2005.0)
        #expect(sum.unit.symbol == "m")
        
        let diff = length2 - length1
        #expect(diff.value == 1.995)
        #expect(diff.unit.symbol == "km")
    }
    
    @Test func testDimensionalAlgebra() {
        // distance = 100 meters
        let distance = Quantity(value: 100.0, unit: Units.meter)
        // duration = 5 seconds
        let duration = Quantity(value: 5.0, unit: Units.second)
        
        // velocity = distance / duration
        let velocity = distance / duration
        #expect(velocity.value == 20.0)
        #expect(velocity.unit.dimension == .speed)
        #expect(velocity.unit.symbol == "(m/s)")
        
        // area = distance * distance
        let area = distance * distance
        #expect(area.value == 10000.0)
        #expect(area.unit.dimension == .area)
        #expect(area.unit.symbol == "(m*m)")
        
        // acceleration unit: m/s^2
        let accelerationUnit = CompositeUnit(
            symbol: "m/s^2",
            dimension: .acceleration,
            converter: LinearConverter(coefficient: 1.0)
        )
        let acceleration = Quantity(value: 9.81, unit: accelerationUnit)
        let mass = Quantity(value: 80.0, unit: Units.kilogram)
        
        // force = mass * acceleration
        let force = mass * acceleration
        #expect(abs(force.value - 784.8) < 1e-9)
        #expect(force.unit.dimension == .force)
        #expect(force.unit.symbol == "(kg*m/s^2)")
        
        // work (energy) = force * distance
        let energy = force * distance
        #expect(abs(energy.value - 78480.0) < 1e-9)
        #expect(energy.unit.dimension == .energy)
        #expect(energy.unit.symbol == "((kg*m/s^2)*m)")
        
        // Verify SI Derived Dimensions
        #expect(PhysicalDimension.resistance.exponents == ["length": 2, "mass": 1, "time": -3, "electricCurrent": -2])
        #expect(PhysicalDimension.capacitance.exponents == ["length": -2, "mass": -1, "time": 4, "electricCurrent": 2])
        #expect(PhysicalDimension.inductance.exponents == ["length": 2, "mass": 1, "time": -2, "electricCurrent": -2])
        #expect(PhysicalDimension.conductance.exponents == ["length": -2, "mass": -1, "time": 3, "electricCurrent": 2])
    }
    
    @Test func testImaginaryAndCustomDimensions() {
        let usdDimension = PhysicalDimension(exponents: ["USD": 1])
        let usdUnit = NamedUnit<MathDimension.unknown>(symbol: "$", dimension: usdDimension, converter: LinearConverter(coefficient: 1.0))
        
        let eurUnit = NamedUnit<MathDimension.unknown>(symbol: "€", dimension: usdDimension, converter: LinearConverter(coefficient: 1.09))
        
        // Currency conversion
        let tenEur = Quantity(value: 10.0, unit: eurUnit)
        let inUsd = tenEur.converted(to: usdUnit)
        #expect(abs(inUsd.value - 10.9) < 1e-9)
        
        // User dimension
        let userDimension = PhysicalDimension(exponents: ["user": 1])
        let userUnit = NamedUnit<MathDimension.unknown>(symbol: "user", dimension: userDimension, converter: LinearConverter(coefficient: 1.0))
        
        // Currency per user (USD / user)
        let revenue = Quantity(value: 1000.0, unit: usdUnit)
        let staff = Quantity(value: 10.0, unit: userUnit)
        let revenuePerUser = revenue / staff
        
        #expect(revenuePerUser.value == 100.0)
        #expect(revenuePerUser.unit.symbol == "($/user)")
        
        let expectedDimension = PhysicalDimension(exponents: ["USD": 1, "user": -1])
        #expect(revenuePerUser.unit.dimension == expectedDimension)
    }
    
    @Test func testGeneratedPrefixedUnits() {
        // Digital Data Conversions (Decimal & Binary)
        let twoGb = Quantity(value: 2.0, unit: Units.gigabyte)
        let inBytes = twoGb.converted(to: Units.byte)
        #expect(inBytes.value == 2_000_000_000.0)
        
        let twoGib = Quantity(value: 2.0, unit: Units.gibibyte)
        let gibInBytes = twoGib.converted(to: Units.byte)
        #expect(gibInBytes.value == 2.0 * 1073741824.0)
        
        // Mass conversions using generated gram/kilogram/microgram
        let oneKg = Quantity(value: 1.0, unit: Units.kilogram)
        let inGrams = oneKg.converted(to: Units.gram)
        #expect(inGrams.value == 1000.0)
        
        let micro = Quantity(value: 1_000_000.0, unit: Units.microgram)
        let microInGrams = micro.converted(to: Units.gram)
        #expect(abs(microInGrams.value - 1.0) < 1e-9)
        
        // Bit prefix conversions
        let oneMib = Quantity(value: 1.0, unit: Units.mebibit)
        let inBits = oneMib.converted(to: Units.bit)
        #expect(inBits.value == 1048576.0)
    }
    
    @Test func testCustomaryAndPhysicsUnits() {
        // Slug to kilograms conversion
        let tenSlugs = Quantity(value: 10.0, unit: Units.slug)
        let inKg = tenSlugs.converted(to: Units.kilogram)
        #expect(abs(inKg.value - 145.939029) < 1e-4)
        
        // Foot-pound to joules conversion
        let work = Quantity(value: 100.0, unit: Units.footPound)
        let workInJoules = work.converted(to: Units.joule)
        #expect(abs(workInJoules.value - 135.58179483314004) < 1e-6)
        
        // Newton to lbf conversion
        let forceInN = Quantity(value: 100.0, unit: Units.newton)
        let forceInLbf = forceInN.converted(to: Units.poundForce)
        #expect(abs(forceInLbf.value - 22.4808943) < 1e-6)
        
        // Fahrenheit to Celsius conversion
        let bodyTempF = Quantity(value: 98.6, unit: Units.fahrenheit)
        let bodyTempC = bodyTempF.converted(to: Units.celsius)
        #expect(abs(bodyTempC.value - 37.0) < 1e-3)
    }
    
    @Test func testFahrenheitToKelvinToBtu() {
        // 1. Convert Fahrenheit to Kelvin
        let tempF = Quantity(value: 77.0, unit: Units.fahrenheit) // Room temperature ~ 77°F
        let tempK = tempF.converted(to: Units.kelvin)
        #expect(abs(tempK.value - 298.15) < 1e-3)
        
        // 2. Relate temperature to thermal energy using Boltzmann's constant:
        // k_B = 1.380649e-23 J/K
        let k_B = Quantity(value: 1.380649e-23, unit: Units.joule / Units.kelvin)
        let expectedJ = 1.380649e-23 * 298.15
        
        // E = k_B * T
        let thermalEnergyJ = k_B * tempK
        #expect(abs(thermalEnergyJ.value - expectedJ) / expectedJ < 1e-5)
        #expect(thermalEnergyJ.unit.dimension == .energy)
        
        // 3. Convert thermal energy in Joules to BTU (1 BTU ≈ 1055.05585262 Joules)
        let thermalEnergyBtu = thermalEnergyJ.converted(to: Units.britishThermalUnit)
        let expectedBtu = expectedJ / 1055.05585262
        #expect(abs(thermalEnergyBtu.value - expectedBtu) / expectedBtu < 1e-5)
        
        // 4. Direct 1-line conversion from temperature to energy (Fahrenheit to BTU)
        let directBtu = tempF.converted(to: Units.britishThermalUnit)
        #expect(abs(directBtu.value - expectedBtu) / expectedBtu < 1e-5)
        
        // 5. Direct 1-line conversion back from energy to temperature (BTU to Fahrenheit)
        let tempBackF = directBtu.converted(to: Units.fahrenheit)
        #expect(abs(tempBackF.value - 77.0) < 1e-9)
        
        // 6. Test thermalEnergy property (returns J)
        let propJ = tempF.thermalEnergy
        #expect(propJ.unit.symbol == "J")
        #expect(abs(propJ.value - expectedJ) / expectedJ < 1e-5)
        
        // 7. Test 1-line conversion from thermal energy to other energy using thermalEnergy(in:)
        let propBtu = tempF.thermalEnergy(in: Units.britishThermalUnit)
        #expect(propBtu.unit.symbol == "BTU")
        #expect(abs(propBtu.value - expectedBtu) / expectedBtu < 1e-5)
    }
    
    @Test func testAdditionalCustomaryUnits() {
        // Test British Breakfast Cup to US Cup
        let breakfastCups = Quantity(value: 2.0, unit: Units.britishBreakfastCup)
        let usCups = breakfastCups.converted(to: Units.usCup)
        // 2 breakfast cups = 2 * 227.3045 ml = 454.609 ml
        // 1 US cup = 236.5882365 ml -> 454.609 / 236.5882365 approx 1.9215 cups
        #expect(abs(usCups.value - 1.92151152) < 1e-5)
        
        // Test Imperial fluid ounces vs US fluid ounces
        let impFlOz = Quantity(value: 20.0, unit: Units.imperialFluidOunce) // 1 Imperial Pint
        let usFlOz = impFlOz.converted(to: Units.usFluidOunce)
        // 20 imp fl oz = 20 * 28.4130625 ml = 568.26125 ml
        // 1 US fl oz = 29.5735295625 ml -> 568.26125 / 29.5735295625 approx 19.215 us fl oz
        #expect(abs(usFlOz.value - 19.2151988) < 1e-5)
        
        // Test Troy pound vs Avoirdupois pound
        let troyLbs = Quantity(value: 10.0, unit: Units.troyPound)
        let avdpLbs = troyLbs.converted(to: Units.pound)
        // 10 troy lbs = 3.732417216 kg
        // 1 avdp lb = 0.45359237 kg -> 3.732417216 / 0.45359237 approx 8.22857 lbs
        #expect(abs(avdpLbs.value - 8.22857143) < 1e-5)
        
        // Test Carat to Gram
        let diamondCarats = Quantity(value: 5.0, unit: Units.carat)
        let grams = diamondCarats.converted(to: Units.gram)
        #expect(abs(grams.value - 1.0) < 1e-9)
    }
    
    @Test func testNewScientificDimensions() {
        // Test tesla to gauss (magnetic flux density)
        let magneticField = Quantity(value: 1.5, unit: Units.tesla)
        let inGauss = magneticField.converted(to: Units.gauss)
        #expect(abs(inGauss.value - 15000.0) < 1e-9)
        
        // Test weber to maxwell (magnetic flux)
        let magneticFlux = Quantity(value: 0.001, unit: Units.weber)
        let inMaxwell = magneticFlux.converted(to: Units.maxwell)
        #expect(abs(inMaxwell.value - 100000.0) < 1e-9)
        
        // Test becquerel to curie (radiation frequency)
        let activity = Quantity(value: 3.7e10, unit: Units.becquerel)
        let inCurie = activity.converted(to: Units.curie)
        #expect(abs(inCurie.value - 1.0) < 1e-9)
        
        // Test gray to rad (absorbed dose)
        let dose = Quantity(value: 1.0, unit: Units.gray)
        let inRad = dose.converted(to: Units.rad)
        #expect(abs(inRad.value - 100.0) < 1e-9)
        
        // Test degree to radian
        let rightAngle = Quantity(value: 90.0, unit: Units.degree)
        let inRadians = rightAngle.converted(to: Units.radian)
        #expect(abs(inRadians.value - Double.pi / 2.0) < 1e-9)
    }
    
    @Test func testFunAndHumorousUnits() {
        // Test beard-seconds to meters
        let beardLength = Quantity(value: 2.0, unit: Units.beardSecond) // 10 nm
        let inMeters = beardLength.converted(to: Units.meter)
        #expect(inMeters.value == 1e-8)
        
        // Test reindeer pee distance (Poronkusema) to kilometers
        let reindeerTravel = Quantity(value: 1.0, unit: Units.poronkusema)
        let inKm = reindeerTravel.converted(to: Units.kilometer)
        #expect(inKm.value == 7.5)
        
        // Test butt to liters
        let buttVolume = Quantity(value: 2.0, unit: Units.butt)
        let inLiters = buttVolume.converted(to: Units.liter)
        #expect(abs(inLiters.value - 981.95544) < 1e-5)
        
        // Test jiffy to seconds
        let compJiffy = Quantity(value: 60.0, unit: Units.jiffy)
        let inSec = compJiffy.converted(to: Units.second)
        #expect(abs(inSec.value - 1.0) < 1e-9)
        
        // Test physics jiffy to seconds
        let physJiffy = Quantity(value: 1e11, unit: Units.physicsJiffy)
        let physInSec = physJiffy.converted(to: Units.second)
        #expect(abs(physInSec.value - 3.33564095198) < 1e-9)
        
        // Test Micromort to percent
        let risk = Quantity(value: 10000.0, unit: Units.micromort) // 10,000 micromorts = 10,000 / 1e6 = 0.01 probability
        let inPercent = risk.converted(to: Units.percent) // 1% = 0.01 probability
        #expect(abs(inPercent.value - 1.0) < 1e-9)
    }
    
    @Test func testCurrencyConversion() {
        // Test standard currency conversion (EUR -> USD)
        let tenEur = Quantity(value: 10.0, unit: Units.eur)
        let inUsd = tenEur.converted(to: Units.usd)
        #expect(abs(inUsd.value - 10.8) < 1e-9)
        
        // Test back to EUR
        let backToEur = inUsd.converted(to: Units.eur)
        #expect(abs(backToEur.value - 10.0) < 1e-9)
        
        // Test cryptocurrency conversion (BTC -> USD)
        let oneBtc = Quantity(value: 1.0, unit: Units.btc)
        let btcInUsd = oneBtc.converted(to: Units.usd)
        #expect(btcInUsd.value == 68000.0)
        
        // Test TRY currency escaping
        let tryValue = Quantity(value: 100.0, unit: Units.`try`)
        let tryInUsd = tryValue.converted(to: Units.usd)
        #expect(abs(tryInUsd.value - 3.1) < 1e-9)
        
        // Test currency symbols inside the units
        #expect(Units.usd.symbol == "$")
        #expect(Units.eur.symbol == "€")
        #expect(Units.gbp.symbol == "£")
        #expect(Units.jpy.symbol == "¥")
        #expect(Units.btc.symbol == "₿")
        
        // Test currency resolution helpers
        #expect(Units.currency(for: "USD") == Units.usd)
        #expect(Units.currency(for: "eur") == Units.eur)
        #expect(Units.currency(for: "btc") == Units.btc)
        #expect(Units.currency(for: "INVALID") == nil)
    }
    
    @Test func testUnitEquatableAndHashable() {
        // Test NamedUnit Equatable
        let usd1 = Units.usd
        let usd2 = NamedUnit<MathDimension.currency>(symbol: "$", dimension: .currency, converter: LinearConverter(coefficient: 1.0))
        let eur = Units.eur
        #expect(usd1 == usd2)
        #expect(usd1 != eur)
        
        // Test NamedUnit Hashable
        var unitSet = Set<NamedUnit<MathDimension.currency>>()
        unitSet.insert(usd1)
        unitSet.insert(usd2)
        unitSet.insert(eur)
        #expect(unitSet.count == 2)
        
        // Test PriceRange compiles and uses Equatable synthesized conformance
        struct PriceRange: Sendable, Equatable {
            public var startPrice: NamedUnit<MathDimension.currency>
            public var endPrice: NamedUnit<MathDimension.currency>
        }
        let range1 = PriceRange(startPrice: usd1, endPrice: eur)
        let range2 = PriceRange(startPrice: usd2, endPrice: eur)
        #expect(range1 == range2)
    }
    
    @Test func testQuantityFormatting() {
        // Test prefix symbol positioning (e.g. USD)
        let tenDollars = Quantity(value: 10.1234, unit: Units.usd)
        #expect(tenDollars.unit.symbolPosition == .prefix)
        #expect(tenDollars.formatted() == "$10.12")
        #expect(tenDollars.formatted(decimalPlaces: 3) == "$10.123")
        #expect(tenDollars.formatted(includeSpace: true) == "$ 10.12")
        
        // Test suffix symbol positioning (e.g. meters)
        let fiveMeters = Quantity(value: 5.5, unit: Units.meter)
        #expect(fiveMeters.unit.symbolPosition == .suffix)
        #expect(fiveMeters.formatted() == "5.50 m")
        #expect(fiveMeters.formatted(decimalPlaces: 1) == "5.5 m")
        #expect(fiveMeters.formatted(includeSpace: false) == "5.50m")
        
        // Test suffix currency symbol positioning (e.g. Swedish Krona)
        let krona = Quantity(value: 100.0, unit: Units.sek)
        #expect(krona.unit.symbolPosition == .suffix)
        #expect(krona.formatted(decimalPlaces: 0) == "100 kr")
        
        // Test percent suffix positioning without space
        let pct = Quantity(value: 75.5, unit: Units.percent)
        #expect(pct.unit.symbolPosition == .suffix)
        #expect(pct.formatted(decimalPlaces: 1) == "75.5%")
        #expect(pct.formatted(decimalPlaces: 1, includeSpace: true) == "75.5 %")
    }
    
    @Test func testQuantityHashable() {
        let fiveMeters = Quantity(value: 5.0, unit: Units.meter)
        let fiveMetersAgain = Quantity(value: 5.0, unit: Units.meter)
        let fiveMiles = Quantity(value: 5.0, unit: Units.mile)
        let threeMeters = Quantity(value: 3.0, unit: Units.meter)

        // Unit-aware equality: compares value AND unit (symbol + dimension)
        #expect(fiveMeters == fiveMetersAgain)
        #expect(fiveMeters != fiveMiles)    // same value, different unit
        #expect(fiveMeters != threeMeters)  // same unit, different value

        // Dictionary key / set member behavior
        let lookup: [Quantity<NamedUnit<MathDimension.length>>: String] = [
            fiveMeters: "five meters",
            fiveMiles: "five miles",
            threeMeters: "three meters",
        ]
        #expect(lookup[fiveMetersAgain] == "five meters")
        #expect(lookup[Quantity(value: 5.0, unit: Units.mile)] == "five miles")
        #expect(Set([fiveMeters, fiveMetersAgain, fiveMiles, threeMeters]).count == 3)
    }
    
    @Test func testQuantityCodableRoundTrip() throws {
        // Linear converter unit (mile -> meter)
        let distance = Quantity(value: 26.2, unit: Units.mile)
        let distanceData = try JSONEncoder().encode(distance)
        let distanceDecoded = try JSONDecoder().decode(
            Quantity<NamedUnit<MathDimension.length>>.self, from: distanceData)
        #expect(distanceDecoded == distance)
        #expect(distanceDecoded.converted(to: Units.kilometer).value > 42.0)

        // Empty converter unit (gram)
        let mass = Quantity(value: 500.0, unit: Units.gram)
        let massData = try JSONEncoder().encode(mass)
        let massDecoded = try JSONDecoder().decode(
            Quantity<NamedUnit<MathDimension.mass>>.self, from: massData)
        #expect(massDecoded == mass)

        // Offset converter unit (Fahrenheit) — preserves the offset
        let temp = Quantity(value: 77.0, unit: Units.fahrenheit)
        let tempData = try JSONEncoder().encode(temp)
        let tempDecoded = try JSONDecoder().decode(
            Quantity<NamedUnit<MathDimension.energy>>.self, from: tempData)
        #expect(tempDecoded == temp)
        #expect(tempDecoded.isEquivalent(to: Quantity(value: 25.0, unit: Units.celsius), tolerance: 1e-3))

        // Composite unit (m/s)
        let speed = Quantity(value: 10.0, unit: Units.meter) / Quantity(value: 2.0, unit: Units.second)
        let speedData = try JSONEncoder().encode(speed)
        let speedDecoded = try JSONDecoder().decode(Quantity<CompositeUnit>.self, from: speedData)
        #expect(speedDecoded == speed)

        // A recipe-style dictionary round-trips as a whole
        let recipe: [String: Quantity<NamedUnit<MathDimension.mass>>] = [
            "flour": Quantity(value: 500.0, unit: Units.gram),
            "sugar": Quantity(value: 200.0, unit: Units.gram),
        ]
        let recipeData = try JSONEncoder().encode(recipe)
        let recipeDecoded = try JSONDecoder().decode(
            [String: Quantity<NamedUnit<MathDimension.mass>>].self, from: recipeData)
        #expect(recipeDecoded == recipe)
    }
    
    // MARK: - Units by Dimension
    
    @Test func testDimensionNamespaces() {
        // Volume units are grouped under Units.Volume
        let water = Quantity(2, Units.Volume.cup)
        #expect(water.unit.dimension == .volume)
        let inPints = water.converted(to: Units.Volume.usPint)
        #expect(abs(inPints.value - 1.0) < 1e-9)
        
        // Mass and weight (force) are distinct dimensions that must not mix.
        let massOunce = Quantity(16, Units.Mass.ounce)
        let weightOunce = Quantity(16, Units.Weight.ounce)
        #expect(massOunce.unit.dimension == .mass)
        #expect(weightOunce.unit.dimension == .force)
        #expect(massOunce.unit.dimension != weightOunce.unit.dimension)
        #expect(massOunce.unit.symbol == "oz")
        #expect(weightOunce.unit.symbol == "ozf")
        
        // The canonical force names are available alongside the colloquial ones.
        #expect(Units.Weight.poundForce.symbol == "lbf")
        #expect(Units.Weight.pound == Units.poundForce)
    }
    
    @Test func testUnitsForDimension() {
        // Browsing volume units returns exactly the volume catalog.
        let volumeUnits = Units.units(for: .volume)
        #expect(volumeUnits.contains { $0.symbol == "fl_oz" })
        #expect(volumeUnits.contains { $0.symbol == "L" })
        #expect(!volumeUnits.contains { $0.symbol == "lb" })
        
        // Force and mass never appear in each other's listings.
        let forceUnits = Units.units(for: .force)
        #expect(forceUnits.contains { $0.symbol == "lbf" })
        #expect(!forceUnits.contains { $0.symbol == "lb" })
        
        // The energy namespace includes the temperature scales.
        let energyUnits = Units.units(for: .energy)
        #expect(energyUnits.contains { $0.symbol == "K" })
        #expect(energyUnits.contains { $0.symbol == "°C" })
        
        // Currency units are browsable via their own dimension.
        let currencyUnits = Units.units(for: .currency)
        #expect(currencyUnits.contains { $0.symbol == "$" })
    }
    
    @Test func testConvenienceInit() {
        let marathon = Quantity(42.195, Units.Length.mile)
        #expect(marathon.value == 42.195)
        #expect(marathon.unit == Units.mile)
        
        let thrust = Quantity(480, Units.Weight.poundForce)
        #expect(thrust.value == 480)
        #expect(thrust.unit == Units.poundForce)
        
        let cup = Quantity(1, Units.Volume.cup)
        #expect(cup.unit == Units.cup)
    }
    
    @Test func testLeadingDotUnitNamespaces() {
        // SE-0299 member lookup: `.volume` resolves against the generic `U: MathUnit`
        // constraint, then `.fluidOunce` chains onto the Volume namespace.
        let oil = Quantity(value: 2, unit: .volume.fluidOunce)
        #expect(oil.unit == Units.fluidOunce)
        #expect(oil.unit.dimension == .volume)

        let recipeWater = Quantity(value: 12, unit: .mass.ounce)
        #expect(recipeWater.unit == Units.ounce)

        let load = Quantity(value: 150, unit: .weight.pound)
        #expect(load.unit == Units.poundForce)

        let fuel = Quantity(value: 10, unit: .energy.calorie)
        #expect(fuel.unit == Units.calorie)

        let cash = Quantity(value: 5, unit: .currency.usd)
        #expect(cash.unit == Units.usd)

        // Prefixed units resolve both bare and filtered by dimension.
        let precise = Quantity(value: 1, unit: .voltage.nanovolt)
        #expect(precise.unit == Units.nanovolt)
        let bareVolt = Quantity(value: 1, unit: .nanovolt)
        #expect(bareVolt.unit == Units.nanovolt)

        let tiny = Quantity(value: 1, unit: .volume.milliliter)
        #expect(tiny.unit == Units.milliliter)
        let bareMilli = Quantity(value: 1, unit: .milliliter)
        #expect(bareMilli.unit == Units.milliliter)
        let positionalMilli = Quantity(1, .milliliter)
        #expect(positionalMilli.unit == Units.milliliter)

        // Binary-prefixed units are reachable the same way.
        let disk = Quantity(value: 1, unit: .data.gibibyte)
        #expect(disk.unit == Units.gibibyte)

        // Mixing mass and weight stays impossible even through leading-dot lookup.
        #expect(Quantity(value: 1, unit: .mass.ounce).unit.dimension !=
                Quantity(value: 1, unit: .weight.ounce).unit.dimension)
    }

    @Test func testCurrencyCommonNameAliases() {
        // Unambiguous common names resolve, in all three access styles.
        #expect(Units.pounds == Units.gbp)
        #expect(Units.Currency.poundsSterling == Units.gbp)
        #expect(Units.Currency.sterling == Units.gbp)

        let salary = Quantity(value: 100, unit: .poundsSterling)
        #expect(salary.unit == Units.gbp)
        let barePounds = Quantity(value: 100, unit: .currency.pounds)
        #expect(barePounds.unit == Units.gbp)

        let yen = Quantity(value: 100, unit: .yen)
        #expect(yen.unit == Units.jpy)
        let rupee = Quantity(value: 100, unit: .rupee)
        #expect(rupee.unit == Units.inr)
        let lira = Quantity(value: 100, unit: .lira)
        #expect(lira.unit == Units.`try`)
        let franc = Quantity(value: 100, unit: .franc)
        #expect(franc.unit == Units.chf)
        #expect(Units.Currency.real == Units.brl)

        // Ambiguous common names are deliberately NOT provided thinly: the clear
        // code-based spellings are the explicit ones.
        #expect(Units.Currency.usd == Units.usd)
        #expect(Units.Currency.cad == Units.cad)
        let peso = Quantity(value: 100, unit: .currency.mxn)
        #expect(peso.unit == Units.mxn)
    }

    @Test func testWeightIsForce() {
        // Weight is a force: W = mg. One pound-mass weighs exactly one
        // pound-force at standard gravity.
        let pound = Quantity(value: 1, unit: Units.pound)
        let poundForce = pound.weight.converted(to: Units.poundForce)
        #expect(pound.unit.dimension == .mass)
        #expect(poundForce.unit.dimension == .force)
        #expect(abs(poundForce.value - 1.0) < 1e-12)

        // 150 lbm weigh 150 lbf; the mass reading can't be mixed with force.
        let person = Quantity(value: 150, unit: Units.pound)
        #expect(abs(person.weight.converted(to: Units.poundForce).value - 150) < 1e-9)

        // 10 kg weigh roughly 98.07 N under standard gravity.
        let sack = Quantity(value: 10, unit: Units.kilogram)
        #expect(abs(sack.weight.converted(to: Units.newton).value - 9.80665 * 10) < 1e-12)

        // weight(on:) accepts a custom gravity, in m/s² or as a quantity.
        let probe = Quantity(value: 100, unit: Units.kilogram)
        #expect(abs(probe.weight(on: 1.62).converted(to: Units.newton).value - 162) < 1e-12)
        #expect(abs(probe.weight(on: Quantity(value: 1, unit: Units.gravity)).converted(to: Units.newton).value - 980.665) < 1e-9)

        // weight(in:) returns the force in a requested force unit.
        let car = Quantity(value: 1, unit: Units.slug)
        #expect(abs(car.weight(in: Units.poundForce).value - 32.1740485564) < 1e-6)

        // Explicit pound-mass names a mass; its weight is lbf, never lb.
        let explicit = Quantity(value: 1, unit: Units.poundMass)
        #expect(explicit.unit.dimension == .mass)
        #expect(abs(explicit.weight(in: Units.poundForce).value - 1.0) < 1e-12)
    }

    @Test func testAvoirdupoisWeightCatalog() {
        // Every avoirdupois mass unit has a force (weight) reading in the
        // Weight namespace, derived from W = mg at standard gravity.
        #expect(Units.Weight.grain.dimension == .force)
        #expect(Units.Weight.stone.dimension == .force)
        #expect(Units.Weight.shortTon.dimension == .force)
        #expect(Units.Weight.longTon.dimension == .force)
        #expect(Units.Weight.hundredweight.dimension == .force)
        #expect(Units.Weight.longHundredweight.dimension == .force)

        #expect(Units.Weight.gram == Units.gramForce)
        #expect(Units.Weight.grain == Units.grainForce)
        #expect(Units.Weight.stone == Units.stoneForce)
        #expect(Units.Weight.shortTon == Units.shortTonForce)
        #expect(Units.Weight.longTon == Units.longTonForce)
        #expect(Units.Weight.hundredweight == Units.hundredweightForce)
        #expect(Units.Weight.longHundredweight == Units.longHundredweightForce)

        // Multiples of pound-force are exact.
        #expect(abs(Quantity(value: 1, unit: Units.gramForce).converted(to: Units.newton).value - 0.00980665) < 1e-15)
        #expect(abs(Quantity(value: 1, unit: Units.grainForce).converted(to: Units.poundForce).value - 1.0 / 7000.0) < 1e-15)
        #expect(abs(Quantity(value: 1, unit: Units.stoneForce).converted(to: Units.poundForce).value - 14.0) < 1e-12)
        #expect(abs(Quantity(value: 1, unit: Units.hundredweightForce).converted(to: Units.poundForce).value - 100.0) < 1e-12)
        #expect(abs(Quantity(value: 1, unit: Units.longHundredweightForce).converted(to: Units.poundForce).value - 112.0) < 1e-12)
        #expect(abs(Quantity(value: 1, unit: Units.shortTonForce).converted(to: Units.poundForce).value - 2000.0) < 1e-12)
        #expect(abs(Quantity(value: 1, unit: Units.longTonForce).converted(to: Units.poundForce).value - 2240.0) < 1e-12)

        // The short ton-force and the long-standing ton-force agree.
        #expect(Quantity(value: 1, unit: Units.shortTonForce).isEquivalent(to: Quantity(value: 1, unit: Units.tonForce), tolerance: 1e-15))
        #expect(Units.tonForce.symbol == "tnf")

        // The mass counterparts stay in Mass and convert as masses.
        #expect(Units.Mass.stone.dimension == .mass)
        #expect(abs(Quantity(value: 1, unit: Units.stone).converted(to: Units.pound).value - 14.0) < 1e-12)
        #expect(abs(Quantity(value: 1, unit: Units.longTon).converted(to: Units.shortTon).value - 1.12) < 1e-12)

        // One gram of mass weighs exactly one gram-force at standard gravity.
        let gram = Quantity(value: 1, unit: Units.gram)
        #expect(gram.unit.dimension == .mass)
        #expect(abs(gram.weight(in: Units.gramForce).value - 1.0) < 1e-12)
        // The gram-force symbol is "gf" and the mass gram is "g".
        #expect(Units.gramForce.symbol == "gf")
    }

    @Test func testExplicitMassAliases() {
        // poundMass/ounceMass are unmistakably mass units.
        #expect(Units.poundMass.symbol == "lbm")
        #expect(Units.poundMass.dimension == .mass)
        #expect(Units.ounceMass.symbol == "ozm")
        #expect(Units.ounceMass.dimension == .mass)
        #expect(Units.Mass.poundMass == Units.poundMass)
        #expect(Units.Mass.ounceMass == Units.ounceMass)

        // 16 ounces of mass are exactly one pound of mass.
        #expect(abs(Quantity(value: 16, unit: Units.ounceMass).converted(to: Units.poundMass).value - 1.0) < 1e-12)
        #expect(Quantity(value: 1, unit: Units.pound).isEquivalent(to: Quantity(value: 1, unit: Units.poundMass), tolerance: 1e-15))

        // Mass pickers surface the aliases; force pickers only see force units.
        #expect(Units.units(for: .mass).contains { $0.symbol == "lbm" })
        #expect(Units.units(for: .mass).contains { $0.symbol == "ozm" })
        #expect(!Units.units(for: .force).contains { $0.symbol == "lbm" })
        #expect(!Units.units(for: .force).contains { $0.symbol == "lb" })
        #expect(Units.units(for: .force).contains { $0.symbol == "stf" })
        #expect(Units.units(for: .force).contains { $0.symbol == "ltnf" })
        #expect(Units.units(for: .force).contains { $0.symbol == "cwtf" })
        #expect(Units.units(for: .force).contains { $0.symbol == "lcwtf" })
        #expect(Units.units(for: .force).contains { $0.symbol == "grf" })

        // Leading-dot lookup reaches the new units in both styles.
        let lifted = Quantity(value: 1, unit: .weight.stone)
        #expect(lifted.unit == Units.stoneForce)
        let bagged = Quantity(value: 1, unit: .mass.poundMass)
        #expect(bagged.unit == Units.poundMass)
        let barePoundMass = Quantity(value: 1, unit: .poundMass)
        #expect(barePoundMass.unit == Units.poundMass)
        let bareOunceMass = Quantity(value: 1, unit: .ounceMass)
        #expect(bareOunceMass.unit == Units.ounceMass)
    }

    @Test func testContextDependentDram() {
        // The same word means different physical things per dimension.
        let massDram = Quantity(value: 1, unit: Units.Mass.dram)
        #expect(massDram.unit.dimension == .mass)

        // Bare `.dram` keeps resolving to the mass unit.
        let bareDram = Quantity(value: 1, unit: .dram)
        #expect(bareDram.unit.dimension == .mass)

        // Weight-reading dram is dram-force: 256 to the pound-force.
        let weightDram = Quantity(value: 1, unit: .weight.dram)
        #expect(weightDram.unit.dimension == .force)
        let pounds = Quantity(value: 256, unit: .weight.dram)
        #expect(abs(pounds.converted(to: Units.poundForce).value - 1) < 1e-12)

        // Volume-reading dram is the fluid dram: 8 to the US fluid ounce.
        let volumeDram = Quantity(value: 1, unit: .volume.dram)
        #expect(volumeDram.unit.dimension == .volume)
        let fluidOunces = Quantity(value: 8, unit: .volume.fluidDram)
        #expect(fluidOunces.unit.dimension == .volume)
        #expect(abs(fluidOunces.converted(to: Units.usFluidOunce).value - 1) < 1e-12)

        // Pickers surface the context-dependent extras too.
        #expect(Units.units(for: .force).contains { ($0 as? NamedUnit<MathDimension.force>)?.symbol == "dramf" })
        #expect(Units.units(for: .volume).contains { ($0 as? NamedUnit<MathDimension.volume>)?.symbol == "fl_dr" })
    }

    @Test func testDecibels() throws {
        // Relative decibels are dimensionless power ratios (10·log10).
        #expect(abs(Quantity(value: 10, unit: Units.decibel).converted(to: Units.bel).value - 1) < 1e-9)
        #expect(abs(Quantity(value: 20, unit: Units.decibel).converted(to: Units.bel).value - 2) < 1e-9)
        #expect(Quantity(value: 0, unit: Units.decibel).converted(to: Units.bel).value == 0)
        #expect(abs(Quantity(value: 1, unit: Units.bel).converted(to: Units.decibel).value - 10) < 1e-9)
        #expect(abs(Quantity(value: 20, unit: .decibel).converted(to: Units.percent).value - 10000) < 1e-4)

        // 3 dB is (almost exactly) a doubling of power.
        let tripleOSS = Quantity(value: 3, unit: Units.decibel).converted(to: Units.percent)
        #expect(abs(tripleOSS.value - 199.52623) / 199.52623 < 1e-5)

        // Absolute power scales: dBm, dBW.
        #expect(Quantity(value: 0, unit: Units.decibelMilliwatt).converted(to: Units.watt).value == 0.001)
        #expect(abs(Quantity(value: 30, unit: Units.decibelMilliwatt).converted(to: Units.watt).value - 1) < 1e-12)
        #expect(abs(Quantity(value: 10, unit: Units.decibelMilliwatt).converted(to: Units.milliwatt).value - 10) < 1e-9)
        #expect(Quantity(value: 0, unit: Units.decibelWatt).converted(to: Units.watt).value == 1)
        #expect(abs(Quantity(value: 20, unit: Units.decibelWatt).converted(to: Units.watt).value - 100) < 1e-10)
        #expect(Units.dBm == Units.decibelMilliwatt)

        // Voltage scales use the field convention (20·log10).
        #expect(Quantity(value: 0, unit: Units.decibelVolt).converted(to: Units.volt).value == 1)
        #expect(abs(Quantity(value: 20, unit: Units.decibelVolt).converted(to: Units.volt).value - 10) < 1e-12)
        #expect(abs(Quantity(value: 120, unit: Units.decibelMicrovolt).converted(to: Units.volt).value - 1) < 1e-9)
        #expect(abs(Quantity(value: 60, unit: Units.decibelMicrovolt).converted(to: Units.millivolt).value - 1) < 1e-8)

        // Sound pressure level is referenced to 20 µPa.
        #expect(Quantity(value: 0, unit: Units.decibelSoundPressureLevel).converted(to: Units.pascal).value == 2e-5)
        let onePascalSPL = Quantity(value: 94, unit: Units.decibelSoundPressureLevel).converted(to: Units.pascal)
        #expect(abs(onePascalSPL.value - 1.00237) / 1.00237 < 1e-4)
        let backToSPL = Quantity(value: 1.00237, unit: Units.pascal).converted(to: Units.decibelSoundPressureLevel)
        #expect(abs(backToSPL.value - 94) < 1e-3)

        // Round trips and leading-dot lookup.
        let wattReading = Quantity(value: 0.5, unit: Units.watt)
        let asDbm = wattReading.converted(to: Units.decibelMilliwatt)
        let back = asDbm.converted(to: Units.watt)
        #expect(abs(asDbm.value - 26.9897) < 1e-3)
        #expect(abs(back.value - 0.5) < 1e-12)

        // Picker surfaces the decibel scales.
        #expect(Units.units(for: .dimensionless).contains { ($0 as? NamedUnit<MathDimension.dimensionless>)?.symbol == "dB" })
        #expect(Units.units(for: .power).contains { ($0 as? NamedUnit<MathDimension.power>)?.symbol == "dBm" })
        #expect(Units.units(for: .voltage).contains { ($0 as? NamedUnit<MathDimension.voltage>)?.symbol == "dBµV" })
        #expect(Units.units(for: .pressure).contains { ($0 as? NamedUnit<MathDimension.pressure>)?.symbol == "dBSPL" })

        // A dB unit round-trips through Codable.
        let encoded = try JSONEncoder().encode(Quantity(value: 30, unit: Units.decibelMilliwatt))
        let decoded = try JSONDecoder().decode(Quantity<NamedUnit<MathDimension.power>>.self, from: encoded)
        #expect(decoded.isEquivalent(to: Quantity(value: 30, unit: Units.decibelMilliwatt), tolerance: 1e-12))
    }
}

// MARK: - Compilation Test for PlaceService
#if canImport(CoreLocation)
import CoreLocation

struct Place {}

protocol PlaceService {
    func fetchNearbyPlaces<U: MathUnit>(
        coordinate: CLLocationCoordinate2D,
        radius: Math.Quantity<U>,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) where U.Dimension == MathDimension.length
}
#endif

