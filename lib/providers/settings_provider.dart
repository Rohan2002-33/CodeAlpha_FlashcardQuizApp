import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._storage) : _themeMode = _storage.loadThemeMode();

  final StorageService _storage;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _storage.saveThemeMode(mode);
  }
}
