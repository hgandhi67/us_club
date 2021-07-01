import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/generated/assets.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/widgets/base_scaffold.dart';
import 'package:us_club/widgets/enums/app_enums.dart';
import 'package:us_club/widgets/widgets.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// Variable for the cart data list
  List<CartData> cartList = List();

  /// Variable for the providers
  CartProvider cartProvider;
  LoginData currentUser;

  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  Map<String, dynamic> map;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      child: ConfirmCheckoutTypeDialog(
        onCheckoutType: (type) {
          Navigator.of(context).pop(type);
        },
      ),
    ) as CheckoutType;

    if (result == null) {
      return;
    }

    switch (result) {
      case CheckoutType.NOT_NOW:
        return;
        break;
      case CheckoutType.COD:
        final result = await navigator.navigateTo(
          Routes.confirmCartDetailsScreen,
          arguments: ConfirmCartDetailsScreenArguments(isCOD: true),
        ) as Map<String, dynamic>;

        showLog("result COD =======>>> $result");

        if (result == null) {
          showLog("oops we can't proceed here");
          return;
        }

        map = result;

        createOrder("1");
        break;
      case CheckoutType.ONLINE:
        final result = await navigator.navigateTo(Routes.confirmCartDetailsScreen) as Map<String, dynamic>;

        showLog("result ONLINE =======>>> $result");

        if (result == null) {
          showLog("oops we can't proceed here");
          return;
        }

        map = result;

        openOnlineCheckout();
        break;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // showToast("SUCCESS: " + response.paymentId);
    showLog("_handlePaymentSuccess paymentId =======>>> ${response.paymentId}");
    showLog("_handlePaymentSuccess orderId =======>>> ${response.orderId}");
    showLog("_handlePaymentSuccess signature =======>>> ${response.signature}");
    createOrder("2");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // showToast("ERROR: " + response.code.toString() + " - " + response.message);
    showLog("_handlePaymentError code =======>>> ${response.code}");
    showLog("_handlePaymentError message =======>>> ${response.message}");
    showFailedDialog();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // showToast("EXTERNAL_WALLET: " + response.walletName);
    showLog("_handleExternalWallet =======>>> ${response.walletName}");
  }

  Future<void> createOrder(String paymentType) async {
    showLog("createOrder map =====>>> $map");

    if (map != null) {
      showLoader();

      /// paymentType 1 = COD
      /// paymentType 2 = ONLINE or RazorPay

      map.update("payment", (value) => paymentType, ifAbsent: () => paymentType);

      final kResponse = await cartProvider.createOrder(map);

      hideLoader();

      if (kResponse != null) {
        if (kResponse.data.isNotNull && !kResponse.data.cartData.isNullOrEmpty) {
          if (kResponse.data.status == "Successfully Created") {
            showSuccessDialog();
            context.read<OrdersProvider>().getOrders(currentUser.id);
            cartProvider.clearCartList();
          } else {
            showFailedDialog();
          }
        } else {
          showFailedDialog();
        }
      } else {
        showFailedDialog();
      }
    } else {
      showFailedDialog();
    }
  }

  openOnlineCheckout() async {
    final amount = (getSubtotal() + getTax()).toInt() * 100;

    final user = context.read<AuthProvider>().currentUser;

    String desc = '';

    cartList.forEach((element) {
      desc += element.cartDesc + ", ";
    });

    desc = desc.substring(0, desc.length - 2) + ".";

    final options = {
      'key': 'rzp_test_QzxJdusuNqNafe',
      'amount': amount,
      'name': user.userName,
      'description': desc,
      'prefill': {
        'contact': user.userMobile,
        'email': user.userEmail,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    showLog("options for razor pay =======>>> $options");

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("openCheckout exception ======>> $e");
    }
  }

  showFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatusDialog(
        type: 'failed',
        message:
            "Oop\'s snapp!!\n\nLooks like something went wrong please try again later after sometime. Thank you!",
        lottieImage: Assets.assetsFailed,
      ),
    );
  }

  showSuccessDialog() async {
    final response = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const StatusDialog(
        type: 'success',
        message: "Congratulations!!\n\nYour order has been placed successfully.",
        lottieImage: Assets.assetsSuccess,
      ),
    );

    context.read<IndexProvider>().setIndex(2);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    currentUser = Provider.of<AuthProvider>(context).currentUser;
    cartList = cartProvider.cartDataList;
    return BaseScaffold(
      isAppbar: true,
      elevation: 0.0,
      appBarColor: Colors.white,
      backgroundColor: Palette.greyLight,
      isDrawer: false,
      title: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Image.asset(
          ImagesLink.app_logo,
          height: 33,
          fit: BoxFit.cover,
        ),
      ),
      leading: BackButton(color: Palette.grey),
      action: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Palette.grey,
            ),
            onPressed: () {
              navigator.navigateTo(
                Routes.searchScreen,
                arguments: SearchScreenArguments(query: "", isSearch: true),
              );
            },
          ),
        ],
      ),
      child: cartList.isNullOrEmpty ? emptyCartItem() : cartListWidget(),
    );
  }

  /// Widget function which will give the list of the cart Items.
  Widget cartListWidget() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    return _singleCartItem(cartList[index]);
                  },
                ),
                const SizedBox(height: 12.0),
                _checkoutLayout(),
              ],
            ),
          ),
        ),
        SafeArea(
          child: FlatButton(
            color: Palette.accentColor,
            onPressed: openCheckout,
            height: kToolbarHeight,
            child: Center(
              child: Texts('CHECKOUT', color: Palette.white, fontFamily: semiBold, fontSize: 18.0),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget function which returns the UI for the cart empty state.
  Widget emptyCartItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: screenHeight * 0.18, color: Palette.accentColor),
        const SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.5),
              child: Icon(Icons.arrow_back, color: Palette.accentColor, size: 20.0),
            ),
            const SizedBox(width: 5.0),
            NoDataFound(
              msg: "Back to home",
              size: 14.0,
              color: Palette.accentColor,
              onTap: () {
                context.read<IndexProvider>().setIndex(0);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Widget function which gives the UI and data for the checkout.
  Widget _checkoutLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      color: Colors.white,
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Texts('CHECKOUT DETAILS', fontSize: 18.0, fontFamily: semiBold, color: Palette.grey),
          const SizedBox(height: 15.0),
          singleCheckoutField('Sub Total', '${Strings.r}${getSubtotal().toString()}', 16.0, Palette.grey),
          const SizedBox(height: 15.0),
          singleCheckoutField('Delivery Charge', '${Strings.r}${getTax().toString()}', 16.0, Palette.grey),
          const SizedBox(height: 15.0),
          singleCheckoutField(
              'Total', '${Strings.r}${(getSubtotal() + getTax()).toString()}', 18.0, Palette.black),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }

  /// Widget function which gives the single checkout field UI.
  Widget singleCheckoutField(String rowTitle, String rowValue, double fontSize, Color color) {
    return Row(
      children: [
        Expanded(child: Texts(rowTitle, fontSize: fontSize, fontFamily: semiBold, color: color)),
        Expanded(child: Texts(rowValue, fontSize: fontSize, fontFamily: semiBold, color: color)),
      ],
    );
  }

  /// Widget function which gives the UI for the single cart item.
  Widget _singleCartItem(CartData cartData) {
    List<StoreDetail> storeDetail = Provider.of<HomeProvider>(context).storeDetails;
    StoreDetail discount = storeDetail.firstWhere((element) => element.type == 'discount');
    final discountPrice = (cartData.price.toInt() -
            ((cartData.price.toInt() * (discount != null ? discount.value.toInt() : 0)) / 100))
        .toStringAsFixed(0);

    showLog("cartData =======>>> ${cartData?.toJson()}");

    return Column(
      children: [
        Container(
          color: Palette.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Texts(
                      cartData.proName,
                      fontSize: 16.0,
                      fontFamily: semiBold,
                      color: Palette.black,
                    ),
                    const SizedBox(width: 8.0),
                    Row(
                      children: [
                        Texts("${Strings.r}$discountPrice/-   ", color: Palette.black, fontSize: 14),
                        Texts("${Strings.r}${cartData.price}/-",
                            color: Palette.greyLight2,
                            fontSize: 14,
                            textDecoration: TextDecoration.lineThrough),
                        Texts("   ${discount != null ? discount.value : 0}% OFF",
                            color: Palette.red, fontSize: 14),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Texts("${cartData.cartDesc}"),
                    const SizedBox(height: 8.0),
                    manipulationWidget(cartData),
                  ],
                ),
              ),
              const SizedBox(width: 15.0),
              ProfileImage(
                height: screenWidth * 0.15,
                width: screenWidth * 0.15,
                imageUrl: cartData.imgLink,
                isRound: false,
                fit: BoxFit.contain,
                onTap: () {
                  final product = Product.fromJson(cartData.toJson());

                  navigator.navigateTo(Routes.productDetails,
                      arguments: ProductDetailsArguments(product: product));
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  /// Widget function which gives the UI and functionality for the manipulation menu like increase, decrease quantity
  /// and the remove item.
  Widget manipulationWidget(CartData cartData) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Palette.grey)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                onTap: () => increaseCartItem(cartData.cartId),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Icon(Icons.add, color: Palette.accentColor, size: 21.0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                color: Palette.greyLight,
                child: Center(
                  child: Texts(cartData.qty),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (int.parse(cartData.qty) <= 1) {
                    showToast('Quantity cannot be less than 1.');
                    return;
                  }
                  decreaseCartItem(cartData.cartId);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Icon(Icons.remove, color: Palette.grey, size: 21.0),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15.0),
        InkWell(
          splashColor: Colors.transparent,
          onTap: () => removeCartItem(cartData.cartId),
          child: Icon(Icons.delete_forever, color: Palette.accentColor, size: 28.0),
        ),
      ],
    );
  }

  double getSubtotal() {
    double subtotal = 0.0;
    cartList
        .map((e) => subtotal +=
            ((double.parse(e.price) - ((e.price.toInt() * discount) / 100)) * double.parse(e.qty)))
        .toList();
    return subtotal;
  }

  double getTax() {
    return getSubtotal().toInt() < 1000 ? 90.0 : 0.0;
  }

  /// Group of functions which will perform all the manipulation functionality.
  void increaseCartItem(String cartId) {
    cartProvider.cartItemManipulation(CartManipulationType.INCREASE, cartId, currentUser.id);
  }

  void decreaseCartItem(String cartId) {
    cartProvider.cartItemManipulation(CartManipulationType.DECREASE, cartId, currentUser.id);
  }

  void removeCartItem(String cartId) {
    cartProvider.cartItemManipulation(CartManipulationType.REMOVE, cartId, currentUser.id);
  }
}

class StatusDialog extends StatelessWidget {
  final String type;
  final String message;
  final String lottieImage;

  const StatusDialog({
    Key key,
    this.type = 'success',
    @required this.message,
    @required this.lottieImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Texts(
            message,
            textAlign: TextAlign.center,
            fontFamily: bold,
            fontSize: 20,
          ),
          const SizedBox(height: 20),
          Lottie.asset(
            lottieImage,
            width: type == 'success' ? 150 : null,
            height: type == 'success' ? 150 : null,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 10),
          child: FlatButton(
            color: context.accentColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Texts("Ok"),
          ),
        )
      ],
    );
  }
}

class ConfirmCheckoutTypeDialog extends StatelessWidget {
  final Function(CheckoutType) onCheckoutType;

  const ConfirmCheckoutTypeDialog({Key key, this.onCheckoutType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Texts(
                  "Payment",
                  fontSize: 18.0,
                  fontFamily: semiBold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Texts(
                  "How would you like to pay for this\ntransaction ?",
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => onCheckoutType?.call(CheckoutType.NOT_NOW),
                    height: 40,
                    child: Texts(
                      "not now".toUpperCase(),
                      fontFamily: semiBold,
                    ),
                  ),
                  FlatButton(
                    onPressed: () => onCheckoutType?.call(CheckoutType.COD),
                    height: 40,
                    padding: const EdgeInsets.only(),
                    child: Texts(
                      "Cash on Delivery".toUpperCase(),
                      fontFamily: semiBold,
                    ),
                  ),
                  FlatButton(
                    onPressed: () => onCheckoutType?.call(CheckoutType.ONLINE),
                    height: 40,
                    child: Texts(
                      "pay online".toUpperCase(),
                      fontFamily: semiBold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
