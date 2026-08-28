/// One measured ingredient used in a recipe.
class RecipeIngredient {
  /// Ingredient name, such as `brown lentils`.
  final String name;

  /// Numeric amount, if the ingredient has a measurable quantity.
  final double? amount;

  /// Unit for the amount, such as `cups`, `tbsp`, or `cloves`.
  final String unit;

  /// Optional preparation detail, such as `chopped` or `rinsed`.
  final String? preparation;

  const RecipeIngredient({
    required this.name,
    this.amount,
    this.unit = '',
    this.preparation,
  });

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      name: map['name'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble(),
      unit: map['unit'] as String? ?? '',
      preparation: map['preparation'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
      'preparation': preparation,
    };
  }
}

/// One recipe instruction, optionally linked to ingredient positions.
class RecipeInstruction {
  /// The instruction shown to the user.
  final String instruction;

  /// Ingredient indexes referenced by this instruction.
  final List<int> ingredientIndices;

  const RecipeInstruction({
    required this.instruction,
    this.ingredientIndices = const [],
  });

  factory RecipeInstruction.fromMap(Map<String, dynamic> map) {
    final rawIndices = map['ingredientIndices'];

    final indices = rawIndices is List
        ? rawIndices
          .whereType<num>()
          .map((index) => index.toInt())
          .toList(growable: false)
        : const <int>[];

    final singleIndex = (map['ingredient_index'] as num?)?.toInt();

    if (singleIndex != null && !indices.contains(singleIndex)) {
      indices.add(singleIndex);
    }

    return RecipeInstruction(
      instruction: map['instruction'] as String? ?? '',
      ingredientIndices: indices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instruction': instruction,
      'ingredient_indices': ingredientIndices,
    };
  }
}

/// Nutritional information for one recipe serving.
class RecipeNutrition {
  final double? calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;

  const RecipeNutrition({
    this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
  });

  factory RecipeNutrition.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const RecipeNutrition();
    }

    return RecipeNutrition(
      calories: (map['calories'] as num?)?.toDouble(),
      proteinGrams: (map['proteinGrams'] as num?)?.toDouble(),
      carbsGrams: (map['carbsGrams'] as num?)?.toDouble(),
      fatGrams: (map['fatGrams'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
    };
  }
}

/// Climate-impact information for one recipe serving.
///
/// Actual recipe emissions and estimated avoided emissions are intentionally
/// stored separately to avoid treating a comparison estimate as a measurement.
class RecipeClimateImpact {
  /// Estimated lifecycle emissions of this recipe per serving, if available.
  final double? co2eKgPerServing;

  /// Estimated reduction compared with the listed comparison baseline.
  final double? estimatedReductionKgPerServing;

  /// Description of the meal used as the comparison baseline.
  final String? comparisonBaseline;

  /// Estimated water savings compared with the comparison baseline.
  final double? waterSavedGallonsPerServing;

  /// Estimated food waste diverted per serving, if applicable.
  final double? wasteDivertedKgPerServing;

  const RecipeClimateImpact({
    this.co2eKgPerServing,
    this.estimatedReductionKgPerServing,
    this.comparisonBaseline,
    this.waterSavedGallonsPerServing,
    this.wasteDivertedKgPerServing,
  });

  factory RecipeClimateImpact.fromMap(
    Map<String, dynamic>? map,
  ) {
    if (map == null) {
      return const RecipeClimateImpact();
    }

    return RecipeClimateImpact(
      co2eKgPerServing: (map['co2eKgPerServing'] as num?)?.toDouble(),
      estimatedReductionKgPerServing:
          (map['co2eReductionPerServingKg'] as num?)?.toDouble(),
      comparisonBaseline: map['comparisonBaseline'] as String?,
      waterSavedGallonsPerServing:
          (map['waterSavedPerServingGallons'] as num?)?.toDouble(),
      wasteDivertedKgPerServing: (map['wasteDivertedPerServingKg'] as num?)
          ?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'co2eKgPerServing': co2eKgPerServing,
      'co2eReductionPerServingKg': estimatedReductionKgPerServing,
      'comparisonBaseline': comparisonBaseline,
      'waterSavedPerServingGallons': waterSavedGallonsPerServing,
      'wasteDivertedPerServingKg': wasteDivertedKgPerServing,
    };
  }
}

class Recipe {
  /// Stable recipe identifier. Use the Firestore document ID when available.
  final String id;

  final String title;
  final String description;
  final String imageUrl;

  final List<String> mealTypes;
  final List<String> categories;
  final List<String> dietTypes;
  final List<String> allergens;

  final String difficulty;
  final int prepTimeMinutes;
  final int totalTimeMinutes;
  final int servings;
  final String costEstimate;
  final double? estimatedCostUsdTotal;
  final double? estimatedCostUsdPerServing;
  final bool isMvpRecipe;
  final String? videoTutorialUrl;

  final List<RecipeIngredient> ingredientDetails;
  final List<RecipeInstruction> instructionSteps;
  final RecipeNutrition nutrition;
  final RecipeClimateImpact climateImpact;

