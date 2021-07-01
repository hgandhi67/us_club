import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';

class ExploreProvider extends ChangeNotifier {
  List<Product> exploreProductsList = [];

  bool _busy = true;

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<void> getExploreProducts(String limit) async {
    if (await isNetworkConnected()) {
      setBusy(true);
      final response = await api.getExploreProducts("50");
      if (response != null && response.status == 200) {
        exploreProductsList = response.data;
        notifyListeners();
      }
    } else {
      showToast(noInternet);
    }
    setBusy(false);
  }

  Future<void> getMoreExploreProducts(String limit) async {
    if (await isNetworkConnected()) {
      final response = await api.getExploreProducts(limit);
      if (response != null && response.status == 200) {
        exploreProductsList?.addAll(response.data);
        notifyListeners();
      }
    } else {
      showToast(noInternet);
    }
  }
}