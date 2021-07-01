import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/cart/cart_item_manipulation_model.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/widgets/enums/app_enums.dart';

class CartProvider extends ChangeNotifier {
  List<CartData> cartDataList = [];
  List<Variant> colors = [];
  List<Variant> sizes = [];

  bool _busy = true;

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<void> getCartDataList(String userId) async {
    if (await isNetworkConnected()) {
      setBusy(true);
      // showLoader();
      final response = await api.userCardData(userId);
      if (response != null && response.status == 200) {
        cartDataList = response.data;
        notifyListeners();
      }
    } else {
      showToast(noInternet);
    }
    // hideLoader();
    setBusy(false);
  }

  Future<void> cartItemManipulation(
      CartManipulationType manipulationType, String cartId, String userId) async {
    if (await isNetworkConnected()) {
      setBusy(true);
      CartItemManipulationModel response;
      switch (manipulationType) {
        case CartManipulationType.INCREASE:
          response = await api.increaseCartItemQty(cartId);
          break;
        case CartManipulationType.DECREASE:
          response = await api.decreaseCartItemQty(cartId);
          break;
        case CartManipulationType.REMOVE:
          response = await api.removeCartItemQty(cartId);
          break;
      }
      if (response != null && response.status == 200) {
        getCartDataList(userId);
      }
    } else {
      showToast(noInternet);
    }
    setBusy(false);
  }

  void clearCartList() {
    cartDataList.clear();
    notifyListeners();
  }

  Future<void> addToCart(Map<String, dynamic> cartData, String userId, {bool showMsg: true}) async {
    if (await isNetworkConnected()) {
      setBusy(true);
      showLoader();
      final response = await api.addToCart(cartData);
      if (response != null && response.data != null && response.data != null) {
        if (response.data[0].status == 200) {
          if (showMsg) showToast('Product added to cart.');
          getCartDataList(userId);
        } else {
          if (showMsg) showToast(response.data[0].data ?? 'Something went wrong.');
        }
        notifyListeners();
      }
    } else {
      showToast(noInternet);
    }
    hideLoader();
    setBusy(false);
  }

  Future<CreateOrderM> createOrder(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      final response = await api.createOrder(map);
      return response;
    } else {
      showToast(noInternet);
    }

    return null;
  }
}
