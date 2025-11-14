// lib/features/classroom/pages/classroom_overview_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/models/call_model.dart';
import 'package:lyceumai/features/classroom/cubit/classroom_cubit.dart';
import 'package:lyceumai/features/classroom/repository/fetch_ongoing_meet.dart';

class ClassroomOverviewPage extends StatefulWidget {
  final String id;
  const ClassroomOverviewPage({super.key, required this.id});

  @override
  State<ClassroomOverviewPage> createState() => _ClassroomOverviewPageState();
}

class _ClassroomOverviewPageState extends State<ClassroomOverviewPage> {
  CallModel? ongoingMeet;

  @override
  void initState() {
    super.initState();
    _fetchMeet();
  }

  Future<void> _onRefresh() async {
    _fetchMeet();
  }

  Future<void> _fetchMeet() async {
    ongoingMeet = await fetchOngoingMeet(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: BlocBuilder<ClassroomCubit, ClassroomState>(
            builder: (context, state) {
              if (state is ClassroomLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClassroomLoaded) {
                final classroom = state.classrooms;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Container(
                              height: 140,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/banner_class.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 16,
                              right: 48,
                              child: Text(
                                classroom.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 48,
                              child: Text(
                                "Code: ${classroom.code}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 28,
                              child: Text(
                                "Updated: ${formatDate(classroom.updatedAt)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: classroom.code),
                                  );
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Classroom code copied!",
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Image.asset("assets/classroom.png", height: 150),
                      const SizedBox(height: 30),
                      const Text(
                        "Welcome to your Classroom!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Here you can access all your class materials, assignments, and quizzes. Stay organized and keep track of your progress.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (ongoingMeet != null)
                        GestureDetector(
                          onTap: () =>
                              _showLiveClassDrawer(context, ongoingMeet!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.greenAccent),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 12,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "A live class is ongoing — Tap to join",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else if (state is ClassroomError) {
                return Center(child: Text("Error: ${state.error}"));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  void _showLiveClassDrawer(BuildContext context, CallModel call) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "🔴 Live Class Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "📚 Classroom ID: ${call.classroomId}",
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "🆔 Meeting ID: ${call.meetId}",
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "🕒 Time: ${formatDate(call.meetingTime)}",
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "📖 Description: ${call.description}",
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    "Status:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    call.meetStatus,
                    style: TextStyle(
                      color: call.meetStatus.toLowerCase() == "ongoing"
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.play_arrow, color: Colors.white),
                label: Text("Join Now", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openInBrowser(call.meetId);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
