import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../config/app_theme.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Recipe Icon/Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.surfaceDark),
                ),
                child: Center(
                  child: Text(
                    recipe.imageUrl,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Recipe Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: AppTheme.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.prepTime} min',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.local_fire_department, size: 16, color: AppTheme.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.calories} cal',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite Button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.accentGreen : AppTheme.textLight,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
