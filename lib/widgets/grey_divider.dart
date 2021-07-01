import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

class GreyDivider extends StatelessWidget {
  final height;
  final child;

  const GreyDivider({this.height=20.0, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.toDouble(),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Palette.greyLight2.withOpacity(0.3)),
      child: child,
    );
  }
}
