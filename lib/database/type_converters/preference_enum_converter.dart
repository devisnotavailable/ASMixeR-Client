import 'package:asmixer/data/preference_type.dart';
import 'package:floor/floor.dart';

class PreferenceEnumConverter extends TypeConverter<PreferenceType, int> {
  @override
  PreferenceType decode(int databaseValue) {
    return PreferenceType.values[databaseValue];
  }

  @override
  int encode(PreferenceType value) {
    return value.index;
  }
}
