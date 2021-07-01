import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/model/orders/orders_m.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/utils/export_utils.dart';
import 'package:us_club/widgets/base_scaffold.dart';
import 'package:us_club/widgets/cached_image.dart';
import 'package:us_club/widgets/native_loader.dart';
import 'package:us_club/widgets/no_data_found.dart';
import 'package:us_club/widgets/text_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;

  const OrderDetailsScreen({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  ShipmentData _data;

  bool isBusy = false;

  void setBusy(bool value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      getOrderDetails();
    });
  }

  Future<void> getOrderDetails() async {
    // showLoader();
    setBusy(true);

    final response = await context.read<OrdersProvider>().getOrderDetails(widget.order.waybill);

    if (response != null) {
      _data = response.shipmentData[0];
    }

    // hideLoader();

    setBusy(false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isAppbar: true,
      leading: BackButton(),
      title: "Order Details",
      appBarColor: context.accentColor,
      centerTitle: true,
      elevation: 0.0,
      child: isBusy
          ? const NativeLoader()
          : _data != null
              ? ListView(
                  children: [
                    _ItemProduct(
                      order: widget.order,
                      data: _data.shipment,
                    ),
                    const Divider(height: 30, thickness: 1),
                    _OrderStatus(
                      order: widget.order,
                      data: _data.shipment,
                    ),
                    _TimelineWidget(
                      order: widget.order,
                      data: _data.shipment,
                    ),
                  ],
                )
              : const NoDataFound(),
    );
  }
}

class _ItemProduct extends StatelessWidget {
  final Order order;
  final Shipment data;

  const _ItemProduct({Key key, this.data, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = order.lineItems[0];

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border.all()),
              child: CachedImage(
                product.imgLink,
                height: 150,
                isRound: false,
                radius: 0.0,
              ),
            ),
          ).onTap(() {
            final kProduct = Product.fromJson(product.toJson());

            navigator.navigateTo(Routes.productDetails,
                arguments: ProductDetailsArguments(product: kProduct));
          }, hitTestBehavior: HitTestBehavior.opaque),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Texts(
                  product.proName,
                  fontSize: 18,
                  color: Palette.black,
                  fontFamily: semiBold,
                ),
                Html(
                  data: product.proDesc,
                  shrinkWrap: true,
                ),
                Texts(
                  "${Strings.r}${order.orderTotal.toDouble().toStringAsFixed(2)}",
                  fontSize: 18,
                  color: Palette.black,
                  fontFamily: semiBold,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OrderStatus extends StatelessWidget {
  final Order order;
  final Shipment data;

  const _OrderStatus({Key key, this.data, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}

class _TimelineWidget extends StatelessWidget {
  final Order order;
  final Shipment data;

  const _TimelineWidget({Key key, this.data, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            children: [
              Column(
                children: [
                  const Texts("Ordered"),
                  Texts(
                    Utils.formatDate4(order.datetime),
                    color: Palette.greyLight2,
                    fontSize: 13,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Texts(data.status.status),
                    Row(
                      children: [
                        Expanded(
                          child: IgnorePointer(
                            ignoring: true,
                            child: FlutterSlider(
                              values: [0, 50],
                              rangeSlider: true,
                              step: FlutterSliderStep(
                                rangeList: [FlutterSliderRangeStep(from: 0.0, to: 50.0, step: 45.0)],
                              ),
                              trackBar: FlutterSliderTrackBar(
                                  activeTrackBar: BoxDecoration(color: Palette.accentColor)),
                              tooltip: FlutterSliderTooltip(
                                disabled: true,
                              ),
                              max: 100,
                              min: 0,
                              handlerHeight: 15,
                              handler: FlutterSliderHandler(
                                child: const SizedBox(),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Palette.white,
                                  border: Border.all(color: Palette.accentColor),
                                ),
                              ),
                              rightHandler: FlutterSliderHandler(
                                child: const SizedBox(),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Palette.accentColor,
                                  border: Border.all(color: Palette.accentColor),
                                ),
                              ),
                              onDragging: (handlerIndex, lowerValue, upperValue) {},
                            ),
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Palette.white,
                            border: Border.all(color: Palette.accentColor),
                          ),
                          child: SizedBox(
                            width: 13,
                            height: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Texts("Delivery"),
                  Texts(
                    Utils.formatDate4(order.delivery) + "*",
                    color: Palette.red,
                    fontSize: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Sender Name : ",
                      style: Styles.customTextStyle(),
                    ),
                    TextSpan(
                      text: data.senderName,
                      style: Styles.customTextStyle(
                        fontFamily: semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Reference No : ",
                      style: Styles.customTextStyle(),
                    ),
                    TextSpan(
                      text: data.referenceNo,
                      style: Styles.customTextStyle(
                        fontFamily: semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 30, thickness: 1),
        ListView.builder(
          itemCount: data.scans.length,
          shrinkWrap: true,
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return _ItemTracking(
              example: data.scans[index],
              isLast: index == 0,
            );
          },
        ),
        // Column(
        //   children: data.scans
        //       .mapIndexed(
        //         (e, index) => _ItemTracking(
        //           example: e,
        //           isLast: index == data.scans.length - 1,
        //         ),
        //       )
        //       .toList(),
        // ),
      ],
    );
  }
}

class _ItemTracking extends StatelessWidget {
  const _ItemTracking({Key key, this.example, this.isLast}) : super(key: key);

  final Scans example;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Texts(
                  Utils.formatDate4(example.scanDetail.statusDateTime),
                  fontFamily: bold,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Container(
                    width: isLast ? 0 : 3,
                    color: Palette.greyLight2.withOpacity(0.4),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Texts(
              example.scanDetail.instructions,
            ),
          ),
          const Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }
}
