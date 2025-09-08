import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void navigateToHome() => changeTab(0);
  void navigateToAuraScan() => changeTab(1);
  void navigateToChatAI() => changeTab(2);
  void navigateToHoroscope() => changeTab(3);
  void navigateToProfile() => changeTab(4);
}

