import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';

class HomeProvider extends ChangeNotifier {
  // List<HomeData> homeList = [];
  List<Menubar> categories = [];
  List<Sliders> sliders = [];
  List<Offer> offers = [];
  List<StoreDetail> storeDetails = [];

  List<Random> randomProducts;

  bool _busy = true;

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<void> getHomeScreen() async {
    if (await isNetworkConnected()) {
      final response = await Future.wait([
        api.getHomeScreen(""),
        api.getRandomProducts("50"),
      ]);
      if (!response.isNullOrEmpty) {
        try {
          final list1 = response[0] as HomeModel;

          categories = list1.data[0].menubar;
          sliders = list1.data[1].slider;
          offers = list1.data[2].offer;
          storeDetails = list1.data[3].storeDetail;

          if (storeDetails?.last?.type == "discount" &&
              storeDetails?.last?.value?.toInt() != null &&
              storeDetails.last.value.toInt() >= 0) {
            discount = storeDetails.last.value.toDouble();
            showLog("discount =======>>> $discount");
          }
          final list2 = response[1] as RandomModel;
          randomProducts = list2.data;

          // showLog("randomProducts =======>>> ${randomProducts?.length}");
          //
          // randomProducts.forEach((element) {
          //
          //   showLog("random =======>>> ${element.toJson()}");
          //
          // });

        } catch (e) {
          showLog("getHomeScreen exception =======>>> $e");
        }

        setBusy(false);
      }
    } else {
      showToast(noInternet);
    }
  }

  Future<void> getRandomProducts(String limit) async {
    if (await isNetworkConnected()) {
      final response = await api.getRandomProducts(limit);
      if (response != null && response.status == 200) {
        randomProducts?.addAll(response.data);
        notifyListeners();
      }
    } else {
      showToast(noInternet);
    }
  }

  Future<ProductDetailsM> getProductDetails(String productId) async {
    if (await isNetworkConnected()) {
      final response = await api.getProductDetails(productId);
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<VariantM> getSingleProductVariant(String productId) async {
    if (await isNetworkConnected()) {
      final response = await api.getSingleProductVariant(productId);
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<ProductReviewsM> getProductReviews(String productId) async {
    if (await isNetworkConnected()) {
      final response = await api.getProductReviews(productId);
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<AvailabilityM> checkAvailability(String pincode) async {
    if (await isNetworkConnected()) {
      final response = await api.checkAvailability(pincode);
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<void> insertProductReview(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      InsertReviewModel response = await api.insertProductReview(map);
      if (response.data.isNotEmpty) {
        showToast(response.data[0].message);
      }
    } else {
      showToast(noInternet);
    }
    return null;
  }
}
