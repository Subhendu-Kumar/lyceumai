// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lyceumai/features/home/pages/home_page.dart';
// import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
// import 'package:lyceumai/features/home/cubit/class_cubit.dart';
// import 'package:lyceumai/features/auth/pages/get_started_page.dart';

// void main() {
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => AuthCubit()),
//         BlocProvider(create: (_) => ClassCubit()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<AuthCubit>(context).getUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         inputDecorationTheme: InputDecorationTheme(
//           contentPadding: EdgeInsets.all(16),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color.fromRGBO(52, 51, 67, 1),
//               width: 1,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color.fromRGBO(52, 51, 67, 1),
//               width: 1,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue, width: 1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.redAccent, width: 1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: BlocBuilder<AuthCubit, AuthState>(
//         builder: (context, state) {
//           if (state is AuthLoading) {
//             return const LoadingPage();
//           }
//           if (state is AuthLoggedIn) {
//             return const HomePage();
//           }
//           return const GetStartedPage();
//         },
//       ),
//     );
//   }
// }

// class LoadingPage extends StatelessWidget {
//   const LoadingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyceumai/app_router.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
import 'package:lyceumai/features/home/cubit/class_cubit.dart';
// import 'package:lyceumai/features/auth/pages/get_started_page.dart';
// import 'package:lyceumai/features/home/pages/home_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..getUserData()),
        BlocProvider(create: (_) => ClassCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    _router = AppRouter.router(authCubit);
  }

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
          // GoRouter when logged in
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            theme: _theme,
          );
        }

        // Not logged in → show GetStartedPage with router
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: _theme,
        );
      },
    );
  }

  ThemeData get _theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromRGBO(52, 51, 67, 1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromRGBO(52, 51, 67, 1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
