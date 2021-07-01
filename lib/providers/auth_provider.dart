import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/login/check_phone_model.dart';
import 'package:us_club/model/login/login_model.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/model/register/register_model.dart';
import 'package:us_club/model/updateProfile/update_profile_image_model.dart';
import 'package:us_club/widgets/widgets.dart';

class AuthProvider extends ChangeNotifier {
  LoginData _currentUserData;

  LoginData get currentUser => _currentUserData;

  bool _busy = false;

  bool get isBusy => _busy;

  bool _imageBusy = false;

  bool get isImageBusy => _imageBusy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<void> setCurrentUser(LoginData userData) async {
    _currentUserData = userData;
    sharedPref.setString(Constants.EMAIL, _currentUserData?.userEmail);
    sharedPref.setString(Constants.NAME, _currentUserData?.userName);
    notifyListeners();
  }

  Future<LoginModel> loginMe(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      showLoader();
      final response = await api.loginUser(map);
      if (response != null && response.status == 200) {
        await setCurrentUser(response.data[0]);
        setUserProfile();
      } else {
        if (response.message != null && response.message.isNotEmpty) {
          showToast(response.message, gravity: ToastGravity.TOP);
        } else {
          showToast(somethingWentWrong, gravity: ToastGravity.TOP);
        }
      }
      hideLoader();
      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<RegisterModel> registerUser(Map<String, dynamic> userDetails) async {
    if (await isNetworkConnected()) {
      showLoader();
      final response = await api.registerUser(userDetails);
      if (response.isNotNull) {
        if (response.status) {
          if (response.data != null) {
            setUserProfile(id: response.data[0].userId);
          }
        } else {
          try {
            if (response.message != null && response.message.isNotEmpty) {
              showToast(response.message, gravity: ToastGravity.TOP);
            } else {
              showToast(somethingWentWrong, gravity: ToastGravity.TOP);
            }
          } catch (e) {
            showLog("Register Provider exception =======>>> $e");
          }
        }
      }
      hideLoader();

      return response;
    } else {
      showToast(noInternet);
    }
    return null;
  }

  void updateUserProfile(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      showLoader();

      final cityName = map['city_name'];
      final stateName = map['state_name'];
      final countryName = map['country_name'];

      /// MUST NOT BE PASSED IN API
      map.remove('city_name');
      map.remove('state_name');
      map.remove('country_name');

      final response = await api.updateProfile(map);
      if (response.isNotNull) {
        try {
          UpdateProfileModel updateProfileModel = response;
          if (updateProfileModel.data != null && updateProfileModel.data.isNotEmpty) {
            // print("111 ==> ${updateProfileModel.data[0].status}");
            if (updateProfileModel.data[0].status == 'Update Success') {
              // print("222");

              currentUser.userCityName = cityName;
              currentUser.userStateName = stateName;
              currentUser.userCountryName = countryName;
              showToast("Profile updated successfully!");
              setUserProfile();
            } else {
              // print("333");
              showToast(updateProfileModel.data[0].status);
            }
          } else if (updateProfileModel.data is String) {
            // print("444");
            showToast(updateProfileModel.data);
          }
        } catch (e) {
          // print("555");
          showLog("Update user exception =======>>> $e");
        }
      }
      hideLoader();
    } else {
      showToast(noInternet);
    }
  }

  Future<void> setUserProfile({String id}) async {
    try {
      if (await isNetworkConnected() && (currentUser != null || id != null)) {
        showLoader();
        LoginModel response = await api.getUserProfile(id != null ? id : currentUser.id);

        if (response != null && response.data != null && response.data[0].error.toString().isEmptyORNull) {
          sharedPref.setString(Constants.AUTH_TOKEN, LoginData().toJson(response?.data[0]));
          setCurrentUser(response.data[0]);
        }
        hideLoader();
      }
    } catch (e, stackTrace) {
      hideLoader();
      print("exception =====>>> $e");
      print("exception stackTrace =====>>> $stackTrace");
    }
  }

  Future<void> changeProfilePicture(File selectedFile) async {
    if (await isNetworkConnected() && currentUser != null) {
      _imageBusy = true;
      notifyListeners();

      ProfilePicUpdateModel response = await api.uploadUserImage(selectedFile, currentUser.id);
      if (response.data != null && response.data.uImg != null && response.data.uImg.isNotEmpty) {
        currentUser.userImageLink = null;

        PaintingBinding.instance.imageCache.clear();
        await Future.delayed(const Duration(microseconds: 500));
        _imageBusy = false;
        notifyListeners();
        setUserProfile();
      }
    }
  }

