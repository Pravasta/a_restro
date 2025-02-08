import 'package:a_restro/feature/profile/repository/profile_repository.dart';
import 'package:flutter/material.dart';

class ChangeThemeProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  ChangeThemeProvider({
    required ProfileRepository repository,
  }) : _repository = repository;

  bool _isDarkTheme = false;
  String _message = '';

  bool get isDarkTheme => _isDarkTheme;
  String get message => _message;

  Future<void> loadTheme() async {
    _isDarkTheme = await _repository.loadTheme();
    notifyListeners();
  }

  Future<void> changeTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await _repository.saveTheme(_isDarkTheme);
    _message = 'Theme has been changed';
    notifyListeners();
  }
}
