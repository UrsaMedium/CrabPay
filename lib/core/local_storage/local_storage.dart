import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppLocalStorage {
  static late final SharedPreferences _preferences;
  static AppAuthUser? _tempUser;

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
      isLimbo: true,
    );
    if (!_preferences.containsKey('cartItemIdsOnPayment')) {
      await _preferences.setStringList('cartItemIdsOnPayment', []);
    }
    if (!_preferences.containsKey('paymentLink')) {
      await _preferences.setString('paymentLink', '');
    }
  }

  static AppAuthUser get tempUser {
    return _tempUser!;
  }

  static Future<void> saveCartItemsOnPayment(List<String> cartItemIds) async {
    await _preferences.setStringList('cartItemIdsOnPayment', cartItemIds);
  }

  static List<String>? getCartItemIdsOnPayment() {
    return _preferences.getStringList('cartItemIdsOnPayment');
  }

  static Future<void> savePaymentLink(String link) async {
    await _preferences.setString('paymentLink', link);
  }

  static String? getPaymentLink() {
    return _preferences.getString('paymentLink');
  }
}
