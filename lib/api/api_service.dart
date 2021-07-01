import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:us_club/api/api_abstract.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/cart/add_to_cart_model.dart';
import 'package:us_club/model/cart/cart_item_manipulation_model.dart';
import 'package:us_club/model/login/check_phone_model.dart';
import 'package:us_club/model/login/login_model.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/model/updateProfile/update_profile_image_model.dart';
import 'package:xml2json/xml2json.dart';

import 'api_end_points.dart';

class ApiService<T> implements AbstractApi {
  /// Auth token used for the api calling.
  final authToken = "70c5fe45-666b-48cf-8365-5f5a10fa94de";
  final deliveryToken = "9641360c164066408761fc38534df99b7125b4e8";

  static IOClient getHttpClient() {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    return http;
  }

  /// Overridden function [loginMe] which will call the rest api for the login of the user.
  /// It will take in the [Map] of the user details and will give output as either [Exception] or the [LoginModel].
  @override
  Future<LoginModel> loginUser(Map<String, dynamic> map) async {
    try {
      showLog("login request ======>>>> $map");
      var response = await getHttpClient().post(ApiUrl.LOGIN + authToken, body: map);
      showLog("login response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.body));
        return loginModel;
      }
    } catch (e) {
      showLog('login exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [RegisterUser] which will call the rest api for the login of the user.
  /// It will take in the [Map] of the user details and will give output as either [Exception] or the [RegisterModel].
  @override
  Future<RegisterModel> registerUser(Map<String, dynamic> map) async {
    try {
      showLog("register request map ======>>>> $map");
      var response = await ApiService.getHttpClient().post(ApiUrl.REGISTER + authToken, body: map);
      showLog("register response ======>>> ${response.body}");
      if (response != null && !response.body.isEmptyORNull) {
        RegisterModel registerModel = RegisterModel.fromJson(jsonDecode(response.body));
        return registerModel;
      }
    } catch (e) {
      showLog('register exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<HomeModel> getHomeScreen(String token) async {
    try {
      showLog("getHomeScreen request ======>>>> $authToken");

      var response = await getHttpClient().get(ApiUrl.HOME_SCREEN + authToken);

      // showLog("getHomeScreen response ======>>> ${response.body}");

      if (response != null && response.statusCode == Strings.ok) {
        HomeModel model = HomeModel.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getHomeScreen exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<RandomModel> getRandomProducts(String limit) async {
    try {
      // showLog("getRandomProducts request ======>>>> $limit");

      final url = ApiUrl.RANDOM_PRODUCTS + "limit=$limit&api=$authToken";

      var response = await getHttpClient().get(url);

      // showLog("getRandomProducts response ======>>> ${response.body}");

      if (response != null && response.statusCode == Strings.ok) {
        RandomModel model = RandomModel.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getRandomProducts exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<ProductDetailsM> getProductDetails(String productId) async {
    try {
      final url = ApiUrl.PRODUCT_DETAILS + authToken + "&pid=$productId";
      // showLog("getProductDetails request ======>>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getProductDetails response ======>>> ${response.body}");

      if (response != null && response.statusCode == Strings.ok) {
        ProductDetailsM model = ProductDetailsM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getProductDetails exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<VariantM> getSingleProductVariant(String productId) async {
    try {
      final url = ApiUrl.SINGLE_PRODUCT_VARIANT + authToken + "&pid=$productId";
      showLog("getSingleProductVariant request ======>>>> $url");

      var response = await getHttpClient().get(url);

      showLog("getSingleProductVariant response ======>>> ${response.body}");

      if (response != null && response.statusCode == Strings.ok) {
        VariantM model = VariantM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getSingleProductVariant exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<ProductReviewsM> getProductReviews(String productId) async {
    try {
      final url = ApiUrl.PRODUCT_REVIEWS + productId + "&api=$authToken";
      // final url = ApiUrl.PRODUCT_REVIEWS + "162" + "&api=$authToken";
      // showLog("getProductReviews request ======>>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getProductReviews response ======>>> ${response.body}");

      if (response != null && response.statusCode == Strings.ok) {
        ProductReviewsM model = ProductReviewsM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getProductReviews exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [ExploreProducts] which will call the rest api for the list of the explore products.
  /// It will take in the [limit] and will give output as either [Exception] or the [ExploreModel].
  @override
  Future<ExploreModel> getExploreProducts(String limit) async {
    try {
      final url = ApiUrl.EXPLORE_PRODUCTS + "$authToken&limit=$limit";
      var response = await getHttpClient().get(url);
      if (response != null && response.statusCode == Strings.ok) {
        ExploreModel model = ExploreModel.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getExploreProducts exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<SubCategoriesM> getAllSubCategories(String cid) async {
    try {
      final url = ApiUrl.GET_SUB_CATEGORIES + cid + "&api=$authToken";

      // showLog("getAllSubCategories request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getAllSubCategories response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        SubCategoriesM model = SubCategoriesM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getAllSubCategories exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<AllCategoryProductM> getAllCategoryProduct(String cid) async {
    try {
      final url = ApiUrl.All_CATEGORIES_PRODUCTS + cid + "&api=$authToken";

      // showLog("getAllCategoryProduct request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getAllCategoryProduct response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        AllCategoryProductM model = AllCategoryProductM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getAllCategoryProduct exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<SubCategoriesM> getAllSubSubCategories(String scid) async {
    try {
      final url = ApiUrl.GET_SUB_SUB_CATEGORIES + scid + "&api=$authToken";

      // showLog("getAllSubSubCategories request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getAllSubSubCategories response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        SubCategoriesM model = SubCategoriesM.fromJson(jsonDecode(response.body));
        // showLog("model =======>>> ${model?.data?.length}");
        return model;
      }
    } catch (e) {
      showLog('getAllSubSubCategories exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<AllCategoryProductM> getAllSubCategoryProduct(String scid) async {
    try {
      final url = ApiUrl.All_SUB_CATEGORIES_PRODUCTS + scid + "&api=$authToken";

      showLog("getAllSubCategoryProduct request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getAllSubCategoryProduct response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        AllCategoryProductM model = AllCategoryProductM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getAllSubCategoryProduct exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<SearchProductM> getSearchedProducts(String query) async {
    try {
      final url = ApiUrl.SEARCH_PRODUCTS + query + "&api=$authToken";

      showLog("getSearchedProducts request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getSearchedProducts response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        SearchProductM model = SearchProductM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getSearchedProducts exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<AvailabilityM> checkAvailability(String pincode) async {
    try {
      final url = ApiUrl.CHECK_AVAILABILITY + deliveryToken + "&filter_codes=$pincode";

      // showLog("checkAvailability request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("checkAvailability response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        AvailabilityM model = AvailabilityM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('checkAvailability exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<OrdersM> getOrders(String userId) async {
    try {
      final url = ApiUrl.GET_ORDERS + '$userId&api=$authToken';

      // showLog("getOrders request =======>>> $url");

      var response = await getHttpClient().get(url);

      // showLog("getOrders response =======>>> ${response?.body}");

      if (response != null && response.statusCode == Strings.ok) {
        OrdersM model = OrdersM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getOrders exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [getUserProfile] which will call the rest api for the get single user info.
  /// It will take in the [userId] and will give output as either [Exception] or the [LoginModel].
  @override
  Future<LoginModel> getUserProfile(String userId) async {
    try {
      var response = await getHttpClient().get(ApiUrl.USER_PROFILE + '$userId&api=$authToken');
      showLog("user profile response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.body));
        return loginModel;
      }
    } catch (e) {
      showLog('user profile exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [getCountries] which will call the rest api for the get list of countries.
  /// It will give output as either [Exception] or the [CountryModel].
  @override
  Future<CountryModel> getCountries() async {
    try {
      var response = await getHttpClient().get(ApiUrl.GET_COUNTRIES + authToken);
      // showLog("Country response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        CountryModel countryModel = CountryModel.fromJson(jsonDecode(response.body));
        return countryModel;
      }
    } catch (e) {
      showLog('Country exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [getStates] which will call the rest api for the get list of state.
  /// It will take in the country id and give output as either [Exception] or the [StateModel].
  @override
  Future<StateModel> getStates(String countryId) async {
    try {
      var response = await getHttpClient().get(ApiUrl.GET_STATE + '$countryId&api=$authToken');
      // showLog("State response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        StateModel stateModel = StateModel.fromJson(jsonDecode(response.body));
        return stateModel;
      }
    } catch (e) {
      showLog('State exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [getCities] which will call the rest api for the get list of Cities.
  /// It will take in the state id and give output as either [Exception] or the [CityModel].
  @override
  Future<CityModel> getCities(String stateId) async {
    try {
      var response = await getHttpClient().get(ApiUrl.GET_CITY + '$stateId&api=$authToken');
      // showLog("City response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        CityModel cityModel = CityModel.fromJson(jsonDecode(response.body));
        return cityModel;
      }
    } catch (e) {
      showLog('City exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [updateProfile] which will call the rest api for the update user profile.
  /// It will take in the state id and give output as either [Exception] or the [UpdateProfileModel].
  @override
  Future<UpdateProfileModel> updateProfile(Map<String, dynamic> map) async {
    try {
      showLog("Update profile request ======>>> ${map}");
      var response = await getHttpClient().post(ApiUrl.UPDATE_PROFILE + authToken, body: map);
      if (response != null && response.statusCode == Strings.ok) {
        showLog("Update profile response ======>>> ${response.body}");
        UpdateProfileModel updateModel = UpdateProfileModel.fromJson(jsonDecode(response.body));
        return updateModel;
      }
    } catch (e) {
      showLog('Update profile exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [uploadUserImage] which will call the rest api for the update user profile picture.
  /// It will take in the [File] of the selected image and give output as either [Exception] or the
  /// [ProfilePicUpdateModel].
  @override
  Future<ProfilePicUpdateModel> uploadUserImage(File userImage, String userId) async {
    try {
      final url = Uri.parse(ApiUrl.UPDATE_PROFILE_PICTURE + authToken);
      var request = new http.MultipartRequest('POST', url);
      request.fields['u_id'] = userId;
      final file = await userImage?.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'u_img',
          file ?? [],
          filename: "user_${userId}_image_${DateTime.now().toIso8601String()}}.jpg",
          contentType: MediaType("image", "jpg"),
        ),
      );
      var response = await request.send();
      final data = await http.ByteStream(response.stream).bytesToString();
      showLog("Update profile pic response ======>>> $data");
      if (response != null && response.statusCode == Strings.ok) {
        ProfilePicUpdateModel updateModel = ProfilePicUpdateModel.fromJson(jsonDecode(data));
        return updateModel;
      }
    } catch (e) {
      showLog('Update profile pic exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [userCardData] which will call the rest api for fetching the user's cart data.
  /// It will take in the [userId] and give output as either [Exception] or the [CartDataModel].
  @override
  Future<SharedModel> removeUserImage(String userId) async {
    try {
      final url = ApiUrl.REMOVE_PROFILE_PIC + '$authToken&u_id=$userId';

      showLog("removeUserImage request ======>>> $url");

      var response = await getHttpClient().get(url);
      if (response != null && response.statusCode == Strings.ok) {
        showLog("removeUserImage response ======>>> ${response.body}");
        SharedModel model = SharedModel.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('User cart exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<CartDataModel> userCardData(String userId) async {
    try {
      showLog("user cart request ======>>> $userId");
      var response = await getHttpClient().get(ApiUrl.USER_CART_DATA + '$userId&api=$authToken');
      if (response != null && response.statusCode == Strings.ok) {
        // showLog("User cart response ======>>> ${response.body}");
        CartDataModel cartModel = CartDataModel.fromJson(jsonDecode(response.body));
        return cartModel;
      }
    } catch (e) {
      showLog('User cart exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [addToCart] which will call the rest api for adding product in the user's cart.
  /// It will take in the product data and give output as either [Exception] or the [AddToCartModel].
  @override
  Future<AddToCartModel> addToCart(Map<String, dynamic> cartData) async {
    try {
      showLog("Add to Cart request ======>>> $cartData");
      var response = await getHttpClient().post(ApiUrl.ADD_TO_CART + authToken, body: cartData);
      showLog("Add to Cart response ======>>> ${response.body}");
      if (response != null) {
        AddToCartModel addToCartModel = AddToCartModel.fromJson(jsonDecode(response.body));
        return addToCartModel;
      }
    } catch (e) {
      showLog('Add to Cart exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [increaseCartItemQty] which will call the rest api for increasing quantity in user's cart.
  /// It will take in the product data and give output as either [Exception] or the [CartItemManipulationModel].
  @override
  Future<CartItemManipulationModel> increaseCartItemQty(String cartId) async {
    try {
      showLog("Item quantity increase request ======>>> $cartId");
      var response = await getHttpClient().get(ApiUrl.INCREASE_CART_QTY + '$cartId&api=$authToken');
      if (response != null && response.statusCode == Strings.ok) {
        showLog("Item quantity increase response ======>>> ${response.body}");
        CartItemManipulationModel itemManipulationModel =
            CartItemManipulationModel.fromJson(jsonDecode(response.body));
        return itemManipulationModel;
      }
    } catch (e) {
      showLog('Item quantity increase exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [decreaseCartItemQty] which will call the rest api for decreasing quantity in user's cart.
  /// It will take in the product data and give output as either [Exception] or the [CartItemManipulationModel].
  @override
  Future<CartItemManipulationModel> decreaseCartItemQty(String cartId) async {
    try {
      showLog("Item quantity decrease request ======>>> $cartId");
      var response = await getHttpClient().get(ApiUrl.DECREASE_CART_QTY + '$cartId&api=$authToken');
      if (response != null && response.statusCode == Strings.ok) {
        showLog("Item quantity decrease response ======>>> ${response.body}");
        CartItemManipulationModel itemManipulationModel =
            CartItemManipulationModel.fromJson(jsonDecode(response.body));
        return itemManipulationModel;
      }
    } catch (e) {
      showLog('Item quantity decrease exception ======>>>> $e');
    }
    return null;
  }

  /// Overridden function [removeCartItemQty] which will call the rest api for removing the product from user's cart.
  /// It will take in the product data and give output as either [Exception] or the [CartItemManipulationModel].
  @override
  Future<CartItemManipulationModel> removeCartItemQty(String cartId) async {
    try {
      showLog("Item removed request ======>>> $cartId");
      var response = await getHttpClient().get(ApiUrl.REMOVE_CART_QTY + '$cartId&api=$authToken');
      if (response != null && response.statusCode == Strings.ok) {
        showLog("Item removed response ======>>> ${response.body}");
        CartItemManipulationModel itemManipulationModel =
            CartItemManipulationModel.fromJson(jsonDecode(response.body));
        return itemManipulationModel;
      }
    } catch (e) {
      showLog('Item removed exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<FilterProductM> getFilteredProduct(
      String catId, String lowerPrice, String upperPrice, String size, String color) async {
    try {
      final url = ApiUrl.FILTER_PRODUCT +
          '$catId&$size&color=$color&plow=$lowerPrice&phigh=$upperPrice&api=$authToken';
      showLog("getFilteredProduct request ======>>> $url");
      var response = await getHttpClient().get(url);
      showLog("getFilteredProduct response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        FilterProductM model = FilterProductM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getFilteredProduct exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<FilterM> getFilterType(String catId, String type) async {
    try {
      final url = ApiUrl.FILTER_TYPE + '$type&id=$catId&api=$authToken';

      showLog("getFilterType request ======>>> $url");
      var response = await getHttpClient().get(url);
      showLog("getFilterType response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        FilterM model = FilterM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getFilterType exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<OrderDetailsM> getOrderDetails(String waybill) async {
    try {
      final url = ApiUrl.ORDERS_DETAILS + '$deliveryToken&waybill=$waybill&api=$authToken';

      showLog("getOrderDetails request ======>>> $url");
      var response = await getHttpClient().get(url);
      // showLog("getOrderDetails response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        OrderDetailsM model = OrderDetailsM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('getOrderDetails exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<InsertReviewModel> insertProductReview(Map<String, dynamic> productReviewMap) async {
    try {
      showLog("InsertReview request ======>>> $productReviewMap");
      var response = await getHttpClient().post(ApiUrl.INSERT_REVIEW + authToken, body: productReviewMap);
      showLog("InsertReview response ======>>> ${response.body}");
      if (response != null) {
        InsertReviewModel insertReviewModel = InsertReviewModel.fromJson(jsonDecode(response.body));
        return insertReviewModel;
      }
    } catch (e) {
      showLog('InsertReview exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<OtpModel> sendOtp(String phoneNumber) async {
    try {
      var response = await getHttpClient().get(ApiUrl.OTP_SEND + phoneNumber + '/AUTOGEN/USCLB-OTP');
      showLog("OTP response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        OtpModel model = OtpModel.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('OTP exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<OtpModel> verifyOtp(String sessionId, String otpInput) async {
    try {
      var response = await getHttpClient().get(ApiUrl.OTP_VERIFY + sessionId + '/$otpInput');
      showLog("OTP Verify response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        OtpModel model = OtpModel.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('OTP verify exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<CancelOrderModel> cancelOrder(Map<String, dynamic> cancelMap) async {
    try {
      showLog("Cancel Order request ======>>> $cancelMap");
      var response = await getHttpClient().post(ApiUrl.CANCEL_ORDER + deliveryToken,
          body: json.encode(cancelMap),
          headers: {'Authorization': 'Token $deliveryToken', 'Content-Type': 'application/json'});
      showLog("Cancel Order response ======>>> ${response.body}");
      if (response != null && response.statusCode == 200) {
        Xml2Json xml2json = new Xml2Json();
        xml2json.parse(response.body);
        var jsonData = xml2json.toGData();
        CancelOrderModel cancelModel = CancelOrderModel.fromJson(jsonDecode(jsonData));
        return cancelModel;
      }
    } catch (e) {
      showLog('Cancel Order exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<CreateOrderM> createOrder(Map<String, dynamic> map) async {
    try {
      final url = ApiUrl.CREATE_ORDER + authToken;

      showLog("createOrder url =======>>> $url");
      showLog("createOrder request =======>>> $map");

      var response = await getHttpClient().post(url, body: map);
      showLog("createOrder response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        CreateOrderM model = CreateOrderM.fromJson(jsonDecode(response.body));
        return model;
      }
    } catch (e) {
      showLog('createOrder exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<ReturnOrderModel> returnOrder(Map<String, dynamic> returnMap) async {
    try {
      showLog("Return Order request ======>>> $returnMap");
      var response = await getHttpClient().post(ApiUrl.RETURN_ORDER,
          body: 'format=json&data=${json.encode(returnMap)}',
          headers: {'Authorization': 'Token $deliveryToken', 'Content-Type': 'application/json'});
      showLog("Return Order response ======>>> ${response.body}");
      if (response != null && response.statusCode == 200) {
        ReturnOrderModel returnOrderModel = returnOrderModelFromJson(response.body.toString());
        return returnOrderModel;
      }
    } catch (e) {
      showLog('Return Order exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<ChangeOrderStatusModel> changeOrderStatus(String orderId, String status) async {
    try {
      var response =
          await getHttpClient().get(ApiUrl.CHANGE_ORDER_STATUS + '$orderId&status=$status&api=$authToken');
      showLog("Change order status response ======>>> ${response.body}");
      if (response != null && response.statusCode == Strings.ok) {
        ChangeOrderStatusModel model = changeOrderStatusModelFromJson(response.body.toString());
        return model;
      }
    } catch (e) {
      showLog('Change order status exception ======>>>> $e');
    }
    return null;
  }

  @override
  Future<CheckPhoneModel> checkPhoneNumber(String phoneNumber) async {
    try {
      var response = await getHttpClient().get(ApiUrl.CHECK_PHONE_NUMBER + '$authToken&u_mob=$phoneNumber');
      showLog("Check phone response ======>>> ${response.body}");
      if (response != null) {
        CheckPhoneModel model = checkPhoneModelFromJson(response.body.toString());
        return model;
      }
    } catch (e) {
      showLog('Check phone response exception ======>>>> $e');
    }
    return null;
  }
}

sampleDio() {
// try {
//       showLog('updateUserProfile map ======>>> $map');
//
//       await isRefreshToken();
//
//       if (map.containsKey("image")) {
//         final url = Uri.parse(ApiUrls.EDIT_PROFILE);
//         var request = new http.MultipartRequest("POST", url);
//
//         map.forEach((key, value) {
//           if (key != "image") request.fields[key] = value.toString();
//         });
//
//         showLog("updateUserProfile dio request ====> ${request.fields}");
//
//         final file = await File(map['image']).readAsBytes();
//
//         request.files.add(
//           new http.MultipartFile.fromBytes(
//             'image',
//             file,
//             filename: "user_document_${DateTime.now().toIso8601String()}${map["ext"]}",
//             contentType: MediaType(map["ext"], map["ext"]),
//           ),
//         );
//
//         request.headers.addAll(getHttpHeaders());
//
//         var response = await request.send();
//
//         final data = await http.ByteStream(response.stream).bytesToString();
//
//         showLog('updateUserProfile http response =======>>> $data');
//
//         if (response != null && response.statusCode == 200) {
//           UserProfileM model = UserProfileM.fromJson(jsonDecode(data));
//           return model;
//         }
//       } else {
//         showLog("updateUserProfile http request ====> $map");
//
//         var response = await http.post(
//           ApiUrls.EDIT_PROFILE,
//           body: map,
//           headers: getHttpHeaders(),
//         );
//
//         showLog('updateUserProfile http response =======>>> ${response.body}');
//
//         if (response != null && response.body != null && response.body != '') {
//           UserProfileM model = UserProfileM.fromJson(jsonDecode(response.body));
//           return model;
//         }
//       }
//
//       /*FormData formData = FormData.fromMap(map);
//       var response = await dio.post(
//         ApiUrls.EDIT_PROFILE,
//         data: formData,
//         options: Options(headers: getHeaders()),
//       );
//
// //    showLog('updateUserProfile response =====>>> ${response.data}');
//
//       if (response != null && response.data != null && response.data != '') {
//         UserProfileM model = UserProfileM.fromJson(response.data);
//         return model;
//       }*/
//     } catch (e) {
//       showLog('updateUserProfile exception ======>>>> $e');
//     }
}
