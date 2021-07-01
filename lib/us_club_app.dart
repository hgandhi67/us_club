import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:us_club/di/export_di.dart' as d;
import 'package:us_club/model/login/login_model.dart';
import 'package:us_club/providers/explore_provider.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/widgets/widgets.dart';

import 'base/export_base.dart';
import 'main.dart';

class UsClub extends StatefulWidget {
  const UsClub();

  @override
  _UsClubState createState() => _UsClubState();
}

class _UsClubState extends State<UsClub> {
  @override
  void initState() {
    super.initState();
    // _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // locator<PushNotificationService>().configure(context);
      // currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      // print("DEVICE LOCAL TIME ZONE ===> $currentTimeZone");
    });

    Future.wait([
      context.read<HomeProvider>().getHomeScreen(),
      context.read<ExploreProvider>().getExploreProducts("20"),
    ]);
  }

  /*void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }*/

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) async {
      /*await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );*/
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      /*await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(payload)),
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      lightTheme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      defaultThemeMode: ThemeMode.light,
      // defaultThemeMode: ThemeMode.dark,
      // defaultThemeMode: ThemeMode.system,
      builder: (_, lightTheme, darkTheme, currentThemeMode) {
        return MaterialApp(
          title: Strings.appName,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentThemeMode,
          initialRoute: '/',
          routes: {
            '/': (_) => PreLoader(),
          },
          builder: BotToastInit(),
          navigatorObservers: [
            BotToastNavigatorObserver(),
          ],
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: d.Router(),
          // onGenerateRoute: (RouteSettings settings) {
          //   Widget screen;
          //   var args = settings.arguments;
          //   switch (settings.name) {
          //     case Routes.USER_TYPE:
          //       screen = UserTypeScreen();
          //       break;
          //     case Routes.SPLASH:
          //       screen = _getSplashWithArgs(args);
          //       break;
          //   }
          //
          //   if (screen != null) {
          //     return MaterialPageRoute(
          //       builder: (context) => screen,
          //     );
          //   }
          //   return null;
          // },
        );
      },
    );
  }
}

class PreLoader extends StatefulWidget {
  @override
  _PreLoaderState createState() => _PreLoaderState();
}

class _PreLoaderState extends State<PreLoader> with AfterLayoutMixin<PreLoader> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      _navigateToHome();
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final authToken = sharedPref.getString(Constants.AUTH_TOKEN);
    if (authToken != null) {
      LoginData userData = LoginData.fromJson(json.decode(authToken));
      Future.wait([
        context.read<AuthProvider>().setCurrentUser(userData),
        context.read<CartProvider>().getCartDataList(userData.id),
        context.read<OrdersProvider>().getOrders(userData.id),
      ]);
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Stack(children: [
        Positioned(
          bottom: 1,
          left: -50,
          right: -50,
          child: Image.asset(ImagesLink.footer_logo),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImagesLink.app_logo, width: screenWidth * 0.6),
              const SizedBox(height: 15.0),
              const NativeLoader(),
            ],
          ),
        ),
      ]),
    );
  }

  _navigateToHome() async {
    String authToken = sharedPref.getString(Constants.AUTH_TOKEN);
    // showLog("auth token ======>>>> $authToken");
    navigator.pushNamedAndRemoveUntil(d.Routes.mainScreen);
  }
}
