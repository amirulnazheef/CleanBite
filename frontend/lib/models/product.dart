class Product {
  final String id;
  final String barcode;
  final String nameKorean;
  final String nameEnglish;
  final String brand;
  final String imageUrl;
  final List<String> ingredientsKorean;
  final List<String> ingredientsEnglish;
  final bool isHalal;
  final bool isVegan;
  final bool isVegetarian;
  final bool isKosher;
  final List<String> allergens;
  final List<String> problematicIngredients;
  final String explanation;
  final List<dynamic>? ingredientDetails; // [{name: "flour", vegan: true, ...}]
  final List<dynamic>? allergenDetails;
  final String? friendlySummary; // "This product is vegetarian friendly"

  Product({
    required this.id,
    required this.barcode,
    required this.nameKorean,
    required this.nameEnglish,
    required this.brand,
    required this.imageUrl,
    required this.ingredientsKorean,
    required this.ingredientsEnglish,
    required this.isHalal,
    required this.isVegan,
    required this.isVegetarian,
    required this.isKosher,
    required this.allergens,
    required this.problematicIngredients,
    required this.explanation,
    this.ingredientDetails,
    this.allergenDetails,
    this.friendlySummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'nameKorean': nameKorean,
      'nameEnglish': nameEnglish,
      'brand': brand,
      'imageUrl': imageUrl,
      'ingredientsKorean': ingredientsKorean,
      'ingredientsEnglish': ingredientsEnglish,
      'isHalal': isHalal,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isKosher': isKosher,
      'allergens': allergens,
      'problematicIngredients': problematicIngredients,
      'explanation': explanation,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      barcode: json['barcode'],
      nameKorean: json['nameKorean'],
      nameEnglish: json['nameEnglish'],
      brand: json['brand'],
      imageUrl: json['imageUrl'],
      ingredientsKorean: List<String>.from(json['ingredientsKorean']),
      ingredientsEnglish: List<String>.from(json['ingredientsEnglish']),
      isHalal: json['isHalal'],
      isVegan: json['isVegan'],
      isVegetarian: json['isVegetarian'],
      isKosher: json['isKosher'],
      allergens: List<String>.from(json['allergens']),
      problematicIngredients: List<String>.from(json['problematicIngredients']),
      explanation: json['explanation'],
    );
  }
}
