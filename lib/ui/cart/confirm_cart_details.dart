import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/utils/export_utils.dart';
import 'package:us_club/widgets/base_scaffold.dart';
import 'package:us_club/widgets/widgets.dart';

class ConfirmCartDetailsScreen extends StatefulWidget {
  final bool isCOD;

  const ConfirmCartDetailsScreen({Key key, this.isCOD = false}) : super(key: key);

  @override
  _ConfirmCartDetailsScreenState createState() => _ConfirmCartDetailsScreenState();
}

class _ConfirmCartDetailsScreenState extends State<ConfirmCartDetailsScreen> {
  /// Controllers for the sign up fields.
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pinController = TextEditingController();

  /// Global key for the entire sign in form.
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Data variables
  LoginData currentUser;

  /// Variables for the user dropdown data.
  String selectedGender;
  Country selectedCountry, countryName;
  States selectedState, stateName;
  City selectedCity, cityName;

  /// Bool which specifies if the dropdown have been loaded.
  bool isLoaded = false, autoValidate = false;

  AuthProvider _provider;
  LocationProvider _locationProvider;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (currentUser != null) {
      _nameController.text = currentUser.userName;
      _phoneController.text = currentUser.userMobile;
      _emailController.text = currentUser.userEmail;
      _addressController.text = currentUser.userAddress;
      selectedGender = currentUser.userGender == 'M' ? 'Male' : 'Female';
      getLocationData();
    }

    final pincode = sharedPref.getString(Constants.PINCODE);

    if (!pincode.isEmptyOrNull) {
      _pinController.text = pincode;
    }

