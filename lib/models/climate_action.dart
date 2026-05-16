enum ActionCategory {
  energy,
  transport,
  diet,
  waste,
  gardening,
  advocacy,
  diy,
}

extension ActionCategoryX on ActionCategory {
  String get label {
    switch (this) {
      case ActionCategory.energy:
        return 'Energy';
      case ActionCategory.transport:
        return 'Transport';
      case ActionCategory.diet:
        return 'Diet';
      case ActionCategory.waste:
        return 'Waste';
      case ActionCategory.gardening:
        return 'Gardening';
      case ActionCategory.advocacy:
        return 'Advocacy';
      case ActionCategory.diy:
        return 'DIY';
    }
  }

  static ActionCategory fromString(String? s) {
    return ActionCategory.values.firstWhere(
      (e) => e.name == s,
      orElse: () => ActionCategory.energy,
    );
  }
}

/// A concrete action a user can take. CO2e savings are expressed in kg per
/// year (rough estimates only - meant for ordering & motivation, not as a
/// formal accounting figure).
class ClimateAction {
  final String id;
  final String title;
  final String summary;
  final ActionCategory category;
  final double co2eKgPerYear;
  final int difficulty; // 1..5
  final List<String> steps;
  final bool requiresProfessional;
  final String? safetyNote;

  const ClimateAction({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.co2eKgPerYear,
    required this.difficulty,
    this.steps = const [],
    this.requiresProfessional = false,
    this.safetyNote,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'summary': summary,
        'category': category.name,
        'co2eKgPerYear': co2eKgPerYear,
        'difficulty': difficulty,
        'steps': steps,
        'requiresProfessional': requiresProfessional,
        'safetyNote': safetyNote,
      };

  factory ClimateAction.fromMap(Map<String, dynamic> m) => ClimateAction(
        id: m['id'] as String,
        title: m['title'] as String? ?? '',
        summary: m['summary'] as String? ?? '',
        category: ActionCategoryX.fromString(m['category'] as String?),
        co2eKgPerYear: (m['co2eKgPerYear'] as num?)?.toDouble() ?? 0,
        difficulty: (m['difficulty'] as num?)?.toInt() ?? 1,
        steps: (m['steps'] as List?)?.cast<String>() ?? const [],
        requiresProfessional: m['requiresProfessional'] as bool? ?? false,
        safetyNote: m['safetyNote'] as String?,
      );
}

class CompletedAction {
  final String actionId;
  final DateTime completedAt;
  final double co2eKgSaved;

  const CompletedAction({
    required this.actionId,
    required this.completedAt,
    required this.co2eKgSaved,
  });

  Map<String, dynamic> toMap() => {
        'actionId': actionId,
        'completedAt': completedAt.toIso8601String(),
        'co2eKgSaved': co2eKgSaved,
      };

  factory CompletedAction.fromMap(Map<String, dynamic> m) => CompletedAction(
        actionId: m['actionId'] as String,
        completedAt: DateTime.parse(m['completedAt'] as String),
        co2eKgSaved: (m['co2eKgSaved'] as num?)?.toDouble() ?? 0,
      );
}
