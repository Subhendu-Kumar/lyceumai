import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/call_model.dart';
import 'package:lyceumai/features/meetings/repository/meetings_remote_repository.dart';

part 'meetings_state.dart';

class MeetingsCubit extends Cubit<MeetingsState> {
  MeetingsCubit() : super(MeetingsInitial());

  final MeetingsRemoteRepository meetingsRemoteRepository =
      MeetingsRemoteRepository();

  Future<void> fetchMeetings(String classId) async {
    emit(CallsLoading());
    try {
      final List<CallModel> data = await meetingsRemoteRepository.getMeetings(
        classId,
      );

      final now = DateTime.now();

      final endedCalls = data.where((call) {
        if (call.endTime == null) return false;
        try {
          return DateTime.parse(call.endTime!).isBefore(now);
        } catch (_) {
          return false;
        }
      }).toList();

      final upcomingCalls = data.where((call) {
        try {
          return DateTime.parse(call.startTime).isAfter(now);
        } catch (_) {
          return false;
        }
      }).toList();

      emit(CallsLoaded(endedCalls: endedCalls, upcomingCalls: upcomingCalls));
    } catch (e) {
      emit(CallsError(e.toString()));
    }
  }
}
