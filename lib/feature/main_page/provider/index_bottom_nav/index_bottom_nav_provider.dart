import 'package:flutter/material.dart';

class IndexBottomNavProvider extends ChangeNotifier {
  int _currentIndexBottomNavBar = 0;

  int get currentIndexBottomNavBar => _currentIndexBottomNavBar;

  set setIndexBottomNavBar(int value) {
    _currentIndexBottomNavBar = value;
    notifyListeners();
  }
}
