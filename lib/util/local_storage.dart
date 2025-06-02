import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  // Menyimpan username dan status login ke SharedPreferences
  static Future<void> login(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", username);
    await prefs.setBool("isLogin", true);
  }

  // Mengecek status login user
  static Future<bool> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  // Mengambil data string dari SharedPreferences berdasarkan key
  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Menghapus data username dan mengubah status login menjadi false
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("username");
    await prefs.setBool("isLogin", false);
  }
}
