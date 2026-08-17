enum MealSlot { breakfast, lunch, dinner }

enum MealPlanPace { gradual, steady, allIn }

class PlannedMeal {
  /// Firestore recipe document ID.
  final String recipeId;

  /// Saved recipe title for readable historical plans.
  final String recipeName;

  /// Breakfast, lunch, or dinner.
  final MealSlot mealSlot;

  /// The calendar day this meal was assigned to in the plan.
  final DateTime plannedForDate;

  /// Number of servings this plan tells the household to make.
  final int servings;

  /// Scaled recipe-use cost for the household's planned servings.
  final double estimatedCostUsd;

  /// Estimated comparative CO₂e reduction for this planned meal.
  final double estimatedCo2eReductionKg;

  /// Estimated comparative water savings for this planned meal.
  final double estimatedWaterSavedGallons;

  /// Deterministic score assigned by the plan generator.
  final double rankingScore;

  /// Human-readable reasons this recipe was selected.
  final List<String> rankingReasons;

  const PlannedMeal({
    required this.recipeId,
    required this.recipeName,
    required this.mealSlot,
    required this.plannedForDate,
    this.servings = 1,
    this.estimatedCostUsd = 0,
    this.estimatedCo2eReductionKg = 0,
    this.estimatedWaterSavedGallons = 0,
    this.rankingScore = 0,
    this.rankingReasons = const [],
  });

  factory PlannedMeal.fromMap(Map<String, dynamic> map) {
    return PlannedMeal(
      recipeId: map['recipeId'] as String? ?? '',
      recipeName: map['recipeName'] as String? ?? 'Unnamed recipe',
      mealSlot: _mealSlotFromValue(map['mealSlot'] as String?),
      plannedForDate:
          DateTime.tryParse(map['plannedForDate'] as String? ?? '') ??
          DateTime.now(),
      servings: _safePositiveInt(map['servings']),
      estimatedCostUsd: _doubleFrom(map['estimatedCostUsd']),
      estimatedCo2eReductionKg: _doubleFrom(map['estimatedCo2eReductionKg']),
      estimatedWaterSavedGallons: _doubleFrom(
        map['estimatedWaterSavedGallons'],
      ),
      rankingScore: _doubleFrom(map['rankingScore']),
      rankingReasons: _stringList(map['rankingReasons']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'mealSlot': mealSlot.name,
      'plannedForDate': _dateOnly(plannedForDate).toIso8601String(),
      'servings': servings,
      'estimatedCostUsd': estimatedCostUsd,
      'estimatedCo2eReductionKg': estimatedCo2eReductionKg,
      'estimatedWaterSavedGallons': estimatedWaterSavedGallons,
      'rankingScore': rankingScore,
      'rankingReasons': rankingReasons,
    };
  }

  static MealSlot _mealSlotFromValue(String? value) {
    return switch (value) {
      'lunch' => MealSlot.lunch,
      'dinner' => MealSlot.dinner,
      _ => MealSlot.breakfast,
    };
  }
}

class WeeklyMealPlan {
  /// Use the Monday date in YYYY-MM-DD format as the Firestore document ID.
  final String id;

  /// Monday at the start of the seven-day plan.
  final DateTime weekStart;

  /// Seven-day meal-plan approach selected by the user.
  final MealPlanPace pace;

  /// Every scheduled breakfast, lunch, and dinner in this plan.
  final List<PlannedMeal> meals;

  /// Household size used to scale recipe quantities and meal totals.
  final int householdSize;

  /// Optional user-selected weekly budget.
  final double? weeklyBudgetUsd;

  /// Sum of all planned meal costs.
  final double estimatedWeeklyCostUsd;

  /// Sum of planned estimated comparative CO₂e reductions.
  final double estimatedWeeklyCo2eReductionKg;

  /// Sum of planned estimated comparative water savings.
  final double estimatedWeeklyWaterSavedGallons;

  /// Lets us change recommendation logic safely in later releases.
  final int generatorVersion;

  final DateTime generatedAt;

  const WeeklyMealPlan({
    required this.id,
    required this.weekStart,
    required this.pace,
    required this.meals,
    this.householdSize = 1,
    this.weeklyBudgetUsd,
    this.estimatedWeeklyCostUsd = 0,
    this.estimatedWeeklyCo2eReductionKg = 0,
    this.estimatedWeeklyWaterSavedGallons = 0,
    this.generatorVersion = 1,
    required this.generatedAt,
  });

  DateTime get weekEnd => weekStart.add(const Duration(days: 6));

  List<PlannedMeal> mealsForDay(DateTime date) {
    final normalizedDate = _dateOnly(date);

    return meals
        .where((meal) => _dateOnly(meal.plannedForDate) == normalizedDate)
        .toList(growable: false);
  }

  List<PlannedMeal> mealsForSlot(DateTime date, MealSlot slot) {
    final normalizedDate = _dateOnly(date);

    return meals
        .where(
          (meal) =>
              meal.mealSlot == slot &&
              _dateOnly(meal.plannedForDate) == normalizedDate,
        )
        .toList(growable: false);
  }

  factory WeeklyMealPlan.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    final rawMeals = map['meals'];

    final meals = rawMeals is List
        ? rawMeals
              .whereType<Map>()
              .map(
                (item) => PlannedMeal.fromMap(Map<String, dynamic>.from(item)),
              )
              .toList(growable: false)
        : const <PlannedMeal>[];

    return WeeklyMealPlan(
      id: id,
      weekStart:
          DateTime.tryParse(map['weekStart'] as String? ?? '') ??
          DateTime.now(),
      pace: _paceFromValue(map['pace'] as String?),
      meals: meals,
      householdSize: _safePositiveInt(map['householdSize']),
      weeklyBudgetUsd: _nullableDoubleFrom(map['weeklyBudgetUsd']),
      estimatedWeeklyCostUsd: _doubleFrom(map['estimatedWeeklyCostUsd']),
      estimatedWeeklyCo2eReductionKg: _doubleFrom(
        map['estimatedWeeklyCo2eReductionKg'],
      ),
      estimatedWeeklyWaterSavedGallons: _doubleFrom(
        map['estimatedWeeklyWaterSavedGallons'],
      ),
      generatorVersion: _safePositiveInt(map['generatorVersion'], fallback: 1),
      generatedAt:
          DateTime.tryParse(map['generatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weekStart': _dateOnly(weekStart).toIso8601String(),
      'pace': pace.name,
      'meals': meals.map((meal) => meal.toMap()).toList(growable: false),
      'householdSize': householdSize,
      'weeklyBudgetUsd': weeklyBudgetUsd,
      'estimatedWeeklyCostUsd': estimatedWeeklyCostUsd,
      'estimatedWeeklyCo2eReductionKg': estimatedWeeklyCo2eReductionKg,
      'estimatedWeeklyWaterSavedGallons': estimatedWeeklyWaterSavedGallons,
      'generatorVersion': generatorVersion,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  static MealPlanPace _paceFromValue(String? value) {
    return switch (value) {
      'gradual' => MealPlanPace.gradual,
      'allIn' => MealPlanPace.allIn,
      _ => MealPlanPace.steady,
    };
  }
}

double _doubleFrom(Object? value) {
  return (value as num?)?.toDouble() ?? 0;
}

double? _nullableDoubleFrom(Object? value) {
  return (value as num?)?.toDouble();
}

int _safePositiveInt(Object? value, {int fallback = 1}) {
  final parsed = (value as num?)?.toInt() ?? fallback;
  return parsed < 1 ? fallback : parsed;
}

List<String> _stringList(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value.whereType<String>().toList(growable: false);
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}
