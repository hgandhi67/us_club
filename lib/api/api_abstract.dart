import 'dart:io';

abstract class AbstractApi<T> {
  Future<T> loginUser(Map<String, dynamic> map);

  Future<T> registerUser(Map<String, dynamic> map);

  Future<T> getHomeScreen(String token);

  Future<T> getRandomProducts(String limit);

  Future<T> getSearchedProducts(String query);

  Future<T> getProductDetails(String productId);

  Future<T> getSingleProductVariant(String productId);

  Future<T> getProductReviews(String productId);

  Future<T> getExploreProducts(String limit);

  Future<T> getAllSubCategories(String cid);

  Future<T> getAllCategoryProduct(String cid);

  Future<T> getAllSubSubCategories(String scid);

  Future<T> getAllSubCategoryProduct(String scid);

  Future<T> getUserProfile(String userId);

  Future<T> checkAvailability(String pincode);

  Future<T> getOrders(String userId);

  Future<T> getOrderDetails(String waybill);

  Future<T> getCountries();

  Future<T> getStates(String stateId);

  Future<T> getCities(String cityId);

  Future<T> updateProfile(Map<String, dynamic> map);

  Future<T> uploadUserImage(File userImage, String userId);

  Future<T> removeUserImage(String userId);

  Future<T> userCardData(String userId);

  Future<T> addToCart(Map<String, dynamic> cartData);

  Future<T> increaseCartItemQty(String cartId);

  Future<T> decreaseCartItemQty(String cartId);

  Future<T> removeCartItemQty(String cartId);

  Future<T> getFilteredProduct(String catId, String lowerPrice, String uppwePrice, String size, String color);

  Future<T> getFilterType(String catId,String type);

  Future<T> insertProductReview(Map<String, dynamic> productReviewMap);

  Future<T> sendOtp(String phoneNumber);

  Future<T> verifyOtp(String sessionId, String otpInput);

  Future<T> cancelOrder(Map<String, dynamic> cancelMap);

  Future<T> createOrder(Map<String, dynamic> map);

  Future<T> returnOrder(Map<String, dynamic> returnMap);

  Future<T> changeOrderStatus(String orderId, String status);

  Future<T> checkPhoneNumber(String phoneNumber);
}
