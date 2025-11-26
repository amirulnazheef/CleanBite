import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// Firebase Authentication Service
/// Handles Google Sign-In, Email/Password auth, and Firestore user data
class FirebaseAuthService extends ChangeNotifier {
  // Singleton pattern
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Lazy initialize GoogleSignIn to avoid web client ID error
  GoogleSignIn? _googleSignIn;
  GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn(
      scopes: ['email', 'profile'],
    );
    return _googleSignIn!;
  }

  // Current user data from Firestore
  UserData? _userData;
  UserData? get userData => _userData;

  // Firebase Auth user
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Initialize - call this on app start
  Future<void> initialize() async {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });

    // Load current user data if already logged in
    if (_auth.currentUser != null) {
      await _loadUserData(_auth.currentUser!.uid);
    }
  }

  // ==================== GOOGLE SIGN IN ====================

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult(
          success: false,
          errorMessage: 'Sign in cancelled',
        );
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user!;
      
      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Create user document in Firestore
        await _createUserDocument(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'User',
          photoUrl: user.photoURL,
          authProvider: 'google',
        );
      } else {
        // For existing users, update photo URL if it changed
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final currentPhotoUrl = doc.data()?['photoUrl'] as String?;
          if (user.photoURL != null && user.photoURL != currentPhotoUrl) {
            // Update photo URL in Firestore
            await _firestore.collection('users').doc(user.uid).update({
              'photoUrl': user.photoURL,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }
        } else {
          // Document doesn't exist, create it
          await _createUserDocument(
            uid: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? 'User',
            photoUrl: user.photoURL,
            authProvider: 'google',
          );
        }
      }

      // Load user data
      await _loadUserData(user.uid);

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessage: _getFirebaseErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Failed to sign in with Google: $e',
      );
    }
  }

  // ==================== EMAIL/PASSWORD AUTH ====================

  /// Register with email and password
  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(displayName.trim());

      // Create user document in Firestore
      await _createUserDocument(
        uid: userCredential.user!.uid,
        email: email.trim(),
        displayName: displayName.trim(),
        authProvider: 'email',
      );

      // Load user data
      await _loadUserData(userCredential.user!.uid);

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessage: _getFirebaseErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Registration failed: $e',
      );
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Load user data
      await _loadUserData(_auth.currentUser!.uid);

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessage: _getFirebaseErrorMessage(e.code),
      );
    } on FirebaseException catch (e) {
      return AuthResult(
        success: false,
        errorMessage: _getFirebaseErrorMessage(e.code),
      );
    } catch (e) {
      // Parse Firebase error from string if needed
      final errorStr = e.toString();
      if (errorStr.contains('user-not-found')) {
        return AuthResult(
          success: false,
          errorMessage: 'No account found with this email. Please sign up first.',
        );
      } else if (errorStr.contains('wrong-password') || errorStr.contains('invalid-credential')) {
        return AuthResult(
          success: false,
          errorMessage: 'Wrong email or password. Please try again.',
        );
      } else if (errorStr.contains('invalid-email')) {
        return AuthResult(
          success: false,
          errorMessage: 'Invalid email address.',
        );
      } else if (errorStr.contains('too-many-requests')) {
        return AuthResult(
          success: false,
          errorMessage: 'Too many failed attempts. Please try again later.',
        );
      }
      return AuthResult(
        success: false,
        errorMessage: 'Wrong email or password. Please try again.',
      );
    }
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessage: _getFirebaseErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Failed to send reset email: $e',
      );
    }
  }

  /// Change password (requires re-authentication)
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return AuthResult(
          success: false,
          errorMessage: 'Not logged in',
        );
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessage: _getFirebaseErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'Failed to change password: $e',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    _userData = null;
    notifyListeners();
  }

  // ==================== FIRESTORE USER DATA ====================

  /// Create user document in Firestore
  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    required String authProvider,
  }) async {
    final userData = UserData(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      authProvider: authProvider,
      createdAt: DateTime.now(),
      dietaryPreferences: DietaryPreferences(),
      allergens: [],
      customAllergens: [],
    );

    await _firestore.collection('users').doc(uid).set(userData.toMap());
  }

  /// Load user data from Firestore
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final firebaseUser = _auth.currentUser;
      
      if (doc.exists) {
        final data = doc.data()!;
        // If Firestore doesn't have photoUrl but Firebase Auth does, use Firebase Auth's
        final photoUrl = data['photoUrl'] as String? ?? firebaseUser?.photoURL;
        
        _userData = UserData.fromMap(data, uid);
        
        // Update photoUrl if it's missing in Firestore but available in Firebase Auth
        if (photoUrl != null && _userData!.photoUrl != photoUrl) {
          _userData = _userData!.copyWith(photoUrl: photoUrl);
        }
      } else if (firebaseUser != null) {
        // Document doesn't exist, create it from Firebase Auth data
        await _createUserDocument(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          photoUrl: firebaseUser.photoURL,
          authProvider: 'google',
        );
        await _loadUserData(uid); // Reload after creating
        return;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (_auth.currentUser == null || _userData == null) return false;

    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName.trim();
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(updates);

      // Update local data
      _userData = _userData!.copyWith(
        displayName: displayName?.trim(),
        photoUrl: photoUrl,
      );
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  /// Update dietary preferences
  Future<bool> updateDietaryPreferences(DietaryPreferences preferences) async {
    if (_auth.currentUser == null || _userData == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'dietaryPreferences': preferences.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _userData = _userData!.copyWith(dietaryPreferences: preferences);
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error updating preferences: $e');
      return false;
    }
  }

  /// Update allergens
  Future<bool> updateAllergens({
    required List<String> allergens,
    required List<String> customAllergens,
  }) async {
    if (_auth.currentUser == null || _userData == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'allergens': allergens,
        'customAllergens': customAllergens,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _userData = _userData!.copyWith(
        allergens: allergens,
        customAllergens: customAllergens,
      );
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error updating allergens: $e');
      return false;
    }
  }

  // ==================== SCAN HISTORY ====================

  /// Add scan to history
  Future<bool> addScanToHistory(ScanHistoryItem item) async {
    if (_auth.currentUser == null) return false;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('scanHistory')
          .add(item.toMap());

      return true;
    } catch (e) {
      debugPrint('Error adding scan: $e');
      return false;
    }
  }

  /// Get scan history
  Stream<List<ScanHistoryItem>> getScanHistory() {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('scanHistory')
        .orderBy('scannedAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ScanHistoryItem.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ==================== HELPERS ====================

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Wrong email or password. Please try again.';
      case 'invalid-credential':
        return 'Wrong email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'requires-recent-login':
        return 'Please log out and log in again to perform this action.';
      default:
        return 'Wrong email or password. Please try again.';
    }
  }
}

