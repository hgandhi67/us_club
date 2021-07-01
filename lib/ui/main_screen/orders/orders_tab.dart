import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/utils/export_utils.dart';
import 'package:us_club/widgets/widgets.dart';

import '../../../providers/home_provider.dart';
import '../../../providers/index_provider.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab();

  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> with AutomaticKeepAliveClientMixin {
  LoginData loginData;

  final _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();

  @override
  void initState() {
    super.initState();

    loginData = context.read<AuthProvider>().currentUser;

    if (loginData != null) {
      if (context.read<OrdersProvider>().ordersList.isNullOrEmpty) {
        context.read<OrdersProvider>().getOrders(loginData.id);
      }
    }

    // if (authToken == null) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     navigator.navigateTo(Routes.loginScreen,
    //         arguments: LoginScreenArguments(moveBackRoute: Routes.mainScreen));
    //   });
    // }
  }

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<OrdersProvider>(context);
    if (loginData == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: screenHeight * 0.18, color: Palette.accentColor),
          const SizedBox(height: 15.0),
          InkWell(
            onTap: () {
              navigator.navigateTo(
                Routes.loginScreen,
                arguments: LoginScreenArguments(moveBackRoute: Routes.mainScreen),
              );
            },
            child: const NoDataFound(
              msg: "Please login to view orders.",
              size: 14.0,
              color: Palette.accentColor,
            ),
          ),
        ],
      );
    }

    return BaseScaffold(
      child: provider.ordersList == null
          ? const NativeLoader()
          : provider.ordersList.isNotEmpty
              ? ScrollConfiguration(
                  behavior: const NoGlowingBehavior(),
                  child: ListView.builder(
                    itemCount: provider.ordersList.length + 1,
                    padding: kMaterialListPadding,
                    key: const PageStorageKey("orders-list"),
                    itemBuilder: (_, index) {
                      if (index == provider.ordersList.length) {
                        return const Card(
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: SizedBox(
                            height: kToolbarHeight,
                            child: Center(child: Texts("No more orders")),
                          ),
                        );
                      }

                      final order = provider.ordersList[index];

                      return _ItemOrder(
                        order: order,
                        loginData: loginData,
                      );
                    },
                  ),
                )
              : NoDataFound(
                  msg: "No orders yet.",
                  onTap: () => context.read<IndexProvider>().setIndex(0),
                ),
    );
  }

  Future<void> _onRefresh() async {
    // final Completer<void> completer = Completer<void>();
    // completer.complete(context.read<OrdersProvider>().getOrders(loginData.id));
    print("Coming in");
    await context.read<OrdersProvider>().getOrders(loginData.id);
  }
}

class _ItemOrder extends StatefulWidget {
  final Order order;
  final LoginData loginData;

  const _ItemOrder({this.order, this.loginData});

  @override
  __ItemOrderState createState() => __ItemOrderState();
}