    Provider.of<LocationProvider>(context, listen: false).getCountries();
  }

  void getLocationData() async {
    // showLoader();

    final country = currentUser.userCountryId;
    final state = currentUser.userStateId;
    final city = currentUser.userCityId;
    showLog("currentUser.userCountryId =======>>> $country");
    showLog("currentUser.userStateId =======>>> $state");
    showLog("currentUser.userCityId =======>>> $city");

    if (!country.isEmptyOrNull && !state.isEmptyOrNull && !city.isEmptyOrNull) {
      LocationProvider provider = Provider.of<LocationProvider>(context, listen: false);
      selectedCountry = (await provider.getCountryById(currentUser.userCountryId));
      selectedState = (await provider.getStateById(currentUser.userStateId, currentUser.userCountryId));
      selectedCity = (await provider.getCityById(currentUser.userCityId, currentUser.userStateId));
    } else {}
    // hideLoader();
    if (mounted)
      setState(() {
        isLoaded = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuthProvider>(context);
    _locationProvider = Provider.of<LocationProvider>(context);
    return BaseScaffold(
      isAppbar: true,
      isLeading: true,
      centerTitle: true,
      appBarColor: context.accentColor,
      title: "Confirm Details",
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  Column(
                    children: context.read<CartProvider>().cartDataList.map((e) {
                      return _ItemCart(
                        // cartData: context.read<CartProvider>().cartDataList[index],
                        cartData: e,
                      );
                    }).toList(),
                  ),
                  _checkoutLayout(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          controller: _nameController,
                          customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                          customInputDecoration: Styles.customTextInputDecorationWithBorder(
                            hint: Strings.name,
                            borderRadius: 0,
                          ),
                          functionValidate: (value) {
                            if (value == '') {
                              return Strings.emptyName;
                            }
                          },
                        ),
                        TextFormFieldWidget(
                          controller: _phoneController,
                          textInputType: TextInputType.number,
                          customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                          customInputDecoration: Styles.customTextInputDecorationWithBorder(
                            hint: Strings.phoneOtp,
                            borderRadius: 0,
                          ),
                          functionValidate: (value) {
                            if (value == '') {
                              return Strings.emptyPhoneNumber;
                            }
                          },
                        ),
                        TextFormFieldWidget(
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                          customInputDecoration: Styles.customTextInputDecorationWithBorder(
                            hint: Strings.email,
                            borderRadius: 0,
                          ),
                          functionValidate: (value) {
                            if (value == '') {
                              return Strings.emptyEmail;
                            } else if (!Validator.validateEmail(value)) {
                              return Strings.emailValidation;
                            }
                          },
                        ),
                        TextFormFieldWidget(
                          controller: _addressController,
                          textInputType: TextInputType.text,
                          customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                          customInputDecoration: Styles.customTextInputDecorationWithBorder(
                            hint: 'Address',
                            borderRadius: 0,
                          ),
                          functionValidate: (value) {
                            if (value == '') {
                              return Strings.emptyAddress;
                            }
                          },
                        ),
                        TextFormFieldWidget(
                          controller: _pinController,
                          customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                          actionKeyboard: TextInputAction.done,
                          customInputDecoration: Styles.customTextInputDecorationWithBorder(
                            hint: Strings.pincode,
                            borderRadius: 0,
                            suffixIcon: FlatButton(
                              onPressed: checkAvailability,
                              child: Texts(
                                "Verify",
                                color: Palette.accentColor,
                              ),
                            ),
                          ),
                          functionValidate: (value) {
                            if (value == '') {
                              return "Please enter valid pin code to check availability";
                            }
                          },
                        ),
                        countryDropDownWidget(),
                        stateDropDownWidget(),
                        cityDropDownWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isCOD)
              FlatButton(
                height: kToolbarHeight,
                minWidth: screenWidth,
                color: context.theme.primaryColor,
                onPressed: () {
                  validateAndContinueFurther();
                },
                child: Texts(
                  Strings.payNow.toUpperCase(),
                  color: Colors.white,
                ),
              )
            else
              PayBar(
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onPayNow: () {
                  validateAndContinueFurther();
                },
              ),
          ],
        ),
      ),
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

  double getSubtotal() {
    double subtotal = 0.0;
    context
        .read<CartProvider>()
        .cartDataList
        .map((e) => subtotal +=
            ((double.parse(e.price) - ((e.price.toInt() * discount) / 100)) * double.parse(e.qty)))
        .toList();
    return subtotal;
  }

  double getTax() {
    return getSubtotal().toInt() < 1000 ? 90.0 : 0.0;
  }

  Widget countryDropDownWidget() {
    if (isLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacers(height: 20.0),
          titleWidget('Country'),
          CustomDropdownWidget(
            valuesList: _locationProvider.countryList,
            validateGender: true,
            initialValue: selectedCountry,
            textSize: 16.0,
            themeTextColor: Palette.black,
            hint: 'Select Country',
            selectedValue: (value) => onCountrySelected(value),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget stateDropDownWidget() {
    if (isLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacers(height: 10.0),
          titleWidget('State'),
          CustomDropdownWidget(
            valuesList: _locationProvider.statesList,
            validateGender: true,
            initialValue: selectedState,
            textSize: 16.0,
            themeTextColor: Palette.black,
            hint: 'Select State',
            selectedValue: (value) => onStateSelected(value),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget cityDropDownWidget() {
    if (isLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacers(height: 10.0),
          titleWidget('City'),
          CustomDropdownWidget(
            valuesList: _locationProvider.cityList,
            validateGender: true,
            initialValue: selectedCity,
            textSize: 16.0,
            themeTextColor: Palette.black,
            selectedValue: (value) => onCitySelected(value),
            hint: 'Select City',
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget titleWidget(String text) {
    return Texts(text, fontSize: 14.0, color: Palette.grey);
  }

  void onCountrySelected(Country country) {
    selectedCountry = country;
    selectedState = null;
    selectedCity = null;
    context.read<LocationProvider>().getState(country.id);
  }

  void onStateSelected(States state) {
    selectedState = state;
    selectedCity = null;
    context.read<LocationProvider>().getCity(state.id);
  }

  void onCitySelected(City city) {
    selectedCity = city;
  }

  void validateAndContinueFurther() {
    if (_formKey.currentState.validate()) {
      if (selectedCountry == null) {
        showToast("Please select country to continue!");
        return;
      }

      if (selectedState == null) {
        showToast("Please select state to continue!");
        return;
      }

      if (selectedCity == null) {
        showToast("Please select city to continue!");
        return;
      }

      final map = {
        "u_id": currentUser.id,
        "name": _nameController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "pincode": _pinController.text,
        "pinfo": "ABC 121, XYZ 123",
        "country": selectedCountry.name,
        "state": selectedState.name,
        "city": selectedCity.name,
      };

      Navigator.of(context).pop(map);
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  void checkAvailability() async {
    final pincode = _pinController.text;

    if (pincode.removeSpaces().isEmptyORNull || pincode.length < 6) {
      showToast("Please enter valid pincode to check availability!");
      return;
    }

    showLoader();

    final response = await context.read<HomeProvider>().checkAvailability(pincode);

    if (response != null && !response.deliveryCodes.isNullOrEmpty) {
      final details = response.deliveryCodes[0].postalCode;

      final pincodeText = "You are eligible for delivery ${details.stateCode}, ${details.district}!";

      // sharedPref.setString(Constants.PINCODE, pincode);

      BotToast.showText(text: pincodeText);
    } else {
      final pincodeText = "Opp's sorry are not eligible for delivery!";
      BotToast.showText(text: pincodeText);
      // showToast("Opp's sorry ou are eligible for delivery!");
    }

    hideLoader();
    if (mounted) setState(() {});
  }
}

class PayBar extends StatelessWidget {
  final Function onPayNow;
  final Function onCancel;

  const PayBar({this.onPayNow, this.onCancel});

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
                onPressed: onPayNow,
                child: Texts(
                  Strings.payNow.toUpperCase(),
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                height: kToolbarHeight,
                onPressed: onCancel,
                child: Texts(
                  Strings.cancel.toUpperCase(),
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

class _ItemCart extends StatelessWidget {
  final CartData cartData;

  const _ItemCart({Key key, this.cartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<StoreDetail> storeDetail = Provider.of<HomeProvider>(context).storeDetails;
    StoreDetail discount = storeDetail.firstWhere((element) => element.type == 'discount');
    final discountPrice = (cartData.proPrice.toInt() -
            ((cartData.proPrice.toInt() * (discount != null ? discount.value.toInt() : 0)) / 100))
        .toStringAsFixed(0);

    // showLog("cartData =======>>> ${cartData?.toJson()}");
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {},
      child: Container(
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
                      Texts("${Strings.r}${cartData.proPrice}/-",
                          color: Palette.greyLight2,
                          fontSize: 14,
                          textDecoration: TextDecoration.lineThrough),
                      Texts("   ${discount != null ? discount.value : 0}% OFF",
                          color: Palette.red, fontSize: 14),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!cartData.cartDesc.isEmptyORNull) Texts("${cartData.cartDesc}"),
                  Texts("Qty :- ${cartData.qty}"),
                ],
              ),
            ),
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
    );
  }
}
