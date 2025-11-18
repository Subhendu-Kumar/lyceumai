import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';
import 'package:lyceumai/models/class_quiz_model.dart';

import "package:http/http.dart" as http;

class QuizBottomDrawer extends StatefulWidget {
  final ClassQuizModel quiz;
  const QuizBottomDrawer({super.key, required this.quiz});

  @override
  State<QuizBottomDrawer> createState() => _QuizBottomDrawerState();
}

class _QuizBottomDrawerState extends State<QuizBottomDrawer> {
  final SpService spService = SpService();
  List<String> attemptIds = [];
  bool isLoading = true;
  String? errorMessage;

  Future<List<String>> _fetchQuizAttempts() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        throw "No Token Found";
      }
      setState(() {
        isLoading = true;
      });
      final res = await http.get(
        Uri.parse(
          '${ServerConstant.serverURL}/quiz/attempt/${widget.quiz.id}/ids',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'];
      }
      return (jsonDecode(res.body)['attempt_ids'] as List)
          .map((e) => e.toString())
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuizAttempts()
        .then((ids) {
          setState(() {
            attemptIds = ids;
            isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            errorMessage = error.toString();
            isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.quiz.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.quiz.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),

          // Display loading, error, or attempt
          Expanded(child: Center(child: _buildStateWidget())),
        ],
      ),
    );
  }

  Widget _buildStateWidget() {
    // Loading State
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    // Error State
    if (errorMessage != null) {
      return Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      );
    }

    // No attempts → Attempt Quiz
    if (attemptIds.isEmpty) {
      return ElevatedButton(
        onPressed: () {
          // TODO: Navigate to quiz attempt screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Attempt Quiz",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }

    // Attempts exist → View Attempts
    return ElevatedButton(
      onPressed: () {
        // TODO: Navigate to view attempts screen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        "View All Attempts",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
