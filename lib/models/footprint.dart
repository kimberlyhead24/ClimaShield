/// Annualized carbon footprint estimate. Values stored in kg CO2e/year.
class CarbonFootprint {
  final double transportKg;
  final double homeEnergyKg;
  final double dietKg;
  final double goodsKg;
  final DateTime updatedAt;

  const CarbonFootprint({
    required this.transportKg,
    required this.homeEnergyKg,
    required this.dietKg,
    required this.goodsKg,
    required this.updatedAt,
  });

  factory CarbonFootprint.empty() => CarbonFootprint(
        transportKg: 0,
        homeEnergyKg: 0,
        dietKg: 0,
        goodsKg: 0,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  double get totalKg => transportKg + homeEnergyKg + dietKg + goodsKg;
  double get totalTonnes => totalKg / 1000.0;

  Map<String, dynamic> toMap() => {
        'transportKg': transportKg,
        'homeEnergyKg': homeEnergyKg,
        'dietKg': dietKg,
        'goodsKg': goodsKg,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CarbonFootprint.fromMap(Map<String, dynamic> m) => CarbonFootprint(
        transportKg: (m['transportKg'] as num?)?.toDouble() ?? 0,
        homeEnergyKg: (m['homeEnergyKg'] as num?)?.toDouble() ?? 0,
        dietKg: (m['dietKg'] as num?)?.toDouble() ?? 0,
        goodsKg: (m['goodsKg'] as num?)?.toDouble() ?? 0,
        updatedAt:
            DateTime.tryParse(m['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );
}

/// Raw inputs used by the carbon calculator. Stored so users can revisit and
/// tweak previously entered numbers.
class CarbonCalculatorInputs {
  final double carMilesPerWeek;
  final double carMpg;
  final double flightsShortHaulPerYear;
  final double flightsLongHaulPerYear;
  final double electricityKwhPerMonth;
  final double naturalGasThermsPerMonth;
  final String dietType; // 'meat_heavy', 'average', 'low_meat', 'vegetarian', 'vegan'
  final int householdSize;
  final double monthlyShoppingUsd;

  const CarbonCalculatorInputs({
    this.carMilesPerWeek = 0,
    this.carMpg = 28,
    this.flightsShortHaulPerYear = 0,
    this.flightsLongHaulPerYear = 0,
    this.electricityKwhPerMonth = 0,
    this.naturalGasThermsPerMonth = 0,
    this.dietType = 'average',
    this.householdSize = 1,
    this.monthlyShoppingUsd = 0,
  });

  Map<String, dynamic> toMap() => {
        'carMilesPerWeek': carMilesPerWeek,
        'carMpg': carMpg,
        'flightsShortHaulPerYear': flightsShortHaulPerYear,
        'flightsLongHaulPerYear': flightsLongHaulPerYear,
        'electricityKwhPerMonth': electricityKwhPerMonth,
        'naturalGasThermsPerMonth': naturalGasThermsPerMonth,
        'dietType': dietType,
        'householdSize': householdSize,
        'monthlyShoppingUsd': monthlyShoppingUsd,
      };

  factory CarbonCalculatorInputs.fromMap(Map<String, dynamic> m) =>
      CarbonCalculatorInputs(
        carMilesPerWeek: (m['carMilesPerWeek'] as num?)?.toDouble() ?? 0,
        carMpg: (m['carMpg'] as num?)?.toDouble() ?? 28,
        flightsShortHaulPerYear:
            (m['flightsShortHaulPerYear'] as num?)?.toDouble() ?? 0,
        flightsLongHaulPerYear:
            (m['flightsLongHaulPerYear'] as num?)?.toDouble() ?? 0,
        electricityKwhPerMonth:
            (m['electricityKwhPerMonth'] as num?)?.toDouble() ?? 0,
        naturalGasThermsPerMonth:
            (m['naturalGasThermsPerMonth'] as num?)?.toDouble() ?? 0,
        dietType: m['dietType'] as String? ?? 'average',
        householdSize: (m['householdSize'] as num?)?.toInt() ?? 1,
        monthlyShoppingUsd:
            (m['monthlyShoppingUsd'] as num?)?.toDouble() ?? 0,
      );
}
