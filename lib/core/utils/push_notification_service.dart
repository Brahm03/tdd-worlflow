import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background FCM message received: '
      'title=${message.notification?.title}, '
      'body=${message.notification?.body}, '
      'data=${message.data}');

  if (message.notification == null) {
    await NotificationService.instance.init();
    await NotificationService.instance._showLocalNotification(message);
  }
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();
  static const String _defaultChannelId = 'default_channel_v2';
  static const String _defaultChannelName = 'Default Notifications';
  static const String _defaultChannelDescription = 'General notifications';
  static const String _notificationIcon = '@mipmap/ic_launcher';

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    _defaultChannelId,
    _defaultChannelName,
    description: _defaultChannelDescription,
    importance: Importance.max,
    playSound: true,
    showBadge: true,
  );

  final FirebaseMessaging _messaging = FirebaseMessaging.instance; // * eshtadi
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin(); // * show notifion korstaish

  Future<void>? _initialization;

  Future<void> init() {
    return _initialization ??= _initInternal();
  }

  // * qurilmada ozini fm token u siz biz notiifcaiotn jonata olmaymiz
  Future<String?> getFcmToken() async {
    try {
      await init();
      if (Platform.isIOS) {
        final isSimulator = await _isIosSimulator();
        if (isSimulator) {
          print(
              'Skipping FCM token fetch on iOS simulator because APNs is unavailable.');
          return null;
        }

        final apnsToken = await _waitForApnsToken();
        if (apnsToken == null) {
          print(
              'APNs token is still unavailable, skipping FCM token request for now.');
          return null;
        }
      }

      final token = await _messaging.getToken();
      print('FCM token fetched: $token');
      return token;
    } catch (e) {
      print('Failed to fetch FCM token: $e');
      return null;
    }
  }

  Future<void> _initInternal() async {
    await _configureForegroundPresentation(); // * dastur ichida notification chiqishi settings
    await _initializeLocalNotifications(); // * settings notification
    await _createAndroidNotificationChannel();
    _listenToForegroundMessages();
  }

  Future<void> requestPermissions() => _requestNotificationPermissions();

  Future<void> _requestNotificationPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          final status = await Permission.notification.request();
          print('Android notification permission status: $status');
        }
      }

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      print(
          'Firebase notification permission status: ${settings.authorizationStatus}');
    } catch (e) {
      print('Failed to request notification permissions: $e');
    }
  }

  Future<void> _configureForegroundPresentation() async {
    if (!Platform.isIOS) {
      return;
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(_notificationIcon);
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings: initializationSettings);
  }

  Future<void> _createAndroidNotificationChannel() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground FCM message received: '
          'title=${message.notification?.title}, '
          'body=${message.notification?.body}, '
          'data=${message.data}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification opened: ${message.messageId}');
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title =
        notification?.title ?? message.data['title']?.toString() ?? 'No title';
    final body =
        notification?.body ?? message.data['body']?.toString() ?? 'No body';

    if (title.isEmpty && body.isEmpty) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _defaultChannelId,
      _defaultChannelName,
      channelDescription: _defaultChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: _notificationIcon,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 10; attempt++) {
      try {
        final token = await _messaging.getAPNSToken();
        if (token != null && token.isNotEmpty) {
          return token;
        }
      } catch (e) {
        // Expected right after launch — APNs registration hasn't completed
        // yet. Swallow and retry instead of letting it bubble up to
        // getFcmToken()'s catch, which would abort the whole wait after
        // just one attempt.
        print('Still waiting for APNs token (attempt ${attempt + 1}/10):$e');
      }

      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    return null;
  }

  Future<bool> _isIosSimulator() async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return !iosInfo.isPhysicalDevice;
  }
}

class PushNotificationTokenService {
  PushNotificationTokenService._();

  static Future<void> initialize() => NotificationService.instance.init();

  static Future<String?> getToken() {
    return NotificationService.instance.getFcmToken();
  }
}