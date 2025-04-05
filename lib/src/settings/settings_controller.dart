import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  late String _colorData;

  late Locale _localeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  String get colorData => _colorData;

  Locale get localeMode => _localeMode;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final ThemeMode? _savedThemeMode =
        _findThemeBrightness(prefs.getString('theme'));
    final String? _savedColorData = prefs.getString('colorData');
    final Locale? _savedlocalMode = _findLocale(prefs.getString('locale'));

    _themeMode = _savedThemeMode ?? await _settingsService.themeMode();
    _colorData = _savedColorData ?? await _settingsService.colorData();
    _localeMode = _savedlocalMode ?? await _settingsService.localeMode();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateColorData(String? newColorData) async {
    if (newColorData == null) return;

    // Do not perform any work if new and old ThemeData are identical
    if (newColorData == _colorData) return;

    // Otherwise, store the new ThemeMode in memory
    _colorData = newColorData;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateColorData(newColorData);
  }

  Future<void> updateLocaleMode(Locale? newLocale) async {
    if (newLocale == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newLocale == _localeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _localeMode = newLocale;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateLocaleMode(newLocale);
  }

  ThemeMode? _findThemeBrightness(String? string) {
    switch (string) {
      case null:
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return null;
    }
  }

  Locale? _findLocale(String? string) {
    switch (string) {
      case 'en':
        return const Locale('en', '');
      case 'ru':
        return const Locale('ru', '');
      case 'av':
        return const Locale('av', '');
      default:
        return null;
    }
  }
}
