import 'package:clima_shield/models/diet_profile.dart';
import 'package:clima_shield/models/recipe_model.dart';
import 'package:clima_shield/models/weekly_meal_plan.dart';
import 'package:clima_shield/services/meal_plan_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final weekStart = DateTime(2026, 8, 17);

  Recipe recipe({
    required String id,
    required String title,
    required List<String> mealTypes,
    List<String> dietTypes = const [],
    List<String> allergens = const [],
    List<String> categories = const [],
    int servings = 2,
    int totalTimeMinutes = 20,
    double costPerServing = 2,
    double co2eReductionPerServing = 1,
    double waterSavedPerServing = 100,
    double proteinGrams = 10,
  }) {
    return Recipe(
      id: id,
      title: title,
      description: '',
      imageUrl: '',
      mealTypes: mealTypes,
      dietTypes: dietTypes,
      allergens: allergens,
      categories: categories,
      servings: servings,
      totalTimeMinutes: totalTimeMinutes,
      estimatedCostUsdTotal: costPerServing * servings,
      estimatedCostUsdPerServing: costPerServing,
      nutrition: RecipeNutrition(proteinGrams: proteinGrams),
      climateImpact: RecipeClimateImpact(
        estimatedReductionKgPerServing: co2eReductionPerServing,
        waterSavedGallonsPerServing: waterSavedPerServing,
      ),
    );
  }

  DietProfile profile({
    int householdSize = 2,
    int maxCookingTimeMinutes = 30,
    double? weeklyBudgetUsd,
    List<String> dietaryRestrictions = const [],
    List<String> allergens = const [],
    List<String> preferredCuisines = const [],
    List<String> avoidedCuisines = const [],
    List<String> dislikedIngredients = const [],
  }) {
    return DietProfile(
      profileVersion: 1,
      householdSize: householdSize,
      mealsPreparedAtHomePerWeek: 21,
      primaryGoal: 'footprint',
      currentDietPattern: 'omnivore',
      totalMealsEatenPerWeek: 21,
      beefOrLambServingsPerWeek: 0,
      porkServingsPerWeek: 0,
      poultryServingsPerWeek: 0,
      fishOrSeafoodServingsPerWeek: 0,
      eggServingsPerWeek: 0,
      dairyServingsPerWeek: 0,
      plantProteinServingsPerWeek: 0,
      preferredCuisines: preferredCuisines,
      avoidedCuisines: avoidedCuisines,
      dislikedIngredients: dislikedIngredients,
      dietaryRestrictions: dietaryRestrictions,
      allergens: allergens,
      maxCookingTimeMinutes: maxCookingTimeMinutes,
      weeklyFoodBudgetUsd: weeklyBudgetUsd,
      transitionPace: 'steady',
      updatedAt: weekStart,
    );
  }

  group('MealPlanGenerator', () {
    test('filters recipes that violate hard user constraints', () {
      final recipes = [
        recipe(
          id: 'safe',
          title: 'Safe Veggie Bowl',
          mealTypes: const ['dinner'],
          dietTypes: const ['vegetarian'],
          categories: const ['mediterranean'],
        ),
        recipe(
          id: 'allergen',
          title: 'Peanut Noodles',
          mealTypes: const ['dinner'],
          dietTypes: const ['vegetarian'],
          allergens: const ['nuts'],
        ),
        recipe(
          id: 'wrong-diet',
          title: 'Chicken Bowl',
          mealTypes: const ['dinner'],
          dietTypes: const ['high-protein'],
        ),
        recipe(
          id: 'slow',
          title: 'Slow Stew',
          mealTypes: const ['dinner'],
          dietTypes: const ['vegetarian'],
          totalTimeMinutes: 90,
        ),
      ];

      final eligible = MealPlanGenerator.filterEligibleRecipes(
        recipes: recipes,
        profile: profile(
          dietaryRestrictions: const ['vegetarian'],
          allergens: const ['nuts'],
          maxCookingTimeMinutes: 30,
        ),
      );

      expect(eligible.map((item) => item.id), ['safe']);
    });

    test('excludes avoided cuisines and disliked ingredients', () {
      final recipes = [
        recipe(
          id: 'keep',
          title: 'Lentil Bowl',
          mealTypes: const ['lunch'],
          categories: const ['mediterranean'],
        ),
        recipe(
          id: 'avoid-cuisine',
          title: 'Spicy Curry',
          mealTypes: const ['lunch'],
          categories: const ['indian'],
        ),
        Recipe(
          id: 'disliked-ingredient',
          title: 'Mushroom Toast',
          description: '',
          imageUrl: '',
          mealTypes: const ['lunch'],
          ingredientDetails: const [
            RecipeIngredient(name: 'mushrooms', amount: 2, unit: 'cups'),
          ],
          servings: 2,
          totalTimeMinutes: 10,
          estimatedCostUsdTotal: 4,
          estimatedCostUsdPerServing: 2,
        ),
      ];

      final eligible = MealPlanGenerator.filterEligibleRecipes(
        recipes: recipes,
        profile: profile(
          avoidedCuisines: const ['indian'],
          dislikedIngredients: const ['mushrooms'],
        ),
      );

      expect(eligible.map((item) => item.id), ['keep']);
    });

    test('ranks a preferred cuisine above an otherwise equal recipe', () {
      final recipes = [
        recipe(
          id: 'preferred',
          title: 'Mediterranean Bowl',
          mealTypes: const ['lunch'],
          categories: const ['mediterranean'],
        ),
        recipe(
          id: 'other',
          title: 'Plain Bowl',
          mealTypes: const ['lunch'],
          categories: const ['american'],
        ),
      ];

      final ranked = MealPlanGenerator.rankRecipes(
        recipes: recipes,
        profile: profile(preferredCuisines: const ['mediterranean']),
      );

      expect(ranked.first.recipe.id, 'preferred');
      expect(
        ranked.first.reasons,
        contains('Matches your preferred mediterranean cuisine'),
      );
    });

    test('keeps a generated plan within a weekly budget', () {
      final recipes = List.generate(
        21,
        (index) => recipe(
          id: 'budgetRecipe$index',
          title: 'Budget Recipe $index',
          mealTypes: switch (index % 3) {
            0 => const ['breakfast'],
            1 => const ['lunch'],
            _ => const ['dinner'],
          },
          dietTypes: const ['vegetarian'],
          costPerServing: 1,
        ),
      );

      final plan = MealPlanGenerator.generate(
        recipes: recipes,
        profile: profile(
          householdSize: 2,
          weeklyBudgetUsd: 42,
          dietaryRestrictions: const ['vegetarian'],
        ),
        weekStart: weekStart,
      );

      expect(plan.estimatedWeeklyCostUsd, lessThanOrEqualTo(42));
      expect(plan.meals, hasLength(21));
    });
    });

    test('keeps the higher-ranked eligible recipe and reports an over-budget plan',
    () {
      final recipes = [
        recipe(
          id: 'expensiveBreakfast',
          title: 'Expensive Breakfast',
          mealTypes: const ['breakfast'],
          dietTypes: const ['vegetarian'],
          costPerServing: 20,
          co2eReductionPerServing: 10,
        ),
        recipe(
          id: 'affordableBreakfast',
          title: 'Affordable Breakfast',
          mealTypes: const ['breakfast'],
          dietTypes: const ['vegetarian'],
          costPerServing: 1,
          co2eReductionPerServing: 1,
        ),
      ];

      final plan = MealPlanGenerator.generate(
        recipes: recipes,
        profile: profile(
          householdSize: 2,
          weeklyBudgetUsd: 2,
          dietaryRestrictions: const ['vegetarian'],
        ),
        weekStart: weekStart,
      );

      final breakfastIds = plan.meals
          .where((meal) => meal.mealSlot == MealSlot.breakfast)
          .map((meal) => meal.recipeId)
          .toList();

      expect(breakfastIds, contains('expensiveBreakfast'));
      expect(plan.estimatedWeeklyCostUsd, greaterThan(plan.weeklyBudgetUsd!));
    },
  );
    test('scales planned cost and climate totals for household size', () {
      final selected = recipe(
        id: 'dinner',
        title: 'Budget Dinner',
        mealTypes: const ['dinner'],
        servings: 2,
        costPerServing: 3,
        co2eReductionPerServing: 1.5,
        waterSavedPerServing: 200,
      );

      final plannedMeal = MealPlanGenerator.toPlannedMeal(
        recipe: selected,
        slot: MealSlot.dinner,
        date: weekStart,
        householdSize: 4,
        rankingScore: 50,
        rankingReasons: const ['Fits your weekly budget'],
      );

      expect(plannedMeal.servings, 4);
      expect(plannedMeal.estimatedCostUsd, 12);
      expect(plannedMeal.estimatedCo2eReductionKg, 6);
      expect(plannedMeal.estimatedWaterSavedGallons, 800);
    });

    test('creates a weekly plan without repeated recipes when enough exist', () {
      final recipes = List.generate(
        21,
        (index) => recipe(
          id: 'recipe-$index',
          title: 'Recipe $index',
          mealTypes: switch (index % 3) {
            0 => const ['breakfast'],
            1 => const ['lunch'],
            _ => const ['dinner'],
          },
          dietTypes: const ['vegetarian'],
          categories: const ['american'],
        ),
      );

      final plan = MealPlanGenerator.generate(
        recipes: recipes,
        profile: profile(dietaryRestrictions: const ['vegetarian']),
        weekStart: weekStart,
      );

      expect(plan.meals, hasLength(21));
      expect(plan.meals.map((meal) => meal.recipeId).toSet(), hasLength(21));
      expect(plan.householdSize, 2);
    }); 
    test(
      'reuses an eligible recipe when unique options for a slot are exhausted',
    () {
      final recipes = [
        recipe(
          id: 'onlyBreakfast',
          title: 'Only Breakfast',
          mealTypes: const ['breakfast'],
          dietTypes: const ['vegetarian'],
          costPerServing: 1,
        ),
      ];

      final plan = MealPlanGenerator.generate(
        recipes: recipes,
        profile: profile(
          householdSize: 1,
          dietaryRestrictions: const ['vegetarian'],
        ),
        weekStart: weekStart,
      );

      final breakfasts = plan.meals.where(
       (meal) => meal.mealSlot == MealSlot.breakfast,
      );

      expect(breakfasts, hasLength(7));
      expect(
        breakfasts.every(
          (meal) => meal.recipeId == 'onlyBreakfast',
        ),
        isTrue,
      );
    },
  );
  test(
  'reuses eligible recipes and flags when a full plan exceeds budget',
  () {
    final recipes = [
      recipe(
        id: 'costlyBreakfast',
        title: 'Costly Breakfast',
        mealTypes: const ['breakfast'],
        dietTypes: const ['vegetarian'],
        costPerServing: 5,
      ),
    ];

    final plan = MealPlanGenerator.generate(
      recipes: recipes,
      profile: profile(
        householdSize: 1,
        weeklyBudgetUsd: 10,
        dietaryRestrictions: const ['vegetarian'],
      ),
      weekStart: weekStart,
    );

    final breakfasts = plan.meals.where(
      (meal) => meal.mealSlot == MealSlot.breakfast,
    );

    expect(breakfasts, hasLength(7));
    expect(breakfasts.every(
      (meal) => meal.recipeId == 'costlyBreakfast',
    ),
    isTrue,
  );
  expect(plan.estimatedWeeklyCostUsd, 35);
  expect(plan.estimatedWeeklyCostUsd, greaterThan(plan.weeklyBudgetUsd!));
  },
);
}

