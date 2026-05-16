import '../models/footprint.dart';

/// Coarse emission factors. Sources: EPA / IPCC public references. These are
/// rule-of-thumb numbers good enough for behavior change, not formal reporting.
class CarbonFactors {
  static const double kgCO2ePerGallonGasoline = 8.89;
  static const double kgCO2ePerKwhUsAvg = 0.39;
  static const double kgCO2ePerThermNaturalGas = 5.31;
  static const double kgCO2eShortHaulFlight = 250;
  static const double kgCO2eLongHaulFlight = 1100;
  static const Map<String, double> dietAnnualKg = {
    'meat_heavy': 3300,
    'average': 2500,
    'low_meat': 1700,
    'vegetarian': 1200,
    'vegan': 900,
  };
  // Rough $ -> kg CO2e for general consumer goods.
  static const double kgCO2ePerUsdGoods = 0.4;
}

CarbonFootprint computeFootprint(CarbonCalculatorInputs i) {
  final weeklyGallons = i.carMpg <= 0 ? 0 : i.carMilesPerWeek / i.carMpg;
  final carKg = weeklyGallons * 52 * CarbonFactors.kgCO2ePerGallonGasoline;
  final flightKg = i.flightsShortHaulPerYear * CarbonFactors.kgCO2eShortHaulFlight +
      i.flightsLongHaulPerYear * CarbonFactors.kgCO2eLongHaulFlight;
  final transportKg = carKg + flightKg;

  final household = i.householdSize <= 0 ? 1 : i.householdSize;
  final electricKg = i.electricityKwhPerMonth *
      12 *
      CarbonFactors.kgCO2ePerKwhUsAvg /
      household;
  final gasKg = i.naturalGasThermsPerMonth *
      12 *
      CarbonFactors.kgCO2ePerThermNaturalGas /
      household;
  final homeEnergyKg = electricKg + gasKg;

  final dietKg = CarbonFactors.dietAnnualKg[i.dietType] ?? 2500;

  final goodsKg = i.monthlyShoppingUsd * 12 * CarbonFactors.kgCO2ePerUsdGoods;

  return CarbonFootprint(
    transportKg: transportKg,
    homeEnergyKg: homeEnergyKg,
    dietKg: dietKg,
    goodsKg: goodsKg,
    updatedAt: DateTime.now(),
  );
}
