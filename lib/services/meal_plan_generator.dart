import 'package:clima_shield/models/diet_profile.dart';
import 'package:clima_shield/models/recipe_model.dart';
import 'package:clima_shield/models/weekly_meal_plan.dart';

class RankedRecipe {
  const RankedRecipe({
    required this.recipe,
    required this.score,
    required this.reasons,
  });

  final Recipe recipe;
  final double score;
  final List<String> reasons;
}

class MealPlanGenerator {
  static List<Recipe> filterEligibleRecipes({
  required List<Recipe> recipes,
  required DietProfile profile,
}) {
  final dietaryRestrictions =
      _normalizedSet(profile.dietaryRestrictions);
  final profileAllergens = _normalizedSet(profile.allergens);
  final avoidedCuisines =
      _normalizedSet(profile.avoidedCuisines);
  final dislikedIngredients =
      _normalizedSet(profile.dislikedIngredients);

  final hasTimeLimit = profile.maxCookingTimeMinutes > 0;

  return recipes.where((recipe) {
    final recipeDietTypes = _normalizedSet(recipe.dietTypes);
    final recipeAllergens = _normalizedSet(recipe.allergens);
    final recipeCategories = _normalizedSet(recipe.categories);

    final exceedsTimeLimit =
        hasTimeLimit &&
        recipe.effectiveTotalTimeMinutes >
            profile.maxCookingTimeMinutes;

    final hasRestrictedDietMismatch =
        dietaryRestrictions.isNotEmpty &&
        !dietaryRestrictions.every(recipeDietTypes.contains);

    final containsAllergen =
        recipeAllergens.any(profileAllergens.contains);

    final usesAvoidedCuisine =
        recipeCategories.any(avoidedCuisines.contains);

    final hasDislikedIngredient = recipe.ingredientDetails.any(
      (ingredient) =>
          dislikedIngredients.contains(
            _normalize(ingredient.name),
          ),
    );

    return !exceedsTimeLimit &&
        !hasRestrictedDietMismatch &&
        !containsAllergen &&
        !usesAvoidedCuisine &&
        !hasDislikedIngredient;
  }).toList(growable: false);
}

  static List<RankedRecipe> rankRecipes({
    required List<Recipe> recipes,
    required DietProfile profile,
  }) {
    final preferredCuisines = _normalizedSet(profile.preferredCuisines);

    final ranked = recipes.map((recipe) {
      var score = 0.0;
      final reasons = <String>[];
      final recipeCategories = _normalizedSet(recipe.categories);
      final climateReduction =
          recipe.climateImpact.estimatedReductionKgPerServing ?? 0.0;

      for (final cuisine in preferredCuisines) {
        if (recipeCategories.contains(cuisine)) {
          score += 20;
          reasons.add('Matches your preferred $cuisine cuisine');
        }
      }

      final hasTimeLimit = profile.maxCookingTimeMinutes > 0;

      if (!hasTimeLimit ||
          recipe.effectiveTotalTimeMinutes <=
            profile.maxCookingTimeMinutes) {
        score += 10;
        reasons.add('Fits your cooking-time preference');
      }

      if (climateReduction > 0) {
        score += climateReduction;
        reasons.add('Helps reduce your meal climate impact');
      }

      return RankedRecipe(
        recipe: recipe,
        score: score,
        reasons: reasons,
      );
    }).toList();

    ranked.sort((a, b) {
      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) {
        return scoreComparison;
      }

      return a.recipe.id.compareTo(b.recipe.id);
    });

