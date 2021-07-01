import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/generated/assets.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/auth_provider.dart';
import 'package:us_club/providers/cart_provider.dart';
import 'package:us_club/providers/home_provider.dart';
import 'package:us_club/providers/orders_provider.dart';
import 'package:us_club/ui/cart/cart_page.dart';
import 'package:us_club/ui/main_screen/widgets/cart_icon_widget.dart';
import 'package:us_club/widgets/enums/app_enums.dart';
import 'package:us_club/widgets/grey_divider.dart';
import 'package:us_club/widgets/my_tinder_swiper.dart';
import 'package:us_club/widgets/svg_image.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String pinCodeText = '';

  Razorpay _razorpay;
  LoginData currentUser;

  Map<String, dynamic> map;

  /// Variable for the cart data list
  List<CartData> cartList = List();

  /// Variable for the providers
  CartProvider cartProvider;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    pinCodeText = sharedPref.getString(Constants.PINCODE);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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

  double getSubtotal() {
    double subtotal = 0.0;
    cartList
        .map((e) => subtotal += ((double.parse(e.price) - ((e.price.toInt() * discount) / 100))))
        .toList();
    return subtotal;
  }

  double getTax() {
    return getSubtotal().toInt() < 1000 ? 90.0 : 0.0;
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

  showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const StatusDialog(
        type: 'success',
        message: "Congratulations!!\n\nYour order has been placed successfully.",
        lottieImage: Assets.assetsSuccess,
      ),
    );
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
          CartIconWidget(routeName: Routes.productDetails),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: _DetailsView(
            product: widget.product,
            pinCodeData: (pinC) => this.pinCodeText = pinC,
          )),
          BuyBar(
            buyNowClick: () {
              openCheckout();
            },
            addToCartClick: () => buyNowClick(),
          ),
        ],
      ),
    );
  }

  Future<void> buyNowClick() async {
    if (currentUser != null) {
      if (!pinCodeText.isEmptyOrNull) {
        String desc = '';

        showLog("desc before =======>>> $desc");
        cartProvider.sizes?.forEach((element) {
          if (element.isNotNull && element.isSelected) {
            showLog("element size =======>>> ${element.ptDesc}");
            desc = desc.insert(" Size :- ${element.ptDesc}", 0);
          }
        });
        cartProvider.colors?.forEach((element) {
          if (element.isNotNull && element.isSelected) {
            desc = desc.insert(", Color :- ${element.ptDesc.sCap()}", desc.length);
          }
        });

        showLog("desc after =======>>> $desc");

        Map<String, dynamic> cartData = Map();
        cartData.putIfAbsent('u_id', () => currentUser.id);
        cartData.putIfAbsent('pro_id', () => widget.product.proId);
        cartData.putIfAbsent('qty', () => '1');
        cartData.putIfAbsent('price', () => widget.product.proPrice);
        cartData.putIfAbsent('pt_id', () => widget.product.uniqueId);
        cartData.putIfAbsent('pincode', () => pinCodeText);
        cartData.putIfAbsent('cart_desc', () => desc);
        await cartProvider.addToCart(cartData, currentUser.id);
      } else {
        showToast('Please verify your pin code first.');
      }
    } else {
      navigator.navigateTo(
        Routes.loginScreen,
        arguments: LoginScreenArguments(moveBackRoute: Routes.productDetails),
      );
    }
  }

  Future<void> addToCart() async {
    String desc = '';

    showLog("desc before =======>>> $desc");
    cartProvider.sizes?.forEach((element) {
      if (element.isNotNull && element.isSelected) {
        showLog("element size =======>>> ${element.ptDesc}");
        desc = desc.insert(" Size :- ${element.ptDesc}", 0);
      }
    });
    cartProvider.colors?.forEach((element) {
      if (element.isNotNull && element.isSelected) {
        desc = desc.insert(", Color :- ${element.ptDesc}", desc.length);
      }
    });

    showLog("desc after =======>>> $desc");
    Map<String, dynamic> cartData = Map();
    cartData.putIfAbsent('u_id', () => currentUser.id);
    cartData.putIfAbsent('pro_id', () => widget.product.proId);
    cartData.putIfAbsent('qty', () => '1');
    cartData.putIfAbsent('price', () => widget.product.proPrice);
    cartData.putIfAbsent('pt_id', () => widget.product.uniqueId);
    cartData.putIfAbsent('pincode', () => pinCodeText);
    cartData.putIfAbsent('cart_desc', () => desc);
    await cartProvider.addToCart(cartData, currentUser.id, showMsg: false);
  }

  void openCheckout() async {
    if (currentUser != null) {
      if (!pinCodeText.isEmptyOrNull) {
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
            await addToCart();
            final result = await navigator.navigateTo(Routes.confirmCartDetailsScreen,
                arguments: ConfirmCartDetailsScreenArguments(
                  isCOD: true,
                )) as Map<String, dynamic>;

            showLog("result COD =======>>> $result");

            if (result == null) {
              showLog("oops we can't proceed here");
              return;
            }

            map = result;

            createOrder("1");
            break;
          case CheckoutType.ONLINE:
            await addToCart();
            final result =
                await navigator.navigateTo(Routes.confirmCartDetailsScreen) as Map<String, dynamic>;

            showLog("result ONLINE =======>>> $result");

            if (result == null) {
              showLog("oops we can't proceed here");
              return;
            }

            map = result;

            openOnlineCheckout();
            break;
        }
      } else {
        showToast('Please verify your pin code first.');
      }
    } else {
      navigator.navigateTo(
        Routes.loginScreen,
        arguments: LoginScreenArguments(moveBackRoute: Routes.productDetails),
      );
    }
  }
}

