import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/recipe_model.dart';
import '../utils/recipe_scaling.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final DateTime? plannedForDate;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    this.plannedForDate,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _plannedYield;
  late int _servingsEaten;
  bool _loggingMeal = false;
  bool _mealLogged = false;

  Recipe get recipe => widget.recipe;

  @override
  void initState() {
    super.initState();
    _plannedYield = recipe.servings > 0 ? recipe.servings : 1;
    _servingsEaten = 1;
  }

  bool get _hasUsableImage {
    return recipe.imageUrl.isNotEmpty &&
        recipe.imageUrl != 'PLACEHOLDER_IMAGE_URL' &&
        recipe.imageUrl.startsWith('http');
  }

  double? get _savingsPerServing {
    return recipe.climateImpact.estimatedReductionKgPerServing;
  }

  double get _plannedBatchSavings {
    return (_savingsPerServing ?? 0) * _plannedYield;
  }

  double get _loggedMealSavings {
    return (_savingsPerServing ?? 0) * _servingsEaten;
  }

  List<RecipeIngredient> get _scaledIngredients {
    return RecipeScaling.scaleIngredients(
      recipe.ingredientDetails,
      originalServings: recipe.servings,
      targetServings: _plannedYield,
    );
  }

  bool get _hasNutrition {
    final nutrition = recipe.nutrition;

    return nutrition.calories != null ||
        nutrition.proteinGrams != null ||
        nutrition.carbsGrams != null ||
        nutrition.fatGrams != null;
  }

  String _renderInstruction(RecipeInstruction step) {
    var nextIngredientPosition = 0;

    return step.instruction.replaceAllMapped(
      RegExp(r'\{ingredient(?:\.name)?\}'),
      (_) {
        if (nextIngredientPosition >= step.ingredientIndices.length) {
          return 'the ingredient';
        }

        final ingredientIndex = step.ingredientIndices[nextIngredientPosition];
        nextIngredientPosition += 1;

        if (ingredientIndex < 0 ||
            ingredientIndex >= recipe.ingredientDetails.length) {
          return 'the ingredient';
        }

        return recipe.ingredientDetails[ingredientIndex].name;
      },
    );
  }

  void _changePlannedYield(int nextValue) {
    final safeYield = nextValue < 1 ? 1 : nextValue;

    setState(() {
      _plannedYield = safeYield;

      if (_servingsEaten > _plannedYield) {
        _servingsEaten = _plannedYield;
      }

      _mealLogged = false;
    });
  }

  void _changeServingsEaten(int nextValue) {
    final safeServings = nextValue.clamp(1, _plannedYield);

    setState(() {
      _servingsEaten = safeServings;
      _mealLogged = false;
    });
  }

  Future<void> _logMeal() async {
    if (_loggingMeal || _mealLogged) {
      return;
    }

    setState(() {
      _loggingMeal = true;
    });

    try {
      await ClimaRepository.instance.logRecipeMeal(
        recipe,
        servings: _servingsEaten,
        plannedForDate: widget.plannedForDate,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _mealLogged = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Meal logged. Your personalized estimated diet impact '
            'will appear on the dashboard.',
          ),
        ),
      );
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message.toString())));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We could not log this meal. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loggingMeal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final metadata = [
      if (recipe.mealTypes.isNotEmpty) recipe.mealTypes.first,
      if (recipe.effectiveTotalTimeMinutes > 0)
        '${recipe.effectiveTotalTimeMinutes} min total',
      if (recipe.difficulty.isNotEmpty) recipe.difficulty,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RecipeHero(
                imageUrl: recipe.imageUrl,
                hasUsableImage: _hasUsableImage,
              ),
              const SizedBox(height: 16),
              if (metadata.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: metadata
                      .map(
                        (item) => Chip(
                          label: Text(item),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              if (metadata.isNotEmpty) const SizedBox(height: 16),
              Text(
                recipe.description,
                style: const TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              _YieldSelector(
                label: 'Servings to make',
                servings: _plannedYield,
                onDecrease: _plannedYield > 1
                    ? () => _changePlannedYield(_plannedYield - 1)
                    : null,
                onIncrease: () => _changePlannedYield(_plannedYield + 1),
                decreaseTooltip: 'Decrease servings to make',
                increaseTooltip: 'Increase servings to make',
              ),

              const SizedBox(height: 16),

              if (_savingsPerServing != null) ...[
                _ImpactCard(
                  comparisonBaseline: recipe.climateImpact.comparisonBaseline,
                  savingsPerServing: _savingsPerServing!,
                  plannedYield: _plannedYield,
                  plannedBatchSavings: _plannedBatchSavings,
                  servingsEaten: _servingsEaten,
                  loggedMealSavings: _loggedMealSavings,
                ),
                const SizedBox(height: 16),
              ],

              if (_hasNutrition) ...[
                _NutritionCard(nutrition: recipe.nutrition),
                const SizedBox(height: 24),
              ],

              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ..._scaledIngredients.map(
                (ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• ${RecipeQuantityFormatter.format(ingredient)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Instructions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ...recipe.instructionSteps.asMap().entries.map((entry) {
                final stepNumber = entry.key + 1;
                final instruction = _renderInstruction(entry.value);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        child: Text(
                          '$stepNumber',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          instruction,
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              if (recipe.allergens.isNotEmpty) ...[
                const Text(
                  'Allergens',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recipe.allergens
                      .map(
                        (allergen) => Chip(
                          avatar: const Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                          ),
                          label: Text(allergen),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],

              _YieldSelector(
                label: 'Servings eaten',
                servings: _servingsEaten,
                onDecrease: _servingsEaten > 1
                    ? () => _changeServingsEaten(_servingsEaten - 1)
                    : null,
                onIncrease: _servingsEaten < _plannedYield
                    ? () => _changeServingsEaten(_servingsEaten + 1)
                    : null,
                decreaseTooltip: 'Decrease servings eaten',
                increaseTooltip: 'Increase servings eaten',
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loggingMeal || _mealLogged ? null : _logMeal,
                  icon: _loggingMeal
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _mealLogged
                              ? Icons.check_circle_outline
                              : Icons.restaurant,
                        ),
                  label: Text(
                    _mealLogged
                        ? 'Meal logged'
                        : _loggingMeal
                        ? 'Logging meal...'
                        : 'Log meal',
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Logging compares this recipe with your household\'s average '
                'diet baseline and credits up to your household size.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeHero extends StatelessWidget {
  final String imageUrl;
  final bool hasUsableImage;

  const _RecipeHero({required this.imageUrl, required this.hasUsableImage});

  @override
  Widget build(BuildContext context) {
    if (!hasUsableImage) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.restaurant_menu, size: 64, color: Colors.green),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, _, _) {
            return Container(
              color: Colors.green.shade100,
              child: const Center(
                child: Icon(
                  Icons.restaurant_menu,
                  size: 64,
                  color: Colors.green,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _YieldSelector extends StatelessWidget {
  final String label;
  final int servings;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final String decreaseTooltip;
  final String increaseTooltip;

  const _YieldSelector({
    required this.label,
    required this.servings,
    required this.onDecrease,
    required this.onIncrease,
    required this.decreaseTooltip,
    required this.increaseTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onDecrease,
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: decreaseTooltip,
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$servings',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: onIncrease,
          icon: const Icon(Icons.add_circle_outline),
          tooltip: increaseTooltip,
        ),
      ],
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final String? comparisonBaseline;
  final double savingsPerServing;
  final int plannedYield;
  final double plannedBatchSavings;
  final int servingsEaten;
  final double loggedMealSavings;

  const _ImpactCard({
    required this.comparisonBaseline,
    required this.savingsPerServing,
    required this.plannedYield,
    required this.plannedBatchSavings,
    required this.servingsEaten,
    required this.loggedMealSavings,
  });

  @override
  Widget build(BuildContext context) {
    final baseline = comparisonBaseline ?? 'the listed comparison meal';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.eco_outlined, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recipe climate information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${savingsPerServing.toStringAsFixed(1)} kg CO₂e per serving '
            'compared with $baseline.',
          ),
          const SizedBox(height: 6),
          Text(
            'Making $plannedYield serving${plannedYield == 1 ? '' : 's'} '
            'could save ${plannedBatchSavings.toStringAsFixed(1)} kg CO₂e.',
          ),
          const SizedBox(height: 6),
          Text(
            'Logging $servingsEaten serving${servingsEaten == 1 ? '' : 's'} '
            'will record ${loggedMealSavings.toStringAsFixed(1)} kg CO₂e.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final RecipeNutrition nutrition;

  const _NutritionCard({required this.nutrition});

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_dining_outlined, color: Color(0xFF197602)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nutrition per serving',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (nutrition.calories != null)
                _NutritionMetric(
                  label: 'Calories',
                  value: _formatNumber(nutrition.calories!),
                  unit: 'kcal',
                ),
              if (nutrition.proteinGrams != null)
                _NutritionMetric(
                  label: 'Protein',
                  value: _formatNumber(nutrition.proteinGrams!),
                  unit: 'g',
                ),
              if (nutrition.carbsGrams != null)
                _NutritionMetric(
                  label: 'Carbs',
                  value: _formatNumber(nutrition.carbsGrams!),
                  unit: 'g',
                ),
              if (nutrition.fatGrams != null)
                _NutritionMetric(
                  label: 'Fat',
                  value: _formatNumber(nutrition.fatGrams!),
                  unit: 'g',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutritionMetric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _NutritionMetric({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value $unit',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
