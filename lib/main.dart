// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:lyceumai/my_app.dart';
import 'package:lyceumai/app_router.dart';
import 'package:lyceumai/firebase_options.dart';
import 'package:lyceumai/core/services/fcm_core_service.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
import 'package:lyceumai/features/home/cubit/class_cubit.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_load_cubit.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_submission_cubit.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ✅ Initialize Cubits first
  final authCubit = AuthCubit()..getUserData();

  // ✅ Build router early (to pass into FCM service)
  final router = AppRouter.router(authCubit);

  // ✅ Setup FCM and link router
  final fcmService = FcmCoreService();
  fcmService.setRouter(router);
  await fcmService.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => authCubit),
        BlocProvider(create: (_) => ClassCubit()),
        BlocProvider(create: (_) => AssignmentLoadCubit()),
        BlocProvider(create: (_) => AssignmentSubmissionCubit()),
      ],
      child: MyApp(router: router),
    ),
  );
}