// ==================== DATA MODELS ====================

class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult({required this.success, this.errorMessage});
}

class UserData {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String authProvider;
  final DateTime createdAt;
  final DietaryPreferences dietaryPreferences;
  final List<String> allergens;
  final List<String> customAllergens;

  UserData({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.authProvider,
    required this.createdAt,
    required this.dietaryPreferences,
    required this.allergens,
    required this.customAllergens,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'createdAt': Timestamp.fromDate(createdAt),
      'dietaryPreferences': dietaryPreferences.toMap(),
      'allergens': allergens,
      'customAllergens': customAllergens,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map, String uid) {
    return UserData(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      photoUrl: map['photoUrl'],
      authProvider: map['authProvider'] ?? 'email',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dietaryPreferences: map['dietaryPreferences'] != null
          ? DietaryPreferences.fromMap(map['dietaryPreferences'])
          : DietaryPreferences(),
      allergens: List<String>.from(map['allergens'] ?? []),
      customAllergens: List<String>.from(map['customAllergens'] ?? []),
    );
  }

  UserData copyWith({
    String? displayName,
    String? photoUrl,
    DietaryPreferences? dietaryPreferences,
    List<String>? allergens,
    List<String>? customAllergens,
  }) {
    return UserData(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider,
      createdAt: createdAt,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergens: allergens ?? this.allergens,
      customAllergens: customAllergens ?? this.customAllergens,
    );
  }
}

class DietaryPreferences {
  final bool halal;
  final bool kosher;
  final bool vegan;
  final bool vegetarian;

  DietaryPreferences({
    this.halal = false,
    this.kosher = false,
    this.vegan = false,
    this.vegetarian = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'halal': halal,
      'kosher': kosher,
      'vegan': vegan,
      'vegetarian': vegetarian,
    };
  }

  factory DietaryPreferences.fromMap(Map<String, dynamic> map) {
    return DietaryPreferences(
      halal: map['halal'] ?? false,
      kosher: map['kosher'] ?? false,
      vegan: map['vegan'] ?? false,
      vegetarian: map['vegetarian'] ?? false,
    );
  }

  DietaryPreferences copyWith({
    bool? halal,
    bool? kosher,
    bool? vegan,
    bool? vegetarian,
  }) {
    return DietaryPreferences(
      halal: halal ?? this.halal,
      kosher: kosher ?? this.kosher,
      vegan: vegan ?? this.vegan,
      vegetarian: vegetarian ?? this.vegetarian,
    );
  }
}

class ScanHistoryItem {
  final String? id;
  final String productName;
  final String? barcode;
  final int ingredientCount;
  final String classification;
  final DateTime scannedAt;
  final String? imageUrl;

  ScanHistoryItem({
    this.id,
    required this.productName,
    this.barcode,
    required this.ingredientCount,
    required this.classification,
    required this.scannedAt,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'barcode': barcode,
      'ingredientCount': ingredientCount,
      'classification': classification,
      'scannedAt': Timestamp.fromDate(scannedAt),
      'imageUrl': imageUrl,
    };
  }

  factory ScanHistoryItem.fromMap(Map<String, dynamic> map, String id) {
    return ScanHistoryItem(
      id: id,
      productName: map['productName'] ?? 'Unknown Product',
      barcode: map['barcode'],
      ingredientCount: map['ingredientCount'] ?? 0,
      classification: map['classification'] ?? 'Unknown',
      scannedAt: (map['scannedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: map['imageUrl'],
    );
  }
}
