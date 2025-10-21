import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/features/meetings/cubit/meetings_cubit.dart';

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
          title: Text("Meetings for Class ${widget.classId}"),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.check_circle_outline), text: "Ended"),
              Tab(icon: Icon(Icons.schedule), text: "Upcoming"),
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
                  // Ended Meetings
                  ListView.builder(
                    itemCount: state.endedCalls.length,
                    itemBuilder: (context, index) {
                      final call = state.endedCalls[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.grey,
                        ),
                        title: Text(call.description),
                        subtitle: Text(call.startTime),
                      );
                    },
                  ),

                  // Upcoming Meetings
                  ListView.builder(
                    itemCount: state.upcomingCalls.length,
                    itemBuilder: (context, index) {
                      final call = state.upcomingCalls[index];
                      return ListTile(
                        leading: const Icon(Icons.schedule, color: Colors.blue),
                        title: Text(call.description),
                        subtitle: Text(call.startTime),
                      );
                    },
                  ),
                ],
              );
            } else if (state is CallsError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