class __ItemOrderState extends State<_ItemOrder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.order.lineItems.map(
        (e) {

          // showLog("e =======>>> ${e.toJson()}");
          return Card(
            elevation: 3.0,
            margin: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                // if (widget.order.orderStatus == '3') {
                //   showToast('Order is cancelled.');
                // } else {
                navigator.navigateTo(
                  Routes.orderDetailsScreen,
                  arguments: OrderDetailsScreenArguments(order: widget.order),
                );
                // }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Texts(e.proName, fontSize: 16),
                              const SizedBox(height: 5),
                              Texts("Ordered On : " + widget.order.datetime, fontSize: 13.0),
                              const SizedBox(height: 5),
                              Texts("Expected Delivery : ${widget.order.delivery}", fontSize: 13.0),
                              const SizedBox(height: 5),
                              Texts("${Strings.seller} : USClub", fontSize: 12.0),
                              const SizedBox(height: 3),
                              Texts(e.proName, fontSize: 12.0, color: Palette.grey),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final product = Product.fromJson(e.toJson());
                            navigator.navigateTo(Routes.productDetails,
                                arguments: ProductDetailsArguments(product: product));
                          },
                          child: CachedImage(
                            e.imgLink,
                            isRound: false,
                            height: 90,
                            width: 75,
                            radius: 0.0,
                            showLoader: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 8),
                      child: FlatButton(
                        height: 40,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        // color: context.accentColor,
                        color: widget.order.orderStatus != "3" ? context.accentColor : null,
                        onPressed: () {
                          onButtonClick(context, e);
                        },
                        child: Texts(
                          getButtonName(),
                          color: widget.order.orderStatus != "3" ? Palette.white : context.accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  String getButtonName() {
    switch (widget.order.orderStatus) {
      case '0':
        return 'Cancel';
      case '1':
        return 'Cancel';
      case '2':
        if (DateTime.now().isAfter(DateTime.parse(widget.order.delivery).add(const Duration(days: 6)))) {
          return 'Review';
        } else {
          return 'Return';
        }
        break;
      case '3':
        return 'Order Cancelled';
      case '4':
        return 'Returned';
      default:
        return '';
    }
  }

  void onButtonClick(BuildContext context, LineItems item) {
    showLog("onButtonClick =======>>> ${widget.order.orderStatus}");
    switch (widget.order.orderStatus) {
      case '0':
        showCancelDialog(context, false);
        break;
      case '1':
        showCancelDialog(context, false);
        break;
      case '2':
        if (DateTime.now().isAfter(DateTime.parse(widget.order.delivery).add(const Duration(days: 6)))) {
          addReviewLayout(context, item, widget.loginData);
        } else {
          showCancelDialog(context, true);
        }
        break;
      default:
        return null;
    }
  }

  void addReviewLayout(BuildContext context, LineItems item, LoginData loginData) {
    double totalRating = 0.0;
    String currentReview = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context2) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Texts(item.proName, fontSize: 18.0, fontFamily: semiBold),
                const SizedBox(height: 10.0),
                RatingBar(
                  icon: Icon(Icons.star, size: 30, color: Colors.grey),
                  starCount: 5,
                  spacing: 3.0,
                  size: 30,
                  allowHalfRating: true,
                  onRatingCallback: (double value, ValueNotifier<bool> isIndicator) {
                    totalRating = value;
                  },
                  color: Colors.amber,
                ),
                const SizedBox(height: 10.0),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.done,
                  maxLines: 4,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration: Styles.customTextInputDecorationWithBorder(
                    hint: 'Enter Review',
                    borderRadius: 0,
                  ),
                  onTextChanged: (review) => currentReview = review,
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        color: Palette.accentColor,
                        text: 'Cancel',
                        fontFamily: bold,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: FilledButton(
                        color: Palette.accentColor,
                        text: 'Submit',
                        fontFamily: bold,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<HomeProvider>().insertProductReview({
                            'pro_id': item.proId,
                            'r_msg': currentReview,
                            'r_rating': totalRating.toString(),
                            'u_id': loginData.id,
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCancelDialog(BuildContext context, bool isReturn) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contextDialog) {
        return AlertDialog(
          title: Texts(
            'Are you sure you want to ${isReturn ? 'return' : 'cancel'} the order?',
            fontSize: 16.0,
            fontFamily: regular,
          ),
          actions: [
            FlatButton(
              height: kToolbarHeight,
              onPressed: () => Navigator.of(context).pop(),
              child: Texts(
                'NO',
                color: Palette.red,
              ),
            ),
            FlatButton(
              height: kToolbarHeight,
              onPressed: () async {
                Navigator.of(context).pop();
                if (isReturn) {
                  showReturnDialog(context);
                } else {
                  context
                      .read<OrdersProvider>()
                      .cancelOrder(widget.order.waybill, widget.loginData.id, widget.order.orderId);
                }
              },
              child: Texts(
                'YES',
                color: Palette.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void showReturnDialog(BuildContext context) async {
    final map = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDetailsDialog(),
    );

    if (map != null && map is Map) {
      map['order'] = widget.order.transactionId;
      map['phone'] = widget.loginData.userMobile;
      map['add'] = widget.loginData.userAddress;
      map['name'] = widget.loginData.userName;
      context.read<OrdersProvider>().returnOrder(map, widget.loginData.id, widget.order.orderId);
    }
  }
}

class ConfirmDetailsDialog extends StatefulWidget {
  const ConfirmDetailsDialog();

  @override
  _ConfirmDetailsDialogState createState() => _ConfirmDetailsDialogState();
}

class _ConfirmDetailsDialogState extends State<ConfirmDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String returnName = '',
      returnAddress = '',
      returnPin = '',
      returnPhone = '',
      returnCountry = '',
      returnState = '',
      returnCity = '';

  bool autoValidateMode = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            autovalidateMode: autoValidateMode ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15.0),
                Texts('Return Details', fontSize: 16.0, fontFamily: semiBold),
                const SizedBox(height: 15.0),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'Name', borderRadius: 0),
                  onTextChanged: (name) => returnName = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyName;
                    } else if (!Validator.validateName(value)) {
                      return Strings.emptyNameValidation;
                    }
                  },
                ),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'Country', borderRadius: 0),
                  onTextChanged: (name) => returnCountry = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyCountry;
                    } else if (!Validator.validateName(value)) {
                      return Strings.emptyCountry2;
                    }
                  },
                ),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'State', borderRadius: 0),
                  onTextChanged: (name) => returnState = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyState;
                    } else if (!Validator.validateName(value)) {
                      return Strings.emptyState2;
                    }
                  },
                ),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'City', borderRadius: 0),
                  onTextChanged: (name) => returnCity = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyCity;
                    } else if (!Validator.validateName(value)) {
                      return Strings.emptyCity2;
                    }
                  },
                ),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'Address', borderRadius: 0),
                  onTextChanged: (name) => returnAddress = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyAddress;
                    }
                  },
                ),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'Pin', borderRadius: 0),
                  onTextChanged: (name) => returnPin = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyPincode;
                    } else if (!Validator.validateText(value, length: 6)) {
                      return Strings.emptyPincode2;
                    }
                  },
                ),
                TextFormFieldWidget(
                  actionKeyboard: TextInputAction.next,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration:
                      Styles.customTextInputDecorationWithBorder(hint: 'Phone', borderRadius: 0),
                  onTextChanged: (name) => returnPhone = name,
                  functionValidate: (value) {
                    if (value == '') {
                      return Strings.emptyPhoneNumber;
                    } else if (!Validator.phoneValidator(value)) {
                      return Strings.emptyPhoneNumberDesc;
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        color: Palette.accentColor,
                        text: 'Cancel',
                        fontFamily: bold,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: FilledButton(
                        color: Palette.accentColor,
                        text: 'Return',
                        fontFamily: bold,
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> returnMap = {
                              "shipments": [
                                {
                                  "payment_mode": "Pickup",
                                  "wbn": "",
                                  "return_name": returnName,
                                  "return_city": returnCity,
                                  "return_state": returnState,
                                  "return_country": returnCountry,
                                  "return_add": returnAddress,
                                  "return_pin": returnPin,
                                  "return_phone": returnPhone,
                                  "pin": returnPin,
                                }
                              ]
                            };
                            Navigator.of(context).pop(returnMap);
                          } else {
                            autoValidateMode = true;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
