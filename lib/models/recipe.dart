class Recipe {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime;
  final int calories;
  final String imageUrl;
  final List<String> tags;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.calories,
    required this.imageUrl,
    required this.tags,
  });
}
