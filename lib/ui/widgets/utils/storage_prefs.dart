import 'package:shared_preferences/shared_preferences.dart';

class StoragePrefs {
  static final StoragePrefs _instancia = new StoragePrefs._internal();

  factory StoragePrefs() {
    return _instancia;
  }

  StoragePrefs._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

/////////////////////////////////////////////////
  String get language {
    return _prefs.getString('language') ?? '';
  }

  set language(String value) {
    _prefs.setString('language', value);
  }
}
