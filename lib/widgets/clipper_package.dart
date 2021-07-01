import 'package:flutter/material.dart';

class ArrowClipperP extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.width);
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ArrowClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.width);
    path.lineTo(size.height, size.width);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
