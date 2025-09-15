import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/my_app.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
import 'package:lyceumai/features/home/cubit/class_cubit.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_load_cubit.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_submission_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..getUserData()),
        BlocProvider(create: (_) => ClassCubit()),
        BlocProvider(create: (_) => AssignmentLoadCubit()),
        BlocProvider(create: (_) => AssignmentSubmissionCubit()),
      ],
      child: const MyApp(),
    ),
  );
}
