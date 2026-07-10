import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@immutable
class AppAuthUser {
  final String id;
  final String? email;
  final bool isEmailVerified;
  final bool isAnonymous;
  final bool isAdmin;
  const AppAuthUser({
    required this.id,
    this.email,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.isAdmin,
  });

  factory AppAuthUser.fromSupabase(
    supabase.User user, {
    required bool isAdmin,
  }) => AppAuthUser(
    id: user.id,
    email: user.email,
    isEmailVerified: true,
    isAnonymous: user.isAnonymous,
    isAdmin: isAdmin,
  );
}
