import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  static SharedPreferences? _prefs;

  SharedPreferencesHelper._internal();

  static Future<SharedPreferencesHelper> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _instance;
  }

  static Future<void> setPositions(List<String> positions) async {
    await _prefs?.setStringList("positions", positions);
  }

  static List<String> getPositions() {
    return _prefs?.getStringList("positions") ?? [];
  }
}
