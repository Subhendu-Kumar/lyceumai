import 'package:go_router/go_router.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
import 'package:lyceumai/features/auth/pages/get_started_page.dart';
import 'package:lyceumai/features/auth/pages/login_page.dart';
import 'package:lyceumai/features/auth/pages/signup_page.dart';
import 'package:lyceumai/features/home/pages/home_page.dart';
import 'package:lyceumai/features/home/pages/join_class_page.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final authState = authCubit.state;
        final isAuth = authState is AuthLoggedIn;

        if (!isAuth) {
          // not logged in → allow only auth pages + '/'
          if (state.matchedLocation.startsWith('/home') ||
              state.matchedLocation.startsWith('/class') ||
              state.matchedLocation.startsWith('/quiz')) {
            return '/';
          }
        } else {
          // logged in → prevent going back to /
          if (state.matchedLocation == '/' ||
              state.matchedLocation == '/signin' ||
              state.matchedLocation == '/signup') {
            return '/home';
          }
        }
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const GetStartedPage()),
        GoRoute(
          path: '/signin',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'joinclass',
              builder: (context, state) => const JoinClassPage(),
            ),
          ],
        ),
      ],
    );
  }
}
