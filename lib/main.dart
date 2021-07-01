import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:us_club/providers/providers.dart';

import 'base/export_base.dart';
import 'di/locator.dart';
import 'us_club_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await ThemeManager.initialise();
  setupLocator();
  initNotification();

  sharedPref = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const UsClub(),
    ),
  );
}

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future initNotification() async {
  /*notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  of the `IOSFlutterLocalNotificationsPlugin` class

  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      showLog('notification payload: ' + payload);

      var kMap = jsonDecode(payload);

      showLog("kMap ====> $kMap");
      showLog("isUser ====> ${isUser()}");
      showLog("kMap['from_video_call'] ====> ${kMap['from_video_call']}");

      if (kMap != null) {
        if (kMap['event_type'] != null && kMap['event_type'] == "chat") {
          var contact = ChatUser.fromMap(kMap);
          showLog("contact ====> ${contact.toMap(contact)}");
          var navigationService = locator<NavigationService>();
          navigationService.navigateTo(Routes.DOC_CHAT, arguments: {
            AppRouteArgKeys.DATA: contact,
            AppRouteArgKeys.BOOLEAN: !isUser()
                ? false
                : kMap['from_video_call'] == "false"
                    ? true
                    : false,
            AppRouteArgKeys.TYPE:
                kMap['from_video_call'] == "false" ? true : false,
          });
        }
      }
    }
    selectNotificationSubject.add(payload);
  });*/
}
