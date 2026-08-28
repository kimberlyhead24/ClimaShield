import 'package:cloud_firestore/cloud_firestore.dart';

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
      case ActionCategory.energy:
        return 'Energy';
      case ActionCategory.transport:
        return 'Transport';
      case ActionCategory.diet:
        return 'Diet';
      case ActionCategory.waste:
        return 'Waste';
      case ActionCategory.water:
        return 'Water';
      case ActionCategory.biodiversity:
        return 'Biodiversity';
      case ActionCategory.advocacy:
        return 'Advocacy';
      case ActionCategory.diy:
        return 'DIY';
    }
  }

  String get imageAsset {
    switch (this) {
      case ActionCategory.energy:
        return 'assets/images/energy.png';
      case ActionCategory.transport:
        return 'assets/images/transport.png';
      case ActionCategory.diet:
        return 'assets/images/diet.png';
      case ActionCategory.waste:
        return 'assets/images/waste_reduction.png';
      case ActionCategory.water:
        return 'assets/images/water_savings.png';
      case ActionCategory.biodiversity:
        return 'assets/images/biodiversity.png';
      case ActionCategory.advocacy:
        return 'assets/images/advocacy.png';
      case ActionCategory.diy:
        return 'assets/images/energy.png';
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

/// Impact metrics stored as a nested map in Firestore under impactScore.
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
          (m['co2eReductionPerYearKg'] as num?)?.toDouble() ?? 0,
      pollinatorHabitatSqFt:
          (m['pollinatorHabitatSqFt'] as num?)?.toDouble() ?? 0,
      wasteDivertedKg: (m['wasteDivertedKg'] as num?)?.toDouble() ?? 0,
      waterSavedGallons: (m['waterSavedGallons'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'co2eReductionPerYearKg': co2eReductionPerYearKg,
    'pollinatorHabitatSqFt': pollinatorHabitatSqFt,
    'wasteDivertedKg': wasteDivertedKg,
    'waterSavedGallons': waterSavedGallons,
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
  final String costEstimate; // "$" | "$$" | "$$$" | "$$$$"
  final String difficulty; // "Easy" | "Medium" | "Hard"
  final ActionImpactScore impactScore;
  final bool isMvpAction;
  final List<String> keywords;
  final String scientificBasis;
  final String sourceLink;
  final List<String> stepByStepGuide;
  final String? videoTutorialUrl;
  final String? imageUrl; // Firestore URL (falls back to asset)
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
      case 'easy':
        return 1;
      case 'medium':
        return 3;
      case 'hard':
        return 5;
      default:
        return 1;
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

  factory ClimateAction.fromFirestore(
    Map<String, dynamic> map, 
    String documentId,
  ) {
    final rawCategories = (map['category'] as List?)?.cast<String>() ?? [];
    final categories = rawCategories.isEmpty
        ? [ActionCategory.energy]
        : rawCategories.map(ActionCategoryX.fromString).toList();

    return ClimateAction(
      id: documentId,
      name: map['name'] as String? ?? map['title'] as String? ?? '',
      description: map['description'] as String? ?? map['summary'] as String? ?? '',
      categories: categories,
      environmentalImpactAreas:
          (map['environmentalImpactAreas'] as List?)?.cast<String>() ?? [],
      costEstimate:
          map['costEstimate'] as String? ?? map['costEstimate'] as String? ?? '\$',
      difficulty: map['difficulty'] as String? ?? 'Easy',
      impactScore: ActionImpactScore.fromMap(
        map['impactScore'] as Map<String, dynamic>?,
      ),
      isMvpAction: map['isMvpAction'] as bool? ?? false,
      keywords: (map['keywords'] as List?)?.cast<String>() ?? [],
      scientificBasis: map['scientificBasis'] as String? ?? '',
      sourceLink: map['sourceLink'] as String? ?? '',
      stepByStepGuide: (map['stepByStepGuide'] as List?)?.cast<String>() ?? [],
      videoTutorialUrl: map['videoTutorialUrl'] as String?,
      imageUrl: map['imageUrl'] as String?,
      requiresProfessional: map['requiresProfessional'] as bool? ?? false,
      safetyNote: map['safetyNote'] as String?,
    );
  }

  // Legacy fromMap for any existing local/sample data
  factory ClimateAction.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    return ClimateAction.fromFirestore(map, id);
  }

  Map<String, dynamic> toMap() => {
    'actionId': id,
    'name': name,
    'description': description,
    'category': categories.map((c) => c.name).toList(),
    'environmentalImpactAreas': environmentalImpactAreas,
    'costEstimate': costEstimate,
    'difficulty': difficulty,
    'impactScore': impactScore.toMap(),
    'isMvpAction': isMvpAction,
    'keywords': keywords,
    'scientificBasis': scientificBasis,
    'sourceLink': sourceLink,
    'stepByStepGuide': stepByStepGuide,
    'videoTutorialUrl': videoTutorialUrl,
    'imageUrl': imageUrl,
    'requiresProfessional': requiresProfessional,
    'safetyNote': safetyNote,
  };
}

// ── CompletedAction ───────────────────────────────────────────────────────────

class CompletedAction {
  final String? id;
  final String actionId;
  final DateTime completedAt;
  final double annualCo2eReductionKg;
  final String category;

  const CompletedAction({
    this.id,
    required this.actionId,
    required this.completedAt,
    required this.annualCo2eReductionKg,
    required this.category,
  });

  factory CompletedAction.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return CompletedAction(
      id: id,
      actionId: map['actionId'] as String? ?? '',
      category: map['category'] as String? ?? 'other',
      annualCo2eReductionKg:
          (map['annualCo2eReductionKg'] as num?)?.toDouble() ?? 0,
      completedAt: _dateTimeFromFirestore(map['completedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actionId': actionId,
      'category': category,
      'annualCo2eReductionKg': annualCo2eReductionKg,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }

  static DateTime _dateTimeFromFirestore(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}