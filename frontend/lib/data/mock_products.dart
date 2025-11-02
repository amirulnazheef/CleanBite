import '../models/product.dart';

class MockProducts {
  static List<Product> getAllProducts() {
    return [
      // 1. Shin Ramyun (신라면)
      Product(
        id: '1',
        barcode: '8801043010238',
        nameKorean: '신라면',
        nameEnglish: 'Shin Ramyun',
        brand: 'Nongshim',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '밀가루',
          '팜유',
          '감자전분',
          '소금',
          '쇠고기 추출물',
          '간장',
          '설탕',
          '고춧가루',
          '마늘',
          '양파',
        ],
        ingredientsEnglish: [
          'Wheat flour',
          'Palm oil',
          'Potato starch',
          'Salt',
          'Beef extract',
          'Soy sauce',
          'Sugar',
          'Red pepper powder',
          'Garlic',
          'Onion',
        ],
        isHalal: false,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        allergens: ['Wheat', 'Soy'],
        problematicIngredients: ['Beef extract'],
        explanation: 'Contains beef extract which is not suitable for Halal (unless certified), Vegan, or Vegetarian diets.',
      ),

      // 2. Choco Pie (초코파이)
      Product(
        id: '2',
        barcode: '8801062638444',
        nameKorean: '초코파이',
        nameEnglish: 'Choco Pie',
        brand: 'Orion',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '밀가루',
          '설탕',
          '식물성유지',
          '계란',
          '젤라틴',
          '코코아가루',
          '우유',
          '버터',
        ],
        ingredientsEnglish: [
          'Wheat flour',
          'Sugar',
          'Vegetable oil',
          'Eggs',
          'Gelatin',
          'Cocoa powder',
          'Milk',
          'Butter',
        ],
        isHalal: false,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        allergens: ['Wheat', 'Eggs', 'Dairy'],
        problematicIngredients: ['Gelatin', 'Eggs', 'Milk', 'Butter'],
        explanation: 'Contains gelatin (animal-sourced), eggs, and dairy products. Not suitable for Halal, Vegan, or Vegetarian diets.',
      ),

