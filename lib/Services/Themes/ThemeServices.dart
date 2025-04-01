import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class ThemeServices {

  final GetStorage _storage = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  bool _loadThemeFromBox() => _storage.read<bool>(_key) ?? false;

  void _saveThemeToBox(bool isDarkMode) {
    _storage.write(_key, isDarkMode);
    _storage.save();
  }
}
