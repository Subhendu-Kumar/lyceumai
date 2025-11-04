// lib/features/meetings/pages/meeting_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/call_model.dart';
import 'package:lyceumai/models/call_rec_model.dart';
import 'package:lyceumai/features/meetings/widgets/meeting_card.dart';
import 'package:lyceumai/features/meetings/cubit/meeting_details_cubit.dart';

class MeetingDetailsPage extends StatefulWidget {
  final String id;
  final String type;
  const MeetingDetailsPage({super.key, required this.id, required this.type});

  @override
  State<MeetingDetailsPage> createState() => _MeetingDetailsPageState();
}

class _MeetingDetailsPageState extends State<MeetingDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Meet Details ${widget.id}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<MeetingDetailsCubit, MeetingDetailsState>(
            builder: (context, state) {
              if (state is MeetingDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MeetingDetailsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is MeetingDetailsLoaded) {
                final CallModel call = CallModel(
                  meetId: state.callDetails.meetId,
                  meetStatus: state.callDetails.meetStatus,
                  classroomId: state.callDetails.classroomId,
                  meetingTime: state.callDetails.meetingTime,
                  description: state.callDetails.description,
                );
                final List<CallRecModel> recordings =
                    state.callDetails.recordings;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MeetingCard(call: call, type: widget.type),
                    const SizedBox(height: 20),
                    const Text(
                      "Recordings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...recordings.map((rec) {
                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Session ID: ${rec.sessionId}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Date: ${formatDate(rec.meetDate)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                rec.summary ?? "No summary available.",
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 36),
                                ),
                                onPressed: () {
                                  context.push("/meeting/rec/play", extra: rec);
                                },
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text(
                                  "View Recording",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "No meeting details available.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
