import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.dark;

  void toggleTheme(bool dark) {
    theme = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}