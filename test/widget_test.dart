import 'package:clima_shield/data/carbon_math.dart';
import 'package:clima_shield/data/sample_data.dart';
import 'package:clima_shield/models/footprint.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('carbon math', () {
    test('zero inputs produce only the diet baseline', () {
      const inputs = CarbonCalculatorInputs();
      final fp = computeFootprint(inputs);
      expect(fp.transportKg, 0);
      expect(fp.homeEnergyKg, 0);
      expect(fp.goodsKg, 0);
      expect(fp.dietKg, CarbonFactors.dietAnnualKg['average']);
    });

    test('vegan diet beats meat-heavy diet', () {
      const vegan = CarbonCalculatorInputs(dietType: 'vegan');
      const meaty = CarbonCalculatorInputs(dietType: 'meat_heavy');
      expect(
        computeFootprint(vegan).dietKg,
        lessThan(computeFootprint(meaty).dietKg),
      );
    });

    test('car miles increase transport footprint', () {
      const a = CarbonCalculatorInputs(carMilesPerWeek: 0);
      const b = CarbonCalculatorInputs(carMilesPerWeek: 200, carMpg: 25);
      expect(
        computeFootprint(b).transportKg,
        greaterThan(computeFootprint(a).transportKg),
      );
    });

    test('household size divides home energy', () {
      const solo = CarbonCalculatorInputs(
        electricityKwhPerMonth: 800,
        householdSize: 1,
      );
      const family = CarbonCalculatorInputs(
        electricityKwhPerMonth: 800,
        householdSize: 4,
      );
      expect(
        computeFootprint(family).homeEnergyKg,
        closeTo(computeFootprint(solo).homeEnergyKg / 4, 0.1),
      );
    });
  });

  group('sample data', () {
    test('every action has a non-empty id and title', () {
      for (final a in SampleData.actions) {
        expect(a.id.isNotEmpty, isTrue);
        expect(a.title.isNotEmpty, isTrue);
      }
    });

    test('meals are tier-tagged with known tiers', () {
      const tiers = {'best', 'good', 'fair', 'high'};
      for (final m in SampleData.meals) {
        expect(
          tiers.contains(m.tier),
          isTrue,
          reason: '${m.name} has tier ${m.tier}',
        );
      }
    });
  });
}
