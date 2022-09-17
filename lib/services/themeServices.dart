import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final key = "isDark";

  _saveThemetoBox(bool isDark) => _box.write(key, isDark);
  bool _loadThemeFromBox() => _box.read(key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchThme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemetoBox(!_loadThemeFromBox());
  }
}
