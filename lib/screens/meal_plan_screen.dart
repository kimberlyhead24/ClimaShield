import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../data/meal_plan_data.dart'; // Import your sample data
import 'recipe_detail_screen.dart'; // We will create this next

class MealPlanScreen extends StatelessWidget {
  final String dietGenre;

  const MealPlanScreen({super.key, required this.dietGenre});

  @override
  Widget build(BuildContext context) {
    // For now, we use the sample data. Later, you'll fetch data based on the dietGenre.
    final mealPlan = sampleMealPlan;

    return Scaffold(
      appBar: AppBar(title: Text("$dietGenre Meal Plan")),
      body: ListView(
        children: [
          _buildMealCard(context, "Breakfast", mealPlan.breakfast),
          _buildMealCard(context, "Lunch", mealPlan.lunch),
          _buildMealCard(context, "Dinner", mealPlan.dinner),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String mealType, Recipe recipe) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(recipe.imageUrl, width: 100, fit: BoxFit.cover),
        title: Text(mealType),
        subtitle: Text(recipe.title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)),
          );
        },
      ),
    );
  }
}