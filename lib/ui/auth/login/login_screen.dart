import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:us_club/base/constants.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final String moveBackRoute;

  const LoginScreen({this.moveBackRoute});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Global key for the entire sign in form.
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Controllers for the username, password fields.
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(children: [
          Positioned(
            bottom: 1,
            left: -50,
            right: -50,
            child: Image.asset(ImagesLink.footer_logo),
          ),
          _mainLoginPageUi(),
        ]),
      ),
    );
  }

  /// Widget function which gives the main UI for the sign in page.
  Widget _mainLoginPageUi() {
    return Container(
      height: screenHeight,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: screenHeight * 0.1, bottom: screenHeight * 0.03),
            alignment: Alignment.center,
            child: Image.asset(ImagesLink.app_logo, width: screenWidth * 0.6),
          ),
          Texts(Strings.login, color: Palette.accentColor, fontSize: screenWidth * 0.08, fontFamily: bold),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.01),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormFieldWidget(
                    controller: _userNameController,
                    textInputType: TextInputType.emailAddress,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.email),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyUserName;
                      }
                    },
                  ),
                  TextFormFieldWidget(
                    controller: _passwordController,
                    actionKeyboard: TextInputAction.done,
                    obscureText: true,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.password),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyPassword;
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  FilledButton(
                    color: Palette.accentColor,
                    text: Strings.signIn.toUpperCase(),
                    fontFamily: bold,
                    onTap: loginMe,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunch(Constants.FORGET_PASSWORD_URL)) {
                        await launch(Constants.FORGET_PASSWORD_URL);
                      } else {
                        throw 'Could not launch ${Constants.FORGET_PASSWORD_URL}';
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Texts(
                        Strings.forgotPassword,
                        color: Palette.black,
                        textAlign: TextAlign.end,
                        fontSize: 18.0,
                        fontFamily: light,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _noAccountLayout(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget function which gives the UI if the user don't have any account.
  Widget _noAccountLayout() {
    return Row(
      children: [
        Texts(
          Strings.dontHaveAcc,
          color: Palette.black,
          textAlign: TextAlign.end,
          fontSize: 18.0,
          fontFamily: light,
        ),
        const SizedBox(width: 10.0),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            Routes.otpScreen,
            arguments: OtpScreenArguments(moveBackRoute: widget.moveBackRoute),
          ),
          splashColor: Colors.transparent,
          child: Texts(
            Strings.signUp,
            color: Palette.accentColor,
            textAlign: TextAlign.end,
            fontSize: 18,
            fontFamily: bold,
          ),
        )
      ],
    );
  }

  /// Widget function which gives the UI for the loader of the screen.
  /// This widget uses the common [NativeLoader]
  Future<void> loginMe() async {
    if (_formKey.currentState.validate()) {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      final map = {
        'u_email': _userNameController.text.trim(),
        'u_pass': _passwordController.text.trim(),
      };

      final response = await provider.loginMe(map);

      if (response.isNotNull && response?.status == Strings.ok) {
        sharedPref.setString(Constants.AUTH_TOKEN, LoginData().toJson(response.data[0]));
        sharedPref.setString(Constants.PASSWORD, _passwordController.text.trim());
        context.read<CartProvider>().getCartDataList(response.data[0].id);
        context.read<OrdersProvider>().getOrders(response.data[0].id);
        if (widget.moveBackRoute != null) {
          context.read<IndexProvider>().setIndex(0);
          // context.read<OrdersProvider>().getOrders(response.data[0].id);
          Navigator.popUntil(context, ModalRoute.withName(widget.moveBackRoute));
        } else {
          await navigator.pushNamedAndRemoveUntil(Routes.mainScreen);
        }
      }
    }
  }
}
