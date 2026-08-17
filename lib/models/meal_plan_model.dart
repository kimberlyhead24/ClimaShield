import 'recipe_model.dart';

class MealPlan {
  final String day; // e.g., "Monday"
  final Recipe breakfast;
  final Recipe lunch;
  final Recipe dinner;

  MealPlan({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}
