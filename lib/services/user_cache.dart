import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:user_profile_management/models/user.dart';


class UserCache {
  static const String _key = 'cached_users';

  // Save users to SharedPreferences
  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonList = users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList(_key, userJsonList);
  }

  // Load users from SharedPreferences
  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonList = prefs.getStringList(_key) ?? [];
    return userJsonList.map((userJson) => User.fromJson(jsonDecode(userJson))).toList();
  }

  // Clear cached users
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}