    return ranked;
  }

  static PlannedMeal toPlannedMeal({
    required Recipe recipe,
    required MealSlot slot,
    required DateTime date,
    required int householdSize,
    required double rankingScore,
    required List<String> rankingReasons,
  }) {
    final safeHouseholdSize = householdSize < 1 ? 1 : householdSize;

    final costPerServing = recipe.effectiveCostPerServing ?? 0;
    final savingsPerServing =
      recipe.climateImpact.estimatedReductionKgPerServing ?? 0;
    final waterSavedPerServing = 
      recipe.climateImpact.waterSavedGallonsPerServing ?? 0;

    return PlannedMeal(
      recipeId: recipe.id,
      recipeName: recipe.title,
      mealSlot: slot,
      plannedForDate: date,
      servings: safeHouseholdSize,
      estimatedCostUsd: costPerServing * safeHouseholdSize,
      estimatedCo2eReductionKg: savingsPerServing * safeHouseholdSize,
      estimatedWaterSavedGallons: waterSavedPerServing * safeHouseholdSize,
      rankingScore: rankingScore,
      rankingReasons: List<String>.unmodifiable(rankingReasons),
    );
  }

  static WeeklyMealPlan generate({
    required List<Recipe> recipes,
    required DietProfile profile,
    required DateTime weekStart,
  }) {
    final eligible = filterEligibleRecipes(
      recipes: recipes,
      profile: profile,
    );

    final ranked = rankRecipes(
      recipes: eligible,
      profile: profile,
    );

    final meals = <PlannedMeal>[];
    final usedRecipeIds = <String>{};

    final slots = <MealSlot>[
      MealSlot.breakfast,
      MealSlot.lunch,
      MealSlot.dinner,
    ];

    for (var dayOffset = 0; dayOffset < 7; dayOffset++) {
      final date = weekStart.add(Duration(days: dayOffset));

      for (final slot in slots) {
        final slotName = slot.name;

        RankedRecipe? candidate;
        for (final rankedRecipe in ranked) {
          final supportsSlot =
              _normalizedSet(rankedRecipe.recipe.mealTypes).contains(slotName);

          if (!usedRecipeIds.contains(rankedRecipe.recipe.id) &&
              supportsSlot) {
            candidate = rankedRecipe;
            break;
          }
        }

        if (candidate == null) {
          continue;
        }

        usedRecipeIds.add(candidate.recipe.id);

        meals.add(
          toPlannedMeal(
            recipe: candidate.recipe,
            slot: slot,
            date: date,
            householdSize: profile.householdSize,
            rankingScore: candidate.score,
            rankingReasons: candidate.reasons,
          ),
        );
      }
    }
    final estimatedWeeklyCostUsd = meals.fold<double>(
      0,
      (total, meal) => total + meal.estimatedCostUsd,
    );

    final estimatedWeeklyCo2eReductionKg = meals.fold<double>(
      0,
      (total, meal) => total + meal.estimatedCo2eReductionKg,
    );

    final estimatedWeeklyWaterSavedGallons = meals.fold<double>(
      0,
      (total, meal) => total + meal.estimatedWaterSavedGallons,
    );

    return WeeklyMealPlan(
      id: _weekId(weekStart),
      weekStart: weekStart,
      pace: _paceFromProfile(profile.transitionPace),
      meals: meals,
      householdSize: profile.householdSize,
      weeklyBudgetUsd: profile.weeklyFoodBudgetUsd,
      estimatedWeeklyCostUsd: estimatedWeeklyCostUsd,
      estimatedWeeklyCo2eReductionKg: estimatedWeeklyCo2eReductionKg,
      estimatedWeeklyWaterSavedGallons: estimatedWeeklyWaterSavedGallons,
      generatorVersion: 1,
      generatedAt: DateTime.now(),
    );
  }

  static MealPlanPace _paceFromProfile(String pace) {
    return switch (_normalize(pace)) {
      'gradual' => MealPlanPace.gradual,
      'all in' || 'all-in' || 'allin' => MealPlanPace.allIn,
      _ => MealPlanPace.steady,
    };
  }

  static String _weekId(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return '${normalized.year}-'
        '${normalized.month.toString().padLeft(2, '0')}-'
        '${normalized.day.toString().padLeft(2, '0')}';
  }

  static Set<String> _normalizedSet(Iterable<dynamic> values) {
    return values
        .whereType<String>()
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}