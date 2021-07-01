import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';

class SearchProvider extends ChangeNotifier {
  Future<List<Product>> getSearchedProducts(String query, bool isViewMore) async {
    if (await isNetworkConnected()) {
      if (!isViewMore) {
        final response = await api.getSearchedProducts(query);
        return response?.data?.products ?? [];
      } else {
        final response = await api.getAllSubCategoryProduct(query);
        return response?.data ?? [];
      }
    } else {
      showToast(noInternet);
    }
    return [];
  }
}
