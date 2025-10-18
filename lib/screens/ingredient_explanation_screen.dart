import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../data/ingredient_database.dart';

class IngredientExplanationScreen extends StatelessWidget {
  const IngredientExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    String ingredientName = '';
    
    if (args is String) {
      ingredientName = args;
    }

    final ingredient = IngredientDatabase.getIngredientByName(ingredientName);

    if (ingredient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ingredient Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Ingredient "$ingredientName" not found',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ingredient Name
            Text(
              ingredient.nameEnglish,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ingredient.nameKorean,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(ingredient.description),
                  const SizedBox(height: 8),
                  Text(
                    'Source: ${ingredient.source}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dietary Classifications
            const Text(
              'Dietary Classifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildClassificationCard(
              'Halal Status',
              ingredient.halalStatus.toUpperCase(),
              ingredient.isHalal,
              _getHalalStatusColor(ingredient.halalStatus),
            ),
            const SizedBox(height: 12),
            
            _buildClassificationCard(
              'Vegan',
              ingredient.isVegan ? 'SUITABLE' : 'NOT SUITABLE',
              ingredient.isVegan,
              ingredient.isVegan ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            
            _buildClassificationCard(
              'Vegetarian',
              ingredient.isVegetarian ? 'SUITABLE' : 'NOT SUITABLE',
              ingredient.isVegetarian,
              ingredient.isVegetarian ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            
            _buildClassificationCard(
              'Kosher',
              ingredient.isKosher ? 'SUITABLE' : 'NOT SUITABLE',
              ingredient.isKosher,
              ingredient.isKosher ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 24),

            // Allergen Information
            if (ingredient.allergens.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Allergen Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Contains: ${ingredient.allergens.join(", ")}'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Reason/Explanation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Why This Classification?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(ingredient.reason),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to watchlist')),
                      );
                    },
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('Add to Watchlist'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Correction submitted')),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Suggest Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationCard(String title, String status, bool isCompliant, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isCompliant ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHalalStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'halal':
        return Colors.green;
      case 'haram':
        return Colors.red;
      case 'doubtful':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
