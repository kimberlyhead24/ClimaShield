enum ActionCategory {
  energy,
  transport,
  diet,
  waste,
  water,
  biodiversity,
  advocacy,
  diy,
}

extension ActionCategoryX on ActionCategory {
  String get label {
    switch (this) {
      case ActionCategory.energy:       return 'Energy';
      case ActionCategory.transport:    return 'Transport';
      case ActionCategory.diet:         return 'Diet';
      case ActionCategory.waste:        return 'Waste';
      case ActionCategory.water:        return 'Water';
      case ActionCategory.biodiversity: return 'Biodiversity';
      case ActionCategory.advocacy:     return 'Advocacy';
      case ActionCategory.diy:          return 'DIY';
    }
  }

  String get imageAsset {
    switch (this) {
      case ActionCategory.energy:       return 'assets/images/energy.png';
      case ActionCategory.transport:    return 'assets/images/transport.png';
      case ActionCategory.diet:         return 'assets/images/diet.png';
      case ActionCategory.waste:        return 'assets/images/waste_reduction.png';
      case ActionCategory.water:        return 'assets/images/water_savings.png';
      case ActionCategory.biodiversity: return 'assets/images/biodiversity.png';
      case ActionCategory.advocacy:     return 'assets/images/advocacy.png';
      case ActionCategory.diy:          return 'assets/images/energy.png';
    }
  }

  static ActionCategory fromString(String? s) {
    return ActionCategory.values.firstWhere(
      (e) => e.name == s,
      orElse: () => ActionCategory.energy,
    );
  }

  // Returns the first matching category from a list (Firestore stores arrays)
  static ActionCategory fromList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return ActionCategory.energy;
    return fromString(list.first as String?);
  }
}

/// Impact metrics stored as a nested map in Firestore under impact_score.
class ActionImpactScore {
  final double co2eReductionPerYearKg;
  final double pollinatorHabitatSqFt;
  final double wasteDivertedKg;
  final double waterSavedGallons;

  const ActionImpactScore({
    this.co2eReductionPerYearKg = 0,
    this.pollinatorHabitatSqFt = 0,
    this.wasteDivertedKg = 0,
    this.waterSavedGallons = 0,
  });

