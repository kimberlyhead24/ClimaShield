import 'package:flutter/material.dart';

import '../data/recipe_repository.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class MealPlanScreen extends StatefulWidget {
  final String dietGenre;

  const MealPlanScreen({super.key, this.dietGenre = 'Recipe ideas'});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  List<Recipe> _recipes = const [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final recipes = await RecipeRepository.instance.loadAllRecipes();

      if (!mounted) return;

      setState(() {
        _recipes = recipes;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage = 'Recipes could not be loaded:\n$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dietGenre)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _ErrorState(message: _errorMessage!, onRetry: _loadRecipes)
          : _recipes.isEmpty
          ? _EmptyState(onRetry: _loadRecipes)
          : RefreshIndicator(
              onRefresh: _loadRecipes,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _recipes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];

                  return _RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final labels = [
      if (recipe.mealTypes.isNotEmpty) recipe.mealTypes.first,
      if (recipe.prepTimeMinutes > 0) '${recipe.prepTimeMinutes} min prep',
      if (recipe.dietTypes.isNotEmpty) recipe.dietTypes.first,
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RecipeImage(imageUrl: recipe.imageUrl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (labels.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: labels
                            .map(
                              (label) => Chip(
                                label: Text(label),
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  final String imageUrl;

  const _RecipeImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasUsableImage =
        imageUrl.isNotEmpty &&
        imageUrl != 'PLACEHOLDER_IMAGE_URL' &&
        imageUrl.startsWith('http');

    if (!hasUsableImage) {
      return Container(
        width: 112,
        height: 150,
        color: Colors.green.shade100,
        child: const Icon(Icons.restaurant_menu, color: Colors.green, size: 36),
      );
    }

    return Image.network(
      imageUrl,
      width: 112,
      height: 150,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          width: 112,
          height: 150,
          color: Colors.green.shade100,
          child: const Icon(
            Icons.restaurant_menu,
            color: Colors.green,
            size: 36,
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              'No recipes found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check that recipes exist in Firestore and that you are signed in.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
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
