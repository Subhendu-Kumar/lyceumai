import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/models/call_details_model.dart';
import 'package:lyceumai/features/meetings/repository/meetings_remote_repository.dart';

part 'meeting_details_state.dart';

class MeetingDetailsCubit extends Cubit<MeetingDetailsState> {
  MeetingDetailsCubit() : super(MeetingDetailsInitial());

  final MeetingsRemoteRepository meetingsRemoteRepository =
      MeetingsRemoteRepository();

  Future<void> fetchMeetingDetails(String meetId) async {
    try {
      emit(MeetingDetailsLoading());
      final CallDetailsModel callDetails = await meetingsRemoteRepository
          .getMeetingDetails(meetId);
      emit(MeetingDetailsLoaded(callDetails: callDetails));
    } catch (e) {
      emit(MeetingDetailsError(e.toString()));
    }
  }
}
