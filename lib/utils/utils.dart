import 'dart:io';
import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as c;
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:us_club/base/export_base.dart';

class Utils {
  static String formatDateFromApi(String inputtedDate) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat("dd MMM yyyy");
      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in formatDateFromApi parsing date ---> $e");
      return null;
    }
  }

  static String formatDateFromApi2(String inputtedDate) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat("dd MMM");
      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in formatDateFromApi2 parsing date ---> $e");
      return null;
    }
  }

  static String formatDateFromApi3(String inputtedDate) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat("EEE, dd MMM yyyy");
      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in formatDateFromApi3 parsing date ---> $e");
      return null;
    }
  }

  static String formatTimeFromApi(String inputtedDate) {
    try {
      var inputFormat = DateFormat("HH:mm:ss");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat("hh:mm a");
      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in formatTimeFromApi parsing time ---> $e");
      return null;
    }
  }

  static String formatDateAPI(String inputtedDate) {
    try {
      var inputFormat = DateFormat("dd MMM yyyy");
      var outputFormat = DateFormat("yyyy-MM-dd");
      var date1 = inputFormat.parse(inputtedDate);

      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in formatDateAPI parsing date ---> $e");
      return null;
    }
  }

  // static String formatTimeStamp(Timestamp timestamp) {
  //   try {
  //     var outputFormat = DateFormat("dd MMM yyyy hh:mm a");
  //
  //     var date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  //
  //     return outputFormat.format(date);
  //   } on Exception catch (e) {
  //     print("Error in formatTimeStamp parsing date ---> $e");
  //     return null;
  //   }
  // }

  static String formatDateAndTimeForComments(String inputtedDate) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var outputFormat = DateFormat("dd MMM yyyy hh:mm a");

      var date1 = inputFormat.parse(inputtedDate);

      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in formatDateAndTimeForComments parsing date ---> $e");
      return null;
    }
  }

  // static String formatTimeStampToDate(Timestamp timestamp) {
  //   try {
  //     var outputFormat = DateFormat("dd MMM yyyy");
  //
  //     var date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  //
  //     return outputFormat.format(date);
  //   } on Exception catch (e) {
  //     print("Error in formatTimeStampToDate parsing date ---> $e");
  //     return null;
  //   }
  // }

  static String currentDate() {
    try {
      var outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(DateTime.now());
    } on Exception catch (e) {
      print("Error in currentDate parsing date ---> $e");
      return null;
    }
  }

  static String currentTime() {
    try {
      var outputFormat = DateFormat("HH:mm:ss");
      return outputFormat.format(DateTime.now());
    } on Exception catch (e) {
      print("Error in currentTime parsing date ---> $e");
      return null;
    }
  }

  static bool isTimeBeforeCurrent(String date, String time) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var date1 = DateTime.now();
      var date2 = inputFormat.parse(date + " " + time);

      if (date2.isBefore(date1)) {
        return true;
      }

      return false;
    } on Exception catch (e) {
      print("Error isTimeBeforeCurrent in parsing time ---> $e");
      return null;
    }
  }

  static String ddMmYyyy({DateTime date1, DateTime date2}) {
    try {
      var outputFormat;
      if (date1 != null) {
        outputFormat = DateFormat("dd MMMM yyyy");
        return outputFormat.format(date1);
      }

      if (date2 != null) {
        outputFormat = DateFormat("dd MM yyyy");
        return outputFormat.format(date1);
      }

      return "";
    } on Exception catch (e) {
      print("Error in ddMmYyyy parsing date ---> $e");
      return null;
    }
  }

  static String formatDateOnly(String inputtedDate, String format) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat(format);

      var date = outputFormat.format(date1);

      return date;
    } on Exception catch (e) {
      print("Error in formatDateOnly parsing date ---> $e");
      return null;
    }
  }

  static String formatDate4(String inputtedDate) {
    try {
      var date1 = DateTime.parse(inputtedDate);

      var outputFormat = DateFormat("dd MMM");

      var date = outputFormat.format(date1);

      return date;
    } on Exception catch (e) {
      print("formatDate4 parsing date =====>> $e");
      return null;
    }
  }

  static String getMonthFromFullString(String month) {
    switch (month) {
      case "January":
        return "01";
        break;
      case "February":
        return "02";
        break;
      case "March":
        return "03";
        break;
      case "April":
        return "04";
        break;
      case "May":
        return "05";
        break;
      case "June":
        return "06";
        break;
      case "July":
        return "07";
        break;
      case "August":
        return "08";
        break;
      case "September":
        return "09";
        break;
      case "October":
        return "10";
        break;
      case "November":
        return "11";
        break;
      case "December":
        return "12";
        break;
      default:
        return "01";
    }
  }

  static String getMaritalStatus(int number, {bool view = false}) {
    switch (number) {
      case 1:
        return "Single";
      case 2:
        return "Married";
      case 3:
        return "Civil partnership";
      case 4:
        return "Prefer not to say";
      default:
        return !view ? "Select Marital Status" : NA;
    }
  }

  static int getMaritalStatusAPI(String number) {
    switch (number) {
      case "Single":
        return 1;
      case "Married":
        return 2;
      case "Civil partnership":
        return 3;
      case "Prefer not to say":
        return 4;
      default:
        return 0;
    }
  }

  static String getGender(int number, {bool view = false}) {
    switch (number) {
      case 1:
        return "Male";
      case 2:
        return "Female";
      case 3:
        return "Transgender";
      case 4:
        return "Prefer not to say";
      default:
        return !view ? "Select Gender" : NA;
    }
  }

  static int getGenderAPI(String number) {
    switch (number) {
      case "Male":
        return 1;
      case "Female":
        return 2;
      case "Prefer not to say":
        return 3;
      case "Transgender":
        return 4;
      default:
        return 0;
    }
  }

  static String getSex(int number) {
    switch (number) {
      case 1:
        return "Male";
      case 2:
        return "Female";
      default:
        return "Prefer not to say";
    }
  }

  static String getYesOrNo(int number) {
    switch (number) {
      case 1:
        return "Yes";
      case 2:
        return "No";
      case 3:
        return "Don\'t Know";
      default:
        return "No";
    }
  }

  static String getEthnicity(int number) {
    switch (number) {
      case 1:
        return "White";
      case 2:
        return "Black";
      case 3:
        return "Asian";
      default:
        return "White";
    }
  }

  static String getDayFromInt(int month) {
    switch (month) {
      case 1:
        return "Monday";
        break;
      case 2:
        return "Tuesday";
        break;
      case 3:
        return "Wednesday";
        break;
      case 4:
        return "Thursday";
        break;
      case 5:
        return "Friday";
        break;
      case 6:
        return "Saturday";
        break;
      case 7:
        return "Sunday";
        break;
      default:
        return "Monday";
        break;
    }
  }

  static int getIntFromDay(String day) {
    switch (day) {
      case "Monday":
        return 1;
        break;
      case "Tuesday":
        return 2;
        break;
      case "Wednesday":
        return 3;
        break;
      case "Thursday":
        return 4;
        break;
      case "Friday":
        return 5;
        break;
      case "Saturday":
        return 6;
        break;
      case "Sunday":
        return 7;
        break;
      default:
        return 1;
        break;
    }
  }

  int nextIntOfDigits(int digitCount) {
    assert(1 <= digitCount && digitCount <= 9);
    int min = digitCount == 1 ? 0 : pow(10, digitCount - 1);
    int max = pow(10, digitCount);
    return min + Random().nextInt(max - min);
  }

  static String getCurrencySymbol(int paymentType) {
    switch (paymentType) {
      case 1:
        return currencyList[0].symbol;
      case 2:
        return currencyList[1].symbol;
      case 3:
        return currencyList[2].symbol;
      default:
        return "USD";
    }
  }

  static String getCurrencyFromInt(int paymentType) {
    switch (paymentType) {
      case 1:
        return "USD";
      case 2:
        return "NGN";
      case 3:
        return "GBP";
      default:
        return "USD";
    }
  }

  static String getCurrencyAPIFromInt(int paymentType) {
    switch (paymentType) {
      case 1:
        return "usd";
      case 2:
        return "nigerian";
      case 3:
        return "gbp";
      default:
        return "usd";
    }
  }

  static int getIntFromCurrency(String currency) {
    switch (currency) {
      case "USD":
        return 1;
      case "NGN":
        return 2;
      case "GBP":
        return 3;
      default:
        return 1;
    }
  }

  static String getPriceFromInt(var package, {bool isPackage = false}) {
    var paymentType;

    if (isPackage) {
      if (package.paymentType != null) {
        paymentType = package.paymentType;
        showLog("getPriceFromInt paymentType");
      } else {
        paymentType = package.priceType;
        showLog("getPriceFromInt priceType");
      }
    } else {
      paymentType = package.currency;
    }

    showLog("getPriceFromInt ====> $paymentType");

    switch (paymentType) {
      case 1:
        return package.priceInDoller;
      case 2:
        return package.priceInN;
      case 3:
        return package.priceInGbp;
      default:
        return package.priceInDoller;
    }
  }



  static launchUrlInBrowser(String url) async {
    // try {
    //   if (await canLaunch(url)) {
    //     await launch(
    //       url,
    //       forceSafariVC: false,
    //       forceWebView: false,
    //     );
    //   } else {
    //     throw 'launchUrlInBrowser could not launch : $url';
    //   }
    // } catch (e) {
    //   print('launchUrlInBrowser exception ====>>> $e');
    // }
  }

  static void launchUrlInCustomTabs(BuildContext context, String url) async {
    // try {
    //   await c.launch(
    //     url,
    //     option: new c.CustomTabsOption(
    //       toolbarColor: Theme.of(context).primaryColor,
    //       enableDefaultShare: true,
    //       enableUrlBarHiding: true,
    //       showPageTitle: true,
    //       animation: new c.CustomTabsAnimation.slideIn(),
    //       extraCustomTabs: <String>[
    //         // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
    //         'org.mozilla.firefox',
    //         // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
    //         'com.microsoft.emmx',
    //       ],
    //     ),
    //   );
    // } catch (e) {
    //   // An exception is thrown if browser app is not installed on Android device.
    //   print('launchUrlInCustomTabs could not launch : $url');
    // }
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile selectedImage = await ImagePicker().getImage(source: source);
    return await compressImage(selectedImage);
  }

  static Future<File> compressImage(PickedFile imageToCompress) async {
    final actualFile = File(imageToCompress.path);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(actualFile.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    return new File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static shareMe(BuildContext context, String title, String content) {
    final RenderBox box = context.findRenderObject();
    Share.share(
      title,
      subject: content,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  static getFileName(String path) {
    var fileName = (path.split('/').last);
    return fileName;
  }

  static Future clearAppCacheData() async {
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }

  static int calculateAge(String inputtedDate) {
    int age = 0;

    try {
      var inputFormat = DateFormat("yyyy-MM-dd");
      var date1 = inputFormat.parse(inputtedDate);
      var current = DateTime.now();

      age = (current.year - date1.year).ceilToDouble().toInt();
    } on Exception catch (e) {
      print("calculateAge in parsing date ---> $e");
    }
    return age;
  }
}
