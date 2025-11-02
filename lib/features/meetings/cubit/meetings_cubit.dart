// lib/features/meetings/cubit/meetings_cubit.dart

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

      final endedCalls = data
          .where(
            (call) =>
                call.meetStatus.trim().toUpperCase() == CallStatus.completed ||
                call.meetStatus.trim().toUpperCase() == CallStatus.canceled,
          )
          .toList();

      final upcomingCalls = data
          .where(
            (call) =>
                call.meetStatus.trim().toUpperCase() == CallStatus.scheduled,
          )
          .toList();

      emit(CallsLoaded(endedCalls: endedCalls, upcomingCalls: upcomingCalls));
    } catch (e) {
      emit(CallsError(e.toString()));
    }
  }
}
