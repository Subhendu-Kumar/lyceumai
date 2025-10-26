import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/features/home/pages/home_page.dart';
import 'package:lyceumai/features/home/pages/join_class_page.dart';

import 'package:lyceumai/features/auth/pages/login_page.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
import 'package:lyceumai/features/auth/pages/signup_page.dart';
import 'package:lyceumai/features/auth/pages/get_started_page.dart';

import 'package:lyceumai/features/meetings/cubit/meetings_cubit.dart';
import 'package:lyceumai/features/meetings/pages/meetings_layout_page.dart';

import 'package:lyceumai/features/classroom/pages/quizzes_page.dart';
import 'package:lyceumai/features/classroom/cubit/quizzes_cubit.dart';
import "package:lyceumai/features/classroom/pages/syllabus_page.dart";
import 'package:lyceumai/features/classroom/cubit/classroom_cubit.dart';
import 'package:lyceumai/features/classroom/cubit/materials_cubit.dart';
import "package:lyceumai/features/classroom/pages/assignments_page.dart";
import 'package:lyceumai/features/classroom/cubit/assignment_cubit.dart';
import "package:lyceumai/features/classroom/pages/classroom_layout_page.dart";
import "package:lyceumai/features/classroom/pages/classroom_overview_page.dart";
import 'package:lyceumai/features/classroom/pages/classroom_materials_page.dart';

import 'package:lyceumai/features/miscellaneous/pages/pdf_view_page.dart';
import 'package:lyceumai/features/miscellaneous/pages/assignment_submission_view_page.dart';
import 'package:lyceumai/features/miscellaneous/pages/text_assignment_submission_page.dart';
import 'package:lyceumai/features/miscellaneous/pages/voice_assignment_submission_page.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final authState = authCubit.state;
        final isAuth = authState is AuthLoggedIn;
        if (!isAuth) {
          if (state.matchedLocation.startsWith('/home') ||
              state.matchedLocation.startsWith('/class') ||
              state.matchedLocation.startsWith('/quiz')) {
            return '/';
          }
        } else {
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
        ShellRoute(
          builder: (context, state, child) {
            final id = state.pathParameters['id']!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => ClassroomCubit()..getClassroom(id)),
                BlocProvider(
                  create: (_) => MaterialsCubit()..getClassMaterials(id),
                ),
                BlocProvider(
                  create: (_) => QuizzesCubit()..getClassQuizzes(id),
                ),
                BlocProvider(
                  create: (_) => AssignmentCubit()..getClassAssignments(id),
                ),
              ],
              child: ClassroomLayoutPage(id: id, child: child),
            );
          },
          routes: [
            GoRoute(
              path: '/class/:id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: ClassroomOverviewPage(id: id));
              },
            ),
            GoRoute(
              path: '/class/:id/assignments',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: AssignmentsPage(id: id));
              },
            ),
            GoRoute(
              path: '/class/:id/syllabus',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: SyllabusPage(id: id));
              },
            ),
            GoRoute(
              path: '/class/:id/materials',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: ClassroomMaterialsPage(id: id));
              },
            ),
            GoRoute(
              path: '/class/:id/quizzes',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return NoTransitionPage(child: QuizzesPage(id: id));
              },
            ),
          ],
        ),
        GoRoute(
          path: '/submission/:assignmentId',
          pageBuilder: (context, state) {
            final assignmentId = state.pathParameters['assignmentId']!;
            return NoTransitionPage(
              child: AssignmentSubmissionViewPage(assignmentId: assignmentId),
            );
          },
        ),
        GoRoute(
          path: '/submission/:assignmentId/text',
          pageBuilder: (context, state) {
            final assignmentId = state.pathParameters['assignmentId']!;
            return NoTransitionPage(
              child: TextAssignmentSubmissionPage(assignmentId: assignmentId),
            );
          },
        ),
        GoRoute(
          path: '/submission/:assignmentId/voice',
          pageBuilder: (context, state) {
            final assignmentId = state.pathParameters['assignmentId']!;
            return NoTransitionPage(
              child: VoiceAssignmentSubmissionPage(assignmentId: assignmentId),
            );
          },
        ),
        GoRoute(
          path: '/pdfview',
          pageBuilder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>?;
            return NoTransitionPage(
              child: PdfViewPage(
                title: extraData?['title'],
                pdfUrl: extraData?['pdfUrl'],
              ),
            );
          },
        ),
        GoRoute(
          path: "/meetings/:classId",
          pageBuilder: (context, state) {
            final classId = state.pathParameters["classId"]!;
            return NoTransitionPage(
              child: BlocProvider(
                create: (context) => MeetingsCubit()..fetchMeetings(classId),
                child: MeetingsLayoutPage(classId: classId),
              ),
            );
          },
        ),
      ],
    );
  }
}
