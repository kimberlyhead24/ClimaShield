// In a new file: data/meal_plan_data.dart
import '../models/recipe_model.dart';
import '../models/meal_plan_model.dart';

// Sample recipes (you'll have more of these)
final Recipe sampleRecipe1 = Recipe(
    title: "Lentil Soup",
    description: "A hearty and healthy soup.",
    imageUrl: "https://storage.googleapis.com/climateshield-app-assets/lentil_soup.jpg",
    ingredients: ["1 cup lentils", "4 cups vegetable broth"],
    instructions: ["Combine and simmer for 25 minutes."]);

final Recipe sampleRecipe2 = Recipe(
    title: "Black Bean Burger",
    description: "A delicious and satisfying burger.",
    imageUrl: "https://storage.googleapis.com/climateshield-app-assets/bean_burger.jpg",
    ingredients: ["1 can black beans", "1/2 cup breadcrumbs"],
    instructions: ["Mash beans, form patties, and cook."]);

// Sample meal plan for one day
final MealPlan sampleMealPlan = MealPlan(
  day: "Monday",
  breakfast: sampleRecipe1,
  lunch: sampleRecipe2,
  dinner: sampleRecipe1,
);