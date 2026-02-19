import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../local/share_prefs_service.dart';
import 'notification_event_bus.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  var initialzationSettingsAndroid =
      const AndroidInitializationSettings("logo");
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            priority: Priority.max,
            enableLights: true,
            playSound: true,
          ),
        ));
  }
}

class NotificationService {
  SharedPrefService prefs = SharedPrefService();
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService? get instance => _instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? _localNotificationsPlugin;
  NotificationService._internal();
  static bool firstRun = true;

  Future<String?> getToken() {
    return _messaging.getToken();
  }

  Future<void> subscripeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscripeToTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> initNotificationService() async {
    await _initFirebaseMessaging();
    _initLocalNotifications();
    _checkForInitialMessage();
  }

  Future<void> _initLocalNotifications() async {
    debugPrint("init local notifications");
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidSettings = const AndroidInitializationSettings("logo");
    var iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotificationsPlugin!.initialize(settings);
    firstRun = false;
  }

  Future<void> _initFirebaseMessaging() async {
    debugPrint("init firebase messaging");
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final type = message.data['type'] ?? '';
        final objectId = message.data['object_id'] ?? '';
        debugPrint("onMessageOpenedApp — type: $type, object_id: $objectId");
        log('notifiationonMessageOpenedApp');

        if (type.isNotEmpty) {
          NotificationEventBus.instance.fire(
            NotificationEvent(type: type, objectId: objectId),
          );
        }
      });

      debugPrint('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log('notifiationonMessage');

        final type = message.data['type'] ?? '';
        final objectId = message.data['object_id'] ?? '';

        if (type.isNotEmpty) {
          NotificationEventBus.instance.fire(
            NotificationEvent(type: type, objectId: objectId),
          );
        }

        PushNotification notification = PushNotification(
          title: message.notification?.title ?? message.data['title'] ?? '',
          body: message.notification?.body ?? message.data['body'] ?? '',
          sound: "default",
        );

        if (notification.title!.isNotEmpty) {
          await showLocalNotification(
              notification.title!, notification.body!, '');
        }
      });
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  _checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      final type = initialMessage.data['type'] ?? '';
      final objectId = initialMessage.data['object_id'] ?? '';
      debugPrint("initialMessage — type: $type, object_id: $objectId");

      if (type.isNotEmpty) {
        NotificationEventBus.instance.fire(
          NotificationEvent(type: type, objectId: objectId),
        );
      }
    }
  }

  Future<void> showLocalNotification(
      String title, String body, String payload) async {
    debugPrint("showing ....");
    var androidDetails = const AndroidNotificationDetails("1", "chats",
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false,
        styleInformation: BigTextStyleInformation(''));
    var iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _localNotificationsPlugin!.show(1, title, body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: payload);
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.sound,
  });
  String? title;
  String? body;
  String? sound;
}
