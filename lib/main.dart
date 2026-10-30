import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_app/core/app/app.dart';
import 'package:task_app/core/di/injection.dart';
import 'package:task_app/core/storage/token_storage.dart';
import 'package:task_app/core/utils/push_notification_service.dart';
import 'package:task_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenStorage.instance.init();
  await configureDependencies();
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await PushNotificationTokenService.initialize();
  }
  runApp(const TaskApp());
}
