/// A meal preset with rough CO2e per serving (kg). Sources: numerous LCA
/// studies; these are coarse estimates suitable for in-app awareness and
/// gamification, not formal accounting.
class MealPreset {
  final String id;
  final String name;
  final String emoji;
  final double co2eKgPerServing;
  final String tier; // 'best', 'good', 'fair', 'high'

  const MealPreset({
    required this.id,
    required this.name,
    required this.emoji,
    required this.co2eKgPerServing,
    required this.tier,
  });
}

class DietLogEntry {
  final String mealPresetId;
  final String name;
  final double co2eKg;
  final DateTime loggedAt;

  const DietLogEntry({
    required this.mealPresetId,
    required this.name,
    required this.co2eKg,
    required this.loggedAt,
  });

  Map<String, dynamic> toMap() => {
        'mealPresetId': mealPresetId,
        'name': name,
        'co2eKg': co2eKg,
        'loggedAt': loggedAt.toIso8601String(),
      };

  factory DietLogEntry.fromMap(Map<String, dynamic> m) => DietLogEntry(
        mealPresetId: m['mealPresetId'] as String,
        name: m['name'] as String? ?? '',
        co2eKg: (m['co2eKg'] as num?)?.toDouble() ?? 0,
        loggedAt:
            DateTime.tryParse(m['loggedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
