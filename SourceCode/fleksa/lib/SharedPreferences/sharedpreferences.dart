
import 'package:shared_preferences/shared_preferences.dart';

class ShareP
{
  static SharedPreferences? _preferences;
  static const _keytoken = 'valuename';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();


  //for token
  static Future setToken(String token) async =>
      await _preferences!.setString(_keytoken, token);

  static String? getToken() => _preferences!.getString(_keytoken);

  static Future removeToken () async =>
      await _preferences!.remove(_keytoken);



}