import 'package:clima_shield/models/recipe_model.dart';
import 'package:clima_shield/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'changing servings to make scales ingredients and caps servings eaten',
    (tester) async {
      final recipe = Recipe(
        id: 'test-recipe',
        title: 'Scaled Soup',
        description: 'A test recipe for serving controls.',
        imageUrl: '',
        servings: 4,
        ingredientDetails: const [
          RecipeIngredient(name: 'vegetable broth', amount: 2, unit: 'cups'),
        ],
        climateImpact: const RecipeClimateImpact(
          estimatedReductionKgPerServing: 0.4,
          comparisonBaseline: 'Beef soup',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(home: RecipeDetailScreen(recipe: recipe)),
      );

      expect(find.text('Servings to make'), findsOneWidget);
      expect(find.text('Servings eaten'), findsOneWidget);

      await tester.tap(find.byTooltip('Increase servings to make'));
      await tester.pump();

      await tester.scrollUntilVisible(
        find.textContaining('vegetable broth'),
        250,
      );

      final ingredientText = tester.widget<Text>(
        find.textContaining('vegetable broth'),
      );

      expect(ingredientText.data, '• 2½ cup vegetable broth');

      await tester.scrollUntilVisible(
        find.byTooltip('Increase servings eaten'),
        250,
      );

      for (var index = 0; index < 4; index++) {
        await tester.tap(find.byTooltip('Increase servings eaten'));
        await tester.pump();
      }

      expect(find.text('5'), findsNWidgets(2));

      final increaseEatenButton = find
          .ancestor(
            of: find.byTooltip('Increase servings eaten'),
            matching: find.byType(IconButton),
          )
          .first;

      final iconButton = tester.widget<IconButton>(increaseEatenButton);

      expect(iconButton.onPressed, isNull);
    },
  );
}
