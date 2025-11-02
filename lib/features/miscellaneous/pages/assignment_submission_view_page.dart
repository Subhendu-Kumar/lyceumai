// lib/features/miscellaneous/pages/assignment_submission_view_page.dart

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:flutter_sound/flutter_sound.dart';

import 'package:lyceumai/core/constants/constants.dart';
import 'package:lyceumai/core/services/sp_service.dart';

import 'package:lyceumai/models/class_assignment_model.dart';
import 'package:lyceumai/models/class_assignment_submission_model.dart';

import 'package:lyceumai/features/miscellaneous/widgets/submission_list_item.dart';
import 'package:lyceumai/features/miscellaneous/widgets/submission_text_item.dart';
import 'package:lyceumai/features/miscellaneous/widgets/assignment_detail_card.dart';

class AssignmentSubmissionViewPage extends StatefulWidget {
  final String assignmentId;
  const AssignmentSubmissionViewPage({super.key, required this.assignmentId});

  @override
  State<AssignmentSubmissionViewPage> createState() =>
      _AssignmentSubmissionViewPageState();
}

class _AssignmentSubmissionViewPageState
    extends State<AssignmentSubmissionViewPage> {
  String? errorMsg;
  bool isPlaying = false;
  FlutterSoundPlayer? _player;
  final SpService _spService = SpService();
  ClassAssignmentSubmissionModel? _submissionDetails;

  Future<void> _fetchSubmissionDetails(String id) async {
    try {
      final token = await _spService.getToken();
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
        setState(() {
          errorMsg = 'User not authenticated';
        });
        return;
      }
      final res = await http.get(
        Uri.parse("${ServerConstant.serverURL}/assignment/s/$id/submission"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        if (mounted) {
          final details = ClassAssignmentSubmissionModel.fromJson(res.body);
          if (details.assignment.type == AssignmentType.voice) {
            _player = FlutterSoundPlayer();
            await _openAudio();
          }
          setState(() {
            _submissionDetails = details;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to fetch submission details: ${res.statusCode}',
              ),
            ),
          );
        }
        setState(() {
          errorMsg = 'Failed to fetch submission details';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching submission details: $e')),
        );
      }
      setState(() {
        errorMsg = 'Error fetching submission details';
      });
    }
  }

  Future<void> _openAudio() async {
    await _player!.openPlayer();
    _player!.setSubscriptionDuration(const Duration(milliseconds: 100));
    _player!.onProgress!.listen((event) {
      if (event.duration.inMilliseconds > 0 &&
          event.position >= event.duration) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  void _togglePlayback(String audioPath) async {
    if (isPlaying) {
      await _player!.pausePlayer();
      setState(() => isPlaying = false);
    } else {
      if (_player!.isPaused) {
        await _player!.resumePlayer();
      } else {
        await _player!.startPlayer(
          fromURI: audioPath,
          codec: Codec.aacADTS,
          whenFinished: () {
            setState(() => isPlaying = false);
          },
        );
      }
      setState(() => isPlaying = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSubmissionDetails(widget.assignmentId);
  }

  @override
  void dispose() {
    _player?.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Submission: ${widget.assignmentId}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_submissionDetails != null) ...[
                AssignmentDetailCard(
                  assignment: _submissionDetails!.assignment,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Your Submission",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (_submissionDetails!.assignment.type ==
                    AssignmentType.text) ...[
                  SubmissionTextItem(
                    title: "Ans:",
                    value:
                        _submissionDetails!.submission.textSubmission!.content,
                  ),
                ] else ...[
                  SubmissionTextItem(
                    title: "Transcript:",
                    value: _submissionDetails!
                        .submission
                        .voiceSubmission!
                        .transcript,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      _togglePlayback(
                        _submissionDetails!.submission.voiceSubmission!.fileUrl,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 4,
                      shadowColor: Colors.blueAccent,
                    ),
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(
                      isPlaying ? "Pause" : "Play",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  "AI Analysis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (_submissionDetails!.assignment.type ==
                    AssignmentType.text) ...[
                  SubmissionTextItem(
                    title: "Score",
                    value:
                        "${_submissionDetails!.submission.textSubmission!.score}/100",
                    backgroundColor: const Color(0xFFE3F2FD),
                  ),
                  SubmissionTextItem(
                    title: "Feedback",
                    value:
                        _submissionDetails!.submission.textSubmission!.feedback,
                    backgroundColor: const Color(0xFFFFF9C4),
                  ),
                  SubmissionListItem(
                    title: "Strengths",
                    items: _submissionDetails!
                        .submission
                        .textSubmission!
                        .strengths,
                    backgroundColor: const Color(0xFFE8F5E9),
                  ),
                  SubmissionListItem(
                    title: "Improvements",
                    items: _submissionDetails!
                        .submission
                        .textSubmission!
                        .improvements,
                    backgroundColor: const Color(0xFFFFF3E0),
                  ),
                ] else ...[
                  SubmissionTextItem(
                    title: "Score",
                    value:
                        "${_submissionDetails!.submission.voiceSubmission!.score}/100",
                    backgroundColor: const Color(0xFFE3F2FD),
                  ),
                  SubmissionTextItem(
                    title: "Feedback",
                    value: _submissionDetails!
                        .submission
                        .voiceSubmission!
                        .feedback,
                    backgroundColor: const Color(0xFFFFF9C4),
                  ),
                  SubmissionListItem(
                    title: "Strengths",
                    items: _submissionDetails!
                        .submission
                        .voiceSubmission!
                        .strengths,
                    backgroundColor: const Color(0xFFE8F5E9),
                  ),
                  SubmissionListItem(
                    title: "Improvements",
                    items: _submissionDetails!
                        .submission
                        .voiceSubmission!
                        .improvements,
                    backgroundColor: const Color(0xFFFFF3E0),
                  ),
                ],
                const SizedBox(height: 40),
              ] else if (errorMsg != null) ...[
                Center(
                  child: Text(
                    errorMsg!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ] else ...[
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