  Future<CheckPhoneModel> checkPhoneNumber(String phoneNumber) async {
    if (await isNetworkConnected()) {
      showLoader();
      try {
        CheckPhoneModel response = await api.checkPhoneNumber(phoneNumber);
        if (response != null && response.status != null && response.status) {
          hideLoader();
          return response;
        } else {
          if (response.message != null) showToast(response.message);
        }
      } catch (e) {
        showToast(e.toString());
      }
      hideLoader();
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<OtpModel> sendUserOtp(String phoneNumber) async {
    CheckPhoneModel response = await checkPhoneNumber(phoneNumber);
    if (await isNetworkConnected()) {
      if (response != null) {
        showLoader();
        try {
          OtpModel response = await api.sendOtp(phoneNumber);
          if (response != null && response.status != null && response.status == 'Success') {
            hideLoader();
            return response;
          }
        } catch (e) {
          showToast(e.toString());
        }
        hideLoader();
      }
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<OtpModel> verifyUserOtp(String sessionId, String otpInput) async {
    if (await isNetworkConnected()) {
      showLoader();
      try {
        OtpModel response = await api.verifyOtp(sessionId, otpInput);
        if (response != null && response.status != null && response.status == 'Success') {
          hideLoader();
          return response;
        }
      } catch (e) {
        showToast(e.toString());
      }
      hideLoader();
    } else {
      showToast(noInternet);
    }
    return null;
  }

  updateUserLocations<T>() async {
    try {
      // showLog("currentUser.userCountryName before =======>>> ${_currentUserData.userCountryId}");
      // showLog("currentUser.userCountryName before =======>>> ${_currentUserData.userStateId}");
      // showLog("currentUser.userCountryName before =======>>> ${_currentUserData.userCityId}");

      final responses = await Future.wait([
        getCountryById(_currentUserData.userCountryId),
        getStateById(_currentUserData.userStateId, _currentUserData.userCountryId),
        getCityById(_currentUserData.userCityId, _currentUserData.userStateId),
      ]) as List<T>;

      showLog("updateUserLocations =======>>> ${responses?.size}");

      if (!responses.isNullOrEmpty && responses.size == 3) {
        _currentUserData.userCountryName = (responses[0] as Country)?.name;
        _currentUserData.userStateName = (responses[1] as States)?.name;
        _currentUserData.userCityName = (responses[2] as City)?.name;
        // showLog("updateUserLocations");
        // showLog("currentUser.userCountryName =======>>> ${currentUser.userCountryName}");
        // showLog("currentUser.userCountryName =======>>> ${currentUser.userStateName}");
        // showLog("currentUser.userCountryName =======>>> ${currentUser.userCityName}");
      }
    } catch (e, stackTrace) {
      print("updateUserLocations exception =====>>> $e");
      print("updateUserLocations exception stackTrace =====>>> $stackTrace");
    }
    notifyListeners();
  }

  static Future<Country> getCountryById(String id) async {
    if (await isNetworkConnected()) {
      final CountryModel response = await api.getCountries();
      try {
        return response?.data?.firstWhere((element) => element.id == id);
      } catch (e) {}
    } else {
      showToast(noInternet);
    }

    return null;
  }

  static Future<States> getStateById(String id, String countryId) async {
    if (await isNetworkConnected()) {
      final StateModel response = await api.getStates(countryId);
      try {
        States cState = response?.data?.firstWhere((element) => element.id == id);
        return cState;
      } catch (e) {}
    } else {
      showToast(noInternet);
    }
    return null;
  }

  static Future<City> getCityById(String id, String stateId) async {
    if (await isNetworkConnected()) {
      final CityModel response = await api.getCities(stateId);
      try {
        return response?.data?.firstWhere((element) => element.id == id);
      } catch (e) {}
    } else {
      showToast(noInternet);
    }
    return null;
  }

  Future<void> removeProfilePicture() async {
    if (await isNetworkConnected() && currentUser != null) {
      showLoader();
      final response = await api.removeUserImage(_currentUserData.id);
      hideLoader();
      showToast(response?.message);
      if (response != null && response.status) {
        _currentUserData.userImageLink = noImageAvailable;
        notifyListeners();
      }
    }
  }
}
