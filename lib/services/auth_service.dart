import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Authentication Service
/// Handles user registration, login, and credential management
class AuthService {
  static const String _usersDbKey = 'users_db';
  static const String _currentUserIdKey = 'current_user_id';

  /// Hash a password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Get all users from storage
  Future<Map<String, User>> _getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersDbKey);
      
      if (usersJson == null || usersJson.isEmpty) {
        return {};
      }

      final Map<String, dynamic> usersMap = jsonDecode(usersJson);
      return usersMap.map(
        (key, value) => MapEntry(key, User.fromJson(value as Map<String, dynamic>)),
      );
    } catch (e) {
      print('Error getting all users: $e');
      return {};
    }
  }

  /// Save all users to storage
  Future<void> _saveAllUsers(Map<String, User> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersMap = users.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString(_usersDbKey, jsonEncode(usersMap));
    } catch (e) {
      print('Error saving all users: $e');
      rethrow;
    }
  }

  /// Check if email already exists
  Future<bool> emailExists(String email) async {
    final users = await _getAllUsers();
    return users.values.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  /// Register a new user
  Future<User?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check if email already exists
      if (await emailExists(email)) {
        throw Exception('Email already registered');
      }

      // Validate email format
      if (!_isValidEmail(email)) {
        throw Exception('Invalid email format');
      }

      // Validate password strength
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Create new user
      final passwordHash = _hashPassword(password);
      final user = User.create(
        email: email,
        passwordHash: passwordHash,
        name: name,
      );

      // Save user to database
      final users = await _getAllUsers();
      users[user.id] = user;
      await _saveAllUsers(users);

      // Set as current user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserIdKey, user.id);

      return user;
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  /// Login with email and password
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final users = await _getAllUsers();
      final passwordHash = _hashPassword(password);

      // Find user with matching email and password
      final user = users.values.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.passwordHash == passwordHash,
        orElse: () => throw Exception('Invalid email or password'),
      );

      // Set as current user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserIdKey, user.id);

      return user;
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  /// Get current logged-in user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_currentUserIdKey);

      if (userId == null) {
        return null;
      }

      final users = await _getAllUsers();
      return users[userId];
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Update user profile
  Future<User?> updateUser(User user) async {
    try {
      final users = await _getAllUsers();
      users[user.id] = user;
      await _saveAllUsers(users);
      return user;
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Change password
  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final users = await _getAllUsers();
      final user = users[userId];

      if (user == null) {
        throw Exception('User not found');
      }

      // Verify old password
      final oldPasswordHash = _hashPassword(oldPassword);
      if (user.passwordHash != oldPasswordHash) {
        throw Exception('Incorrect current password');
      }

      // Validate new password
      if (newPassword.length < 6) {
        throw Exception('New password must be at least 6 characters');
      }

      // Update password
      final newPasswordHash = _hashPassword(newPassword);
      final updatedUser = user.copyWith(passwordHash: newPasswordHash);
      users[userId] = updatedUser;
      await _saveAllUsers(users);
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserIdKey);
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  /// Delete user account
  Future<void> deleteAccount(String userId) async {
    try {
      final users = await _getAllUsers();
      users.remove(userId);
      await _saveAllUsers(users);

      // Remove current user if it's the deleted one
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getString(_currentUserIdKey);
      if (currentUserId == userId) {
        await prefs.remove(_currentUserIdKey);
      }

      // Remove user preferences
      await prefs.remove('user_preferences_$userId');
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  /// Clear all data (for testing/debugging)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing all data: $e');
      rethrow;
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_currentUserIdKey);
      return userId != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      final users = await _getAllUsers();
      return users[userId];
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }
}
