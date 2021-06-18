// // import 'package:flutter/material.dart';
// // import 'package:rxdart/subjects.dart';
// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// // import 'package:handin/src/pages/bottom_navigation_pages/alerts_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import 'package:handin/src/scoped_models/main.dart';

// class AppPushNotifications {
//   FirebaseMessaging _firebaseMessaging;
//   GlobalKey<NavigatorState> navigatorKey;
//   // MainModel model = MainModel();

//   static StreamController<Map<String, dynamic>> _onMessageStreamController =
//       StreamController.broadcast();
//   static StreamController<Map<String, dynamic>> _streamController =
//       StreamController.broadcast();
//   static final Stream<Map<String, dynamic>> onFcmMessage =
//       _streamController.stream;

//   void notificationSetup(GlobalKey<NavigatorState> navigatorKey) {
//     _firebaseMessaging = FirebaseMessaging();
//     this.navigatorKey = navigatorKey;
//     requestPermissions();
//     getFcmToken();
//     notificationListeners();
//   }

//   StreamController<Map<String, dynamic>> get notificationSubject {
//     return _onMessageStreamController;
//   }

//   void requestPermissions() {
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, alert: true, badge: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings setting) {
//       print('IOS Setting Registed');
//     });
//   }

//   Future<String> getFcmToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String fcmToken = await _firebaseMessaging.getToken();
//     prefs.setString('msgToken', fcmToken);
//     print('=============================== firebase token => $fcmToken');
//     return fcmToken;
//   }

//   void notificationListeners() {
//     _firebaseMessaging.configure(
//         onMessage: _onNotificationMessage,
//         onResume: _onNotificationResume,
//         onLaunch: _onNotificationLaunch);
//   }

//   Future<dynamic> _onNotificationMessage(Map<String, dynamic> message) async {
//     notificationSubject.add(message);
//     _onMessageStreamController.add(message);

//     ///////////////////////////////////////////////////////
//     print("------- ON MESSAGE -------5555555----- $message");
//     print("4444444444444444");
//   } //////

//   Future<dynamic> _onNotificationResume(Map<String, dynamic> message) async {
//     // navigatorKey.currentState.push(PageRouteBuilder(pageBuilder: (_, __, ___) {

//     // }));
//     notificationSubject.add(message);
//     print(message);
//     // print("55555555555555555");
//     // navigatorKey.currentState.push(PageRouteBuilder(pageBuilder: (_, __, ___) {

//     // }));
//     _streamController.add(message);
//     print("------- ON RESUME ------66666666------ $message");
//   }

//   Future<dynamic> _onNotificationLaunch(Map<String, dynamic> message) async {
//     notificationSubject.add(message);
//     _streamController.add(message);
//     print("------- ON LAUNCH -----7777777777777------- $message");
//     print("77777777777777777777");
//     // navigatorKey.currentState.push(PageRouteBuilder(pageBuilder: (_, __, ___) {

//     // }));
//   }

//   void killNotification() {
//     _onMessageStreamController.close();
//     _streamController.close();
//   }
// }
