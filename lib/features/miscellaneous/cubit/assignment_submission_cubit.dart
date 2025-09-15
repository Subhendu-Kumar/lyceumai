import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assignment_submission_state.dart';

class AssignmentSubmissionCubit extends Cubit<AssignmentSubmissionState> {
  AssignmentSubmissionCubit() : super(AssignmentSubmissionInitial());
}
