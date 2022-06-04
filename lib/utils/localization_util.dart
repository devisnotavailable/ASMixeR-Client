import 'package:flutter/cupertino.dart';

class LocalizationUtil {
  bool isRussian(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ru';
  }
}