  factory ActionImpactScore.fromMap(Map<String, dynamic>? m) {
    if (m == null) return const ActionImpactScore();
    return ActionImpactScore(
      co2eReductionPerYearKg:
          (m['co2e_reduction_per_year_kg'] as num?)?.toDouble() ?? 0,
      pollinatorHabitatSqFt:
          (m['pollinator_habitat_sq_ft'] as num?)?.toDouble() ?? 0,
      wasteDivertedKg:
          (m['waste_diverted_kg'] as num?)?.toDouble() ?? 0,
      waterSavedGallons:
          (m['water_saved_gallons'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'co2e_reduction_per_year_kg': co2eReductionPerYearKg,
        'pollinator_habitat_sq_ft': pollinatorHabitatSqFt,
        'waste_diverted_kg': wasteDivertedKg,
        'water_saved_gallons': waterSavedGallons,
      };

  // Total impact score 0–100 for sorting/filtering (weighted)
  double get totalScore {
    return (co2eReductionPerYearKg * 0.5) +
        (pollinatorHabitatSqFt * 0.3) +
        (wasteDivertedKg * 0.1) +
        (waterSavedGallons * 0.002);
  }
}

/// Full action model — maps 1:1 to Firestore /actions/{action_id} documents.
/// Users run the calculator once per year; actions reduce that annual baseline.
class ClimateAction {
  final String id;
  final String name;
  final String description;
  final List<ActionCategory> categories; // multi-category support
  final List<String> environmentalImpactAreas;
  final String costEstimate;             // "$" | "$$" | "$$$" | "$$$$"
  final String difficulty;               // "Easy" | "Medium" | "Hard"
  final ActionImpactScore impactScore;
  final bool isMvpAction;
  final List<String> keywords;
  final String scientificBasis;
  final String sourceLink;
  final List<String> stepByStepGuide;
  final String? videoTutorialUrl;
  final String? imageUrl;                // Firestore URL (falls back to asset)
  final bool requiresProfessional;
  final String? safetyNote;

  // Legacy compatibility fields (used by existing dashboard/repository code)
  // These map to the new fields so old code keeps working without changes.
  String get title => name;
  String get summary => description;
  double get co2eKgPerYear => impactScore.co2eReductionPerYearKg;
  List<String> get steps => stepByStepGuide;
  ActionCategory get primaryCategory =>
      categories.isNotEmpty ? categories.first : ActionCategory.energy;
  int get difficultyInt {
    switch (difficulty.toLowerCase()) {
      case 'easy':   return 1;
      case 'medium': return 3;
      case 'hard':   return 5;
      default:       return 1;
    }
  }

  const ClimateAction({
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    required this.environmentalImpactAreas,
    required this.costEstimate,
    required this.difficulty,
    required this.impactScore,
    this.isMvpAction = false,
    this.keywords = const [],
    this.scientificBasis = '',
    this.sourceLink = '',
    this.stepByStepGuide = const [],
    this.videoTutorialUrl,
    this.imageUrl,
    this.requiresProfessional = false,
    this.safetyNote,
  });

  // ── Firestore deserialization ─────────────────────────────────────────────

  factory ClimateAction.fromFirestore(Map<String, dynamic> m, String docId) {
    final rawCategories = (m['category'] as List?)?.cast<String>() ?? [];
    final categories = rawCategories.isEmpty
        ? [ActionCategory.energy]
        : rawCategories.map(ActionCategoryX.fromString).toList();

    return ClimateAction(
      id: docId,
      name: m['name'] as String? ?? m['title'] as String? ?? '',
      description: m['description'] as String? ?? m['summary'] as String? ?? '',
      categories: categories,
      environmentalImpactAreas:
          (m['environmental_impact_areas'] as List?)?.cast<String>() ?? [],
      costEstimate: m['cost_estimate'] as String? ?? m['costEstimate'] as String? ?? '\$',
      difficulty: m['difficulty'] as String? ?? 'Easy',
      impactScore: ActionImpactScore.fromMap(
          m['impact_score'] as Map<String, dynamic>?),
      isMvpAction: m['is_mvp_action'] as bool? ?? false,
      keywords: (m['keywords'] as List?)?.cast<String>() ?? [],
      scientificBasis: m['scientific_basis'] as String? ?? '',
      sourceLink: m['source_link'] as String? ?? '',
      stepByStepGuide:
          (m['step_by_step_guide'] as List?)?.cast<String>() ?? [],
      videoTutorialUrl: m['video_tutorial_url'] as String?,
      imageUrl: m['image_url'] as String?,
      requiresProfessional: m['requires_professional'] as bool? ?? false,
      safetyNote: m['safety_note'] as String?,
    );
  }

  // Legacy fromMap for any existing local/sample data
  factory ClimateAction.fromMap(Map<String, dynamic> m) =>
      ClimateAction.fromFirestore(m, m['id'] as String? ?? m['action_id'] as String? ?? '');

  Map<String, dynamic> toMap() => {
        'action_id': id,
        'name': name,
        'description': description,
        'category': categories.map((c) => c.name).toList(),
        'environmental_impact_areas': environmentalImpactAreas,
        'cost_estimate': costEstimate,
        'difficulty': difficulty,
        'impact_score': impactScore.toMap(),
        'is_mvp_action': isMvpAction,
        'keywords': keywords,
        'scientific_basis': scientificBasis,
        'source_link': sourceLink,
        'step_by_step_guide': stepByStepGuide,
        'video_tutorial_url': videoTutorialUrl,
        'image_url': imageUrl,
        'requires_professional': requiresProfessional,
        'safety_note': safetyNote,
      };
}

// ── CompletedAction ───────────────────────────────────────────────────────────

class CompletedAction {
  final String actionId;
  final DateTime completedAt;
  final double co2eKgSaved;
  final String category;

  const CompletedAction({
    required this.actionId,
    required this.completedAt,
    required this.co2eKgSaved,
    this.category = '',
  });

  Map<String, dynamic> toMap() => {
        'actionId': actionId,
        'completedAt': completedAt.toIso8601String(),
        'co2eKgSaved': co2eKgSaved,
        'co2eKgPerYear': co2eKgSaved,
        'category': category,
      };

  factory CompletedAction.fromMap(Map<String, dynamic> m) => CompletedAction(
        actionId: m['actionId'] as String,
        completedAt: m['completedAt'] is String
            ? DateTime.parse(m['completedAt'] as String)
            : (m['completedAt'] as dynamic)?.toDate() ?? DateTime.now(),
        co2eKgSaved: (m['co2eKgSaved'] as num?)?.toDouble() ?? 0,
        category: m['category'] as String? ?? '',
      );
}