      // 3. Banana Milk (바나나맛 우유)
      Product(
        id: '3',
        barcode: '8801056082017',
        nameKorean: '바나나맛 우유',
        nameEnglish: 'Banana Milk',
        brand: 'Binggrae',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '우유',
          '설탕',
          '바나나 농축액',
          '향료',
          '비타민',
        ],
        ingredientsEnglish: [
          'Milk',
          'Sugar',
          'Banana concentrate',
          'Flavoring',
          'Vitamins',
        ],
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        allergens: ['Dairy'],
        problematicIngredients: ['Milk'],
        explanation: 'Contains dairy (milk). Suitable for Vegetarian and Halal diets, but not Vegan.',
      ),

      // 4. Kimchi (김치)
      Product(
        id: '4',
        barcode: '8809211340015',
        nameKorean: '김치',
        nameEnglish: 'Kimchi',
        brand: 'Jongga',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '배추',
          '무',
          '고춧가루',
          '마늘',
          '생강',
          '소금',
          '설탕',
          '멸치액젓',
        ],
        ingredientsEnglish: [
          'Napa cabbage',
          'Radish',
          'Red pepper powder',
          'Garlic',
          'Ginger',
          'Salt',
          'Sugar',
          'Anchovy fish sauce',
        ],
        isHalal: true,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        allergens: ['Fish'],
        problematicIngredients: ['Anchovy fish sauce'],
        explanation: 'Contains anchovy fish sauce. Not suitable for Vegan or Vegetarian diets. Halal if fish sauce is from halal-certified fish.',
      ),

      // 5. Seaweed Snack (김)
      Product(
        id: '5',
        barcode: '8801073110014',
        nameKorean: '구운김',
        nameEnglish: 'Roasted Seaweed',
        brand: 'Dongwon',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '김',
          '식용유',
          '소금',
        ],
        ingredientsEnglish: [
          'Seaweed',
          'Vegetable oil',
          'Salt',
        ],
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        allergens: [],
        problematicIngredients: [],
        explanation: 'Fully plant-based. Suitable for all dietary restrictions including Halal, Vegan, Vegetarian, and Kosher.',
      ),

      // 6. Honey Butter Chips (허니버터칩)
      Product(
        id: '6',
        barcode: '8801019606267',
        nameKorean: '허니버터칩',
        nameEnglish: 'Honey Butter Chips',
        brand: 'Haitai',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '감자',
          '식물성유지',
          '설탕',
          '꿀',
          '버터',
          '우유',
          '소금',
        ],
        ingredientsEnglish: [
          'Potato',
          'Vegetable oil',
          'Sugar',
          'Honey',
          'Butter',
          'Milk',
          'Salt',
        ],
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        allergens: ['Dairy'],
        problematicIngredients: ['Honey', 'Butter', 'Milk'],
        explanation: 'Contains honey and dairy products. Suitable for Vegetarian and Halal diets, but not Vegan (honey and dairy).',
      ),

      // 7. Bulgogi Sauce (불고기 양념)
      Product(
        id: '7',
        barcode: '8801007055015',
        nameKorean: '불고기 양념',
        nameEnglish: 'Bulgogi Marinade',
        brand: 'Sempio',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '간장',
          '설탕',
          '마늘',
          '배즙',
          '참기름',
          '후추',
          '쇠고기 추출물',
        ],
        ingredientsEnglish: [
          'Soy sauce',
          'Sugar',
          'Garlic',
          'Pear juice',
          'Sesame oil',
          'Black pepper',
          'Beef extract',
        ],
        isHalal: false,
        isVegan: false,
        isVegetarian: false,
        isKosher: false,
        allergens: ['Soy', 'Sesame'],
        problematicIngredients: ['Beef extract'],
        explanation: 'Contains beef extract. Not suitable for Halal (unless certified), Vegan, or Vegetarian diets.',
      ),

      // 8. Rice Cake (떡볶이 떡)
      Product(
        id: '8',
        barcode: '8809211340022',
        nameKorean: '떡볶이 떡',
        nameEnglish: 'Tteokbokki Rice Cake',
        brand: 'Pulmuone',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '쌀',
          '물',
          '소금',
        ],
        ingredientsEnglish: [
          'Rice',
          'Water',
          'Salt',
        ],
        isHalal: true,
        isVegan: true,
        isVegetarian: true,
        isKosher: true,
        allergens: [],
        problematicIngredients: [],
        explanation: 'Simple rice-based product. Suitable for all dietary restrictions including Halal, Vegan, Vegetarian, and Kosher.',
      ),

      // 9. Yakult (야쿠르트)
      Product(
        id: '9',
        barcode: '8801056010010',
        nameKorean: '야쿠르트',
        nameEnglish: 'Yakult',
        brand: 'Korea Yakult',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '물',
          '설탕',
          '탈지분유',
          '유산균',
          '향료',
        ],
        ingredientsEnglish: [
          'Water',
          'Sugar',
          'Skim milk powder',
          'Lactobacillus',
          'Flavoring',
        ],
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        allergens: ['Dairy'],
        problematicIngredients: ['Skim milk powder'],
        explanation: 'Contains dairy (skim milk powder). Suitable for Vegetarian and Halal diets, but not Vegan.',
      ),

      // 10. Pepero (빼빼로)
      Product(
        id: '10',
        barcode: '8801062638451',
        nameKorean: '빼빼로',
        nameEnglish: 'Pepero',
        brand: 'Lotte',
        imageUrl: 'https://via.placeholder.com/150',
        ingredientsKorean: [
          '밀가루',
          '설탕',
          '식물성유지',
          '코코아',
          '우유',
          '대두',
        ],
        ingredientsEnglish: [
          'Wheat flour',
          'Sugar',
          'Vegetable oil',
          'Cocoa',
          'Milk',
          'Soy',
        ],
        isHalal: true,
        isVegan: false,
        isVegetarian: true,
        isKosher: true,
        allergens: ['Wheat', 'Dairy', 'Soy'],
        problematicIngredients: ['Milk'],
        explanation: 'Contains dairy (milk). Suitable for Vegetarian and Halal diets, but not Vegan.',
      ),
    ];
  }

  static Product? getProductByBarcode(String barcode) {
    try {
      return getAllProducts().firstWhere((product) => product.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  static List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllProducts().where((product) {
      return product.nameEnglish.toLowerCase().contains(lowerQuery) ||
          product.nameKorean.contains(query) ||
          product.brand.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
