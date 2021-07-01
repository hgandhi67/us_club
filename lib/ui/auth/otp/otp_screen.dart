import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/router.gr.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/auth_provider.dart';
import 'package:us_club/widgets/button_widgets.dart';
import 'package:us_club/widgets/text_field_widget.dart';
import 'package:us_club/widgets/text_widget.dart';

class OtpScreen extends StatefulWidget {
  final String moveBackRoute;

  const OtpScreen({Key key, this.moveBackRoute}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  /// Global key for the entire sign in form.
  GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  /// Controllers for the phone, otp fields.
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  /// Screen Height and Width
  double screenHeight = 0.0, screenWidth = 0.0;

  /// OTP Session Id
  String sessionId = '';

  String sendOtpText = Strings.sendOtp;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Palette.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.1, bottom: screenHeight * 0.03),
                alignment: Alignment.center,
                child: Image.asset(ImagesLink.app_logo, width: screenWidth * 0.6),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.01),
                child: Form(
                  key: _otpFormKey,
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        controller: _phoneController,
                        textInputType: TextInputType.number,
                        customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                        customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.phoneOtp),
                        functionValidate: (value) {
                          if (value == '') {
                            return Strings.emptyPhoneNumber;
                          }
                        },
                      ),
                      TextFormFieldWidget(
                        controller: _otpController,
                        actionKeyboard: TextInputAction.done,
                        customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                        customInputDecoration: Styles.customTextInputDecorationWithBorder(hint: Strings.otp),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      InkWell(
                        onTap: () => sendOtp(),
                        splashColor: Colors.transparent,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Texts(
                            sendOtpText,
                            color: Palette.accentColor,
                            textAlign: TextAlign.end,
                            fontSize: 18.0,
                            fontFamily: bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      FilledButton(
                        color: Palette.accentColor,
                        text: Strings.verifyOtp.toUpperCase(),
                        fontFamily: bold,
                        onTap: () async {
                          if (_otpController.isNotNull && _otpController.text.isNotEmpty) {
                            OtpModel otpModel =
                                await Provider.of<AuthProvider>(context, listen: false).verifyUserOtp(sessionId, _otpController.text);
                            if (otpModel != null) {
                              Navigator.of(context).pushReplacementNamed(
                                Routes.registerScreen,
                                arguments: RegisterScreenArguments(
                                  moveBackRoute: widget.moveBackRoute,
                                  phoneNumber: _phoneController.text,
                                ),
                              );
                            } else {
                              showToast('Please enter correct otp or click on re-send otp to resend.');
                            }
                          } else {
                            showToast('Please enter otp to verify.');
                          }
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _alreadyAccountLayout(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 1,
            left: -50,
            right: -50,
            child: Image.asset(ImagesLink.footer_logo),
          ),
        ],
      ),
    );
  }

  Widget _alreadyAccountLayout() {
    return Row(
      children: [
        Texts(
          Strings.alreadyHaveAccount,
          color: Palette.black,
          textAlign: TextAlign.end,
          fontSize: 18.0,
          fontFamily: light,
        ),
        const SizedBox(width: 10.0),
        InkWell(
          onTap: () => Navigator.of(context).popUntil(ModalRoute.withName(Routes.loginScreen)),
          splashColor: Colors.transparent,
          child: Texts(
            Strings.signIn,
            color: Palette.accentColor,
            textAlign: TextAlign.end,
            fontSize: 18,
            fontFamily: bold,
          ),
        )
      ],
    );
  }

  void sendOtp() async {
    if (_otpFormKey.currentState.validate()) {
      OtpModel otpModel = await Provider.of<AuthProvider>(context, listen: false).sendUserOtp(_phoneController.text);
      if (otpModel != null) {
        sessionId = otpModel.details;
        setState(() {
          sendOtpText = Strings.reSendOtp;
        });
      }else{
        setState(() {
          sendOtpText = Strings.sendOtp;
        });
      }
    }
  }
}
