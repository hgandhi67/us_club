import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

class Styles {
  static customTextStyle({
    Color color: Colors.black,
    FontWeight fontWeight: FontWeight.normal,
    double fontSize: 15.0,
    TextDecoration textDecoration: TextDecoration.none,
    double letterSpacing,
    String fontFamily = light,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      decoration: textDecoration,
      letterSpacing: letterSpacing,
    );
  }

  static customTextInputDecoration(
      {Color borderColor: Colors.white,
      Color fillColor: Colors.white,
      String errorText,
      String hintText: '',
      double contentPadding: 12.0}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(contentPadding),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorText: errorText,
      errorStyle: customTextStyle(fontSize: 12.0, color: Palette.red.withOpacity(0.5)),
      hintText: hintText,
      hintStyle: customTextStyle(
        color: Palette.accentColor,
        fontSize: 14.0,
      ),
      labelText: hintText,
      labelStyle: customTextStyle(
        color: Palette.accentColor,
        fontSize: 16.0,
      ),
      filled: true,
      fillColor: fillColor,
    );
  }

  static customTextInputDecorationWithCustomBorders(
      {Color borderColor: Colors.white,
      Color fillColor: Colors.white,
      String errorText,
      String hintText: '',
      Color hintColor: Palette.accentColor,
      double contentPadding: 11.0}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(contentPadding),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      hintText: hintText,
      hintStyle: customTextStyle(
        color: hintColor,
        fontSize: 15.0,
      ),
      labelText: hintText,
      labelStyle: customTextStyle(
        color: Palette.accentColor,
        fontSize: 16.0,
      ),
      filled: true,
      fillColor: fillColor,
    );
  }

  static customTextInputDecorationWithSuffix({
    Color borderColor: Colors.white,
    Color fillColor: Colors.white,
    String errorText,
    String hintText: '',
    Color hintColor: Palette.accentColor,
    Widget suffix,
    int type: 1,
    bool labelText: true,
    double contentPadding = 15.0,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: contentPadding, horizontal: contentPadding),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorText: errorText,
      errorStyle: customTextStyle(fontSize: 12.0, color: Palette.red.withOpacity(0.5)),
      suffix: type == 0 ? null : suffix,
      suffixIcon: type == 0 ? suffix : null,
      hintText: hintText,
      hintStyle: customTextStyle(
        color: hintColor,
        fontSize: 15.0,
      ),
      labelText: labelText ? hintText : null,
      labelStyle: customTextStyle(
        color: Palette.accentColor,
        fontSize: 16.0,
      ),
      filled: true,
      fillColor: fillColor,
    );
  }

  static customTextInputDecorationWithBorder(
      {bool isBorder: true,
      double borderRadius: 12.0,
      String hint,
      String errorText,
      Widget prefixIcon,
      Widget suffixIcon,
      EdgeInsets contentPadding}) {
    return InputDecoration(
      contentPadding: contentPadding,
      border: isBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Palette.grey),
            )
          : null,
      enabledBorder: isBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Palette.grey),
            )
          : null,
      errorBorder: isBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Palette.red),
            )
          : null,
      disabledBorder: isBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Palette.grey),
            )
          : null,
      focusedBorder: isBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Palette.grey),
            )
          : null,
      hintText: hint,
      hintStyle: Styles.customTextStyle(fontSize: 15.0, color: Palette.grey),
      errorText: errorText,
      errorStyle: Styles.customTextStyle(fontSize: 13.0, color: Palette.red),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
