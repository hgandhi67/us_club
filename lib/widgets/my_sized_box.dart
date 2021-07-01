import 'package:flutter/material.dart';

class Spacers extends StatelessWidget {
  final width;
  final height;

  const Spacers({this.width: 5.0, this.height: 5.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.toDouble(), height: height.toDouble());
  }
}
