import 'package:clima_shield/models/weekly_meal_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monday = DateTime(2026, 8, 17);
  final tuesday = DateTime(2026, 8, 18);

  PlannedMeal makeMeal({
    required String id,
    required MealSlot slot,
    required DateTime date,
  }) {
    return PlannedMeal(
      recipeId: id,
      recipeName: 'Recipe $id',
      mealSlot: slot,
      plannedForDate: date,
      servings: 2,
    );
  }

  group('PlannedMeal', () {
    test('round-trips through a Firestore-compatible map', () {
      final meal = PlannedMeal(
        recipeId: 'recipe-1',
        recipeName: 'Test Breakfast',
        mealSlot: MealSlot.breakfast,
        plannedForDate: monday,
        servings: 3,
      );

      final restored = PlannedMeal.fromMap(meal.toMap());

      expect(restored.recipeId, 'recipe-1');
      expect(restored.recipeName, 'Test Breakfast');
      expect(restored.mealSlot, MealSlot.breakfast);
      expect(restored.plannedForDate, monday);
      expect(restored.servings, 3);
    });

    test('round-trips planning snapshot and ranking fields', () {
      final meal = PlannedMeal(
        recipeId: 'recipe-1',
        recipeName: 'Low-impact Chili',
        mealSlot: MealSlot.dinner,
        plannedForDate: monday,
        servings: 2,
        estimatedCostUsd: 4.50,
        estimatedCo2eReductionKg: 3.20,
        estimatedWaterSavedGallons: 840,
        rankingScore: 92.5,
        rankingReasons: const [
          'Fits your weekly budget',
          'Matches your vegetarian preference',
        ],
      );

      final restored = PlannedMeal.fromMap(meal.toMap());

      expect(restored.estimatedCostUsd, 4.50);
      expect(restored.estimatedCo2eReductionKg, 3.20);
      expect(restored.estimatedWaterSavedGallons, 840);
      expect(restored.rankingScore, 92.5);
      expect(restored.rankingReasons, [
        'Fits your weekly budget',
        'Matches your vegetarian preference',
      ]);
    });

    test('uses safe defaults for incomplete saved data', () {
      final meal = PlannedMeal.fromMap(const {});

      expect(meal.recipeId, isEmpty);
      expect(meal.recipeName, 'Unnamed recipe');
      expect(meal.mealSlot, MealSlot.breakfast);
      expect(meal.servings, 1);
    });
  });

  group('WeeklyMealPlan', () {
    final meals = [
      makeMeal(id: 'breakfast-1', slot: MealSlot.breakfast, date: monday),
      makeMeal(id: 'lunch-1', slot: MealSlot.lunch, date: monday),
      makeMeal(id: 'dinner-1', slot: MealSlot.dinner, date: monday),
      makeMeal(id: 'breakfast-2', slot: MealSlot.breakfast, date: tuesday),
    ];

    final plan = WeeklyMealPlan(
      id: '2026-08-17',
      weekStart: monday,
      pace: MealPlanPace.allIn,
      meals: meals,
      generatorVersion: 1,
      generatedAt: monday,
    );

    test('calculates the Sunday end date for a Monday-based week', () {
      expect(plan.weekEnd, DateTime(2026, 8, 23));
    });
    test('reports no budget overage when a plan is within budget', () {
      final plan = WeeklyMealPlan(
        id: '2026-08-24',
        weekStart: DateTime(2026, 8, 24),
        pace: MealPlanPace.steady,
        meals: const [],
        weeklyBudgetUsd: 100,
        estimatedWeeklyCostUsd: 85,
        generatedAt: DateTime(2026, 8, 24),
      );

      expect(plan.isOverBudget, isFalse);
      expect(plan.budgetOverageUsd, 0);
    });

    test('reports the amount when a plan exceeds budget', () {
      final plan = WeeklyMealPlan(
        id: '2026-08-24',
        weekStart: DateTime(2026, 8, 24),
        pace: MealPlanPace.steady,
        meals: const [],
        weeklyBudgetUsd: 100,
        estimatedWeeklyCostUsd: 114.75,
        generatedAt: DateTime(2026, 8, 24),
      );

      expect(plan.isOverBudget, isTrue);
      expect(plan.budgetOverageUsd, greaterThan(0));
    });
    test('returns only meals scheduled for the requested day', () {
      final mondayMeals = plan.mealsForDay(monday);

      expect(mondayMeals, hasLength(3));
      expect(mondayMeals.map((meal) => meal.recipeId), [
        'breakfast-1',
        'lunch-1',
        'dinner-1',
      ]);
    });

    test('returns only the requested slot on the requested day', () {
      final dinner = plan.mealsForSlot(monday, MealSlot.dinner);

      expect(dinner, hasLength(1));
      expect(dinner.single.recipeId, 'dinner-1');
    });

    test('returns an empty list for a day with no planned meals', () {
      expect(plan.mealsForDay(DateTime(2026, 8, 22)), isEmpty);
    });

    test('round-trips all fields through a Firestore-compatible map', () {
      final restored = WeeklyMealPlan.fromMap(plan.toMap(), id: plan.id);

      expect(restored.id, '2026-08-17');
      expect(restored.weekStart, monday);
      expect(restored.pace, MealPlanPace.allIn);
      expect(restored.generatorVersion, 1);
      expect(restored.generatedAt, monday);
      expect(restored.meals, hasLength(4));
      expect(restored.meals.last.recipeId, 'breakfast-2');
    });

    test('round-trips weekly budget, household, and impact totals', () {
      final configuredPlan = WeeklyMealPlan(
        id: '2026-08-17',
        weekStart: monday,
        pace: MealPlanPace.steady,
        meals: const [],
        householdSize: 3,
        weeklyBudgetUsd: 125.00,
        estimatedWeeklyCostUsd: 112.40,
        estimatedWeeklyCo2eReductionKg: 18.75,
        estimatedWeeklyWaterSavedGallons: 2400,
        generatedAt: monday,
      );

      final restored = WeeklyMealPlan.fromMap(
        configuredPlan.toMap(),
        id: configuredPlan.id,
      );

      expect(restored.householdSize, 3);
      expect(restored.weeklyBudgetUsd, 125.00);
      expect(restored.estimatedWeeklyCostUsd, 112.40);
      expect(restored.estimatedWeeklyCo2eReductionKg, 18.75);
      expect(restored.estimatedWeeklyWaterSavedGallons, 2400);
    });

    test('restores the allIn pace from persisted data', () {
      final restored = WeeklyMealPlan.fromMap({
        'weekStart': '2026-08-17T00:00:00.000',
        'pace': 'allIn',
        'meals': [],
        'generatorVersion': 1,
        'generatedAt': '2026-08-17T00:00:00.000',
      }, id: '2026-08-17');

      expect(restored.pace, MealPlanPace.allIn);
    });
  });
}
