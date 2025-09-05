import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/features/home/cubit/class_cubit.dart';
import 'package:lyceumai/models/user_model.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ClassCubit>().getEnrolledClasses(); // fetch classes on load
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        UserModel? user;
        if (state is AuthLoggedIn) {
          user = state.user;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Lyceum AI",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (user != null) {
                    _showUserDialog(context, user);
                  }
                },
                icon: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.black87),
              ),
            ],
          ),
          body: BlocBuilder<ClassCubit, ClassState>(
            builder: (context, state) {
              if (state is ClassLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClassLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.classes.length,
                  itemBuilder: (context, index) {
                    final classItem = state.classes[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      clipBehavior: Clip.antiAlias, // keeps rounded corners
                      child: Stack(
                        children: [
                          // Background image
                          Container(
                            height: 160,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/banner_class.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Dark overlay for readability
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                          ),
                          // Class details (your data)
                          Positioned(
                            left: 16,
                            top: 16,
                            right: 48, // leave space for menu button
                            child: Text(
                              classItem.name,
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
                              "Code: ${classItem.code}",
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
                              "Updated: ${formatDate(classItem.updatedAt)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Menu icon
                          Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Handle menu actions
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is ClassEmpty) {
                // Default screen if no classes
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.computer, size: 150, color: Colors.grey),
                      const Text(
                        "Add a class to get started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Join class"),
                      ),
                    ],
                  ),
                );
              } else if (state is ClassError) {
                return Center(child: Text("Error: ${state.error}"));
              }
              return const SizedBox();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.add, color: Colors.black87),
          ),
        );
      },
    );
  }

  void _showUserDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange,
                radius: 30,
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user.email,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}
