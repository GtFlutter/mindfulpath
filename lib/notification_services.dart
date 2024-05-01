import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation_app/data/model/response/CustomNotificationData.dart';
import 'package:meditation_app/ui/screens/category/detail_category_screen.dart';
import 'package:meditation_app/ui/screens/discover/discover_screen.dart';

import 'data/model/response/category_list_reponse.dart';
import 'helper/route/router.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        //notification device ma show krva mate
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        //notification aave iphone ma tyathi notification on off kri ske
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted provisional permission");
    } else {
      print("user denied permission");
    }
  }

  void initLocalNotification(RemoteMessage message) async {
    var androidInitializationSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSetting = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      print("initLocalNotification====>${message.data}");
      print("initLocalNotification 11====>${message.data['custom']}");
      handleMessage(message);
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("<------------------------onMessage------------------------------------>${message.data}");
      debugPrint("<------------------------onMessage------------------------------------>${message.data['custom']}");
      if (Platform.isIOS) {
        forgroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotification(message);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(Random.secure().nextInt(10000).toString(), "High Importance Notifications", importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id.toString(), channel.name.toString(), channelDescription: "My Notification", importance: Importance.high, priority: Priority.high, ticker: "ticker");

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title ?? "",
          // (message.notification?.body ?? ""),
          null,
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future<void> setupInteractMessage() async {
    //when app is forGround
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    //when app is backGround
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
  }

  void handleMessage(RemoteMessage message) {
    BuildContext? ctx = rootNavigator.currentContext;
    if (ctx == null || !ctx.mounted) return;

    final notificationCustomData = CustomNotificationData.fromJson(jsonDecode(message.data['custom']));

    if (notificationCustomData.type == "video") {
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => DetailCategoryScreen(categoryListResponse: notificationCustomData.catData ?? CategoryListResponse(), initialVideo: null)));
    } else if (notificationCustomData.type == "pdf") {
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => DetailCategoryScreen(categoryListResponse: notificationCustomData.catData ?? CategoryListResponse(), initialVideo: null,isFromPdfNotification: true,)));
    }else if (notificationCustomData.type == "category") {
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => const DiscoverScreen()));
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
