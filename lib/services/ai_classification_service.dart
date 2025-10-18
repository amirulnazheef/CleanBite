import '../data/ingredient_database.dart';
import '../models/ingredient.dart';

class AIClassificationService {
  // Classify ingredients based on dietary rules
  Future<Map<String, dynamic>> classifyIngredients(List<String> ingredients) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 800));

    bool isHalal = true;
    bool isVegan = true;
    bool isVegetarian = true;
    bool isKosher = true;
    List<String> allergens = [];
    List<String> problematicIngredients = [];
    List<String> reasons = [];

    for (String ingredientName in ingredients) {
      final ingredient = IngredientDatabase.getIngredientByName(ingredientName);
      
      if (ingredient != null) {
        // Check dietary classifications
        if (!ingredient.isHalal) {
          isHalal = false;
          problematicIngredients.add(ingredientName);
          reasons.add('$ingredientName: ${ingredient.reason}');
        }
        
        if (!ingredient.isVegan) {
          isVegan = false;
          if (!problematicIngredients.contains(ingredientName)) {
            problematicIngredients.add(ingredientName);
          }
        }
        
        if (!ingredient.isVegetarian) {
          isVegetarian = false;
          if (!problematicIngredients.contains(ingredientName)) {
            problematicIngredients.add(ingredientName);
          }
        }
        
        if (!ingredient.isKosher) {
          isKosher = false;
        }
        
        // Collect allergens
        for (String allergen in ingredient.allergens) {
          if (!allergens.contains(allergen)) {
            allergens.add(allergen);
          }
        }
      } else {
        // Unknown ingredient - apply conservative classification
        // Check for common keywords
        final lowerName = ingredientName.toLowerCase();
        
        if (_containsAnimalKeywords(lowerName)) {
          isVegan = false;
          isVegetarian = false;
          problematicIngredients.add(ingredientName);
          reasons.add('$ingredientName: May contain animal-derived ingredients');
        }
        
        if (_containsPorkKeywords(lowerName)) {
          isHalal = false;
          isKosher = false;
          problematicIngredients.add(ingredientName);
          reasons.add('$ingredientName: Contains pork or pork derivatives');
        }
        
        if (_containsAlcoholKeywords(lowerName)) {
          isHalal = false;
          problematicIngredients.add(ingredientName);
          reasons.add('$ingredientName: Contains alcohol');
        }
      }
    }

    // Generate explanation
    String explanation = _generateExplanation(
      isHalal,
      isVegan,
      isVegetarian,
      isKosher,
      problematicIngredients,
      allergens,
    );

    return {
      'isHalal': isHalal,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isKosher': isKosher,
      'allergens': allergens,
      'problematicIngredients': problematicIngredients,
      'explanation': explanation,
      'reasons': reasons,
    };
  }

  // Check for animal-related keywords
  bool _containsAnimalKeywords(String text) {
    final animalKeywords = [
      'meat', 'beef', 'pork', 'chicken', 'fish', 'gelatin', 'lard',
      'tallow', 'rennet', 'whey', 'casein', 'lactose', 'egg', 'honey',
      '고기', '쇠고기', '돼지고기', '닭고기', '생선', '젤라틴', '계란', '꿀'
    ];
    
    return animalKeywords.any((keyword) => text.contains(keyword));
  }

  // Check for pork-related keywords
  bool _containsPorkKeywords(String text) {
    final porkKeywords = [
      'pork', 'bacon', 'ham', 'lard', 'pig',
      '돼지', '돼지고기', '베이컨', '햄'
    ];
    
    return porkKeywords.any((keyword) => text.contains(keyword));
  }

  // Check for alcohol-related keywords
  bool _containsAlcoholKeywords(String text) {
    final alcoholKeywords = [
      'alcohol', 'ethanol', 'wine', 'beer', 'liquor',
      '알코올', '에탄올', '술', '맥주', '소주'
    ];
    
    return alcoholKeywords.any((keyword) => text.contains(keyword));
  }

  // Generate human-readable explanation
  String _generateExplanation(
    bool isHalal,
    bool isVegan,
    bool isVegetarian,
    bool isKosher,
    List<String> problematicIngredients,
    List<String> allergens,
  ) {
    List<String> issues = [];

    if (!isHalal) {
      issues.add('not Halal');
    }
    if (!isVegan) {
      issues.add('not Vegan');
    }
    if (!isVegetarian) {
      issues.add('not Vegetarian');
    }
    if (!isKosher) {
      issues.add('not Kosher');
    }

    if (issues.isEmpty && allergens.isEmpty) {
      return 'This product is suitable for all dietary restrictions including Halal, Vegan, Vegetarian, and Kosher diets.';
    }

    String explanation = '';

    if (problematicIngredients.isNotEmpty) {
      explanation += 'Contains: ${problematicIngredients.join(", ")}. ';
    }

    if (issues.isNotEmpty) {
      explanation += 'This product is ${issues.join(", ")}. ';
    }

    if (allergens.isNotEmpty) {
      explanation += 'Allergen warning: Contains ${allergens.join(", ")}.';
    }

    return explanation.trim();
  }

  // Classify a single ingredient
  Future<Map<String, dynamic>> classifySingleIngredient(String ingredientName) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final ingredient = IngredientDatabase.getIngredientByName(ingredientName);

    if (ingredient != null) {
      return {
        'found': true,
        'ingredient': ingredient.toJson(),
      };
    }

    return {
      'found': false,
      'message': 'Ingredient not found in database',
    };
  }
}
