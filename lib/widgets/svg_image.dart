import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:us_club/base/export_base.dart';

class SvgImage extends StatelessWidget {
  final imageUrl;
  final height;
  final width;
  final color;

  const SvgImage(this.imageUrl, {Key key, this.height, this.width, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imageUrl,
      color: color,
      width: width.toString().toDouble(),
      height: height.toString().toDouble(),
    );
  }
}
