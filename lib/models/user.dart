import 'package:uuid/uuid.dart';

/// User Model
/// Represents a user account with credentials and profile information
class User {
  final String id;
  final String email;
  final String passwordHash;
  final String name;
  final String? profileImage;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.name,
    this.profileImage,
    required this.createdAt,
  });

  /// Create a new user with generated ID
  factory User.create({
    required String email,
    required String passwordHash,
    required String name,
    String? profileImage,
  }) {
    return User(
      id: const Uuid().v4(),
      email: email,
      passwordHash: passwordHash,
      name: name,
      profileImage: profileImage,
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'name': name,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? passwordHash,
    String? name,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