  Recipe({
    this.id = '',
    required this.title,
    required this.description,
    required this.imageUrl,

    // These preserve compatibility with your current sample meal-plan code.
    List<String> ingredients = const [],
    List<String> instructions = const [],

    this.mealTypes = const [],
    this.categories = const [],
    this.dietTypes = const [],
    this.allergens = const [],
    this.difficulty = 'Easy',
    this.prepTimeMinutes = 0,
    this.totalTimeMinutes = 0,
    this.servings = 1,
    this.costEstimate = '',
    this.estimatedCostUsdTotal,
    this.estimatedCostUsdPerServing,
    this.isMvpRecipe = false,
    this.videoTutorialUrl,
    List<RecipeIngredient>? ingredientDetails,
    List<RecipeInstruction>? instructionSteps,
    this.nutrition = const RecipeNutrition(),
    this.climateImpact = const RecipeClimateImpact(),
  }) : ingredientDetails =
           ingredientDetails ??
           ingredients
               .map((ingredient) => RecipeIngredient(name: ingredient))
               .toList(),
       instructionSteps =
           instructionSteps ??
           instructions
               .map(
                 (instruction) => RecipeInstruction(instruction: instruction),
               )
               .toList();

  /// Existing screens can continue using `recipe.ingredients`.
  List<String> get ingredients {
    return ingredientDetails.map((ingredient) {
      final amount = ingredient.amount;

      final quantity = amount == null
          ? ''
          : amount == amount.roundToDouble()
          ? amount.toInt().toString()
          : amount.toString();

      return [
        quantity,
        ingredient.unit,
        ingredient.name,
        if (ingredient.preparation != null &&
            ingredient.preparation!.isNotEmpty)
          '(${ingredient.preparation})',
      ].where((part) => part.isNotEmpty).join(' ');
    }).toList();
  }

  /// Existing screens can continue using `recipe.instructions`.
  List<String> get instructions {
    return instructionSteps.map((step) => step.instruction).toList();
  }

  static Map<String, dynamic>? _mapOrNull(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  bool get hasCostEstimate {
    return estimatedCostUsdTotal != null &&
        estimatedCostUsdTotal! >= 0 &&
        servings > 0;
  }

  double? get effectiveCostPerServing {
    if (estimatedCostUsdPerServing != null) {
      return estimatedCostUsdPerServing;
    }

    if (!hasCostEstimate) {
      return null;
    }

    return estimatedCostUsdTotal! / servings;
  }

  int get effectiveTotalTimeMinutes {
    if (totalTimeMinutes > 0) {
      return totalTimeMinutes;
    }

    return prepTimeMinutes;
  }

  factory Recipe.fromMap(Map<String, dynamic> map, {String id = ''}) {
    final rawIngredients = map['ingredients'];
    final rawInstructions = map['stepByStepGuide'];

    final ingredients = rawIngredients is List
        ? rawIngredients
              .whereType<Map>()
              .map(
                (item) =>
                    RecipeIngredient.fromMap(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <RecipeIngredient>[];

    final instructions = rawInstructions is List
        ? rawInstructions
              .whereType<Map>()
              .map(
                (item) =>
                    RecipeInstruction.fromMap(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <RecipeInstruction>[];

    return Recipe(
      id: id,
      title: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      mealTypes: List<String>.from(
        map['mealType'] as List? ?? const [],
      ),
      categories: List<String>.from(
        map['category'] as List? ?? const [],
      ),
      dietTypes: List<String>.from(
        map['dietType'] as List? ?? const [],
      ),
      allergens: List<String>.from(
        map['allergens'] as List? ?? const [],
        ),
      difficulty: map['difficulty'] as String? ?? 'Easy',
      prepTimeMinutes: 
        (map['prepTimeMinutes'] as num?)?.toInt() ?? 0,
      totalTimeMinutes: 
        (map['totalTimeMinutes'] as num?)?.toInt() ?? 0,
      servings: (map['servings'] as num?)?.toInt() ?? 1,
      costEstimate: map['costEstimate'] as String? ?? '',
      estimatedCostUsdTotal: 
        (map['estimatedCostUsdTotal'] as num?)?.toDouble(),
      estimatedCostUsdPerServing: 
        (map['estimatedCostUsdPerServing'] as num?)?.toDouble(),
      isMvpRecipe: map['isMvpRecipe'] as bool? ?? false,
      videoTutorialUrl: map['videoTutorialUrl'] as String?,
      ingredientDetails: ingredients,
      instructionSteps: instructions,
      nutrition: RecipeNutrition.fromMap(
        _mapOrNull(map['nutritionalInfo']),
      ),
      climateImpact: RecipeClimateImpact.fromMap(
        _mapOrNull(map['impactScore']),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'description': description,
      'imageUrl': imageUrl,
      'mealType': mealTypes,
      'category': categories,
      'dietType': dietTypes,
      'allergens': allergens,
      'difficulty': difficulty,
      'prepTimeMinutes': prepTimeMinutes,
      'totalTimeMinutes': totalTimeMinutes,
      'servings': servings,
      'costEstimate': costEstimate,
      'estimatedCostUsdTotal': estimatedCostUsdTotal,
      'estimatedCostUsdPerServing': estimatedCostUsdPerServing,
      'isMvpRecipe': isMvpRecipe,
      'videoTutorialUrl': videoTutorialUrl,
      'ingredients': ingredientDetails
          .map((ingredient) => ingredient.toMap())
          .toList(),
      'stepByStepGuide': instructionSteps
          .map((instruction) => instruction.toMap())
          .toList(),
      'nutritionalInfo': nutrition.toMap(),
      'impactScore': climateImpact.toMap(),
    };
  }
}
