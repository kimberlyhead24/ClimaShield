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
    final rawIndices = map['ingredient_indices'];

    final indices = rawIndices is List
        ? rawIndices.whereType<num>().map((index) => index.toInt()).toList()
        : <int>[];

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
      proteinGrams: (map['protein_grams'] as num?)?.toDouble(),
      carbsGrams: (map['carbs_grams'] as num?)?.toDouble(),
      fatGrams: (map['fat_grams'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'protein_grams': proteinGrams,
      'carbs_grams': carbsGrams,
      'fat_grams': fatGrams,
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

  factory RecipeClimateImpact.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const RecipeClimateImpact();
    }

    return RecipeClimateImpact(
      co2eKgPerServing: (map['co2e_kg_per_serving'] as num?)?.toDouble(),
      estimatedReductionKgPerServing:
          (map['co2e_reduction_per_serving_kg'] as num?)?.toDouble(),
      comparisonBaseline: map['comparison_baseline'] as String?,
      waterSavedGallonsPerServing:
          (map['water_saved_per_serving_gallons'] as num?)?.toDouble(),
      wasteDivertedKgPerServing: (map['waste_diverted_per_serving_kg'] as num?)
          ?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'co2e_kg_per_serving': co2eKgPerServing,
      'co2e_reduction_per_serving_kg': estimatedReductionKgPerServing,
      'comparison_baseline': comparisonBaseline,
      'water_saved_per_serving_gallons': waterSavedGallonsPerServing,
      'waste_diverted_per_serving_kg': wasteDivertedKgPerServing,
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
  final int servings;
  final String costEstimate;
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
    this.servings = 1,
    this.costEstimate = '',
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

  factory Recipe.fromMap(Map<String, dynamic> map, {String id = ''}) {
    final rawIngredients = map['ingredients'];
    final rawInstructions = map['step_by_step_guide'];

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
      title: map['name'] as String? ?? map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      mealTypes: List<String>.from(map['meal_type'] as List? ?? const []),
      categories: List<String>.from(map['category'] as List? ?? const []),
      dietTypes: List<String>.from(map['diet_type'] as List? ?? const []),
      allergens: List<String>.from(map['allergens'] as List? ?? const []),
      difficulty: map['difficulty'] as String? ?? 'Easy',
      prepTimeMinutes: (map['prep_time_minutes'] as num?)?.toInt() ?? 0,
      servings: (map['servings'] as num?)?.toInt() ?? 1,
      costEstimate: map['cost_estimate'] as String? ?? '',
      isMvpRecipe: map['is_mvp_recipe'] as bool? ?? false,
      videoTutorialUrl: map['video_tutorial_url'] as String?,
      ingredientDetails: ingredients,
      instructionSteps: instructions,
      nutrition: RecipeNutrition.fromMap(_mapOrNull(map['nutritional_info'])),
      climateImpact: RecipeClimateImpact.fromMap(
        _mapOrNull(map['impact_score']),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'description': description,
      'image_url': imageUrl,
      'meal_type': mealTypes,
      'category': categories,
      'diet_type': dietTypes,
      'allergens': allergens,
      'difficulty': difficulty,
      'prep_time_minutes': prepTimeMinutes,
      'servings': servings,
      'cost_estimate': costEstimate,
      'is_mvp_recipe': isMvpRecipe,
      'video_tutorial_url': videoTutorialUrl,
      'ingredients': ingredientDetails
          .map((ingredient) => ingredient.toMap())
          .toList(),
      'step_by_step_guide': instructionSteps
          .map((instruction) => instruction.toMap())
          .toList(),
      'nutritional_info': nutrition.toMap(),
      'impact_score': climateImpact.toMap(),
    };
  }
}
