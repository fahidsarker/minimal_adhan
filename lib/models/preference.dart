import 'package:minimal_adhan/helpers/SQLHelper.dart';

late final Map<String, Object?> _preferences;

Future<void> initPreferences() async {
  _preferences = await allPreferences;
}


//Should only accept int, double, bool and String
class Preference<T extends Object?> {
  final String key;
  final T defaultValue;

  const Preference(this.key, this.defaultValue);

  T get value {
    return (_preferences[key] as T?) ?? defaultValue;
  }

  set value(T value) {
    _preferences[key] = value;
    updatePreferenceValue(key, value);
  }
}
