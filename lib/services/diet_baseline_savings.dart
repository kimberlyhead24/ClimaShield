class DietBaselineSavings {
  const DietBaselineSavings._();

  static double annualHouseholdServings({
    required int totalMealsEatenPerWeek,
    required int householdSize,
  }) {
    final safeMealsPerWeek = totalMealsEatenPerWeek < 1
        ? 0
        : totalMealsEatenPerWeek;

    final safeHouseholdSize = householdSize < 1 ? 1 : householdSize;

    return (safeMealsPerWeek * 52 * safeHouseholdSize).toDouble();
  }

  static double baselineCo2eKgPerServing({
    required double annualDietCo2eKg,
    required int totalMealsEatenPerWeek,
    required int householdSize,
  }) {
    final servings = annualHouseholdServings(
      totalMealsEatenPerWeek: totalMealsEatenPerWeek,
      householdSize: householdSize,
    );

    if (annualDietCo2eKg <= 0 || servings <= 0) {
      return 0;
    }

    return annualDietCo2eKg / servings;
  }

  static int creditableServings({
    required int servingsLogged,
    required int householdSize,
  }) {
    final safeServingsLogged = servingsLogged < 0 ? 0 : servingsLogged;
    final safeHouseholdSize = householdSize < 1 ? 1 : householdSize;

    return safeServingsLogged > safeHouseholdSize
        ? safeHouseholdSize
        : safeServingsLogged;
  }

  static double estimatedCo2eSavingsKg({
    required double baselineCo2eKgPerServing,
    required double recipeCo2eKgPerServing,
    required int servingsLogged,
    required int householdSize,
  }) {
    final perServingSavings = baselineCo2eKgPerServing - recipeCo2eKgPerServing;

    if (perServingSavings <= 0) {
      return 0;
    }

    final servings = creditableServings(
      servingsLogged: servingsLogged,
      householdSize: householdSize,
    );

    return perServingSavings * servings;
  }
}
