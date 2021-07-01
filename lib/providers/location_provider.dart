import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';

class LocationProvider extends ChangeNotifier {
  List<Country> _countries = [];
  List<States> _states = [];
  List<City> _cities = [];

  List<Country> get countryList => _countries.toSet().toList();

  List<States> get statesList => _states.toSet().toList();

  List<City> get cityList => _cities.toSet().toList();

  bool _busy = false;

  bool get isBusy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void getCountries() async {
    if (await isNetworkConnected()) {
      showLoader();
      final CountryModel response = await api.getCountries();
      _countries = response?.data;
      hideLoader();
      notifyListeners();
    } else {
      showToast(noInternet);
    }
  }

  void getState(String countryId) async {
    if (await isNetworkConnected()) {
      showLoader();
      final StateModel response = await api.getStates(countryId);
      _states = response.data;
      hideLoader();
      notifyListeners();
    } else {
      showToast(noInternet);
    }
  }

  void getCity(String stateId) async {
    if (await isNetworkConnected()) {
      showLoader();
      final CityModel response = await api.getCities(stateId);
      _cities = response.data;
      hideLoader();
      notifyListeners();
    } else {
      showToast(noInternet);
    }
  }

  Future<Country> getCountryById(String id) async {
    try {
      if (await isNetworkConnected()) {
        // showLoader();
        final CountryModel response = await api.getCountries();
        _countries = response.data;
        // hideLoader();
        notifyListeners();
        return _countries.firstWhere((element) => element.id == id);
      } else {
        showToast(noInternet);
      }
    } catch (e, stackTrace) {
      print("exception =====>>> $e");
      print("exception stackTrace =====>>> $stackTrace");
    }

    return null;
  }

  Future<States> getStateById(String id, String countryId) async {
    try {
      if (await isNetworkConnected()) {
        // showLoader();
        final StateModel response = await api.getStates(countryId);
        _states = response.data;
        // hideLoader();
        notifyListeners();
        States cState = _states.firstWhere((element) => element.id == id);
        return cState;
      } else {
        showToast(noInternet);
      }
    } catch (e, stackTrace) {
      print("exception =====>>> $e");
      print("exception stackTrace =====>>> $stackTrace");
    }
    return null;
  }

  Future<City> getCityById(String id, String stateId) async {
    try {
      if (await isNetworkConnected()) {
        // showLoader();
        final CityModel response = await api.getCities(stateId);
        _cities = response.data;
        // hideLoader();
        notifyListeners();
        return _cities.firstWhere((element) => element.id == id);
      } else {
        showToast(noInternet);
      }
    } catch (e, stackTrace) {
      print("exception =====>>> $e");
      print("exception stackTrace =====>>> $stackTrace");
    }
    return null;
  }
}
