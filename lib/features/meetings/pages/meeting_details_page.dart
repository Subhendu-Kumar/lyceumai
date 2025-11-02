import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/features/meetings/cubit/meeting_details_cubit.dart';

class MeetingDetailsPage extends StatefulWidget {
  final String id;
  const MeetingDetailsPage({super.key, required this.id});

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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(state.callDetails.description)],
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
