import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';

class UserProvider with ChangeNotifier {
  UserPreferences _preferences = UserPreferences.defaultPreferences();
  bool _isLoggedIn = false;

  UserPreferences get preferences => _preferences;
  bool get isLoggedIn => _isLoggedIn;

  // Initialize and load saved preferences
  Future<void> initialize() async {
    await loadPreferences();
  }

  // Load preferences from local storage
  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = prefs.getString('user_preferences');
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (prefsJson != null) {
        _preferences = UserPreferences.fromJson(jsonDecode(prefsJson));
      }
      _isLoggedIn = isLoggedIn;
      notifyListeners();
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  // Save preferences to local storage
  Future<void> savePreferences(UserPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_preferences', jsonEncode(preferences.toJson()));
      _preferences = preferences;
      notifyListeners();
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  // Update user name
  Future<void> updateName(String name) async {
    final updated = _preferences.copyWith(name: name);
    await savePreferences(updated);
  }

  // Update language
  Future<void> updateLanguage(String language) async {
    final updated = _preferences.copyWith(language: language);
    await savePreferences(updated);
  }

  // Update dietary restrictions
  Future<void> updateDietaryRestrictions(List<String> restrictions) async {
    final updated = _preferences.copyWith(dietaryRestrictions: restrictions);
    await savePreferences(updated);
  }

  // Update allergens
  Future<void> updateAllergens(List<String> allergens) async {
    final updated = _preferences.copyWith(allergens: allergens);
    await savePreferences(updated);
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    final updated = _preferences.copyWith(darkMode: !_preferences.darkMode);
    await savePreferences(updated);
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    final updated = _preferences.copyWith(notifications: !_preferences.notifications);
    await savePreferences(updated);
  }

  // Login
  Future<void> login(UserPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await savePreferences(preferences);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Error during login: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      _isLoggedIn = false;
      _preferences = UserPreferences.defaultPreferences();
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _isLoggedIn = false;
      _preferences = UserPreferences.defaultPreferences();
      notifyListeners();
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}
