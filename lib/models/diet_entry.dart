import 'package:cloud_firestore/cloud_firestore.dart';

/// Temporary preset meal used by the current Diet screen.
///
/// These will be replaced by Firestore recipe logging after the new
/// Log meal button is connected.
class MealPreset {
  final String id;
  final String name;
  final String emoji;
  final double co2eKgPerServing;
  final String tier;

  const MealPreset({
    required this.id,
    required this.name,
    required this.emoji,
    required this.co2eKgPerServing,
    required this.tier,
  });
}

/// A user-owned record of one logged meal.
///
/// For real recipes, [estimatedSavingsKg] represents the estimated avoided
/// emissions versus the recipe's stated comparison baseline. It is not the
/// absolute footprint of the meal.
class DietLogEntry {
  /// Firestore document ID, when available.
  final String? id;

  /// Firestore recipe document ID. Legacy presets use their preset ID.
  final String recipeId;

  /// A saved copy of the recipe name, so historical logs remain readable even
  /// if a catalog recipe is later renamed or removed.
  final String recipeName;

  /// Number of servings the user made or ate.
  final int servings;

  /// Estimated comparative savings for one serving.
  final double estimatedSavingsKgPerServing;

  /// [estimatedSavingsKgPerServing] multiplied by [servings].
  final double estimatedSavingsKg;

  /// The meal used as the recipe's climate comparison reference.
  final String? comparisonBaseline;

  /// The scheduled plan date, if the recipe came from a weekly meal plan.
  final DateTime? plannedForDate;

  /// When the user actually recorded the meal.
  final DateTime loggedAt;

  /// Retains the old preset raw-footprint value for existing historical logs.
  ///
  /// New recipe logs leave this null because they track comparative savings,
  /// not an asserted absolute food footprint.
  final double? legacyFootprintKg;

  const DietLogEntry({
    this.id,
    required this.recipeId,
    required this.recipeName,
    required this.servings,
    required this.estimatedSavingsKgPerServing,
    required this.estimatedSavingsKg,
    this.comparisonBaseline,
    this.plannedForDate,
    required this.loggedAt,
    this.legacyFootprintKg,
  });

  /// Compatibility constructor for existing preset meal chips.
  factory DietLogEntry.fromPreset(MealPreset preset) {
    return DietLogEntry(
      recipeId: preset.id,
      recipeName: preset.name,
      servings: 1,
      estimatedSavingsKgPerServing: 0,
      estimatedSavingsKg: 0,
      loggedAt: DateTime.now(),
      legacyFootprintKg: preset.co2eKgPerServing,
    );
  }

  /// Existing screens temporarily use these names.
  @Deprecated('Use recipeId instead.')
  String get mealPresetId => recipeId;

  @Deprecated('Use recipeName instead.')
  String get name => recipeName;

  @Deprecated('Use estimatedSavingsKg instead.')
  double get co2eKg => legacyFootprintKg ?? estimatedSavingsKg;

  factory DietLogEntry.fromMap(Map<String, dynamic> map, {String? id}) {
    final servings = (map['servings'] as num?)?.toInt() ?? 1;

    final savingsPerServing =
        (map['estimatedSavingsKgPerServing'] as num?)?.toDouble() ?? 0;

    final savings =
        (map['estimatedSavingsKg'] as num?)?.toDouble() ??
        savingsPerServing * servings;

    return DietLogEntry(
      id: id,
      recipeId:
          map['recipeId'] as String? ?? map['mealPresetId'] as String? ?? '',
      recipeName:
          map['recipeName'] as String? ??
          map['name'] as String? ??
          'Unnamed meal',
      servings: servings,
      estimatedSavingsKgPerServing: savingsPerServing,
      estimatedSavingsKg: savings,
      comparisonBaseline: map['comparisonBaseline'] as String?,
      plannedForDate: _dateFromValue(map['plannedForDate']),
      loggedAt: _dateFromValue(map['loggedAt']) ?? DateTime.now(),
      legacyFootprintKg: (map['co2eKg'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'servings': servings,
      'estimatedSavingsKgPerServing': estimatedSavingsKgPerServing,
      'estimatedSavingsKg': estimatedSavingsKg,
      'comparisonBaseline': comparisonBaseline,
      'plannedForDate': plannedForDate,
      'loggedAt': loggedAt,
      'legacyFootprintKg': legacyFootprintKg,
    };
  }

  static DateTime? _dateFromValue(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}
