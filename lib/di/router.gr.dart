// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../model/models.dart';
import '../ui/screens.dart';

class Routes {
  static const String loginScreen = '/login-screen';
  static const String mainScreen = '/main-screen';
  static const String productDetails = '/product-details';
  static const String otpScreen = '/otp-screen';
  static const String registerScreen = '/register-screen';
  static const String subCategoriesScreen = '/sub-categories-screen';
  static const String searchScreen = '/search-screen';
  static const String imagePreviewScreen = '/image-preview-screen';
  static const String updateProfilePage = '/update-profile-page';
  static const String cartPage = '/cart-page';
  static const String orderDetailsScreen = '/order-details-screen';
  static const String confirmCartDetailsScreen = '/confirm-cart-details-screen';
  static const all = <String>{
    loginScreen,
    mainScreen,
    productDetails,
    otpScreen,
    registerScreen,
    subCategoriesScreen,
    searchScreen,
    imagePreviewScreen,
    updateProfilePage,
    cartPage,
    orderDetailsScreen,
    confirmCartDetailsScreen,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.mainScreen, page: MainScreen),
    RouteDef(Routes.productDetails, page: ProductDetails),
    RouteDef(Routes.otpScreen, page: OtpScreen),
    RouteDef(Routes.registerScreen, page: RegisterScreen),
    RouteDef(Routes.subCategoriesScreen, page: SubCategoriesScreen),
    RouteDef(Routes.searchScreen, page: SearchScreen),
    RouteDef(Routes.imagePreviewScreen, page: ImagePreviewScreen),
    RouteDef(Routes.updateProfilePage, page: UpdateProfilePage),
    RouteDef(Routes.cartPage, page: CartPage),
    RouteDef(Routes.orderDetailsScreen, page: OrderDetailsScreen),
    RouteDef(Routes.confirmCartDetailsScreen, page: ConfirmCartDetailsScreen),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LoginScreen: (data) {
      final args = data.getArgs<LoginScreenArguments>(
        orElse: () => LoginScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginScreen(moveBackRoute: args.moveBackRoute),
        settings: data,
      );
    },
    MainScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MainScreen(),
        settings: data,
      );
    },
    ProductDetails: (data) {
      final args = data.getArgs<ProductDetailsArguments>(
        orElse: () => ProductDetailsArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProductDetails(product: args.product),
        settings: data,
      );
    },
    OtpScreen: (data) {
      final args = data.getArgs<OtpScreenArguments>(
        orElse: () => OtpScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => OtpScreen(
          key: args.key,
          moveBackRoute: args.moveBackRoute,
        ),
        settings: data,
      );
    },
    RegisterScreen: (data) {
      final args = data.getArgs<RegisterScreenArguments>(
        orElse: () => RegisterScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => RegisterScreen(
          key: args.key,
          moveBackRoute: args.moveBackRoute,
          phoneNumber: args.phoneNumber,
        ),
        settings: data,
      );
    },
    SubCategoriesScreen: (data) {
      final args = data.getArgs<SubCategoriesScreenArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SubCategoriesScreen(
          menuBar: args.menuBar,
          cid: args.cid,
          isCid: args.isCid,
          scid: args.scid,
          isScid: args.isScid,
        ),
        settings: data,
      );
    },
    SearchScreen: (data) {
      final args = data.getArgs<SearchScreenArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchScreen(
          isSearch: args.isSearch,
          subCatId: args.subCatId,
          query: args.query,
          showSearch: args.showSearch,
          isViewMore: args.isViewMore,
        ),
        settings: data,
      );
    },
    ImagePreviewScreen: (data) {
      final args = data.getArgs<ImagePreviewScreenArguments>(
        orElse: () => ImagePreviewScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ImagePreviewScreen(
          imagesList: args.imagesList,
          index: args.index,
          tag: args.tag,
        ),
        settings: data,
      );
    },
    UpdateProfilePage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => UpdateProfilePage(),
        settings: data,
      );
    },
    CartPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CartPage(),
        settings: data,
      );
    },
    OrderDetailsScreen: (data) {
      final args = data.getArgs<OrderDetailsScreenArguments>(
        orElse: () => OrderDetailsScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrderDetailsScreen(
          key: args.key,
          order: args.order,
        ),
        settings: data,
      );
    },
    ConfirmCartDetailsScreen: (data) {
      final args = data.getArgs<ConfirmCartDetailsScreenArguments>(
        orElse: () => ConfirmCartDetailsScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ConfirmCartDetailsScreen(
          key: args.key,
          isCOD: args.isCOD,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginScreen arguments holder class
class LoginScreenArguments {
  final String moveBackRoute;
  LoginScreenArguments({this.moveBackRoute});
}

/// ProductDetails arguments holder class
class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({this.product});
}

/// OtpScreen arguments holder class
class OtpScreenArguments {
  final Key key;
  final String moveBackRoute;
  OtpScreenArguments({this.key, this.moveBackRoute});
}

/// RegisterScreen arguments holder class
class RegisterScreenArguments {
  final Key key;
  final String moveBackRoute;
  final String phoneNumber;
  RegisterScreenArguments({this.key, this.moveBackRoute, this.phoneNumber});
}

/// SubCategoriesScreen arguments holder class
class SubCategoriesScreenArguments {
  final Menubar menuBar;
  final String cid;
  final bool isCid;
  final String scid;
  final bool isScid;
  SubCategoriesScreenArguments(
      {@required this.menuBar,
      @required this.cid,
      @required this.isCid,
      @required this.scid,
      @required this.isScid});
}

/// SearchScreen arguments holder class
class SearchScreenArguments {
  final bool isSearch;
  final String subCatId;
  final String query;
  final bool showSearch;
  final bool isViewMore;
  SearchScreenArguments(
      {@required this.isSearch,
      this.subCatId,
      this.query,
      this.showSearch = true,
      this.isViewMore = false});
}

/// ImagePreviewScreen arguments holder class
class ImagePreviewScreenArguments {
  final List<Media> imagesList;
  final int index;
  final String tag;
  ImagePreviewScreenArguments({this.imagesList, this.index, this.tag});
}

/// OrderDetailsScreen arguments holder class
class OrderDetailsScreenArguments {
  final Key key;
  final Order order;
  OrderDetailsScreenArguments({this.key, this.order});
}

/// ConfirmCartDetailsScreen arguments holder class
class ConfirmCartDetailsScreenArguments {
  final Key key;
  final bool isCOD;
  ConfirmCartDetailsScreenArguments({this.key, this.isCOD = false});
}
