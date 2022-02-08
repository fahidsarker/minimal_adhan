import 'package:minimal_adhan/helpers/SQLHelper.dart';

late final Map<String?, Object?> _preferences;

Future<void> initPreferences() async {
  //print("Init pref");
  _preferences = await allPreferences;
}

//Should only accept int, double, bool and String
class Preference<T extends Object?> {
  final String key;
  final T defaultValue;

  const Preference(this.key, this.defaultValue);

  T get value {
    //print("VALUE FOR $key : ${_preferences[key]}");
    return (_modifiedVal as T?) ?? defaultValue;
  }

  Object? get _modifiedVal {
    final v = _preferences[key];
    if (v != null && T == bool) {
      return v == 1;
    } else {
      return v;
    }
  }

  set value(T value) {
    final saveValue = (value is String)
        ? "'$value'"
        : (value is bool)
            ? value
                ? 1
                : 0
            : value;
    _preferences[key] = saveValue;
    print(_preferences);
    updatePreferenceValue(
      key,
      saveValue,
    );
  }
}
