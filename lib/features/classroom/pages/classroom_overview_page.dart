import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyceumai/core/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/features/classroom/cubit/classroom_cubit.dart';

class ClassroomOverviewPage extends StatefulWidget {
  final String id;
  const ClassroomOverviewPage({super.key, required this.id});

  @override
  State<ClassroomOverviewPage> createState() => _ClassroomOverviewPageState();
}

class _ClassroomOverviewPageState extends State<ClassroomOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ClassroomCubit, ClassroomState>(
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
                            icon: const Icon(Icons.copy, color: Colors.white),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: classroom.code),
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Classroom code copied!"),
                                  backgroundColor:
                                      Colors.green, // ✅ set your color
                                  behavior: SnackBarBehavior
                                      .floating, // optional: floating style
                                  shape: RoundedRectangleBorder(
                                    // optional: rounded corners
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
                  const SizedBox(height: 100),
                  SvgPicture.asset(
                    'assets/class_room_placeholder.svg',
                    height: 150,
                  ),
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
                ],
              ),
            );
          } else if (state is ClassroomError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
