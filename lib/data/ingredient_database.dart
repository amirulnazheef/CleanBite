import '../models/ingredient.dart';

class IngredientDatabase {
  static List<Ingredient> getAllIngredients() {
    return [
      // Animal-based ingredients
      Ingredient(
        id: '1',
        nameKorean: '젤라틴',
        nameEnglish: 'Gelatin',
        isHalal: false,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        halalStatus: 'haram',
        allergens: [],
        description: 'Protein derived from animal collagen',
        source: 'Usually from pork, beef, or fish',
        reason: 'Animal-sourced ingredient. Not suitable for vegetarian, vegan, or halal diets unless specifically certified.',
      ),
      Ingredient(
        id: '2',
        nameKorean: '돼지고기',
        nameEnglish: 'Pork',
        isHalal: false,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        halalStatus: 'haram',
        allergens: [],
        description: 'Meat from pigs',
        source: 'Pork',
        reason: 'Prohibited in Halal and Kosher diets. Not suitable for vegetarian or vegan diets.',
      ),
      Ingredient(
        id: '3',
        nameKorean: '쇠고기 추출물',
        nameEnglish: 'Beef extract',
        isHalal: false,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        halalStatus: 'doubtful',
        allergens: [],
        description: 'Concentrated beef flavoring',
        source: 'Beef',
        reason: 'Animal-sourced. Not halal unless from halal-certified beef. Not suitable for vegetarian or vegan diets.',
      ),
      Ingredient(
        id: '4',
        nameKorean: '알코올',
        nameEnglish: 'Alcohol',
        isHalal: false,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'haram',
        allergens: [],
        description: 'Ethanol or ethyl alcohol',
        source: 'Fermentation',
        reason: 'Prohibited in Halal diet. May be acceptable in small amounts for flavoring in some interpretations.',
      ),

      // Dairy products
      Ingredient(
        id: '5',
        nameKorean: '우유',
        nameEnglish: 'Milk',
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Dairy'],
        description: 'Liquid produced by mammals',
        source: 'Cow, goat, or other mammals',
        reason: 'Dairy product. Not suitable for vegan diets. Contains lactose allergen.',
      ),
      Ingredient(
        id: '6',
        nameKorean: '버터',
        nameEnglish: 'Butter',
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Dairy'],
        description: 'Dairy product made from milk fat',
        source: 'Milk',
        reason: 'Dairy product. Not suitable for vegan diets. Contains lactose allergen.',
      ),
      Ingredient(
        id: '7',
        nameKorean: '탈지분유',
        nameEnglish: 'Skim milk powder',
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Dairy'],
        description: 'Dried milk with fat removed',
        source: 'Milk',
        reason: 'Dairy product. Not suitable for vegan diets. Contains lactose allergen.',
      ),

      // Eggs
      Ingredient(
        id: '8',
        nameKorean: '계란',
        nameEnglish: 'Eggs',
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Eggs'],
        description: 'Chicken eggs',
        source: 'Chickens',
        reason: 'Animal product. Not suitable for vegan diets. Common allergen.',
      ),

      // Fish and seafood
      Ingredient(
        id: '9',
        nameKorean: '멸치액젓',
        nameEnglish: 'Anchovy fish sauce',
        isHalal: true,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        halalStatus: 'halal',
        allergens: ['Fish'],
        description: 'Fermented fish sauce',
        source: 'Anchovies',
        reason: 'Fish-based product. Not suitable for vegetarian or vegan diets. Contains fish allergen.',
      ),

      // Honey
      Ingredient(
        id: '10',
        nameKorean: '꿀',
        nameEnglish: 'Honey',
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: [],
        description: 'Sweet substance made by bees',
        source: 'Bees',
        reason: 'Animal product (bee-produced). Not suitable for strict vegan diets.',
      ),

      // Allergens
      Ingredient(
        id: '11',
        nameKorean: '땅콩',
        nameEnglish: 'Peanuts',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Nuts'],
        description: 'Legume commonly used as a nut',
        source: 'Plant',
        reason: 'Common allergen. Suitable for all diets but may cause severe allergic reactions.',
      ),
      Ingredient(
        id: '12',
        nameKorean: '대두',
        nameEnglish: 'Soy',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Soy'],
        description: 'Soybeans and soy products',
        source: 'Plant',
        reason: 'Common allergen. Suitable for all diets.',
      ),
      Ingredient(
        id: '13',
        nameKorean: '밀가루',
        nameEnglish: 'Wheat flour',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: ['Wheat', 'Gluten'],
        description: 'Flour made from wheat',
        source: 'Plant',
        reason: 'Contains gluten. Common allergen. Suitable for all diets except gluten-free.',
      ),

      // Plant-based ingredients
      Ingredient(
        id: '14',
        nameKorean: '쌀',
        nameEnglish: 'Rice',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: [],
        description: 'Grain staple',
        source: 'Plant',
        reason: 'Plant-based. Suitable for all dietary restrictions.',
      ),
      Ingredient(
        id: '15',
        nameKorean: '김',
        nameEnglish: 'Seaweed',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: [],
        description: 'Edible sea vegetable',
        source: 'Sea plant',
        reason: 'Plant-based. Suitable for all dietary restrictions.',
      ),
      Ingredient(
        id: '16',
        nameKorean: '감자',
        nameEnglish: 'Potato',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: [],
        description: 'Root vegetable',
        source: 'Plant',
        reason: 'Plant-based. Suitable for all dietary restrictions.',
      ),
      Ingredient(
        id: '17',
        nameKorean: '설탕',
        nameEnglish: 'Sugar',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: [],
        description: 'Sweet carbohydrate',
        source: 'Plant (sugarcane or beet)',
        reason: 'Plant-based. Suitable for all dietary restrictions.',
      ),
      Ingredient(
        id: '18',
        nameKorean: '소금',
        nameEnglish: 'Salt',
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        halalStatus: 'halal',
        allergens: [],
        description: 'Sodium chloride',
        source: 'Mineral',
        reason: 'Mineral. Suitable for all dietary restrictions.',
      ),
    ];
  }

  static Ingredient? getIngredientByName(String name) {
    final lowerName = name.toLowerCase();
    try {
      return getAllIngredients().firstWhere(
        (ingredient) =>
            ingredient.nameEnglish.toLowerCase() == lowerName ||
            ingredient.nameKorean == name,
      );
    } catch (e) {
      return null;
    }
  }

  static List<Ingredient> searchIngredients(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllIngredients().where((ingredient) {
      return ingredient.nameEnglish.toLowerCase().contains(lowerQuery) ||
          ingredient.nameKorean.contains(query);
    }).toList();
  }
}
