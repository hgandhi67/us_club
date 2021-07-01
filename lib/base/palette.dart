import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

class Palette {
  static const accentColor = Color(0xFFF73F37);
  static const accentLight = Color(0xAAF73F37);
  static const red = Colors.red;
  static const black = Colors.black;
  static const white = Colors.white;
  static const grey = Color(0xFF707070);
  static const darkGrey = Color(0xFF8D8D8D);
  static const greyShade = Color(0xFF8A8A8F);
  static const greyLight2 = Color(0xFFAFACB1);
  static const redHeart = Color(0xFFFF3B30);
  static const fbBlue = Color(0xFF4267B2);
  static const greyLight = Color(0xFFF3F3F3);
  static const yellow = Color(0xFFFFD200);

  static const blackWithOpacity = Color(0xFF202020);
  static const blue = Color(0xFF0084FE);
  static const femaleColor = Color(0xFF5b0293);
  static const greenColor = Colors.green;
  static final disabledColor = Colors.grey[850];

  static ThemeData lightTheme = ThemeData(
    primaryColor: accentColor,
    accentColor: accentColor.withOpacity(0.8),
    primarySwatch: Colours.swatch("F73F37"),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    textSelectionColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Palette.grey,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: accentColor,
      contentTextStyle: Styles.customTextStyle(
        color: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: accentColor,
    accentColor: accentColor.withOpacity(0.8),
    backgroundColor: Colors.black38,
    primarySwatch: Colours.swatch("F73F37"),
    brightness: Brightness.dark,
    // backgroundColor: Colors.grey[850],
    textSelectionColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
    ),
    iconTheme: IconThemeData(
      color: Colors.grey[700],
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: accentColor,
      contentTextStyle: Styles.customTextStyle(
        color: Colors.white,
      ),
    ),
  );
}
