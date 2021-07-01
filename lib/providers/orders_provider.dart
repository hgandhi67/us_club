import 'package:flutter/foundation.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> ordersList;

  Future<void> getOrders(String userId) async {
    if (await isNetworkConnected()) {
      final response = await api.getOrders(userId);
      ordersList = response?.data ?? [];
      notifyListeners();
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<OrderDetailsM> getOrderDetails(String waybill) async {
    if (await isNetworkConnected()) {
      final response = await api.getOrderDetails(waybill);
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<CancelOrderModel> cancelOrder(String waybill, String userId, String orderId) async {
    if (await isNetworkConnected()) {
      CancelOrderModel response = await api.cancelOrder({'waybill': waybill, "cancellation": "true"});

      if (response != null && response.root != null && response.root.status != null) {
        if (response.root.status.t == 'True') {
          changeOrderStatus(orderId, userId, 'cancelled');
        } else {
          showToast(response?.root?.error?.t);
        }
      }
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<ReturnOrderModel> returnOrder(Map<String, dynamic> returnMap, String userId, String orderId) async {
    if (await isNetworkConnected()) {
      showLoader();
      ReturnOrderModel response = await api.returnOrder(returnMap);
      if (response.success) {
        changeOrderStatus(orderId, userId, 'returned');
      } else {
        showToast(response.rmk);
      }
      hideLoader();
      return response;
    } else {
      showToast(noInternet);
    }
    hideLoader();
    return null;
  }

  Future<ChangeOrderStatusModel> changeOrderStatus(String orderId, String userId, String status) async {
    if (await isNetworkConnected()) {
      showLoader();
      ChangeOrderStatusModel response = await api.changeOrderStatus(orderId, status);
      if (response.data.status == 'Success') {
        getOrders(userId);
      } else {
        showToast(response.data.message);
      }
      hideLoader();
      return response;
    } else {
      showToast(noInternet);
    }
    hideLoader();
    return null;
  }
}
