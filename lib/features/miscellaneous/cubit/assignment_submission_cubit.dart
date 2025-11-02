// lib/features/miscellaneous/cubit/assignment_submission_cubit.dart

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/features/miscellaneous/repository/miscellaneous_remote_repository.dart';

part 'assignment_submission_state.dart';

class AssignmentSubmissionCubit extends Cubit<AssignmentSubmissionState> {
  AssignmentSubmissionCubit() : super(AssignmentSubmissionInitial());

  final MiscellaneousRemoteRepository _miscellaneousRemoteRepository =
      MiscellaneousRemoteRepository();

  Future<void> textAssignmentSubmission(String id, String ans) async {
    emit(AssignmentSubmissionInProgress());
    try {
      await _miscellaneousRemoteRepository.submitTextAssignment(id, ans);
      emit(AssignmentSubmissionSuccess());
    } catch (e) {
      emit(AssignmentSubmissionFailure(e.toString()));
    }
  }

  Future<void> voiceAssignmentSubmission(String id, String filePath) async {
    emit(AssignmentSubmissionInProgress());
    try {
      await _miscellaneousRemoteRepository.submitVoiceAssignment(id, filePath);
      emit(AssignmentSubmissionSuccess());
    } catch (e) {
      emit(AssignmentSubmissionFailure(e.toString()));
    }
  }
}
