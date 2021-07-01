import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/generated/assets.dart';
import 'package:us_club/model/home/home_model.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

import 'svg_image.dart';

export 'package:velocity_x/velocity_x.dart';

final menuList = [
  DrawerClass(index: 0, title: "Profile", isSelected: true),
  DrawerClass(index: 1, title: "My Clubs"),
  DrawerClass(index: 2, title: "Change Password"),
  DrawerClass(index: 3, title: "Settings"),
  DrawerClass(index: 4, title: "Logout"),
];

class BaseScaffold extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final bool isLeading;
  final bool isAppbar;
  final dynamic title;
  final Widget action;
  final VoidCallback onLeading;
  final onAction;
  final leading;
  final isDrawer;
  final isNavigationBar;
  final currentIndex;
  final Function(int) onNavigationChanged;
  final Function onDrawerSelected;
  final double elevation;
  final Color appBarColor;
  final bool centerTitle;

  const BaseScaffold({
    Key key,
    this.backgroundColor: Palette.white,
    @required this.child,
    this.isLeading = true,
    this.title,
    this.action,
    this.onAction,
    this.onLeading,
    this.isAppbar = false,
    this.leading,
    this.isDrawer = false,
    this.isNavigationBar = false,
    this.onNavigationChanged,
    this.currentIndex,
    this.onDrawerSelected,
    this.elevation,
    this.appBarColor,
    this.centerTitle,
  }) : super(key: key);

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget.backgroundColor,
      appBar: widget.isAppbar
          ? AppBar(
              centerTitle: widget.centerTitle,
              backgroundColor: widget.appBarColor,
              elevation: widget.elevation,
              leading: widget.leading != null
                  ? widget.isDrawer
                      ? IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Palette.grey,
                          ),
                          onPressed: () => _scaffoldKey.currentState.openDrawer(),
                        )
                      : widget.leading
                  : Visibility(
                      visible: widget.isLeading,
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          iconSize: 22,
                          onPressed: widget.onLeading != null
                              ? widget.onLeading
                              : () {
                                  Navigator.of(context).pop();
                                }),
                    ),
              title: (widget.title is String)
                  ? Texts(
                      widget.title ?? "",
                      fontSize: 16.0,
                      color: Palette.white,
                      fontFamily: bold,
                    )
                  : widget.title,
              actions: <Widget>[
                Visibility(
                  visible: widget.action != null,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: widget.onAction,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: widget.onAction != null ? 15 : 0.0),
                      child: Center(
                        child: widget.action,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      drawer: widget.isDrawer ? FrontDrawer(onSelected: widget.onDrawerSelected) : null,
      bottomNavigationBar: widget.isNavigationBar
          ? NavigationBar(
              currentIndex: widget.currentIndex,
              onChanged: (value) => widget.onNavigationChanged(value),
            )
          : null,
      body: widget.child,
    );
  }
}

class DrawerClass {
  bool isSelected;
  String title;
  int index;

  DrawerClass({this.index, this.isSelected = false, this.title});
}

class FrontDrawer extends StatefulWidget {
  final Function onSelected;

  const FrontDrawer({Key key, @required this.onSelected}) : super(key: key);

  @override
  _FrontDrawerState createState() => _FrontDrawerState();
}

