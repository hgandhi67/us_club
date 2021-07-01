import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/generated/assets.dart';
import 'package:us_club/model/login/login_model.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/ui/main_screen/widgets/cart_icon_widget.dart';
import 'package:us_club/utils/export_utils.dart';
import 'package:us_club/widgets/widgets.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  /// Global key for the entire sign in form.
  GlobalKey<FormState> _updateProfileFormKey = GlobalKey<FormState>();

  /// Data variables
  LoginData currentUser;

  /// [TextEditingController] for the text form fields.
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  /// Variables for the user dropdown data.
  String selectedGender;
  Country selectedCountry, countryName;
  States selectedState, stateName;
  City selectedCity, cityName;

  String kCountry, kState, kCity;

  /// Bool which specifies if the dropdown have been loaded.
  bool isLoaded = false;

  AuthProvider _provider;
  LocationProvider _locationProvider;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (currentUser != null) {
      _nameController.text = currentUser.userName;
      _mobileController.text = currentUser.userMobile;
      _emailController.text = currentUser.userEmail;
      _addressController.text = currentUser.userAddress;
      selectedGender = currentUser.userGender == 'M' ? 'Male' : 'Female';
      getLocationData();
    }
    context.read<LocationProvider>().getCountries();
  }

  void getLocationData() async {
    LocationProvider provider = Provider.of<LocationProvider>(context, listen: false);
    selectedCountry = (await provider.getCountryById(currentUser.userCountryId));
    selectedState = (await provider.getStateById(currentUser.userStateId, currentUser.userCountryId));
    selectedCity = (await provider.getCityById(currentUser.userCityId, currentUser.userStateId));
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuthProvider>(context);
    _locationProvider = Provider.of<LocationProvider>(context);
    currentUser = _provider.currentUser;

    return BaseScaffold(
      isAppbar: true,
      elevation: 0.0,
      appBarColor: Colors.white,
      isDrawer: false,
      title: InkWell(
        onTap: () {
          navigator.pushNamedAndRemoveUntil(Routes.mainScreen);
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
          CartIconWidget(routeName: Routes.updateProfilePage),
        ],
      ),
      child: ListView(
        children: [
          Spacers(height: 15.0),
          const UserProfileImage(),
          Spacers(height: 15.0),
          profileDataForm(),
        ],
      ),
    );
  }

  /// Widget function which gives the ui and functionality for the profile picture of the user.
  // Widget profilePicture() {
  //   return ProfileImage(
  //     onTap: onProfilePictureTap,
  //     width: screenWidth * 0.3,
  //     height: screenWidth * 0.3,
  //     imageUrl: currentUser.userImageLink,
  //     // useCachedImage: false,
  //   );
  // }

  Widget profileDataForm() {
    return Form(
      key: _updateProfileFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldWidget(
              controller: _nameController,
              textInputType: TextInputType.text,
              customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
              customInputDecoration: Styles.customTextInputDecorationWithBorder(
                hint: 'Name',
                borderRadius: 0,
              ),
              label: 'Name',
              functionValidate: (value) {
                if (value == '') {
                  return 'Please enter name';
                }
              },
            ),
            Spacers(height: 10.0),
            TextFormFieldWidget(
              controller: _mobileController,
              enabled: false,
              textInputType: TextInputType.text,
              customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
              customInputDecoration: Styles.customTextInputDecorationWithBorder(
                hint: 'Mobile',
                borderRadius: 0,
              ),
              label: 'Mobile',
            ),
            Spacers(height: 10.0),
            TextFormFieldWidget(
              controller: _emailController,
              enabled: false,
              textInputType: TextInputType.emailAddress,
              customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
              customInputDecoration: Styles.customTextInputDecorationWithBorder(
                hint: 'Email',
                borderRadius: 0,
              ),
              label: 'Email',
            ),
            Spacers(height: 10.0),
            titleWidget('Gender'),
            CustomDropdownWidget(
              valuesList: ['Male', 'Female'],
              validateGender: true,
              initialValue: selectedGender,
              textSize: 16.0,
              themeTextColor: Palette.black,
              hint: 'Gender',
              selectedValue: (value) => onGenderChanged(value),
            ),
            countryDropDownWidget(),
            stateDropDownWidget(),
            cityDropDownWidget(),
            Spacers(height: 10.0),
            TextFormFieldWidget(
              controller: _addressController,
              textInputType: TextInputType.text,
              customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
              customInputDecoration: Styles.customTextInputDecorationWithBorder(
                hint: 'Address',
                borderRadius: 0,
              ),
              label: 'Address',
            ),
            Spacers(height: 10.0),
            FilledButton(
              color: Palette.accentColor,
              text: 'UPDATE',
              fontFamily: bold,
              onTap: onUpdateClicked,
            ),
          ],
        ),
      ),
    );
  }

  Widget countryDropDownWidget() {
    if (isLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacers(height: 10.0),
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

  void onGenderChanged(String gender) {
    selectedGender = gender;
  }

  void onCountrySelected(country) {
    selectedCountry = country;
    selectedState = null;
    selectedCity = null;
    context.read<LocationProvider>().getState(country.id);
  }

  void onStateSelected(state) {
    selectedState = state;
    selectedCity = null;
    context.read<LocationProvider>().getCity(state.id);
  }

  void onCitySelected(city) {
    selectedCity = city;
  }

  void onUpdateClicked() {
    if (_updateProfileFormKey.currentState.validate()) {
      openPasswordDialog();
    }
  }

  void openPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldWidget(
                  controller: _passwordController,
                  textInputType: TextInputType.text,
                  customTextStyle: Styles.customTextStyle(color: Palette.black, fontSize: 16.0),
                  customInputDecoration: Styles.customTextInputDecorationWithBorder(
                    hint: 'Enter Password',
                    borderRadius: 0,
                  ),
                  label: 'Password',
                  obscureText: true,
                ),
                Spacers(height: 12.0),
                FilledButton(
                  color: Palette.accentColor,
                  text: Strings.confirmPassword.toUpperCase(),
                  fontFamily: bold,
                  onTap: checkPassword,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkPassword() {
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text.trim() == sharedPref.getString(Constants.PASSWORD)) {
      Navigator.pop(context);
      hideKeyboard(context);
      Map<String, dynamic> userMap = Map();
      userMap.putIfAbsent('u_id', () => currentUser.id);
      userMap.putIfAbsent('u_name', () => _nameController.text.trim());
      userMap.putIfAbsent('u_email', () => currentUser.userEmail);
      userMap.putIfAbsent('u_password', () => sharedPref.getString(Constants.PASSWORD));
      userMap.putIfAbsent('u_add', () => _addressController.text.trim());
      userMap.putIfAbsent('u_gen', () => selectedGender.substring(0, 1));
      userMap.putIfAbsent('u_mob', () => currentUser.userMobile);
      userMap.putIfAbsent('state_id', () => selectedState.id);
      userMap.putIfAbsent('city_id', () => selectedCity.id);
      userMap.putIfAbsent('country_id', () => selectedCountry.id);

      /// just adding here and will be removed from provider
      /// only to get this data at the payment type as calling api to fetch names from ID every time
      /// is not the best practices and does not even need to when are already fetching data in getProfile
      /// API CALL.
      userMap.putIfAbsent('state_name', () => selectedState.name);
      userMap.putIfAbsent('city_name', () => selectedCity.name);
      userMap.putIfAbsent('country_name', () => selectedCountry.name);

      context.read<AuthProvider>().updateUserProfile(userMap);
    } else {
      showToast('Please enter proper password');
    }
  }
}

class PickProfilePictureWidget extends StatefulWidget {
  final Function updateProfile;
  final String userProfileLink;

  const PickProfilePictureWidget({Key key, this.updateProfile, this.userProfileLink}) : super(key: key);

  @override
  _PickProfilePictureWidgetState createState() => _PickProfilePictureWidgetState();
}

class _PickProfilePictureWidgetState extends State<PickProfilePictureWidget> {
  File currentSelectedFile;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Consumer<AuthProvider>(
        builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!model.isImageBusy)
                  ProfileImage(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    imageUrl: currentSelectedFile != null ? null : widget.userProfileLink,
                    imageFile: currentSelectedFile != null ? currentSelectedFile.path : null,
                    useCachedImage: false,
                  )
                else
                  SizedBox(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    child: const NativeLoader(),
                  ),
                const Spacers(height: 12.0),
                FilledButton(
                  color: Colors.grey,
                  text: 'REMOVE PICTURE',
                  fontFamily: bold,
                  onTap: () async {
                    await context.read<AuthProvider>().removeProfilePicture();
                    Navigator.of(context).pop();
                  },
                ),
                const Spacers(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        color: Palette.accentColor,
                        text: 'GALLERY',
                        fontFamily: bold,
                        onTap: () => pickImage(ImageSource.gallery),
                      ),
                    ),
                    Spacers(width: 8.0),
                    Expanded(
                      child: FilledButton(
                        color: Palette.accentColor,
                        text: 'CAMERA',
                        fontFamily: bold,
                        onTap: () => pickImage(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
                const Spacers(height: 12.0),
                FilledButton(
                  color: Palette.accentColor,
                  text: 'SAVE PICTURE',
                  fontFamily: bold,
                  // onTap: () => widget.updateProfile(currentSelectedFile),
                  onTap: () async {
                    if (currentSelectedFile != null) {
                      await model.changeProfilePicture(currentSelectedFile);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void pickImage(ImageSource source) async {
    File imagePicked = await Utils.pickImage(source: source);
    setState(() {
      currentSelectedFile = imagePicked;
    });
  }
}

class UserProfileImage extends StatefulWidget {
  const UserProfileImage();

  @override
  _UserProfileImageState createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  AuthProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuthProvider>(context);
    return _provider.currentUser.userImageLink != null
        ? ProfileImage(
            onTap: onProfilePictureTap,
            width: screenWidth * 0.3,
            height: screenWidth * 0.3,
            imageUrl: _provider.currentUser.userImageLink,
            useCachedImage: false,
          )
        : InkWell(
            onTap: onProfilePictureTap,
            child: Container(
              width: screenWidth * 0.3,
              height: screenWidth * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(Assets.imagesDefault),
                ),
              ),
            ),
          );
  }

  /// Group of functions which provides the basic functionality like taps.
  void onProfilePictureTap() {
    openProfilePictureDialog();
  }

  void openProfilePictureDialog() async {
    final result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return PickProfilePictureWidget(
          updateProfile: (selectedFile) {
            Navigator.of(context).pop(selectedFile);
          },
          userProfileLink: _provider.currentUser.userImageLink,
        );
      },
    );

    if (result != null) {
      await _provider.changeProfilePicture(result);
      setState(() {});
    }
  }
}
