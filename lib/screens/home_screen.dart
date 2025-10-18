import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../data/sample_data.dart';
import '../widgets/category_chip.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Set<String> favoriteRecipeIds;
  final Function(String) onFavoriteToggle;

  const HomeScreen({
    super.key,
    required this.favoriteRecipeIds,
    required this.onFavoriteToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Recipe> allRecipes = [];
  List<Recipe> filteredRecipes = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    categories = SampleData.getCategories();
    allRecipes = SampleData.getRecipes();
    filteredRecipes = allRecipes;
  }

  void _filterByCategory(String? categoryName) {
    setState(() {
      selectedCategory = categoryName;
      if (categoryName == null) {
        filteredRecipes = allRecipes;
      } else {
        filteredRecipes = allRecipes
            .where((recipe) => recipe.category == categoryName)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    'CleanBite',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Healthy recipes for a better you',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Categories
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryChip(
                    category: Category(
                      id: 'all',
                      name: 'All',
                      icon: '🍴',
                      color: '4CAF50',
                    ),
                    isSelected: selectedCategory == null,
                    onTap: () => _filterByCategory(null),
                  ),
                  ...categories.map((category) => CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category.name,
                        onTap: () => _filterByCategory(category.name),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Recipe Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${filteredRecipes.length} ${filteredRecipes.length == 1 ? 'Recipe' : 'Recipes'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Recipes List
            Expanded(
              child: filteredRecipes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recipes found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          isFavorite: widget.favoriteRecipeIds.contains(recipe.id),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipe: recipe,
                                  isFavorite: widget.favoriteRecipeIds.contains(recipe.id),
                                  onFavoriteToggle: () => widget.onFavoriteToggle(recipe.id),
                                ),
                              ),
                            );
                          },
                          onFavoriteToggle: () => widget.onFavoriteToggle(recipe.id),
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
