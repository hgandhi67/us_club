import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class FilledButton extends StatelessWidget {
  final onTap;
  final String text;
  final Color textColor;
  final Color color;
  final double borderRadius;
  final double minWidth;
  final double height;
  final double elevation;
  final Color borderSideColor;
  final Widget leading;
  final Widget trailing;
  final FontWeight fontWeight;
  final String fontFamily;

  const FilledButton({
    Key key,
    this.onTap,
    this.text,
    this.textColor: Colors.white,
    this.color: Palette.accentColor,
    this.borderRadius,
    this.minWidth,
    this.height,
    this.elevation,
    this.borderSideColor,
    this.leading,
    this.trailing,
    this.fontWeight: FontWeight.w600,
    this.fontFamily: regular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth ?? context.screenWidth,
      height: 50.0,
      child: MaterialButton(
        color: color,
        elevation: elevation,
        splashColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          side: BorderSide(color: borderSideColor ?? color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leading ?? SizedBox(),
            Expanded(
              child: Center(
                child: Texts(
                  text ?? '',
                  color: textColor,
                  fontSize: 17.0,
                  letterSpacing: 1,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            trailing ?? SizedBox(),
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  final onTap;
  final String text;
  final Color textColor;
  final Color color;
  final double fontSize;
  final double borderRadius;
  final double minWidth;
  final double height;
  final double elevation;
  final Color borderSideColor;
  final Widget leading;
  final Widget trailing;
  final FontWeight fontWeight;
  final String fontFamily;
  final double padding;

  const BorderButton({
    Key key,
    this.onTap,
    this.text,
    this.color: Colors.white,
    this.textColor: Palette.accentColor,
    this.borderRadius,
    this.minWidth,
    this.height,
    this.elevation: 0.0,
    this.borderSideColor: Palette.accentColor,
    this.leading,
    this.trailing,
    this.fontWeight: FontWeight.w600,
    this.fontFamily: semiBold,
    this.fontSize: 17.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: context.screenWidth,
      height: 50.0,
      child: MaterialButton(
        color: color,
        elevation: elevation,
        padding: EdgeInsets.symmetric(horizontal: padding ?? 15, vertical: 5),
        splashColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          side: BorderSide(color: borderSideColor ?? color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leading ?? SizedBox(),
            Expanded(
              child: Center(
                child: Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: Styles.customTextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    letterSpacing: 1,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
            trailing ?? SizedBox(),
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}

class EmptyButton extends StatelessWidget {
  final onTap;
  final String text;
  final Color textColor;
  final Color color;
  final Widget leading;
  final Widget trailing;
  final String fontFamily;

  const EmptyButton({
    Key key,
    this.onTap,
    this.text,
    this.color: Colors.white,
    this.textColor: Palette.accentColor,
    this.leading,
    this.trailing,
    this.fontFamily: regular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leading ?? SizedBox(),
            Expanded(
              child: Center(
                child: Text(
                  text ?? '',
                  style: Styles.customTextStyle(
                    color: textColor,
                    fontSize: 17.0,
                    letterSpacing: 1,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
            trailing ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
