import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favoriteRecipeIds;
  final Function(String) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favoriteRecipeIds,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final allRecipes = SampleData.getRecipes();
    final favoriteRecipes = allRecipes
        .where((recipe) => favoriteRecipeIds.contains(recipe.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your saved recipes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Recipe Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${favoriteRecipes.length} ${favoriteRecipes.length == 1 ? 'Recipe' : 'Recipes'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Favorites List
            Expanded(
              child: favoriteRecipes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start adding recipes to your favorites!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = favoriteRecipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          isFavorite: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipe: recipe,
                                  isFavorite: true,
                                  onFavoriteToggle: () => onFavoriteToggle(recipe.id),
                                ),
                              ),
                            );
                          },
                          onFavoriteToggle: () => onFavoriteToggle(recipe.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
