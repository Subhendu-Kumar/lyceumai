import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/features/meetings/repository/meetings_remote_repository.dart';
import 'package:lyceumai/models/call_model.dart';

part 'meetings_state.dart';

class MeetingsCubit extends Cubit<MeetingsState> {
  MeetingsCubit() : super(MeetingsInitial());

  final meetingsRemoteRepository = MeetingsRemoteRepository();

  Future<void> fetchMeetings(String classId) async {
    emit(CallsLoading());
    try {
      final List<CallModel> data = await meetingsRemoteRepository.getMeetings(
        classId,
      );

      final now = DateTime.now();

      final endedCalls = data
          .where(
            (call) =>
                call.endTime != null &&
                DateTime.parse(call.endTime!).isBefore(now),
          )
          .toList();

      final upcomingCalls = data
          .where((call) => DateTime.parse(call.startTime).isAfter(now))
          .toList();

      print(endedCalls[0].description);
      emit(CallsLoaded(endedCalls: endedCalls, upcomingCalls: upcomingCalls));
    } catch (e) {
      emit(CallsError(e.toString()));
    }
  }
}
