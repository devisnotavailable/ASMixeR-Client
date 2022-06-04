import 'package:asmixer/screens/ui/dialogs/remix_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/themes.dart';

Future<SharedPreferencesUtils> initSharedPreferences() async {
  return SharedPreferencesUtils(await SharedPreferences.getInstance());
}

class SharedPreferencesUtils {
  final SharedPreferences preferences;

  SharedPreferencesUtils(this.preferences);

  final String selectedProfileOption = 'selectedProfile';

  int getSelectedProfile() {
    return preferences.getInt(selectedProfileOption) ?? 0;
  }

  void setSelectedProfile(int value) {
    preferences.setInt(selectedProfileOption, value);
  }

  final _themeKey = 'themeKey';

  void setThemeData(ThemeType value) =>
      preferences.setString(_themeKey, value.name);

  ThemeType getThemeData() {
    String result = preferences.getString(_themeKey) ?? ThemeType.SYSTEM.name;
    return ThemeType.values.byName(result);
  }

  final _firstLaunch = 'firstLaunch';

  void setFirstLaunch(bool value) => preferences.setBool(_firstLaunch, value);

  bool isFirstLaunch() {
    return preferences.getBool(_firstLaunch) ?? true;
  }

  final _useSearchLocale = 'useSearchLocale';

  void setUseSearchLocale(bool value) =>
      preferences.setBool(_useSearchLocale, value);

  bool isUseSearchLocale() {
    return preferences.getBool(_useSearchLocale) ?? true;
  }

  final _remixDialogKey = 'remixDialog';

  void setRemixAction(RemixAction value) =>
      preferences.setString(_remixDialogKey, value.name);

  RemixAction getRemixAction() {
    String result =
        preferences.getString(_remixDialogKey) ?? RemixAction.ASK.name;
    return RemixAction.values.byName(result);
  }
}
