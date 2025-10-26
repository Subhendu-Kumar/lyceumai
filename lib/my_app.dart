import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/app_theme.dart';
import 'package:lyceumai/loading_page.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingInitial) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoadingPage(),
          );
        }
        if (state is AuthLoggedIn) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: appTheme,
          );
        }
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: appTheme,
        );
      },
    );
  }
}