class _DetailsView extends StatefulWidget {
  final Product product;
  final Function pinCodeData;

  const _DetailsView({@required this.product, this.pinCodeData});

  @override
  __DetailsViewState createState() => __DetailsViewState();
}

class __DetailsViewState extends State<_DetailsView> {
  PData _product;

  HomeProvider _provider;
  final pincodeController = TextEditingController();
  String pincodeText;

  var reviews = 0.0;

  VariantM _variantM;

  CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();

    final pincode = sharedPref.getString(Constants.PINCODE);

    if (!pincode.isEmptyOrNull) {
      pincodeController.text = pincode;
    }

    _cartProvider = context.read<CartProvider>();

    getProductDetail();
  }

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  void getProductDetail() async {
    final response = await Future.wait([
      context.read<HomeProvider>().getProductDetails(widget.product.proId),
      context.read<HomeProvider>().getSingleProductVariant(widget.product.proId),
      // context.read<HomeProvider>().getProductDetails("128"),
      // context.read<HomeProvider>().getSingleProductVariant("128"),
    ]) as dynamic;

    if (response != null && response.isNotEmpty) {
      _product = response[0]?.data[0];
      _variantM = response[1];

      _cartProvider.colors.clear();
      _cartProvider.sizes.clear();

      if (_variantM != null && !_variantM.data.isNullOrEmpty) {
        _variantM.data.forEach((element) {
          if (element?.ptName?.toLowerCase() == 'color') {
            _cartProvider.colors.add(element);
          }

          if (element?.ptName?.toLowerCase() == 'size') {
            _cartProvider.sizes.add(element);
          }
        });
      }

      showLog("sizes =======>>> ${_cartProvider.sizes?.size}");
      showLog("colors =======>>> ${_cartProvider.colors?.size}");
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // showLog("product details =======>>> ${_product?.toJson()}");
    // showLog('reviews ===> $reviews');
    _provider = Provider.of<HomeProvider>(context);

    List<StoreDetail> storeDetail = Provider.of<HomeProvider>(context).storeDetails;
    StoreDetail discount = storeDetail.firstWhere((element) => element.type == 'discount');
    final discountPrice = (widget.product.proPrice.toInt() -
            ((widget.product.proPrice.toInt() * (discount != null ? discount.value.toInt() : 0)) / 100))
        .toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GreyDivider(
          child: Texts(
            _product.isNotNull ? "  ${_product.catName} / ${_product.subcatName} / ${_product.sctName}" : "",
            color: Palette.darkGrey,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 5),
                _ImagesSlider(
                  product: widget.product,
                  mediaList: _product?.media,
                ),
                // SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Texts(
                        widget.product.proName,
                        color: Palette.black,
                        fontSize: 15,
                      ),
                      SizedBox(height: 4),
                      AbsorbPointer(
                        absorbing: true,
                        child: RatingBar(
                          rating: reviews,
                          icon: Icon(Icons.star, size: 20, color: Colors.grey),
                          starCount: 5,
                          spacing: 5.0,
                          size: 15,
                          isIndicator: false,
                          allowHalfRating: true,
                          onRatingCallback: (double value, ValueNotifier<bool> isIndicator) {
                            isIndicator.value = true;
                          },
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Texts(
                            "${Strings.r}$discountPrice/-   ",
                            color: Palette.black,
                            fontSize: 15,
                          ),
                          Texts(
                            "${Strings.r}${widget.product.proPrice}/-",
                            color: Palette.greyLight2,
                            fontSize: 15,
                            textDecoration: TextDecoration.lineThrough,
                          ),
                          Texts(
                            "   ${discount != null ? discount.value : 0}% OFF",
                            color: Palette.red,
                            fontSize: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Texts(
                        "By ${_product?.proCompany ?? ""}",
                        color: Palette.darkGrey,
                        fontSize: 15,
                      ),
                      SizedBox(height: 10),
                      // Html(
                      //   data: _product?.proDesc.trimLeft(),
                      //   style: {
                      //     "p":Style(
                      //       color: Palette.greyLight2,
                      //     )
                      //   },
                      // ),
                      Texts(
                        "${_product?.sctName ?? ""}",
                        color: Palette.darkGrey,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
                GreyDivider(height: 6),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Texts(
                        "Sold By : ${_product?.seller ?? ""}",
                        color: Palette.darkGrey,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
                !_cartProvider.sizes.isNullOrEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Texts(
                              "Size",
                              color: Palette.black,
                              fontSize: 17,
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _cartProvider.sizes.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        // final newPrice =
                                        //     (math.max(widget.product.proPrice.toInt(), e.ptPrice.toInt()));

                                        final newPrice = e.ptPrice.toInt();

                                        widget.product.proPrice = newPrice.toString();

                                        if (!e.isSelected) {
                                          _cartProvider.sizes.forEach((element) {
                                            element.isSelected = element.ptDesc == e.ptDesc;
                                          });
                                        }
                                      });
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      // width: 25,
                                      // height: 25,
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Texts(
                                        e.ptDesc,
                                        color: e.isSelected ? context.accentColor : Palette.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                !_cartProvider.colors.isNullOrEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Texts(
                              "Colors",
                              color: Palette.black,
                              fontSize: 17,
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _cartProvider.colors.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      showLog("e =======>>> ${e.toJson()}");

                                      setState(() {
                                        final newPrice = (math.max(
                                          widget.product.proPrice.toInt(),
                                          e.ptPrice.toInt(),
                                        ));

                                        widget.product.proPrice = newPrice.toString();

                                        if (!e.isSelected) {
                                          _cartProvider.colors.forEach((element) {
                                            element.isSelected = element.colorCode == e.colorCode;
                                          });
                                        }

                                        if (e.isSelected) {
                                          showToast('Color selected ${e.ptDesc.sCap()}');
                                        }
                                      });
                                    },
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: AnimatedContainer(
                                      width: 25,
                                      height: 25,
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: e.colorCode?.toColor(),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                GreyDivider(height: 6),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Texts(
                        "Check for availability",
                        color: Palette.darkGrey,
                        fontSize: 15,
                      ),
                      const Spacers(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormFieldWidget(
                              controller: pincodeController,
                              onTextChanged: (String pincode) {
                                widget.pinCodeData(pincode);

                                showLog("pincode =======>>> $pincode");

                                if (!pincode.isEmptyOrNull && pincode.removeSpaces().length == 6) {
                                  checkAvailability();
                                }
                              },
                              hintText: "Pincode",
                            ),
                          ),
                          const Spacers(width: 10),
                          Expanded(
                            flex: 3,
                            child: FlatButton(
                              height: kToolbarHeight,
                              onPressed: checkAvailability,
                              child: Texts(
                                "Check",
                                color: context.theme.accentColor,
                                fontFamily: bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: pincodeText != null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Texts(
                            pincodeText,
                            color: Palette.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GreyDivider(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: const Texts(
                        "Ratings & Reviews",
                        color: Palette.darkGrey,
                      ),
                    ),
                    _ReviewsList(
                        pid: widget.product.proId,
                        reviewsTotal: (revs) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            if (mounted)
                              setState(() {
                                reviews = revs.toDouble();
                              });
                          });
                        }),
                  ],
                ),
                GreyDivider(height: 6),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Texts(
                        "Delivery & Services",
                        color: Palette.darkGrey,
                        fontSize: 15,
                      ),
                      SizedBox(height: 15),
                      _itemServices(Assets.svgsDelivery, "Faster Delivery"),
                      SizedBox(height: 15),
                      _itemServices(Assets.svgsCreditCard, "Cash on Delivery"),
                      SizedBox(height: 15),
                      _itemServices(Assets.svgsReturn, "7 Days Return Policy"),
                    ],
                  ),
                ),
                GreyDivider(height: 6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _itemServices(String image, String title) {
    return Row(
      children: [
        SvgImage(
          image,
          height: 20,
          width: 20,
          color: context.theme.primaryColor,
        ),
        SizedBox(width: 15),
        Expanded(
          child: Texts(
            title,
            color: Palette.greyShade,
          ),
        ),
      ],
    );
  }

  void checkAvailability() async {
    final pincode = pincodeController.text;

    showLog("checkAvailability =======>>> $pincode");

    if (pincode.removeSpaces().isEmptyORNull || pincode.length < 6) {
      showToast("Please enter valid pincode to check availability!");
      return;
    }

    showLoader();

    final response = await _provider.checkAvailability(pincode);

    if (response != null && !response.deliveryCodes.isNullOrEmpty) {
      final details = response.deliveryCodes[0].postalCode;

      pincodeText = "You are eligible for delivery ${details.stateCode}, ${details.district}!";

      sharedPref.setString(Constants.PINCODE, pincode);

      // BotToast.showText(text: "You are eligible for delivery ${details.stateCode}, ${details.district}!");
    } else {
      pincodeText = "Opp's sorry are not eligible for delivery!";
      // BotToast.showText(text: "Opp's sorry are not eligible for delivery!");
      // showToast("Opp's sorry ou are eligible for delivery!");
    }

    hideLoader();
    if (mounted) setState(() {});
  }
}

class _ReviewsList extends StatefulWidget {
  final String pid;
  final Function reviewsTotal;

  const _ReviewsList({this.pid, this.reviewsTotal});

  @override
  __ReviewsListState createState() => __ReviewsListState();
}

class __ReviewsListState extends State<_ReviewsList> {
  List<Reviews> _reviews = [];

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  void getReviews() async {
    final response = await context.read<HomeProvider>().getProductReviews(widget.pid);

    if (response != null) {
      _reviews = response.data ?? [];
    }
    double totalRating = 0.0;
    if (_reviews != null && _reviews.isNotEmpty) {
      _reviews.map((e) => totalRating += double.parse(e.rRating != null ? e.rRating : '0')).toList();
      widget.reviewsTotal(totalRating / _reviews.length);
    } else {
      widget.reviewsTotal(0);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _reviews.isNull
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: const NativeLoader(),
              )
            : _reviews.isNotEmpty && _reviews?.first?.response?.isNotNull == true
                ? Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 16),
                    child: const Texts(
                      "No reviews",
                      color: Palette.red,
                      fontSize: 15,
                    ),
                  )
                : ListView.separated(
                    itemCount: _reviews?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, index) {
                      return Divider(height: 20);
                    },
                    itemBuilder: (_, index) {
                      final item = _reviews[index];

                      return Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Texts(
                              item.rMsg.trimLeft(),
                              maxLines: 2,
                              fontFamily: semiBold,
                              overflow: TextOverflow.ellipsis,
                              color: context.theme.unselectedWidgetColor,
                            ),
                            const SizedBox(height: 5),
                            Texts(
                              "by " + item.uName + "  - Reviewed on :- ${item.rDate}",
                              color: Palette.greyShade,
                              fontSize: 13,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ],
    );

    // return Column(
    //   children: reviewsList
    //       .mapIndexed(
    //         (currentValue, index) => Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             RichText(
    //               textAlign: TextAlign.start,
    //               text: TextSpan(
    //                 children: [
    //                   TextSpan(
    //                       text: currentValue.uName.trimLeft(),
    //                       style: Styles.customTextStyle(
    //                         color: context.theme.primaryColor,
    //                       )),
    //                   TextSpan(
    //                     text: " " + currentValue.rDate,
    //                     style: Styles.customTextStyle(
    //                       color: Palette.greyShade,
    //                       fontSize: 13,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(height: 8),
    //             Texts(
    //               currentValue.rMsg,
    //               color: Palette.greyShade,
    //               fontSize: 13,
    //             ),
    //           ],
    //         ),
    //       )
    //       .toList(),
    // );
  }
}

class _ImagesSlider extends StatefulWidget {
  final Product product;
  final List<Media> mediaList;

  const _ImagesSlider({this.mediaList, this.product});

  @override
  __ImagesSliderState createState() => __ImagesSliderState();
}

class __ImagesSliderState extends State<_ImagesSlider> {
  int _currentIndex = 0;

  CardController controller; //Use this to trigger swap.

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            final list = !widget.mediaList.isNullOrEmpty
                ? widget.mediaList
                : [
                    Media(url: widget.product.imgLink),
                  ];

            navigator.navigateTo(
              Routes.imagePreviewScreen,
              arguments: ImagePreviewScreenArguments(
                imagesList: list,
                index: _currentIndex,
                tag: list[0].url,
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: screenHeight * 0.33,
            child: Swiper(
              loop: false,
              // itemWidth: 300.0,
              itemHeight: screenHeight * 0.33,
              viewportFraction: 0.8,
              scale: 0.9,
              itemCount: !widget.mediaList.isNullOrEmpty ? widget.mediaList.length : 1,
              onIndexChanged: (index) => setState(() {
                _currentIndex = index;
              }),
              itemBuilder: (_, index) {
                // var url = product.imgLink;

                if (widget.mediaList.isNull) {
                  return const NativeLoader();
                }

                if (widget.mediaList.isEmpty) {
                  final url = widget.product.imgLink;
                  return _itemImage(url);
                }

                if (!widget.mediaList.isNullOrEmpty) {
                  final url = widget.mediaList[index].url;
                  return _itemImage(url);
                }

                return NativeLoader();
              },
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: widget.mediaList.isNull || widget.mediaList.isEmpty
              ? 5
              : widget.mediaList.length == 1
                  ? 5
                  : 25,
          color: Palette.greyLight2.withOpacity(0.3),
          child: widget.mediaList.isNull || widget.mediaList.isEmpty || widget.mediaList.length == 1
              ? const SizedBox()
              : PageIndicators(
                  indicatorsList: widget.mediaList,
                  index: _currentIndex,
                  size: 8,
                  isFill: true,
                  // isScale: false,
                  activeColor: Palette.black,
                  inActiveColor: Palette.greyLight2,
                ),
        ),
      ],
    );
  }

  Widget _itemImage(String url) {
    return InteractiveViewer(
      child: Hero(
        tag: url,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
          child: CachedImage(
            url,
            isRound: false,
            width: screenWidth,
            height: screenHeight * 0.33,
            radius: 0.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class BuyBar extends StatelessWidget {
  final Function buyNowClick;
  final Function addToCartClick;

  const BuyBar({this.buyNowClick, this.addToCartClick});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            Expanded(
              child: FlatButton(
                height: kToolbarHeight,
                color: context.theme.primaryColor,
                onPressed: () => buyNowClick(),
                child: Texts(
                  "Buy now".toUpperCase(),
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                height: kToolbarHeight,
                onPressed: () => addToCartClick(),
                child: Texts(
                  "Add to cart".toUpperCase(),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
