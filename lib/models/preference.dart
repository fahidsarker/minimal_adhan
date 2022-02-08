import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _preferences;

Future<void> initPreferences() async {
  _preferences = await SharedPreferences.getInstance();
}

abstract class Preference<T extends Object?> {
  final String key;
  final T defaultValue;

  const Preference(this.key, this.defaultValue);

  T get value => _rawValue as T? ?? defaultValue;

  Object? get _rawValue;

  Future _setVal(T v);

  Future updateValue(T val) async {
    if (val == null) {
      await _preferences.remove(key);
    } else {
      await _setVal(val);
    }
  }
}

class IntPreference<R extends int?> extends Preference<R> {
  const IntPreference(String key, R defaultValue) : super(key, defaultValue);

  @override
  Object? get _rawValue => _preferences.getInt(key);

  @override
  Future _setVal(R v) => _preferences.setInt(key, v!);
}

class BoolPreference<R extends bool> extends Preference<R> {
  const BoolPreference(String key, R defaultValue) : super(key, defaultValue);

  @override
  Object? get _rawValue => _preferences.getBool(key);

  @override
  Future _setVal(R v) => _preferences.setBool(key, v);
}

class DoublePreference<R extends double?> extends Preference<R> {
  const DoublePreference(String key, R defaultValue) : super(key, defaultValue);

  @override
  Object? get _rawValue => _preferences.getDouble(key);

  @override
  Future _setVal(R v) => _preferences.setDouble(key, v!);
}

class StringPreference<R extends String?> extends Preference<R> {
  const StringPreference(String key, R defaultValue) : super(key, defaultValue);

  @override
  Object? get _rawValue => _preferences.getString(key);

  @override
  Future _setVal(R v) => _preferences.setString(key, v!);
}
