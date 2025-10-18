class Ingredient {
  final String id;
  final String nameKorean;
  final String nameEnglish;
  final bool isHalal;
  final bool isVegan;
  final bool isVegetarian;
  final bool isKosher;
  final String halalStatus; // 'halal', 'haram', 'doubtful'
  final List<String> allergens;
  final String description;
  final String source;
  final String reason;

  Ingredient({
    required this.id,
    required this.nameKorean,
    required this.nameEnglish,
    required this.isHalal,
    required this.isVegan,
    required this.isVegetarian,
    required this.isKosher,
    required this.halalStatus,
    required this.allergens,
    required this.description,
    required this.source,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKorean': nameKorean,
      'nameEnglish': nameEnglish,
      'isHalal': isHalal,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isKosher': isKosher,
      'halalStatus': halalStatus,
      'allergens': allergens,
      'description': description,
      'source': source,
      'reason': reason,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      nameKorean: json['nameKorean'],
      nameEnglish: json['nameEnglish'],
      isHalal: json['isHalal'],
      isVegan: json['isVegan'],
      isVegetarian: json['isVegetarian'],
      isKosher: json['isKosher'],
      halalStatus: json['halalStatus'],
      allergens: List<String>.from(json['allergens']),
      description: json['description'],
      source: json['source'],
      reason: json['reason'],
    );
  }
}
