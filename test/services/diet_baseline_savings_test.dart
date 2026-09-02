import 'package:clima_shield/services/diet_baseline_savings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DietBaselineSavings', () {
    test('calculates household annual food servings', () {
      final servings = DietBaselineSavings.annualHouseholdServings(
        totalMealsEatenPerWeek: 21,
        householdSize: 3,
      );

      expect(servings, 3276);
    });

    test('calculates an annual diet baseline per serving', () {
      final baseline = DietBaselineSavings.baselineCo2eKgPerServing(
        annualDietCo2eKg: 3276,
        totalMealsEatenPerWeek: 21,
        householdSize: 3,
      );

      expect(baseline, 1);
    });

    test('credits fewer logged servings than the household size', () {
      final savings = DietBaselineSavings.estimatedCo2eSavingsKg(
        baselineCo2eKgPerServing: 5,
        recipeCo2eKgPerServing: 2,
        servingsLogged: 2,
        householdSize: 3,
      );

      expect(savings, 6);
    });

    test('caps creditable servings at household size', () {
      final savings = DietBaselineSavings.estimatedCo2eSavingsKg(
        baselineCo2eKgPerServing: 5,
        recipeCo2eKgPerServing: 2,
        servingsLogged: 4,
        householdSize: 3,
      );

      expect(savings, 9);
    });

    test('does not report savings for a higher-emission recipe', () {
      final savings = DietBaselineSavings.estimatedCo2eSavingsKg(
        baselineCo2eKgPerServing: 2,
        recipeCo2eKgPerServing: 5,
        servingsLogged: 3,
        householdSize: 3,
      );

      expect(savings, 0);
    });
  });
}