import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String? email;
  final bool isEmailVerified;
  final bool isAnonymous;
  final bool isAdmin;
  const AuthUser({
    required this.id,
    this.email,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.isAdmin,
  });

  factory AuthUser.fromFirebase(User user, {required bool isAdmin}) => AuthUser(
    id: user.uid,
    email: user.email,
    isEmailVerified: user.emailVerified,
    isAnonymous: user.isAnonymous,
    isAdmin: isAdmin,
  );
}
