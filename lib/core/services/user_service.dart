import 'package:flutter/foundation.dart';

/// User model
class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String password; // In production, this would be hashed
  final String? photoUrl;
  final DietaryPreferences dietaryPreferences;
  final Set<String> allergens;
  final List<String> customAllergens;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.password,
    this.photoUrl,
    DietaryPreferences? dietaryPreferences,
    Set<String>? allergens,
    List<String>? customAllergens,
  })  : dietaryPreferences = dietaryPreferences ?? DietaryPreferences(),
        allergens = allergens ?? {},
        customAllergens = customAllergens ?? [];

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? password,
    String? photoUrl,
    DietaryPreferences? dietaryPreferences,
    Set<String>? allergens,
    List<String>? customAllergens,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      photoUrl: photoUrl ?? this.photoUrl,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergens: allergens ?? this.allergens,
      customAllergens: customAllergens ?? this.customAllergens,
    );
  }
}

/// Dietary Preferences model
class DietaryPreferences {
  final bool halal;
  final bool kosher;
  final bool vegan;
  final bool vegetarian;
  final bool strictHalal;
  final bool gelatinAllowed;
  final bool alcoholFlavorsAllowed;

  DietaryPreferences({
    this.halal = false,
    this.kosher = false,
    this.vegan = false,
    this.vegetarian = false,
    this.strictHalal = true,
    this.gelatinAllowed = false,
    this.alcoholFlavorsAllowed = false,
  });

  DietaryPreferences copyWith({
    bool? halal,
    bool? kosher,
    bool? vegan,
    bool? vegetarian,
    bool? strictHalal,
    bool? gelatinAllowed,
    bool? alcoholFlavorsAllowed,
  }) {
    return DietaryPreferences(
      halal: halal ?? this.halal,
      kosher: kosher ?? this.kosher,
      vegan: vegan ?? this.vegan,
      vegetarian: vegetarian ?? this.vegetarian,
      strictHalal: strictHalal ?? this.strictHalal,
      gelatinAllowed: gelatinAllowed ?? this.gelatinAllowed,
      alcoholFlavorsAllowed: alcoholFlavorsAllowed ?? this.alcoholFlavorsAllowed,
    );
  }
}

/// Scan History Item
class ScanHistoryItem {
  final String id;
  final String productName;
  final String classification;
  final DateTime scanDate;
  final int ingredientCount;
  final String? imageUrl;

  ScanHistoryItem({
    required this.id,
    required this.productName,
    required this.classification,
    required this.scanDate,
    required this.ingredientCount,
    this.imageUrl,
  });
}

/// Authentication result
class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult({required this.success, this.errorMessage});
}

/// User Service - manages user state and authentication
class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Registered users database (in production, this would be server-side)
  final Map<String, UserModel> _registeredUsers = {};
  
  UserModel? _currentUser;
  final List<ScanHistoryItem> _scanHistory = [];
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  List<ScanHistoryItem> get scanHistory => List.unmodifiable(_scanHistory);

  /// Check if email is already registered
  bool isEmailRegistered(String email) {
    return _registeredUsers.containsKey(email.toLowerCase().trim());
  }

  /// Sign up a new user
  Future<AuthResult> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final normalizedEmail = email.toLowerCase().trim();

    // Check if email already exists
    if (_registeredUsers.containsKey(normalizedEmail)) {
      return AuthResult(
        success: false,
        errorMessage: 'An account with this email already exists',
      );
    }

    // Create new user
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      displayName: displayName.trim(),
      email: normalizedEmail,
      password: password, // In production, hash this!
    );

    // Store in database
    _registeredUsers[normalizedEmail] = newUser;
    
    // Log them in
    _currentUser = newUser;
    _isLoggedIn = true;
    notifyListeners();
    
    return AuthResult(success: true);
  }

  /// Login user - MUST be registered first
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final normalizedEmail = email.toLowerCase().trim();

    // Check if user exists
    final user = _registeredUsers[normalizedEmail];
    if (user == null) {
      return AuthResult(
        success: false,
        errorMessage: 'No account found with this email. Please sign up first.',
      );
    }

    // Verify password
    if (user.password != password) {
      return AuthResult(
        success: false,
        errorMessage: 'Incorrect password. Please try again.',
      );
    }

    // Login successful
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
    
    return AuthResult(success: true);
  }

  /// Logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Update profile
  Future<bool> updateProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return false;

    await Future.delayed(const Duration(milliseconds: 500));

    final oldEmail = _currentUser!.email;
    final newEmail = email?.toLowerCase().trim() ?? oldEmail;

    // If changing email, check if new email is available
    if (newEmail != oldEmail && _registeredUsers.containsKey(newEmail)) {
      return false; // Email already taken
    }

    // Update user
    _currentUser = _currentUser!.copyWith(
      displayName: displayName?.trim(),
      email: newEmail,
      photoUrl: photoUrl,
    );

    // Update in database
    if (newEmail != oldEmail) {
      _registeredUsers.remove(oldEmail);
    }
    _registeredUsers[newEmail] = _currentUser!;
    
    notifyListeners();
    return true;
  }

  /// Update password with verification
  Future<AuthResult> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        errorMessage: 'Not logged in',
      );
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Verify current password
    if (_currentUser!.password != currentPassword) {
      return AuthResult(
        success: false,
        errorMessage: 'Current password is incorrect',
      );
    }

    // Validate new password
    if (newPassword.length < 6) {
      return AuthResult(
        success: false,
        errorMessage: 'New password must be at least 6 characters',
      );
    }

    if (newPassword == currentPassword) {
      return AuthResult(
        success: false,
        errorMessage: 'New password must be different from current password',
      );
    }

    // Update password
    _currentUser = _currentUser!.copyWith(password: newPassword);
    _registeredUsers[_currentUser!.email] = _currentUser!;
    
    notifyListeners();
    return AuthResult(success: true);
  }

  /// Update dietary preferences
  Future<bool> updateDietaryPreferences(DietaryPreferences preferences) async {
    if (_currentUser == null) return false;

    await Future.delayed(const Duration(milliseconds: 300));

    _currentUser = _currentUser!.copyWith(
      dietaryPreferences: preferences,
    );
    _registeredUsers[_currentUser!.email] = _currentUser!;
    
    notifyListeners();
    return true;
  }

  /// Update allergens
  Future<bool> updateAllergens({
    required Set<String> allergens,
    required List<String> customAllergens,
  }) async {
    if (_currentUser == null) return false;

    await Future.delayed(const Duration(milliseconds: 300));

    _currentUser = _currentUser!.copyWith(
      allergens: allergens,
      customAllergens: customAllergens,
    );
    _registeredUsers[_currentUser!.email] = _currentUser!;
    
    notifyListeners();
    return true;
  }

  /// Add scan to history
  void addScanToHistory(ScanHistoryItem item) {
    _scanHistory.insert(0, item);
    notifyListeners();
  }

  /// Clear scan history
  void clearScanHistory() {
    _scanHistory.clear();
    notifyListeners();
  }
}
