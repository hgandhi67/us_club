import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:us_club/api/api_service.dart';
import 'package:us_club/base/constants.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/widgets/native_loader.dart';

final int itemThreshHold = 10;

SharedPreferences sharedPref;
String currentTimeZone;
String deviceToken;

bool isChatScreenOpen = false;

final NavigationService navigator = locator<NavigationService>();
final SnackbarService snackbar = locator<SnackbarService>();
final DialogService dialog = locator<DialogService>();

final api = ApiService();

double screenHeight;
double screenWidth;

const String light = 'Poppins-Light';
const String bold = 'Poppins-Bold';
const String semiBold = 'Poppins-Medium';
const String regular = 'Poppins-Regular';

const String NA = "NA";

const String deviceApple = "apple";
const String deviceAndroid = "android";

const String COMMON_PASSWORD = "THC@123";

const String somethingWentWrong = "Something went wrong please try again later!";
const String noInternet = "Please check your internet and try again";
double discount = 10.0;

enum UserType { doctor, user }

bool isUser() {
  var userType = sharedPref.getString(Constants.USER_TYPE);
  return userType != null && userType == "user";
}

void setUserType(String userType) {
  sharedPref.setString(Constants.USER_TYPE, userType.toString());
}

List<String> genderList = ["Select Gender", "Male", "Female", "Transgender", "Prefer not to say"];
List<String> bloodGroupsList = [
  "Select Blood Group",
  "A+",
  "O+",
  "B+",
  "AB+",
  "A-",
  "O-",
  "B-",
  "AB-",
  "Unknown",
];
List<String> maritalStatusList = [
  "Select Marital Status",
  "Single",
  "Married",
  "Civil partnership",
  "Prefer not to say"
];

Future<bool> isNetworkConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

showLog(Object msg) {
//  Fimber.d(msg);
  debugPrint(msg);
}

//showError(String msg, {dynamic ex, StackTrace stackTrace}) {
//  Fimber.e(msg, ex: ex, stacktrace: stackTrace);
//}

showToast(String msg, {ToastGravity gravity: ToastGravity.TOP}) {
  Fluttertoast.showToast(msg: msg ?? somethingWentWrong, toastLength: Toast.LENGTH_SHORT, gravity: gravity);
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String apiParam(var str) {
  return '\"${str.toString()}\"';
}

List<String> daysList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
List<String> mothsList = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
List<String> yearsList = [
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
  "2021",
  "2022",
  "2023",
  "2024",
  "2025",
];
List<Currencies> currencyList = [
  Currencies(name: "USD", symbol: "\$", value: "usd", paymentType: 1),
  Currencies(name: "NGN", symbol: "₦", value: "nigerian", paymentType: 2),
  Currencies(name: "GBP", symbol: "£", value: "gbp", paymentType: 3, isSelected: true),
];

class Currencies {
  String name;
  String value;
  String symbol;
  int paymentType;
  bool isSelected;

  Currencies({this.name, this.value, this.isSelected = false, this.symbol, this.paymentType});
}

class PackagesClass {
  final int index;
  final String id;
  final String image;
  final String title;
  final String price;
  final Color color;
  final List<Features> featuresList;
  bool isSelected;

  PackagesClass({
    this.id,
    this.index,
    this.image,
    this.price,
    this.color,
    this.title,
    this.featuresList,
    this.isSelected = false,
  });
}

class Features {
  String icon;
  String id;
  String title;
  String key;

  Features({
    this.id,
    this.icon,
    this.title,
    this.key,
  });
}

//String Extensions
extension StringExtension on String {
  String sCap() {
    if (!this.isEmptyORNull) {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } else {
      return this;
    }
  }

  String wordCap() {
    return this.isEmptyORNull
        ? ""
        : toLowerCase().split(' ').map((word) {
            final String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
            return word[0].toUpperCase() + leftText;
          }).join(' ');
  }

  String commaCap() {
    return toLowerCase().split(',').map((word) {
      final String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(', ');
  }

  String removeSpaces() {
    return this.replaceAll(RegExp(r"\s+"), "");
  }

  bool get isEmptyORNull => this == null || isEmpty;

  int toInt() {
    return int.tryParse(this);
  }

  double toDouble() {
    return double.tryParse(this);
  }

  String sentenceCap() {
    return this.isEmptyORNull
        ? this
        : toLowerCase().split(".").map((word) {
            final String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
            return word[0].toUpperCase() + leftText;
          }).join('.');
  }

  String get removeLastS {
    String str = this;
    String newStr = str.toLowerCase();

    if (str != null && str.isNotEmpty) {
      if (newStr.endsWith("s")) {
        str = str.substring(0, str.length - 1);
      }
    }

    return str;
  }

  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

// int Extensions
extension IntExtension on int {
  String timestampToString(String formatted) {
    var format = new DateFormat(formatted ?? 'MM-dd-yy HH:mm:ss');
    var date = new DateTime.fromMillisecondsSinceEpoch(this);
    return format.format(date);
  }

  double toDouble() {
    return double.parse(this.toString());
  }
}

// double Extensions
extension DoubletExtension on double {
  int toInt() {
    return int.parse(this.toString());
  }
}

// double Extensions
extension ObjectExtention on Object {
  int toInt() {
    return int.parse(this.toString());
  }

  double toDouble() {
    return double.parse(this.toString());
  }

  bool get isNull => this == null;

  bool get isNotNull => this != null;
}

extension RandomOfDigits on Random {
  int nextIntOfDigits(int digitCount) {
    assert(1 <= digitCount && digitCount <= 9);
    int min = digitCount == 1 ? 0 : pow(10, digitCount - 1);
    int max = pow(10, digitCount);
    return min + this.nextInt(max - min);
  }
}

extension ListExtention<E> on Iterable<E> {
  int get size => this.length;

  // Iterable<T> mapIndexed<T>(T Function(E item, int index) f) {
  //   var index = 0;
  //   return map((e) => f(e, index++));
  // }

  bool get isNullOrEmpty => this == null || this.isEmpty;

  bool get isNull => this == null;

  bool get isNotNull => this != null;

  List<E> distinct() {
    if (this != null) {
      return LinkedHashSet<E>.from(this).toList();
    } else {
      return this;
    }
  }
}

extension MapExtention on Map {
  addIt(String key, dynamic value) {
    this.update(key, (dynamic k) => value, ifAbsent: () => value);
  }
}

CancelFunc loading;

showLoader() {
  loading = BotToast.showCustomLoading(
    backButtonBehavior: BackButtonBehavior.none,
    backgroundColor: Colors.black38,
    toastBuilder: (func) {
      return const NativeLoader();
    },
  );
}

hideLoader() {
  loading?.call();
}
