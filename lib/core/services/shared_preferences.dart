import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferenceHelperProvider =
    Provider.autoDispose<SharedPreferenceHelper>(
  (ref) => SharedPreferenceHelper(),
);

class SharedPreferenceHelper {
  final Future<SharedPreferences> _sharedPreference;

  SharedPreferenceHelper()
      : _sharedPreference = SharedPreferences.getInstance();

  static const String userName = "userName";
  static const String password = "password";
  static const String uid = "password";

  Future<String?> get getUserName async {
    SharedPreferences preference = await _sharedPreference;
    return preference.getString(userName);
  }

  Future<bool> saveUserName(String phone) async {
    SharedPreferences preference = await _sharedPreference;
    return preference.setString(userName, phone);
  }

  Future<String?> get getUid async {
    SharedPreferences preference = await _sharedPreference;
    return preference.getString(uid);
  }

  Future<bool> saveUid(String uid) async {
    SharedPreferences preference = await _sharedPreference;
    return preference.setString(userName, uid);
  }

  Future<String?> get getPassword async {
    SharedPreferences preference = await _sharedPreference;
    return preference.getString(password);
  }

  Future<bool> savePassword(String pass) async {
    SharedPreferences preference = await _sharedPreference;
    return preference.setString(password, pass);
  }
}
