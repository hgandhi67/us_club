import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool mini;
  final bool divider;
  final Color color;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const CustomTile({
    this.leading,
    @required this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.onLongPress,
    this.mini = true,
    this.color = Colors.white,
    this.divider = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: padding,
        margin: margin,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                leading ?? SizedBox(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: mini ? 10 : 15),
                    padding: EdgeInsets.symmetric(vertical: mini ? 3 : 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              title,
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  icon ?? SizedBox(),
                                  subtitle ?? SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                        trailing ?? SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            divider ? Divider(height: 20, thickness: 1) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
