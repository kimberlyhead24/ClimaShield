import 'package:cloud_firestore/cloud_firestore.dart';

/// A user's saved diet preferences and baseline inputs
///
/// This model is stored at:
/// users/{uid}/dietProfile/current
class DietProfile {
  /// Increment when the Firestore profile structure changes.
  final int profileVersion;

  /// Number of people normally eating the meals prepared by this user.
  final int householdSize;

  /// Meals typically prepared at home each week.
  final int mealsPreparedAtHomePerWeek;

  /// The user's primary app goal, such as 'footprint', 'health', or 'budget'.
  final String primaryGoal;

  /// The user's self-described dietary pattern, such as 'omnivore or vegan'.
  final String currentDietPattern;

  /// Total meals the user typically eats in one week.
  ///
  /// This is usually near 21, but users can report a different routine.
  final int totalMealsEatenPerWeek;

  /// Weekly servings containing beef or lamb.
  final double beefOrLambServingsPerWeek;

  /// Weekly servings containing pork.
  final double porkServingsPerWeek;

  /// Weekly servings containing poultry.
  final double poultryServingsPerWeek;

  /// Weekly servings containing fish or seafood.
  final double fishOrSeafoodServingsPerWeek;

  /// Weekly servings where eggs are a meaningful ingredient or protein source.
  final double eggServingsPerWeek;

  /// Weekly servings with dairy as a substantial part of the meal.
  final double dairyServingsPerWeek;

  /// Weekly servings centered on plant proteins, such as beans, lentils
  /// tofu, tempeh, or other meat alternatives.
  final double plantProteinServingsPerWeek;

  /// Cuisines the user wants to see more often in recommendations.
  final List<String> preferredCuisines;

  /// Cuisines the user prefers not to receive in recommendations.
  final List<String> avoidedCuisines;

  /// Ingredients the user dislikes but that are not medical restrictions.
  final List<String> dislikedIngredients;

  /// Dietary requirements, such as 'gluten-free' or 'dairy-free'.
  final List<String> dietaryRestrictions;

  /// Food allergens, such as 'nut_allergy' or 'shellfish_allergy'.
  final List<String> allergens;

  /// Maximum preferred preparation and cooking time for a recipe.
  final int maxCookingTimeMinutes;

  /// Optional weekly food budget provided by the user.
  ///
  /// Null means the user chose not to provide a budget.
  final double? weeklyFoodBudgetUsd;

  /// The user's preferred change pace: 'gradual', 'steady', or 'all_in'.
  final String transitionPace;

  /// The most recent time the profile was saved or updated.
  final DateTime updatedAt;

  const DietProfile({
    required this.profileVersion,
    required this.householdSize,
    required this.mealsPreparedAtHomePerWeek,
    required this.primaryGoal,
    required this.currentDietPattern,
    required this.totalMealsEatenPerWeek,
    required this.beefOrLambServingsPerWeek,
    required this.porkServingsPerWeek,
    required this.poultryServingsPerWeek,
    required this.fishOrSeafoodServingsPerWeek,
    required this.eggServingsPerWeek,
    required this.dairyServingsPerWeek,
    required this.plantProteinServingsPerWeek,
    required this.preferredCuisines,
    required this.avoidedCuisines,
    required this.dislikedIngredients,
    required this.dietaryRestrictions,
    required this.allergens,
    required this.maxCookingTimeMinutes,
    required this.weeklyFoodBudgetUsd,
    required this.transitionPace,
    required this.updatedAt,
  });

