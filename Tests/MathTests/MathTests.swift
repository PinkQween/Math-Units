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
        #expect(boilingKelvin.value == 373.15)
        
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
        let usdUnit = NamedUnit<Math.Dimension.unknown>(symbol: "$", dimension: usdDimension, converter: LinearConverter(coefficient: 1.0))
        
        let eurUnit = NamedUnit<Math.Dimension.unknown>(symbol: "€", dimension: usdDimension, converter: LinearConverter(coefficient: 1.09))
        
        // Currency conversion
        let tenEur = Quantity(value: 10.0, unit: eurUnit)
        let inUsd = tenEur.converted(to: usdUnit)
        #expect(abs(inUsd.value - 10.9) < 1e-9)
        
        // User dimension
        let userDimension = PhysicalDimension(exponents: ["user": 1])
        let userUnit = NamedUnit<Math.Dimension.unknown>(symbol: "user", dimension: userDimension, converter: LinearConverter(coefficient: 1.0))
        
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
        #expect(abs(bodyTempC.value - 37.0) < 1e-6)
    }
    
    @Test func testFahrenheitToKelvinToBtu() {
        // 1. Convert Fahrenheit to Kelvin
        let tempF = Quantity(value: 77.0, unit: Units.fahrenheit) // Room temperature ~ 77°F
        let tempK = tempF.converted(to: Units.kelvin)
        #expect(abs(tempK.value - 298.15) < 1e-9)
        
        // 2. Relate temperature to thermal energy using Boltzmann's constant:
        // k_B = 1.380649e-23 J/K
        let k_B = Quantity(value: 1.380649e-23, unit: Units.joule / Units.kelvin)
        
        // E = k_B * T
        let thermalEnergyJ = k_B * tempK
        #expect(abs(thermalEnergyJ.value - (1.380649e-23 * 298.15)) < 1e-35)
        #expect(thermalEnergyJ.unit.dimension == .energy)
        
        // 3. Convert thermal energy in Joules to BTU (1 BTU ≈ 1055.05585262 Joules)
        let thermalEnergyBtu = thermalEnergyJ.converted(to: Units.britishThermalUnit)
        let expectedBtu = (1.380649e-23 * 298.15) / 1055.05585262
        #expect(abs(thermalEnergyBtu.value - expectedBtu) < 1e-35)
        
        // 4. Direct 1-line conversion from temperature to energy (Fahrenheit to BTU)
        let directBtu = tempF.converted(to: Units.britishThermalUnit)
        #expect(abs(directBtu.value - expectedBtu) < 1e-35)
        
        // 5. Direct 1-line conversion back from energy to temperature (BTU to Fahrenheit)
        let tempBackF = directBtu.converted(to: Units.fahrenheit)
        #expect(abs(tempBackF.value - 77.0) < 1e-9)
        
        // 6. Test thermalEnergy property (returns J)
        let propJ = tempF.thermalEnergy
        #expect(propJ.unit.symbol == "J")
        #expect(abs(propJ.value - (1.380649e-23 * 298.15)) < 1e-35)
        
        // 7. Test 1-line conversion from thermal energy to other energy using thermalEnergy(in:)
        let propBtu = tempF.thermalEnergy(in: Units.britishThermalUnit)
        #expect(propBtu.unit.symbol == "BTU")
        #expect(abs(propBtu.value - expectedBtu) < 1e-35)
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
        #expect(inSec.value == 1.0)
        
        // Test physics jiffy to seconds
        let physJiffy = Quantity(value: 1e11, unit: Units.physicsJiffy)
        let physInSec = physJiffy.converted(to: Units.second)
        #expect(abs(physInSec.value - 3.33564095198) < 1e-9)
        
        // Test Micromort to percent
        let risk = Quantity(value: 10000.0, unit: Units.micromort) // 10,000 micromorts = 10,000 / 1e6 = 0.01 probability
        let inPercent = risk.converted(to: Units.percent) // 1% = 0.01 probability
        #expect(abs(inPercent.value - 1.0) < 1e-9)
    }
}

// MARK: - Compilation Test for PlaceService
#if canImport(CoreLocation)
import CoreLocation

struct Place {}

protocol PlaceService {
    func fetchNearbyPlaces<U: Math.Unit>(
        coordinate: CLLocationCoordinate2D,
        radius: Math.Quantity<U>,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) where U.Dimension == Math.Dimension.length
}
#endif

