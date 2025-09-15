import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/features/miscellaneous/repository/miscellaneous_remote_repository.dart';

part 'assignment_load_state.dart';

class AssignmentLoadCubit extends Cubit<AssignmentLoadState> {
  AssignmentLoadCubit() : super(AssignmentLoadInitial());

  final MiscellaneousRemoteRepository _miscellaneousRemoteRepository =
      MiscellaneousRemoteRepository();

  Future<void> loadAssignment(String id) async {
    emit(AssignmentLoading());
    try {
      final assignment = await _miscellaneousRemoteRepository.fetchAssignment(
        id,
      );
      emit(AssignmentLoaded(assignment));
    } catch (e) {
      emit(AssignmentLoadingFailure(e.toString()));
    }
  }
}
