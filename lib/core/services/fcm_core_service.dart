import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmCoreService {
  late GoRouter _router;
  AndroidNotificationChannel? _channel;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 👇 Call this before initialize()
  void setRouter(GoRouter router) {
    _router = router;
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User denied permission');
      }
    }
  }

  Future<void> _initLocalNotifications() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel!);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    // await _flutterLocalNotificationsPlugin.initialize(initSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      // 👇 When user taps on local notification
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null && route.isNotEmpty) {
          _router.push(route);
        }
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    if (_channel == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel!.id,
      _channel!.name,
      channelDescription: _channel!.description,
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final route = message.data['route'] ?? '';

    _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      notificationDetails,
      payload: route, // 👈 Pass route to notification
    );
  }

  Future<void> initialize() async {
    await _requestNotificationPermission();
    await _initLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // 👇 When app is in background & user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final route = message.data['route'];
      if (route != null && route.isNotEmpty) {
        _router.push(route);
      }
    });

    // 👇 When app launches from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      final route = initialMessage.data['route'];
      if (route != null && route.isNotEmpty) {
        _router.push(route);
      }
    }
  }
}
