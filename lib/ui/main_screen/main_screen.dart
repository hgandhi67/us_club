import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/ui/main_screen/categories/categories_screen.dart';
import 'package:us_club/ui/main_screen/explore/explore_screen.dart';
import 'package:us_club/ui/main_screen/home/home_screen.dart';
import 'package:us_club/ui/main_screen/orders/orders_tab.dart';
import 'package:us_club/ui/main_screen/profile/profile_tab.dart';
import 'package:us_club/ui/main_screen/widgets/cart_icon_widget.dart';
import 'package:us_club/widgets/base_scaffold.dart';
import 'package:us_club/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool isBusy = true;

  DateTime backButtonPressTime;

  List<Widget> pages = [
    const HomeScreen(),
    const CategoriesScreen(),
    const OrdersTab(),
    const ExploreScreen(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
    context.read<IndexProvider>().setTabController(_tabController);
  }

  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null || now.difference(backButtonPressTime) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      showToast("Tap again to exit!");

      // final result = await showDialog(
      //   context: context,
      //   builder: (_) => const ConfirmationDialog(title: "Are you sure you want to exit?", message: ""),
      // );
      //
      // if (result != null) {
      //   return true;
      // }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IndexProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () => handleWillPop(context),
      child: BaseScaffold(
        isAppbar: true,
        elevation: 0.0,
        appBarColor: Colors.white,
        backgroundColor: Palette.greyLight,
        isDrawer: true,
        leading: const SizedBox(),
        currentIndex: provider.currentIndex,
        isNavigationBar: true,
        title: InkWell(
          onTap: () {
            provider.setIndex(0);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Image.asset(
            ImagesLink.app_logo,
            height: 33,
            fit: BoxFit.cover,
          ),
        ),
        onNavigationChanged: (index) async {
          showLog("onNavigationChanged =======>>> $index");

          if (provider.currentIndex != 3 && index == 3) {
            showLoader();
            await context.read<ExploreProvider>().getExploreProducts("50");
            hideLoader();
          }

          // setState(() {
          //   provider.setIndex(index);
          // });
        },
        action: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: Palette.grey),
              onPressed: () {
                navigator.navigateTo(
                  Routes.searchScreen,
                  arguments: SearchScreenArguments(query: "", isSearch: true),
                );
              },
            ),
            const CartIconWidget(routeName: Routes.mainScreen),
          ],
        ),
        child: provider.tabController == null
            ? const SizedBox()
            : TabBarView(
                controller: provider.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
      ),
    );
  }
}
