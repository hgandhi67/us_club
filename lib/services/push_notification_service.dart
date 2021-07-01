// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:device_info/device_info.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:provider/provider.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'package:thc_patient/app/locator.dart';
// import 'package:thc_patient/providers/bookings_provider.dart';
// import 'package:thc_patient/providers/call_provider.dart';
// import 'package:thc_patient/providers/doctor_provider.dart';
// import 'package:thc_patient/providers/user_provider.dart';
// import 'package:thc_patient/thc_base/constants.dart';
// import 'package:thc_patient/thc_base/globals.dart';
// import 'package:thc_patient/thc_base/images_link.dart';
// import 'package:thc_patient/thc_base/routes.dart';
// import 'package:thc_patient/ui/chats/chat_user.dart';
// import 'package:thc_patient/ui/video_call/call_screens/pickup/pickup_screen.dart';
// import 'package:thc_patient/ui/video_call/models/call.dart';
// import 'package:thc_patient/widgets/cached_image.dart';
// import 'package:thc_patient/widgets/text_widget.dart';
//
// class PushNotificationService {
//   final _navigationService = locator<NavigationService>();
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//
//   Future<String> getDeviceToken() async {
//     await _fcm.deleteInstanceID();
//     var newToken = await _fcm.getToken();
//     return newToken;
//   }
//
//   void configure(BuildContext context) async {
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         handleMessage(context, message, inApp: true);
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         handleMessage(context, message);
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         handleMessage(context, message);
//       },
//       // onBackgroundMessage: (Map<String, dynamic> message) async {
//       //   print("onBackgroundMessage: $message");
//       //   handleMessage(context, message);
//       // },
//     );
//
//     showLog("PushNotificationService configured");
//
//     if (Platform.isIOS) {
//       await _fcm.requestNotificationPermissions(
//           IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
//       _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
//         print("Settings registered: $settings");
//       });
//     }
//   }
//
//   void handleMessage(BuildContext context, Map<String, dynamic> message, {bool inApp = false}) async {
//     try {
//       var finalNotification;
//
//       if (Platform.isIOS) {
//         finalNotification = message['aps']['alert'];
//         showLog("background notification for ios ====> $finalNotification");
//       } else {
//         finalNotification = message['notification'];
//         showLog("background notification for android ====> $finalNotification");
//       }
//
//       dynamic eventType = message['event_type'];
//       dynamic kFinalData;
//
//       if (message.containsKey("data")) {
//         var data = message['data'];
//         eventType = data['event_type'];
//         kFinalData = data;
//       } else {
//         eventType = message['event_type'];
//         kFinalData = message;
//       }
//
//       showLog("notification event type =====>>> $eventType");
//
//       if (eventType != null) {
//         switch (eventType.toString().removeSpaces()) {
//           case "chat":
//             if (!isChatScreenOpen) {
//               _showNotification(context, finalNotification, kFinalData);
//             } else {
//               showLog("don't do anything ====> ");
//             }
//             break;
//           case "connect_room":
//             _joinVideoCallFromDoctor(context, kFinalData);
//             break;
//           case "meeting_start":
//             _joinVideoCallFromDoctor(context, kFinalData, isMeeting: true);
//             break;
//           case "meeting_end":
//             declineCall(context);
//             break;
//           case "leave_room":
//             declineCall(context);
//             break;
//           case "complete_room":
//             break;
//           case "declined":
//             declineCall(context);
//             break;
//           default:
//             showLog("default event");
//             if (inApp) {
//               _showNotification(context, finalNotification, kFinalData);
//               try {
//                 if (eventType == "new_appointment") {
//                   showLog("new_appointment called");
//                   await Provider.of<BookingsProvider>(context, listen: false).setDataChanged(true);
//                 }
//               } catch (e) {
//                 print("setDataChanged exception =====>>> $e");
//               }
//             }
//             break;
//         }
//       }
//     } catch (e) {
//       showLog(e);
//     }
//   }
//
//   void declineCall(context) async {
//     try {
//       showLog("declineCall event");
//       await Provider.of<CallProvider>(context, listen: false).setEvent("declined");
//     } catch (e) {
//       print('call declined exception ====>>> $e');
//     }
//   }
//
//   void myBackgroundMessageHandler(Map<String, dynamic> message) {
//     if (message.containsKey('data')) {
//       // Handle data message
//       final dynamic data = message['data'];
//
//       showLog("background data ====> $data");
//     }
//
//     if (message.containsKey('notification')) {
//       // Handle notification message
//       final dynamic notification = message['notification'];
//
//       showLog("background notification ====> $notification");
//     }
//
//     // Or do other work.
//   }
//
//   void _joinVideoCallFromDoctor(context, data, {bool isMeeting = false}) async {
//     // var perm1 = await Permission.camera.request() ?? false;
//     // var perm2 = await Permission.microphone.request() ?? false;
//     //
//     // if (perm1 == PermissionStatus.granted && perm2 == PermissionStatus.granted) {
//     try {
//       var callProvider = Provider.of<CallProvider>(context, listen: false);
//
//       showLog("_joinVideoCallFromDoctor isResume =====>>> ${callProvider.isResume}");
//
//       await callProvider.setEvent("none");
//       final call = Call(
//         appointmentId: data['id'],
//         roomId: data['room_id'],
//         callerId: data['doctor_firebase_id'],
//         callerName: data['caller_name'],
//         callerPic: data['caller_pic'],
//         receiverId: data['receiver_id'],
//         receiverName: data['receiver_name'],
//         receiverPic: data['receiver_pic'],
//         senderToken: data['doctor_firebase_token'],
//         receiverToken: data['patient_firebase_token'],
//         hasDialled: false,
//       );
//
//       if (callProvider.isResume == null || !callProvider.isResume) {
//         await _navigationService.navigateToView(PickupScreen(call: call, isMeeting: isMeeting));
//       }
//     } catch (err) {
//       showLog("_joinVideoCallFromDoctor exception ====> $err");
//     }
//     // } else {
//     //   showLog("do nothing in pick up screen");
//     // }
//   }
//
//   Future<void> _showNotification(context, message, data) async {
//     try {
//       if (message != null && data != null) {
//         dynamic userSettings = Provider.of<UsersProvider>(context, listen: false).userSettings;
//
//         if (!isUser()) {
//           userSettings = Provider.of<DoctorsProvider>(context, listen: false).doctorSettings;
//         }
//
//         if (userSettings != null) {
//           if (message["title"] != null && message["body"] != null) {
//             Map payload = message;
//
//             payload.putIfAbsent("id", () => data["id"]);
//             payload.putIfAbsent("event_type", () => data["event_type"]);
//             payload.putIfAbsent("device_token", () => data['device_token']);
//             payload.putIfAbsent("uid", () => data['uid']);
//             payload.putIfAbsent("name", () => data['name']);
//             payload.putIfAbsent("profile_photo", () => data['profile_photo'] ?? data["profile_pic"]);
//             payload.putIfAbsent("user_type", () => data['user_type']);
//             payload.putIfAbsent("from_video_call", () => data['from_video_call']);
//
//             if (isUser()) {
//               var messageSetting =
//                   (userSettings.data as List).firstWhere((element) => element.settingType == keyMsg);
//
//               showLog("user settings for notification is =====>>> ${messageSetting?.value}");
//
//               if (messageSetting?.value == "1") {
//                 makeOverLayNotification(message["title"], message["body"], jsonEncode(payload));
//               } else {
//                 showLog("user settings for notification is turned off =====>>> ${messageSetting?.value}");
//               }
//             } else {
//               makeOverLayNotification(message["title"], message["body"], jsonEncode(payload));
//             }
//           }
//         } else {
//           showLog("sorry bro notification is null or they turned off by this user");
//         }
//       }
//     } catch (e) {
//       print('_showNotification exception ====>>> $e');
//     }
//   }
//
//   void makeOverLayNotification(String title, String body, String payload) {
//     var kMap = jsonDecode(payload);
//     FlutterRingtonePlayer.play(
//       android: AndroidSounds.notification,
//       ios: IosSounds.glass,
//       looping: false,
//       // Android only - API >= 28
//       volume: 1.0,
//       // Android only - API >= 28
//       asAlarm: false, // Android only - all APIs
//     );
//     showOverlayNotification(
//       (context) {
//         return Card(
//           margin: EdgeInsets.zero,
//           child: SafeArea(
//             child: ListTile(
//               onTap: () {
//                 showLog("kMap ====> $kMap");
//                 showLog("isUser ====> ${isUser()}");
//                 showLog("kMap['from_video_call'] ====> ${kMap['from_video_call']}");
//
//                 if (kMap != null) {
//                   if (kMap['event_type'] != null && kMap['event_type'] == "chat") {
//                     var contact = ChatUser.fromMap(kMap);
//                     showLog("contact ====> ${contact.toMap(contact)}");
//                     OverlaySupportEntry.of(context).dismiss();
//                     _navigationService.navigateTo(Routes.DOC_CHAT, arguments: {
//                       AppRouteArgKeys.DATA: contact,
//                       AppRouteArgKeys.BOOLEAN: !isUser()
//                           ? false
//                           : kMap['from_video_call'] == "false"
//                               ? true
//                               : false,
//                       AppRouteArgKeys.TYPE: kMap['from_video_call'] == "false" ? true : false,
//                     });
//                   }
//                 }
//               },
//               leading: SizedBox.fromSize(
//                 size: const Size(40, 40),
//                 child: CachedImage(
//                   kMap['profile_photo'] ?? "",
//                   width: 40,
//                   height: 40,
//                   placeholder: ImagesLink.imgPlaceholder,
//                 ),
//               ),
//               title: Texts(title),
//               subtitle: Texts(body),
//               trailing: IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () {
//                     OverlaySupportEntry.of(context).dismiss();
//                   }),
//             ),
//           ),
//         );
//       },
//       duration: Duration(seconds: 5),
//     );
//   }
//
//   Future<void> deviceInfoInit() async {
//     if (Platform.isIOS) {
//       var deviceInfo = await DeviceInfoPlugin().iosInfo;
//
//       sharedPref.setString(Constants.DEVICE_TYPE, deviceApple);
//       sharedPref.setString(Constants.DEVICE_OS, (deviceInfo.systemVersion));
//     } else {
//       var deviceInfo = await DeviceInfoPlugin().androidInfo;
//       sharedPref.setString(Constants.DEVICE_TYPE, deviceAndroid);
//       sharedPref.setString(Constants.DEVICE_OS, (deviceInfo.version.baseOS));
//     }
//
//     print("DEVICE TYPE ===> ${sharedPref.getString(Constants.DEVICE_TYPE)}");
//     print("DEVICE OS ===> ${sharedPref.getString(Constants.DEVICE_OS)}");
//   }
// }
