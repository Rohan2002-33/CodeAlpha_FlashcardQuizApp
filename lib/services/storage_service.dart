import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flashcard.dart';

/// Saves flashcards and settings on the device.
class StorageService {
  StorageService(this._prefs);

  static const _cardsKey = 'flashcards_v1';
  static const _themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    return StorageService(await SharedPreferences.getInstance());
  }

  /// Returns null when nothing saved yet (first launch).
  List<Flashcard>? loadCards() {
    final raw = _prefs.getString(_cardsKey);
    if (raw == null) return null;
    try {
      return Flashcard.decodeList(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCards(List<Flashcard> cards) {
    return _prefs.setString(_cardsKey, Flashcard.encodeList(cards));
  }

  ThemeMode loadThemeMode() {
    switch (_prefs.getString(_themeKey)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) {
    return _prefs.setString(_themeKey, mode.name);
  }
}