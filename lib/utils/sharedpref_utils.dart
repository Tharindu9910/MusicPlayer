import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();
  SharedPrefs._internal();

  final String _userName = "user_name";
  final String _userEmail = "user_email";
  final String _userPhotoURL = "user_photourl";
  final String _userPassword = "user_password";

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  /// Saves if user signup
  void setUserName(String value) {
    _sharedPrefs?.setString(_userName, value);
  }

  String get userName => _sharedPrefs?.getString(_userName) ?? "";

  ///Saves user email
  void setUserEmail(String value) {
    _sharedPrefs?.setString(_userEmail, value);
  }

  String get userEmail => _sharedPrefs?.getString(_userEmail) ?? "";

  ///Saves user photo URL
  void setPhotoURL(String value) {
    _sharedPrefs?.setString(_userPhotoURL, value);
  }

  String get userPhotoURL => _sharedPrefs?.getString(_userPhotoURL) ?? "";

  /// Saves user password
  void setUserPassword(String value) {
    _sharedPrefs?.setString(_userPassword, value);
  }

  String get userPassword => _sharedPrefs?.getString(_userPassword) ?? "";
  Future<void> clearAll() async {
    setUserEmail("");
    setUserName("");
    setPhotoURL("");
    setUserPassword("");
  }
}
