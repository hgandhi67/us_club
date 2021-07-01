import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/ui/main_screen/widgets/cart_icon_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomAppbar extends StatelessWidget implements PreferredSize {
  final Widget leading;
  final dynamic title;
  final List<Widget> actions;
  final isBack;
  final elevation;
  final centerTitle;
  final appBarColor;
  final isLeading;
  final GestureTapCallback onLeading;
  final GestureTapCallback onLogo;
  final String routeName;

  const CustomAppbar({
    this.leading,
    this.title,
    this.actions,
    this.isBack = true,
    this.elevation,
    this.centerTitle,
    this.appBarColor,
    this.isLeading,
    this.onLeading,
    this.onLogo,
    @required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: context.theme.appBarTheme.color,
      elevation: elevation,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: context.theme.iconTheme.color,
        iconSize: 22,
        onPressed: onLeading != null ? onLeading : () => Navigator.of(context).maybePop(),
      ),
      title: InkWell(
        onTap: onLogo == null
            ? () {
                navigator.pushNamedAndRemoveUntil(Routes.mainScreen);
              }
            : onLogo,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Image.asset(
          ImagesLink.app_logo,
          height: 33,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Palette.grey,
          ),
          onPressed: () {
            navigator.navigateTo(
              Routes.searchScreen,
              arguments: SearchScreenArguments(query: "", isSearch: true),
            );
          },
        ),
        CartIconWidget(routeName: routeName),
      ],
    );
  }

  @override
  Widget get child => child;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
