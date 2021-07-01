import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

class Texts extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final double letterSpacing;
  final TextDecoration textDecoration;
  final String fontFamily;

  const Texts(
    this.text, {
    Key key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign: TextAlign.left,
    this.letterSpacing,
    this.textDecoration,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Styles.customTextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        textDecoration: textDecoration,
        fontFamily: fontFamily ?? regular,
      ),
    );
  }
}