  /// Returns an incomplete profile for a user who has not finished onboarding.
  ///
  /// This must not be used to calculate a diet-carbon baseline until the user
  /// provides actual food-frequency information.
  factory DietProfile.empty() {
    return DietProfile(
      profileVersion: 1,
      householdSize: 1,
      mealsPreparedAtHomePerWeek: 0,
      primaryGoal: '',
      currentDietPattern: 'unknown',
      totalMealsEatenPerWeek: 0,
      beefOrLambServingsPerWeek: 0,
      porkServingsPerWeek: 0,
      poultryServingsPerWeek: 0,
      fishOrSeafoodServingsPerWeek: 0,
      eggServingsPerWeek: 0,
      dairyServingsPerWeek: 0,
      plantProteinServingsPerWeek: 0,
      preferredCuisines: const [],
      avoidedCuisines: const [],
      dislikedIngredients: const [],
      dietaryRestrictions: const [],
      allergens: const [],
      maxCookingTimeMinutes: 0,
      weeklyFoodBudgetUsd: null,
      transitionPace: 'gradual',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// Converts this profile into Firebase-compatible data.
  Map<String, dynamic> toMap() {
    return {
      'profileVersion': profileVersion,
      'householdSize': householdSize,
      'mealsPreparedAtHomePerWeek': mealsPreparedAtHomePerWeek,
      'primaryGoal': primaryGoal,
      'currentDietPattern': currentDietPattern,
      'totalMealsEatenPerWeek': totalMealsEatenPerWeek,
      'beefOrLambServingsPerWeek': beefOrLambServingsPerWeek,
      'porkServingsPerWeek': porkServingsPerWeek,
      'poultryServingsPerWeek': poultryServingsPerWeek,
      'fishOrSeafoodServingsPerWeek': fishOrSeafoodServingsPerWeek,
      'eggServingsPerWeek': eggServingsPerWeek,
      'dairyServingsPerWeek': dairyServingsPerWeek,
      'plantProteinServingsPerWeek': plantProteinServingsPerWeek,
      'preferredCuisines': preferredCuisines,
      'avoidedCuisines': avoidedCuisines,
      'dislikedIngredients': dislikedIngredients,
      'dietaryRestrictions': dietaryRestrictions,
      'allergens': allergens,
      'maxCookingTimeMinutes': maxCookingTimeMinutes,
      'weeklyFoodBudgetUsd': weeklyFoodBudgetUsd,
      'transitionPace': transitionPace,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Creates a diet profile from Firestore data.
  factory DietProfile.fromMap(Map<String, dynamic> map) {
    return DietProfile(
      profileVersion: (map['profileVersion'] as num?)?.toInt() ?? 1,
      householdSize: (map['householdSize'] as num?)?.toInt() ?? 1,
      mealsPreparedAtHomePerWeek:
          (map['mealsPreparedAtHomePerWeek'] as num?)?.toInt() ?? 0,
      primaryGoal: map['primaryGoal'] as String? ?? '',
      currentDietPattern: map['currentDietPattern'] as String? ?? 'unknown',
      totalMealsEatenPerWeek:
          (map['totalMealsEatenPerWeek'] as num?)?.toInt() ?? 0,
      beefOrLambServingsPerWeek:
          (map['beefOrLambServingsPerWeek'] as num?)?.toDouble() ?? 0,
      porkServingsPerWeek:
          (map['porkServingsPerWeek'] as num?)?.toDouble() ?? 0,
      poultryServingsPerWeek:
          (map['poultryServingsPerWeek'] as num?)?.toDouble() ?? 0,
      fishOrSeafoodServingsPerWeek:
          (map['fishOrSeafoodServingsPerWeek'] as num?)?.toDouble() ?? 0,
      eggServingsPerWeek: (map['eggServingsPerWeek'] as num?)?.toDouble() ?? 0,
      dairyServingsPerWeek:
          (map['dairyServingsPerWeek'] as num?)?.toDouble() ?? 0,
      plantProteinServingsPerWeek:
          (map['plantProteinServingsPerWeek'] as num?)?.toDouble() ?? 0,
      preferredCuisines: _stringList(map['preferredCuisines']),
      avoidedCuisines: _stringList(map['avoidedCuisines']),
      dislikedIngredients: _stringList(map['dislikedIngredients']),
      dietaryRestrictions: _stringList(map['dietaryRestrictions']),
      allergens: _stringList(map['allergens']),
      maxCookingTimeMinutes:
          (map['maxCookingTimeMinutes'] as num?)?.toInt() ?? 0,
      weeklyFoodBudgetUsd: (map['weeklyFoodBudgetUsd'] as num?)?.toDouble(),
      transitionPace: map['transitionPace'] as String? ?? 'gradual',
      updatedAt: _dateFromFirestore(map['updatedAt']),
    );
  }

  /// Converts a dynamic Firestore list into a safe list of strings.
  static List<String> _stringList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value.whereType<String>().toList();
  }

  /// Converts Firestore or legacy timestamp values into Dart DateTime values.
  static DateTime _dateFromFirestore(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Total weekly servings reported across the major tracked food groups.
  ///
  /// This is a derived value and is not stored separately in Firestore.
  double get totalReportedFoodGroupServingsPerWeek {
    return beefOrLambServingsPerWeek +
        porkServingsPerWeek +
        poultryServingsPerWeek +
        fishOrSeafoodServingsPerWeek +
        eggServingsPerWeek +
        dairyServingsPerWeek +
        plantProteinServingsPerWeek;
  }

  /// True when the profile has enough information for a preliminary
  /// personalized diet-carbon baseline.
  bool get isReadyForDietBaseline {
    return totalMealsEatenPerWeek > 0 &&
        totalReportedFoodGroupServingsPerWeek > 0;
  }
}
