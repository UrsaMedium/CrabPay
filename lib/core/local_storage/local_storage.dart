import 'package:crabpay/core/backend_and_bindings/authentication/auth_binding_circle/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalStorage {
  static late final SharedPreferences _preferences;
  static AuthUser? _tempUser;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    if (!_preferences.containsKey('tempUserId')) {
      await _preferences.setString('tempUserId', Uuid().v4());
    }
    _tempUser = AuthUser(
      id: _preferences.getString('tempUserId')!,
      email: 'tempUser_id=${_preferences.getString('tempUserId')!}',
      isEmailVerified: false,
      isAnonymous: true,
      isAdmin: false,
    );
  }

  static AuthUser get tempUser {
    return _tempUser!;
  }
}
