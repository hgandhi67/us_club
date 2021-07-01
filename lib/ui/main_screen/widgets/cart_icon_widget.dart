import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/auth_provider.dart';
import 'package:us_club/providers/cart_provider.dart';
import 'package:us_club/widgets/text_widget.dart';

class CartIconWidget extends StatelessWidget {
  final String routeName;

  const CartIconWidget({Key key, @required this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    LoginData currentUser = Provider.of<AuthProvider>(context).currentUser;
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.card_travel_sharp,
            color: Palette.grey,
          ),
          onPressed: () {
            if (currentUser != null) {
              navigator.navigateTo(Routes.cartPage);
            } else {
              navigator.navigateTo(Routes.loginScreen, arguments: LoginScreenArguments(moveBackRoute:  this.routeName));
            }
          },
        ),
        cartProvider.cartDataList.isNullOrEmpty || currentUser == null
            ? SizedBox()
            : Positioned(
                top: 5,
                right: 8,
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Palette.red),
                  child: Center(
                    child: Texts(
                      cartProvider.cartDataList.length.toString(),
                      fontSize: 8.0,
                      fontFamily: regular,
                      color: Palette.white,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
