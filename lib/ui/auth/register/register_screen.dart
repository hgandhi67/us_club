import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/router.gr.dart';
import 'package:us_club/providers/auth_provider.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/utils/export_utils.dart';
import 'package:us_club/widgets/button_widgets.dart';
import 'package:us_club/widgets/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  final String moveBackRoute;
  final String phoneNumber;

  const RegisterScreen({Key key, this.moveBackRoute, this.phoneNumber}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Global key for the entire sign in form.
  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  /// Controllers for the sign up fields.
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      _phoneController.text = widget.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              bottom: 1,
              left: -50,
              right: -50,
              child: Image.asset(ImagesLink.footer_logo),
            ),
            _mainRegisterUi(),
          ],
        ),
      ),
    );
  }

  Widget _mainRegisterUi() {
    return Container(
      height: screenHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.only(top: screenHeight * 0.1, bottom: screenHeight * 0.03),
            alignment: Alignment.center,
            child: Image.asset(ImagesLink.app_logo, width: screenWidth * 0.6),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.01),
            child: Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  TextFormFieldWidget(
                    controller: _nameController,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.name),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyName;
                      }
                    },
                  ),
                  TextFormFieldWidget(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.email),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyEmail;
                      } else if (!Validator.validateEmail(value)) {
                        return Strings.emailValidation;
                      }
                    },
                  ),
                  TextFormFieldWidget(
                    controller: _phoneController,
                    textInputType: TextInputType.number,
                    enabled: widget.phoneNumber == null,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.phoneOtp),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyPhoneNumber;
                      }
                    },
                  ),
                  TextFormFieldWidget(
                    controller: _passwordController,
                    obscureText: true,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.password),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyPassword;
                      } else if (value.toString().length < 6) {
                        return Strings.passwordValidation;
                      }
                    },
                  ),
                  TextFormFieldWidget(
                    controller: _confirmPasswordController,
                    customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                    actionKeyboard: TextInputAction.done,
                    obscureText: true,
                    customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.confirmPassword),
                    functionValidate: (value) {
                      if (value == '') {
                        return Strings.emptyPassword;
                      } else if (value.toString().length < 6) {
                        return Strings.passwordValidation;
                      } else if (value != _passwordController.text) {
                        return Strings.passwordMatchValidation;
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  FilledButton(
                    color: Palette.accentColor,
                    text: Strings.signUp.toUpperCase(),
                    fontFamily: bold,
                    onTap: registerMe,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget function which gives the UI for the loader of the screen.
  /// This widget uses the common [NativeLoader]
  Future<void> registerMe() async {
    if (_signUpFormKey.currentState.validate()) {
      final map = {
        'u_name': _nameController.text.trim(),
        'u_email': _emailController.text.trim(),
        'u_mob': _phoneController.text.trim(),
        'u_password': _passwordController.text.trim(),
      };

      final response = await context.read<AuthProvider>().registerUser(map);

      if (response.isNotNull && response.data != null) {
        showToast("Your account created successfully!");
        sharedPref.setString(Constants.AUTH_TOKEN, response.data.toString());
        context.read<OrdersProvider>().getOrders(response.data[0].userId);
        moveToHomeScreen();
      }
    }
  }

  void moveToHomeScreen() {
    if (widget.moveBackRoute != null) {
      Navigator.popUntil(context, ModalRoute.withName(widget.moveBackRoute));
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainScreen, (dynamic) => false);
    }
  }
}
