class UserPreferences {
  final String name;
  final String language; // 'en' or 'ko'
  final List<String> dietaryRestrictions; // ['halal', 'vegan', 'kosher', etc.]
  final List<String> allergens; // ['nuts', 'dairy', 'gluten', etc.]
  final bool darkMode;
  final bool notifications;

  UserPreferences({
    required this.name,
    required this.language,
    required this.dietaryRestrictions,
    required this.allergens,
    this.darkMode = false,
    this.notifications = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'language': language,
      'dietaryRestrictions': dietaryRestrictions,
      'allergens': allergens,
      'darkMode': darkMode,
      'notifications': notifications,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      name: json['name'] ?? '',
      language: json['language'] ?? 'en',
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
      darkMode: json['darkMode'] ?? false,
      notifications: json['notifications'] ?? true,
    );
  }

  UserPreferences copyWith({
    String? name,
    String? language,
    List<String>? dietaryRestrictions,
    List<String>? allergens,
    bool? darkMode,
    bool? notifications,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      language: language ?? this.language,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergens: allergens ?? this.allergens,
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
    );
  }

  static UserPreferences defaultPreferences() {
    return UserPreferences(
      name: 'Guest',
      language: 'en',
      dietaryRestrictions: [],
      allergens: [],
      darkMode: false,
      notifications: true,
    );
  }
}
