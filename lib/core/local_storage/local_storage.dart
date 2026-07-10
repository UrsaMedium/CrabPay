import 'package:crabpay/core/backend/authentication/auth_binding_circle/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppLocalStorage {
  static late final SharedPreferences _preferences;
  static AppAuthUser? _tempUser;
  static List<String>? _cartItemIdsOnPayment;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    if (!_preferences.containsKey('tempUserId')) {
      await _preferences.setString('tempUserId', Uuid().v4());
    }
    _tempUser = AppAuthUser(
      id: _preferences.getString('tempUserId')!,
      email: 'tempUser_id=${_preferences.getString('tempUserId')!}',
      isEmailVerified: false,
      isAnonymous: true,
      isAdmin: false,
    );
    if (!_preferences.containsKey('cartItemIdsOnPayment')) {
      await _preferences.setStringList('cartItemIdsOnPayment', []);
    }
    _cartItemIdsOnPayment = _preferences.getStringList('cartItemIdsOnPayment');
  }

  static AppAuthUser get tempUser {
    return _tempUser!;
  }

  static Future<void> saveCartItemsOnPayment(List<String> cartItemIds) async {
    await _preferences.setStringList('cartItemIdsOnPayment', cartItemIds);
  }

  static List<String>? getCartItemIdsOnPayment() {
    return _cartItemIdsOnPayment;
  }
}
