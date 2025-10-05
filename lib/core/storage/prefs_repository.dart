import 'package:flutter/material.dart';

  abstract class PrefsRepository{
  Future<bool> setTheme(ThemeMode themeMode);
  ThemeMode get getTheme;
}