class _FrontDrawerState extends State<FrontDrawer> {
  String authToken = sharedPref.getString(Constants.AUTH_TOKEN);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final provider2 = Provider.of<IndexProvider>(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.theme.backgroundColor,
              gradient: LinearGradient(
                colors: [
                  Palette.accentColor,
                  Colors.grey[900],
                  Colors.grey[900],
                  Colors.black,
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0.0, 0.3, 0.5, 0.8, 0.9],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacers(height: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).pop();
                      provider2.setIndex(4);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedImage(
                          provider.currentUser != null ? provider.currentUser.userImageLink : '',
                          placeholder: Assets.imagesDefault,
                          radius: 70,
                          fit: BoxFit.cover,
                        ),
                        const Spacers(height: 15),
                        provider.currentUser == null
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "${Strings.login} ",
                                        style: Styles.customTextStyle(
                                          color: Colors.white,
                                          fontFamily: semiBold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).pop();
                                            navigator.navigateTo(Routes.loginScreen,
                                                arguments:
                                                    LoginScreenArguments(moveBackRoute: Routes.mainScreen));
                                          }),
                                    TextSpan(
                                        text: " ${Strings.signUp}",
                                        style: Styles.customTextStyle(
                                          color: Colors.white,
                                          fontFamily: semiBold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).pop();
                                            navigator.navigateTo(Routes.otpScreen,
                                                arguments:
                                                    OtpScreenArguments(moveBackRoute: Routes.mainScreen));
                                          }),
                                  ],
                                ),
                              )
                            : Texts(
                                provider.currentUser.userName,
                                color: Colors.white,
                                fontFamily: semiBold,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(child: const CategoriesList())
        ],
      ),
    );
  }
}

class NavigationBar extends StatefulWidget {
  final Function(int) onChanged;
  final int currentIndex;

  NavigationBar({Key key, this.onChanged, this.currentIndex}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final List<String> itemsList = [
    ImagesLink.svg_home,
    ImagesLink.svg_categories,
    ImagesLink.svg_gift,
    ImagesLink.svg_explore,
    ImagesLink.svg_user,
  ];

  IndexProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<IndexProvider>(context);

    return BottomNavigationBar(
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Palette.greyShade,
      selectedItemColor: context.theme.accentColor,
      currentIndex: _provider.currentIndex,
      onTap: (index) {
        widget.onChanged.call(index);
        _provider.setIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          title: Texts("Home", fontSize: 10),
          icon: getIconImage(itemsList[0], 0),
        ),
        BottomNavigationBarItem(
          title: Texts("Categories", fontSize: 10),
          icon: getIconImage(itemsList[1], 1),
        ),
        BottomNavigationBarItem(
          title: Texts("Orders", fontSize: 10),
          icon: getIconImage(itemsList[2], 2),
        ),
        BottomNavigationBarItem(
          title: Texts("Explore", fontSize: 10),
          icon: getIconImage(itemsList[3], 3),
        ),
        BottomNavigationBarItem(
          title: Texts("Profile", fontSize: 10),
          icon: getIconImage(itemsList[4], 4),
        ),
      ],
    );
  }

  Widget getIconImage(String path, int index) {
    return SvgImage(
      path,
      width: 20,
      height: 20,
      color: _provider.currentIndex == index ? context.theme.accentColor : Palette.greyShade,
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: provider.categories.length,
        itemBuilder: (_, index) {
          return ItemDrawerCategory(category: provider.categories[index]);
        },
      ),
    );
  }
}

class ItemDrawerCategory extends StatelessWidget {
  final Menubar category;

  const ItemDrawerCategory({this.category});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Texts(
        category.catName,
        color: context.theme.textSelectionColor,
        fontFamily: bold,
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      expandedAlignment: Alignment.centerLeft,
      children: category.subCat.map((e) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pop();
            navigator.navigateTo(
              Routes.subCategoriesScreen,
              arguments: SubCategoriesScreenArguments(
                menuBar: category,
                cid: "",
                isCid: false,
                scid: e.subcatId,
                isScid: true,
              ),
            );
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10, left: 15),
              child: Texts(
                e.subCatName,
                fontFamily: regular,
                textAlign: TextAlign.start,
                color: context.theme.textSelectionColor,
              ),
            ),
          ),
        );

        return ListTile(
          onTap: () {
            Navigator.of(context).pop();
            navigator.navigateTo(
              Routes.subCategoriesScreen,
              arguments: SubCategoriesScreenArguments(
                menuBar: category,
                cid: "",
                isCid: false,
                scid: e.subcatId,
                isScid: true,
              ),
            );
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Texts(
            e.subCatName,
            fontFamily: bold,
            color: context.theme.textSelectionColor,
          ),
        );
      }).toList(),
    );
  }
}
