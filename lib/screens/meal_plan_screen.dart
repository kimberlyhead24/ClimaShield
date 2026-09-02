import 'package:flutter/material.dart';

import '../data/recipe_repository.dart';
import '../data/repository.dart';

import '../models/weekly_meal_plan.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';


class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  WeeklyMealPlan? _plan;
  List<String> _warnings = const [];
  final Map<String, Recipe> _recipesById = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentWeek();
  }

  Future<void> _loadCurrentWeek() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _warnings = const [];
    });

    try {
      final repository = ClimaRepository.instance;
      final now = DateTime.now();

      final recipes = await RecipeRepository.instance.loadAllRecipes();

      final savedPlan = await repository.loadWeeklyMealPlan(date: now);

      if (savedPlan != null) {
        if (!mounted) {
          return;
        }

        setState(() {
          _plan = savedPlan;
          _recipesById
            ..clear()
            ..addEntries(recipes.map((recipe) => MapEntry(recipe.id, recipe)));
          _isLoading = false;
        });
        return;
      }

      final result = await repository.generateWeeklyMealPlan(
        recipes: recipes,
        date: now,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _plan = result.plan;
        _warnings = result.warnings;
        _recipesById
          ..clear()
          ..addEntries(recipes.map((recipe) => MapEntry(recipe.id, recipe)));
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = _friendlyErrorMessage(error);
      });
    }
  }

  String _friendlyErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('Complete the diet quiz')) {
      return 'Complete the diet quiz before creating your weekly plan.';
    }

    if (message.contains('No signed-in Firebase user')) {
      return 'Please sign in to create and save a meal plan.';
    }

    return 'We could not load your weekly meal plan. Please try again.';
  }

  Future<void> _openRecipe(PlannedMeal plannedMeal) async {
    try {
      final recipe = await RecipeRepository.instance.loadRecipeById(
        plannedMeal.recipeId,
      );

      if (!mounted) {
        return;
      }

      if (recipe == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This recipe is no longer available.')),
        );
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeDetailScreen(
            recipe: recipe,
            plannedForDate: plannedMeal.plannedForDate,
          ),
        ),
      );

      if (mounted) {
        await _loadCurrentWeek();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We could not open this recipe. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Diet')),
        body: _PlannerErrorState(
          message: _errorMessage!,
          onRetry: _loadCurrentWeek,
        ),
      );
    }

    final plan = _plan;

    if (plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Diet')),
        body: _PlannerErrorState(
          message: 'No weekly plan is available yet.',
          onRetry: _loadCurrentWeek,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Diet'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _loadCurrentWeek,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _WeekHeader(plan: plan),
            const SizedBox(height: 16),
            _PlanSummary(plan: plan),
            if (plan.isOverBudget) ...[
              const SizedBox(height: 12),
              _BudgetWarning(plan: plan),
            ],
            if (_warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              _PlanWarnings(warnings: _warnings),
            ],
            const SizedBox(height: 24),
            ...List.generate(7, (dayOffset) {
              final date = plan.weekStart.add(Duration(days: dayOffset));

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _DayPlanCard(
                  date: date,
                  meals: plan.mealsForDay(date),
                  onMealPressed: _openRecipe,
                ),
              );
            }),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Grocery-list meal selection is the next feature.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Generate grocery list'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  final WeeklyMealPlan plan;

  const _WeekHeader({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_monthName(plan.weekStart.month)} '
          '${plan.weekStart.day} – '
          '${_monthName(plan.weekEnd.month)} '
          '${plan.weekEnd.day}',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          'Your personalized climate-friendly meal plan',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}

class _PlanSummary extends StatelessWidget {
  final WeeklyMealPlan plan;

  const _PlanSummary({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                icon: Icons.payments_outlined,
                label: 'Estimated weekly cost',
                value: '\$${plan.estimatedWeeklyCostUsd.toStringAsFixed(0)}',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryTile(
                icon: Icons.eco_outlined,
                label: 'Estimated CO₂e saved',
                value: '${plan.estimatedWeeklyCo2eReductionKg.toStringAsFixed(1)} kg',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryTile(
                icon: Icons.water_drop_outlined,
                label: 'Estimated water saved',
                value: '${plan.estimatedWeeklyWaterSavedGallons.toStringAsFixed(0)} gal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'These are planning estimates compared with your '
          'average baseline developed from your onboarding quiz. '
          'Savings count toward your dashboard only after you log a meal. ',
          style: TextStyle(fontSize: 12, height: 1.35, color: Colors.black54),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF74A97D).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF197602), size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _BudgetWarning extends StatelessWidget {
  final WeeklyMealPlan plan;

  const _BudgetWarning({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF28A16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFF28A16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This week is estimated to be \$'
              '${plan.budgetOverageUsd.toStringAsFixed(0)} over your '
              'selected budget. You can still use the plan and adjust '
              'individual meals as needed.',
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanWarnings extends StatelessWidget {
  final List<String> warnings;

  const _PlanWarnings({required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFF9A6A00)),
              SizedBox(width: 8),
              Text(
                'Some meals need attention',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...warnings.map(
            (warning) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• $warning'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPlanCard extends StatelessWidget {
  final DateTime date;
  final List<PlannedMeal> meals;
  final ValueChanged<PlannedMeal> onMealPressed;

  const _DayPlanCard({
    required this.date,
    required this.meals,
    required this.onMealPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              '${_weekdayName(date.weekday)} · '
              '${_monthName(date.month)} ${date.day}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          for (final slot in MealSlot.values)
            _MealSlotRow(
              slot: slot,
              meal: _mealForSlot(meals, slot),
              onPressed: onMealPressed,
            ),
        ],
      ),
    );
  }

  PlannedMeal? _mealForSlot(List<PlannedMeal> meals, MealSlot slot) {
    for (final meal in meals) {
      if (meal.mealSlot == slot) {
        return meal;
      }
    }

    return null;
  }
}

class _MealSlotRow extends StatelessWidget {
  final MealSlot slot;
  final PlannedMeal? meal;
  final ValueChanged<PlannedMeal> onPressed;

  const _MealSlotRow({
    required this.slot,
    required this.meal,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final plannedMeal = meal;

    return InkWell(
      onTap: plannedMeal == null ? null : () => onPressed(plannedMeal),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          children: [
            Icon(_slotIcon(slot), color: const Color(0xFF197602), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: plannedMeal == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _slotLabel(slot),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'No eligible meal available',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _slotLabel(slot),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plannedMeal.recipeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${plannedMeal.estimatedCo2eReductionKg.toStringAsFixed(1)} kg '
                          'CO₂e forecast · \$'
                          '${plannedMeal.estimatedCostUsd.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF477451),
                          ),
                        ),
                        if (plannedMeal.rankingReasons.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            plannedMeal.rankingReasons.first,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
            if (plannedMeal != null)
              const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _PlannerErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _PlannerErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Color(0xFF5F6E63),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return months[month - 1];
}

String _weekdayName(int weekday) {
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  return weekdays[weekday - DateTime.monday];
}

String _slotLabel(MealSlot slot) {
  return switch (slot) {
    MealSlot.breakfast => 'Breakfast',
    MealSlot.lunch => 'Lunch',
    MealSlot.dinner => 'Dinner',
  };
}

IconData _slotIcon(MealSlot slot) {
  return switch (slot) {
    MealSlot.breakfast => Icons.wb_sunny_outlined,
    MealSlot.lunch => Icons.restaurant_outlined,
    MealSlot.dinner => Icons.nightlight_outlined,
  };
}
