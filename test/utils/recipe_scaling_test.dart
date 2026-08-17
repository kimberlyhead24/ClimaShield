import 'package:clima_shield/models/recipe_model.dart';
import 'package:clima_shield/utils/recipe_scaling.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecipeScaling', () {
    test('calculates the correct scale factor', () {
      expect(
        RecipeScaling.scaleFactor(originalServings: 4, targetServings: 2),
        0.5,
      );
      expect(
        RecipeScaling.scaleFactor(originalServings: 4, targetServings: 6),
        1.5,
      );
      expect(
        RecipeScaling.scaleFactor(originalServings: 4, targetServings: 4),
        1.0,
      );
    });

    test('uses a safe original serving fallback when zero is supplied', () {
      expect(
        RecipeScaling.scaleFactor(originalServings: 0, targetServings: 3),
        3.0,
      );
    });

    test('uses at least one target serving', () {
      expect(
        RecipeScaling.scaleFactor(originalServings: 4, targetServings: 0),
        0.25,
      );
    });

    test('scales measurable ingredient quantities', () {
      const ingredient = RecipeIngredient(
        name: 'rolled oats',
        amount: 0.5,
        unit: 'cup',
      );

      final scaled = RecipeScaling.scaleIngredient(
        ingredient,
        originalServings: 2,
        targetServings: 4,
      );

      expect(scaled.amount, 1.0);
      expect(scaled.unit, 'cup');
      expect(scaled.name, 'rolled oats');
    });

    test('does not invent a quantity for unmeasured ingredients', () {
      const ingredient = RecipeIngredient(name: 'salt', unit: 'to taste');

      final scaled = RecipeScaling.scaleIngredient(
        ingredient,
        originalServings: 2,
        targetServings: 4,
      );

      expect(scaled.amount, isNull);
      expect(scaled.unit, 'to taste');
    });

    test('formats common fractions naturally', () {
      expect(RecipeQuantityFormatter.formatNumber(0.25), '¼');
      expect(RecipeQuantityFormatter.formatNumber(0.5), '½');
      expect(RecipeQuantityFormatter.formatNumber(0.75), '¾');
      expect(RecipeQuantityFormatter.formatNumber(1.5), '1½');
      expect(RecipeQuantityFormatter.formatNumber(2.0), '2');
    });

    test('converts teaspoons to tablespoons when exactly possible', () {
      final formatted = RecipeQuantityFormatter.format(
        const RecipeIngredient(name: 'vanilla extract', amount: 3, unit: 'tsp'),
      );

      expect(formatted, '1 tbsp vanilla extract');
    });

    test('converts tablespoons to cups when exactly possible', () {
      final formatted = RecipeQuantityFormatter.format(
        const RecipeIngredient(name: 'olive oil', amount: 4, unit: 'tbsp'),
      );

      expect(formatted, '¼ cup olive oil');
    });

    test('converts eight tablespoons to one-half cup', () {
      final formatted = RecipeQuantityFormatter.format(
        const RecipeIngredient(name: 'milk', amount: 8, unit: 'tbsp'),
      );

      expect(formatted, '½ cup milk');
    });

    test(
      'keeps quantities in the original unit when no clean conversion exists',
      () {
        final formatted = RecipeQuantityFormatter.format(
          const RecipeIngredient(name: 'cumin', amount: 1.5, unit: 'tsp'),
        );

        expect(formatted, '1½ tsp cumin');
      },
    );

    test('preserves preparation details', () {
      final formatted = RecipeQuantityFormatter.format(
        const RecipeIngredient(
          name: 'onion',
          amount: 0.5,
          unit: 'whole',
          preparation: 'diced',
        ),
      );

      expect(formatted, '½ whole onion (diced)');
    });

    test('formats unmeasured ingredients without a leading null quantity', () {
      final formatted = RecipeQuantityFormatter.format(
        const RecipeIngredient(name: 'salt and pepper', unit: 'to taste'),
      );

      expect(formatted, 'salt and pepper (to taste)');
    });

    test(
      'rounds unusual decimal quantities instead of showing long floats',
      () {
        expect(RecipeQuantityFormatter.formatNumber(0.3333333), '⅓');
        expect(RecipeQuantityFormatter.formatNumber(1.6666667), '1⅔');
      },
    );

    test('scales a four-serving recipe down to three servings', () {
      const ingredient = RecipeIngredient(
        name: 'vegetable broth',
        amount: 2,
        unit: 'cups',
      );

      final scaled = RecipeScaling.scaleIngredient(
        ingredient,
        originalServings: 4,
        targetServings: 3,
      );

      expect(scaled.amount, 1.5);
      expect(RecipeQuantityFormatter.format(scaled), '1½ cup vegetable broth');
    });

    test(
      'rounds an awkward display amount to the nearest culinary fraction',
      () {
        expect(RecipeQuantityFormatter.formatNumber(1.34), '1⅓');

        expect(RecipeQuantityFormatter.formatNumber(1.26), '1¼');
      },
    );
  });
}
