import 'package:flutter/material.dart';

@immutable
class AppAuthUser {
  final String id;
  final String? email;
  final bool isEmailVerified;
  final bool isAnonymous;
  final bool isAdmin;
  final bool isLimbo;
  const AppAuthUser({
    required this.id,
    this.email,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.isAdmin,
    required this.isLimbo,
  });

  static const empty = AppAuthUser(
    id: '',
    isEmailVerified: false,
    isAnonymous: false,
    isAdmin: false,
    email: null,
    isLimbo: true,
  );

  bool get isEmpty => this == AppAuthUser.empty;
  bool get isNotEmpty => this != AppAuthUser.empty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppAuthUser &&
        other.email == email &&
        other.id == id &&
        other.isAdmin == isAdmin &&
        other.isAnonymous == isAnonymous &&
        other.isEmailVerified == isEmailVerified &&
        other.isLimbo == isLimbo;
  }

  @override
  int get hashCode =>
      Object.hash(id, email, isAdmin, isAnonymous, isEmailVerified, isLimbo);

  @override
  String toString() {
    return 'AppAuthUser(id: $id, email: $email, isAnonymous: $isAnonymous, isAdmin: $isAdmin, isLimbo: $isLimbo)';
  }
}
