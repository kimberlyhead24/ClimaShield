import '../models/recipe_model.dart';

class RecipeScaling {
  const RecipeScaling._();

  static double scaleFactor({
    required int originalServings,
    required int targetServings,
  }) {
    final safeOriginal = originalServings < 1 ? 1 : originalServings;
    final safeTarget = targetServings < 1 ? 1 : targetServings;

    return safeTarget / safeOriginal;
  }

  static RecipeIngredient scaleIngredient(
    RecipeIngredient ingredient, {
    required int originalServings,
    required int targetServings,
  }) {
    final amount = ingredient.amount;

    if (amount == null) {
      return ingredient;
    }

    final factor = scaleFactor(
      originalServings: originalServings,
      targetServings: targetServings,
    );

    return RecipeIngredient(
      name: ingredient.name,
      amount: amount * factor,
      unit: ingredient.unit,
      preparation: ingredient.preparation,
    );
  }

  static List<RecipeIngredient> scaleIngredients(
    List<RecipeIngredient> ingredients, {
    required int originalServings,
    required int targetServings,
  }) {
    return ingredients
        .map(
          (ingredient) => scaleIngredient(
            ingredient,
            originalServings: originalServings,
            targetServings: targetServings,
          ),
        )
        .toList(growable: false);
  }
}

class RecipeQuantityFormatter {
  const RecipeQuantityFormatter._();

  static const double _epsilon = 0.0001;

  static String format(RecipeIngredient ingredient) {
    final normalizedUnit = _normalizeUnit(ingredient.unit);
    final converted = _convert(amount: ingredient.amount, unit: normalizedUnit);

    final amount = converted.amount;
    final unit = converted.unit;

    if (amount == null) {
      final suffix = unit.isEmpty ? '' : ' ($unit)';
      final preparation = _formatPreparation(ingredient.preparation);

      return '${ingredient.name}$suffix$preparation';
    }

    final quantity = formatNumber(amount);
    final parts = <String>[
      quantity,
      if (unit.isNotEmpty) unit,
      ingredient.name,
    ];

    return '${parts.join(' ')}${_formatPreparation(ingredient.preparation)}';
  }

  static String formatNumber(double value) {
    if (value.abs() < _epsilon) {
      return '0';
    }

    final whole = value.truncate();
    final fraction = value - whole;

    const fractions = <_Fraction>[
      _Fraction(0, ''),
      _Fraction(1 / 8, '⅛'),
      _Fraction(1 / 6, '⅙'),
      _Fraction(1 / 4, '¼'),
      _Fraction(1 / 3, '⅓'),
      _Fraction(3 / 8, '⅜'),
      _Fraction(1 / 2, '½'),
      _Fraction(5 / 8, '⅝'),
      _Fraction(2 / 3, '⅔'),
      _Fraction(3 / 4, '¾'),
      _Fraction(5 / 6, '⅚'),
      _Fraction(7 / 8, '⅞'),
      _Fraction(1, ''),
    ];

    final bestMatch = fractions.reduce(
      (best, candidate) =>
          (fraction - candidate.value).abs() < (fraction - best.value).abs()
          ? candidate
          : best,
    );

    if (bestMatch.value == 1) {
      return (whole + 1).toString();
    }

    if (bestMatch.value == 0) {
      return whole.toString();
    }

    if (whole == 0) {
      return bestMatch.symbol;
    }

    return '$whole${bestMatch.symbol}';
  }

  static _ConvertedQuantity _convert({
    required double? amount,
    required String unit,
  }) {
    if (amount == null) {
      return _ConvertedQuantity(amount: null, unit: unit);
    }

    if (unit == 'tsp' && _isWholeMultiple(amount, 3)) {
      return _ConvertedQuantity(amount: amount / 3, unit: 'tbsp');
    }

    if (unit == 'tbsp' && _isCleanCupFraction(amount / 16)) {
      return _ConvertedQuantity(amount: amount / 16, unit: 'cup');
    }

    return _ConvertedQuantity(amount: amount, unit: unit);
  }

  static bool _isWholeMultiple(double value, int divisor) {
    final quotient = value / divisor;
    return (quotient - quotient.roundToDouble()).abs() < _epsilon;
  }

  static bool _isCleanCupFraction(double cups) {
    const cleanFractions = <double>[
      0.125,
      0.25,
      1 / 3,
      0.375,
      0.5,
      0.625,
      2 / 3,
      0.75,
      0.875,
      1.0,
      1.25,
      1.5,
      1.75,
      2.0,
    ];

    return cleanFractions.any((fraction) => (cups - fraction).abs() < _epsilon);
  }

  static String _normalizeUnit(String unit) {
    final value = unit.trim().toLowerCase();

    switch (value) {
      case 'teaspoon':
      case 'teaspoons':
      case 'tsp.':
        return 'tsp';
      case 'tablespoon':
      case 'tablespoons':
      case 'tbl':
      case 'tbls':
      case 'tbsp.':
        return 'tbsp';
      case 'cup':
      case 'cups':
        return 'cup';
      default:
        return unit.trim();
    }
  }

  static String _formatPreparation(String? preparation) {
    if (preparation == null || preparation.trim().isEmpty) {
      return '';
    }

    return ' (${preparation.trim()})';
  }
}

class _ConvertedQuantity {
  final double? amount;
  final String unit;

  const _ConvertedQuantity({required this.amount, required this.unit});
}

class _Fraction {
  final double value;
  final String symbol;

  const _Fraction(this.value, this.symbol);
}
