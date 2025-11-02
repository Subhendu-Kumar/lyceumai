// lib/features/meetings/pages/meetings_layout_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/features/meetings/cubit/meetings_cubit.dart';
import 'package:lyceumai/features/meetings/widgets/meeting_type_list.dart';

class MeetingsLayoutPage extends StatefulWidget {
  final String classId;
  const MeetingsLayoutPage({super.key, required this.classId});

  @override
  State<MeetingsLayoutPage> createState() => _MeetingsLayoutPageState();
}

class _MeetingsLayoutPageState extends State<MeetingsLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Meetings for ${widget.classId}"),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Ended"),
            ],
          ),
        ),
        body: BlocBuilder<MeetingsCubit, MeetingsState>(
          builder: (context, state) {
            if (state is CallsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CallsLoaded) {
              return TabBarView(
                children: [
                  MeetingTypeList(calls: state.upcomingCalls, type: "upcoming"),
                  MeetingTypeList(calls: state.endedCalls, type: "ended"),
                ],
              );
            } else if (state is CallsError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text(state.message)),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text("No meetings available.")),
              );
            }
          },
        ),
      ),
    );
  }
}
