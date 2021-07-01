import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/widgets/widgets.dart';

class NoDataFound extends StatelessWidget {
  final msg;
  final double size;
  final Color color;
  final GestureTapCallback onTap;

  const NoDataFound({
    Key key,
    this.msg,
    this.size: 20.0,
    this.color: Palette.black,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap != null ? () => onTap?.call() : null,
            behavior: HitTestBehavior.opaque,
            child: Texts(
              msg ?? "No data found.",
              color: color,
              fontSize: size,
              fontFamily: bold,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
