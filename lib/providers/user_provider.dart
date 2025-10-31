import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/user_preferences.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  UserPreferences _preferences = UserPreferences.defaultPreferences();
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  UserPreferences get preferences => _preferences;
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _currentUser?.name ?? _preferences.name;
  String get userEmail => _currentUser?.email ?? '';

  // Initialize and load saved data
  Future<void> initialize() async {
    await _loadUserSession();
  }

  // Load user session and preferences
  Future<void> _loadUserSession() async {
    try {
      // Check if user is logged in
      _isLoggedIn = await _authService.isLoggedIn();
      
      if (_isLoggedIn) {
        // Load current user
        _currentUser = await _authService.getCurrentUser();
        
        if (_currentUser != null) {
          // Load user preferences
          await _loadPreferences(_currentUser!.id);
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading user session: $e');
      _isLoggedIn = false;
      _currentUser = null;
      notifyListeners();
    }
  }

  // Load preferences for specific user
  Future<void> _loadPreferences(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = prefs.getString('user_preferences_$userId');

      if (prefsJson != null) {
        _preferences = UserPreferences.fromJson(jsonDecode(prefsJson));
      } else {
        // Initialize with user's name from account
        _preferences = UserPreferences(
          name: _currentUser?.name ?? 'User',
          language: 'en',
          dietaryRestrictions: [],
          allergens: [],
        );
        await _savePreferences();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  // Save preferences to local storage
  Future<void> _savePreferences() async {
    try {
      if (_currentUser == null) return;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'user_preferences_${_currentUser!.id}',
        jsonEncode(_preferences.toJson()),
      );
      notifyListeners();
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  // Register new user
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        
        // Initialize preferences with user's name
        _preferences = UserPreferences(
          name: name,
          language: 'en',
          dietaryRestrictions: [],
          allergens: [],
        );
        await _savePreferences();
        
        notifyListeners();
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  // Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        await _loadPreferences(user.id);
        notifyListeners();
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      if (_currentUser == null) return;

      final updatedUser = _currentUser!.copyWith(
        name: name,
        email: email,
      );

      final result = await _authService.updateUser(updatedUser);
      if (result != null) {
        _currentUser = result;
        
        // Update preferences name if changed
        if (name != null && name != _preferences.name) {
          _preferences = _preferences.copyWith(name: name);
          await _savePreferences();
        }
        
        notifyListeners();
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (_currentUser == null) return;

      await _authService.changePassword(
        userId: _currentUser!.id,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  // Update language
  Future<void> updateLanguage(String language) async {
    final updated = _preferences.copyWith(language: language);
    _preferences = updated;
    await _savePreferences();
  }

  // Update dietary restrictions
  Future<void> updateDietaryRestrictions(List<String> restrictions) async {
    final updated = _preferences.copyWith(dietaryRestrictions: restrictions);
    _preferences = updated;
    await _savePreferences();
  }

  // Update allergens
  Future<void> updateAllergens(List<String> allergens) async {
    final updated = _preferences.copyWith(allergens: allergens);
    _preferences = updated;
    await _savePreferences();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    final updated = _preferences.copyWith(darkMode: !_preferences.darkMode);
    _preferences = updated;
    await _savePreferences();
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    final updated = _preferences.copyWith(notifications: !_preferences.notifications);
    _preferences = updated;
    await _savePreferences();
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authService.logout();
      _isLoggedIn = false;
      _currentUser = null;
      _preferences = UserPreferences.defaultPreferences();
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      if (_currentUser == null) return;
      
      await _authService.deleteAccount(_currentUser!.id);
      _isLoggedIn = false;
      _currentUser = null;
      _preferences = UserPreferences.defaultPreferences();
      notifyListeners();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    try {
      await _authService.clearAllData();
      _isLoggedIn = false;
      _currentUser = null;
      _preferences = UserPreferences.defaultPreferences();
      notifyListeners();
    } catch (e) {
      print('Error clearing all data: $e');
      rethrow;
    }
  }
}
