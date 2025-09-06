import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/features/auth/cubit/auth_cubit.dart';
import 'package:lyceumai/features/home/cubit/class_cubit.dart';

class JoinClassPage extends StatefulWidget {
  const JoinClassPage({super.key});

  @override
  State<JoinClassPage> createState() => _JoinClassPageState();
}

class _JoinClassPageState extends State<JoinClassPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassCubit, ClassState>(
      listener: (context, state) {
        if (state is ClassJoined) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is ClassError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Join class",
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: BlocBuilder<ClassCubit, ClassState>(
                builder: (context, state) {
                  if (state is ClassJoining) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return ActionChip(
                    label: const Text(
                      "Join",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      final code = _codeController.text.trim();
                      if (code.isNotEmpty) {
                        context.read<ClassCubit>().joinClass(code);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a class code."),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoggedIn) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You're currently signed in as",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 24,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Ask your teacher for the class code, then enter it here.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: "Class code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "To sign in with a class code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "• Use an authorized account",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const Text(
                      "• Use a class code with 12 letters or numbers",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "If you have trouble joining the class, go to the\n help center article.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
