import 'package:asmixer/theme/themes.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';

import '../service_locator.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeType _currentTheme = ThemeType.SYSTEM;

  ThemeNotifier() {
    var prefs = getIt<SharedPreferencesUtils>();
    setCurrentTheme(prefs.getThemeData());
  }

  getCurrentTheme() => _currentTheme;

  setCurrentTheme(ThemeType value) {
    _currentTheme = value;
    notifyListeners();
    _setThemeData();
  }

  _setThemeData() async {
    var prefs = getIt<SharedPreferencesUtils>();
    if (prefs.getThemeData() != _currentTheme) {
      prefs.setThemeData(_currentTheme);
    }
  }

  getMode() {
    switch (_currentTheme) {
      case ThemeType.DARK:
        return ThemeMode.dark;
      case ThemeType.LIGHT:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
