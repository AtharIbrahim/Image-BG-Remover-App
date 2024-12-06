import 'package:shared_preferences/shared_preferences.dart';

class CreditManager {
  static final CreditManager _instance = CreditManager._internal();
  int _credits = 0;

  factory CreditManager() {
    return _instance;
  }

  CreditManager._internal();

  Future<void> loadCredits() async {
    final prefs = await SharedPreferences.getInstance();
    _credits = prefs.getInt('credits') ?? 10; // Default to 10 if not set
  }

  int get credits => _credits;

  Future<void> updateCredits(int amount) async {
    _credits += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('credits', _credits);
  }
}
