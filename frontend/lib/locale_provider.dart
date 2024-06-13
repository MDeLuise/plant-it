import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  LocaleProvider();

  Locale? get locale => _locale;

  void setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);
      await prefs.setString('country_code', locale.countryCode ?? '');
      notifyListeners();
    }
  }

  void cleanupLocale() async {
    _locale = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('language_code');
    await prefs.remove('country_code');
    notifyListeners();
  }
}
