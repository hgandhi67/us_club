import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/widgets/widgets.dart';

class CategoriesProvider extends ChangeNotifier {
  CData cData;
  List<Product> allProducts;
  List<Product> tempAllProducts;

  CData scData;
  List<Product> scAllProducts;
  List<Product> tempScAllProducts;

  bool _busy = true;

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _busy = value;

    // if (value == false) {
    notifyListeners();
    // }
  }

  Future<SubCategoriesM> getAllSubCategories(String cid) async {
    setBusy(true);

    if (await isNetworkConnected()) {
      final response = await api.getAllSubCategories(cid);
      if (response != null) {
        cData = response.data[0];
      }
      setBusy(false);
      return response;
    } else {
      showToast(noInternet);
    }
    setBusy(false);
    return null;
  }

  Future<AllCategoryProductM> getAllCategoryProduct(String cid) async {
    setBusy(true);

    if (await isNetworkConnected()) {
      final response = await api.getAllCategoryProduct(cid);

      if (response != null) {
        allProducts = response.data;
        tempAllProducts = response.data;
      } else {
        allProducts = [];
      }

      setBusy(false);

      return response;
    } else {
      showToast(noInternet);
    }
    setBusy(false);
    return null;
  }

  Future<SubCategoriesM> getAllSubSubCategories(String scid) async {
    setBusy(true);
    if (await isNetworkConnected()) {
      final response = await api.getAllSubSubCategories(scid);
      if (response != null) {
        scData = response.data[0];
      }

      setBusy(false);

      return response;
    } else {
      showToast(noInternet);
    }
    setBusy(false);
    return null;
  }

  Future<AllCategoryProductM> getAllSubCategoriesProducts(String scid) async {
    setBusy(true);
    if (await isNetworkConnected()) {
      final response = await api.getAllSubCategoryProduct(scid);

      if (response != null) {
        scAllProducts = response.data;
        tempScAllProducts = response.data;
      } else {
        scAllProducts = [];
      }

      setBusy(false);

      return response;
    } else {
      showToast(noInternet);
    }
    setBusy(false);
    return null;
  }

  void clearAllValues() {
    cData = null;
    scData = null;
    allProducts = null;
    scAllProducts = null;
  }

  void clearCatValues() {
    cData = null;
    allProducts = null;
  }

  void clearSubCatValues() {
    scData = null;
    scAllProducts = null;
  }

  void sortProducts(SortBy sortBy, bool isCid) {
    List<Product> list;

    if (isCid) {
      list = allProducts.toList();
    } else {
      list = scAllProducts.toList();
    }

    if (!list.isNullOrEmpty) {
      switch (sortBy) {
        case SortBy.popularity:
          // list.sort((a, b) {
          //   return a.proQty.compareTo(b.proQty);
          // });
          if (isCid) {
            list = tempAllProducts;
          } else {
            list = tempScAllProducts;
          }

          break;
        case SortBy.high_to_low:
          list.sort((a, b) {
            return b.proPrice.toDouble().compareTo(a.proPrice.toDouble());
          });
          break;
        case SortBy.low_to_high:
          list.sort((a, b) {
            return a.proPrice.toDouble().compareTo(b.proPrice.toDouble());
          });
          break;
      }

      if (isCid) {
        allProducts = list;
      } else {
        scAllProducts = list;
      }

      notifyListeners();
    }
  }

  Future<void> getFilteredProducts(
      String catId, String lowerPrice, String upperPrice, String size, String color, bool isCid) async {
    if (await isNetworkConnected()) {
      final response = await api.getFilteredProduct(catId, lowerPrice, upperPrice, size, color);

      if (response != null && !response.data.isNullOrEmpty) {
        if (isCid) {
          allProducts = response.data;
        } else {
          scAllProducts = response.data;
        }
      }

      notifyListeners();
    } else {
      showToast(noInternet);
    }
  }
}
