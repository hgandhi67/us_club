import 'package:flutter/material.dart';

class IndexProvider extends ChangeNotifier {
  TabController _tabController;

  TabController get tabController => _tabController;
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (currentIndex != index) {
      _currentIndex = index;
      _tabController.animateTo(index);
      notifyListeners();
    }
  }

  setTabController(controller) {
    _tabController = controller;
    _currentIndex = 0;
  }
}
