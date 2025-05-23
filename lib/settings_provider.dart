import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _screenReaderEnabled = true;
  bool _darkMode = true;

  bool get darkMode => _darkMode;
  bool get screenReaderEnabled => _screenReaderEnabled;

  void setScreenReaderEnabled(bool value) {
    _screenReaderEnabled = value;
    notifyListeners();
  }
  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}