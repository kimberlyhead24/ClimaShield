class Recipe {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });
}
