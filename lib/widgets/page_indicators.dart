import 'package:flutter/material.dart';
import 'package:us_club/base/palette.dart';

class PageIndicators extends StatelessWidget {
  final List indicatorsList;
  final int index;
  final Color activeColor;
  final Color inActiveColor;
  final double size;
  final double thickness;
  final bool isFill;
  final bool isScale;

  const PageIndicators({
    Key key,
    @required this.indicatorsList,
    @required this.index,
    this.activeColor = Palette.accentColor,
    this.inActiveColor = Palette.greyShade,
    this.size = 13,
    this.thickness = 2.5,
    this.isFill = false,
    this.isScale = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size + 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < indicatorsList.length; i++)
            if (i == index) ...[circleBar(true)] else circleBar(false),
        ],
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: isScale
          ? isActive
          ? size
          : (size / 2) + 0.5
          : size,
      width: isScale
          ? isActive
          ? size
          : (size / 2) + 0.5
          : size,
      decoration: BoxDecoration(
        color: isFill
            ? isActive
            ? activeColor
            : inActiveColor
            : null,
        border: !isFill
            ? Border.all(
          color: isActive ? activeColor : inActiveColor,
          width: isActive ? thickness : thickness - 1,
        )
            : null,
        borderRadius: BorderRadius.all(Radius.circular(size)),
      ),
    );
  }
}
