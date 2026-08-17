import 'package:clima_shield/models/recipe_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Recipe.fromMap', () {
    test('parses numeric cost and total-time fields', () {
      final recipe = Recipe.fromMap({
        'name': 'Test Recipe',
        'description': 'A test recipe.',
        'image_url': '',
        'servings': 4,
        'prep_time_minutes': 10,
        'total_time_minutes': 35,
        'estimatedCostUsdTotal': 12.40,
        'estimatedCostUsdPerServing': 3.10,
      }, id: 'recipe-1');

      expect(recipe.id, 'recipe-1');
      expect(recipe.totalTimeMinutes, 35);
      expect(recipe.estimatedCostUsdTotal, 12.40);
      expect(recipe.estimatedCostUsdPerServing, 3.10);
      expect(recipe.hasCostEstimate, isTrue);
      expect(recipe.effectiveCostPerServing, 3.10);
      expect(recipe.effectiveTotalTimeMinutes, 35);
    });

    test('keeps missing cost estimates nullable', () {
      final recipe = Recipe.fromMap({
        'name': 'No Cost Recipe',
        'description': '',
        'image_url': '',
        'servings': 4,
      });

      expect(recipe.estimatedCostUsdTotal, isNull);
      expect(recipe.estimatedCostUsdPerServing, isNull);
      expect(recipe.hasCostEstimate, isFalse);
      expect(recipe.effectiveCostPerServing, isNull);
    });

    test('calcualtes per-serving cost from the total when needed', () {
      final recipe = Recipe.fromMap({
        'name': 'Total Cost Only Recipe',
        'description': '',
        'image_url': '',
        'servings': 4,
        'estimatedCostUsdTotal': 10.00,
      });

      expect(recipe.hasCostEstimate, isTrue);
      expect(recipe.estimatedCostUsdPerServing, isNull);
      expect(recipe.effectiveCostPerServing, 2.50);
    });

    test('uses prep time when total time is missing', () {
      final recipe = Recipe.fromMap({
        'name': 'Prep Time Only Recipe',
        'description': '',
        'image_url': '',
        'prep_time_minutes': 18,
      });

      expect(recipe.totalTimeMinutes, 0);
      expect(recipe.effectiveTotalTimeMinutes, 18);
    });

    test('parses allergens, categories, nutrition, and climate impact', () {
      final recipe = Recipe.fromMap({
        'name': 'Full Metadata Recipe',
        'description': '',
        'image_url': '',
        'allergens': ['gluten', 'dairy'],
        'category': ['italian', 'pasta'],
        'nutritional_info': {
          'calories': 425,
          'protein_grams': 21,
          'carbs_grams': 54,
          'fat_grams': 15,
        },
        'impact_score': {
          'co2e_reduction_per_serving_kg': 1.4,
          'water_saved_per_serving_gallons': 120,
          'waste_diverted_per_serving_kg': 0.2,
          'comparison_baseline': 'Beef pasta',
        },
      });

      expect(recipe.allergens, ['gluten', 'dairy']);
      expect(recipe.categories, ['italian', 'pasta']);

      expect(recipe.nutrition.calories, 425);
      expect(recipe.nutrition.proteinGrams, 21);
      expect(recipe.nutrition.carbsGrams, 54);
      expect(recipe.nutrition.fatGrams, 15);

      expect(recipe.climateImpact.estimatedReductionKgPerServing, 1.4);
      expect(recipe.climateImpact.waterSavedGallonsPerServing, 120);
      expect(recipe.climateImpact.wasteDivertedKgPerServing, 0.2);
      expect(recipe.climateImpact.comparisonBaseline, 'Beef pasta');
    });

    test('uses safe defaults for missing optional fields', () {
      final recipe = Recipe.fromMap({
        'name': 'Minimal Recipe',
        'description': '',
        'image_url': '',
      });

      expect(recipe.servings, 1);
      expect(recipe.prepTimeMinutes, 0);
      expect(recipe.totalTimeMinutes, 0);
      expect(recipe.allergens, isEmpty);
      expect(recipe.categories, isEmpty);
      expect(recipe.climateImpact.estimatedReductionKgPerServing, isNull);
    });
  });
}
