import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.imageUrl),
            const SizedBox(height: 16),
            Text(recipe.description, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            const Text("Ingredients", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ...recipe.ingredients.map((ingredient) => Text("- $ingredient")),
            const SizedBox(height: 16),
            const Text("Instructions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ...recipe.instructions.map((instruction) => Text("- $instruction")),
          ],
        ),
      ),
    );
  }
}