class ApiUrl {
  static const BASE_URL = "https://usclub.in";
  static const STAGING_BASE_URL = "https://staging-express.delhivery.com";
  static const OTP_KEY = 'c8e6b834-817d-11eb-a9bc-0200cd936042';
  static const OTP_SEND = 'https://2factor.in/API/V1/$OTP_KEY/SMS/';
  static const OTP_VERIFY = 'https://2factor.in/API/V1/$OTP_KEY/SMS/VERIFY/';
  static const HOME_SCREEN = "$BASE_URL/api/home/banner?api=";
  static const RANDOM_PRODUCTS = "$BASE_URL/api/home/home_product?";
  static const LOGIN = "$BASE_URL/api/sp_users/login?api=";
  static const REGISTER = "$BASE_URL/api/sp_users/signup_user.php?api=";
  static const EXPLORE_PRODUCTS = "$BASE_URL/api/home/explore?api=";
  static const PRODUCT_DETAILS = "$BASE_URL/api/sp_product/getProductById?api=";
  static const PRODUCT_REVIEWS = "$BASE_URL/api/sp_review/getAllProductReview?pid=";

  static const SINGLE_PRODUCT_VARIANT = "$BASE_URL/api/sp_pro_type/getAllProductDescription?api=";

  static const GET_SUB_CATEGORIES = "$BASE_URL/api/sp_subcat/getAllCatSubcat.php?cid=";
  static const All_CATEGORIES_PRODUCTS = "$BASE_URL/api/sp_product/getAllCategoryProduct.php?cid=";

  static const GET_SUB_SUB_CATEGORIES = "$BASE_URL/api/sp_subcat_type/getAllSubcatSubcatType.php?scid=";
  static const All_SUB_CATEGORIES_PRODUCTS = "$BASE_URL/api/sp_product/getAllSubcatProduct.php?scid=";

  static const SEARCH_PRODUCTS = "$BASE_URL/api/search/sp_search?q=";
  static const USER_PROFILE = "$BASE_URL/api/sp_users/getSingleUsers.php?uid=";
  static const CHECK_AVAILABILITY = "$STAGING_BASE_URL/c/api/pin-codes/json/?token=";

  static const GET_COUNTRIES = "$BASE_URL/api/location/getCountry.php?api=";
  static const GET_STATE = "$BASE_URL/api/location/getStateByCountry.php?country_id=";
  static const GET_CITY = "$BASE_URL/api/location/getCityByState.php?state_id=";
  static const UPDATE_PROFILE = "$BASE_URL/api/sp_users/update_user?api=";
  static const UPDATE_PROFILE_PICTURE = "$BASE_URL/api/sp_users/changeProfileImage.php?api=";
  static const USER_CART_DATA = "$BASE_URL/api/sp_cart/getAllUserCart.php?id=";
  static const REMOVE_PROFILE_PIC = "$BASE_URL/api/sp_users/removeProfile?api=";

  static const ADD_TO_CART = "$BASE_URL/api/sp_cart/addProductToCart?api=";
  static const INCREASE_CART_QTY = "$BASE_URL/api/sp_cart/increaseCartQty.php?cart_id=";
  static const DECREASE_CART_QTY = "$BASE_URL/api/sp_cart/decreaseCartQty.php?cart_id=";
  static const REMOVE_CART_QTY = "$BASE_URL/api/sp_cart/deletecart.php?cart_id=";
  static const FILTER_TYPE = "$BASE_URL/api/filter/filter?type=";

  static const FILTER_PRODUCT = "$BASE_URL/api/filter/filteredProduct?cat=";
  static const GET_ORDERS = "$BASE_URL/api/orders/getOrders?u_id=";
  static const ORDERS_DETAILS = "$STAGING_BASE_URL/api/v1/packages/json/?token=";
  static const INSERT_REVIEW = "$BASE_URL/api/sp_review/insertProductReview.php?api=";

  static const CANCEL_ORDER = "$STAGING_BASE_URL/api/p/edit?token=";

  static const CREATE_ORDER = "$BASE_URL/api/orders/createOrder?api=";
  static const RETURN_ORDER = "$STAGING_BASE_URL/api/cmu/create.json";
  static const CHANGE_ORDER_STATUS = "$BASE_URL/api/orders/changeOrderStatus?order_id=";
  static const CHECK_PHONE_NUMBER = "$BASE_URL/api/sp_users/checkMobile.php?api=";
}
