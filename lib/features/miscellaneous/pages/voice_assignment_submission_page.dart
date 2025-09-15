import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import 'package:lyceumai/models/assignment_model.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_load_cubit.dart';
import 'package:lyceumai/features/miscellaneous/widgets/assignment_detail_card.dart';
import 'package:lyceumai/features/miscellaneous/cubit/assignment_submission_cubit.dart';

class VoiceAssignmentSubmissionPage extends StatefulWidget {
  final String assignmentId;
  const VoiceAssignmentSubmissionPage({super.key, required this.assignmentId});

  @override
  State<VoiceAssignmentSubmissionPage> createState() =>
      _VoiceAssignmentSubmissionPageState();
}

class _VoiceAssignmentSubmissionPageState
    extends State<VoiceAssignmentSubmissionPage> {
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isPlaying = false;
  String? recordedFilePath;
  // String? serverResponse;

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;

  @override
  void initState() {
    super.initState();
    context.read<AssignmentLoadCubit>().loadAssignment(widget.assignmentId);
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    openAudio();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    isRecorderInit = false;
    super.dispose();
  }

  Future<void> openAudio() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic is not allowed!");
    }

    await _recorder!.openRecorder();
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

    isRecorderInit = true;
  }

  void handleRecording() async {
    if (!isRecorderInit) return;

    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';

    if (isRecording) {
      final filePath = await _recorder!.stopRecorder();
      setState(() {
        isRecording = false;
        recordedFilePath = filePath;
      });
    } else {
      await _recorder!.startRecorder(toFile: path);
      setState(() {
        isRecording = true;
      });
    }
  }

  void togglePlayback() async {
    if (recordedFilePath == null) return;

    if (isPlaying) {
      await _player!.pausePlayer();
      setState(() => isPlaying = false);
    } else {
      if (_player!.isPaused) {
        await _player!.resumePlayer();
      } else {
        await _player!.startPlayer(
          fromURI: recordedFilePath,
          whenFinished: () {
            setState(() => isPlaying = false);
          },
        );
      }
      setState(() => isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Voice Assignment Submission'),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            recordedFilePath = null;
          });
        },
        backgroundColor: Colors.grey[100],
        child: const Icon(Icons.refresh_rounded),
      ),
      body: BlocBuilder<AssignmentLoadCubit, AssignmentLoadState>(
        builder: (context, state) {
          AssignmentModel? assignment;
          if (state is AssignmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AssignmentLoadingFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is AssignmentLoaded) {
            assignment = state.assignment;
          }

          return BlocListener<
            AssignmentSubmissionCubit,
            AssignmentSubmissionState
          >(
            listener: (context, subState) {
              if (subState is AssignmentSubmissionSuccess) {
                Future.delayed(Duration(milliseconds: 100), () {
                  // ignore: use_build_context_synchronously
                  context.pop();
                });
              } else if (subState is AssignmentSubmissionFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(subState.error)));
              }
            },
            child: BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionState>(
              builder: (context, subState) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AssignmentDetailCard(assignment: assignment!),
                            const SizedBox(height: 20),
                            const Text(
                              "Record Your Answer",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    isRecording
                                        ? 'Recording in progress...'
                                        : 'Press the mic to start recording',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 20),
                                  IconButton(
                                    onPressed: handleRecording,
                                    icon: isRecording
                                        ? const Icon(
                                            Icons.stop,
                                            color: Colors.red,
                                            size: 40,
                                          )
                                        : const Icon(
                                            Icons.mic,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                  ),
                                  const SizedBox(height: 20),
                                  // If recorded file exists
                                  if (recordedFilePath != null) ...[
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.audiotrack,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Saved File: $recordedFilePath",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: togglePlayback,
                                      style: ElevatedButton.styleFrom(
                                        iconColor: Colors.white,
                                        minimumSize: const Size(
                                          double.infinity,
                                          52,
                                        ),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        elevation: 4,
                                        shadowColor: Colors.blueAccent,
                                      ),
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                      label: Text(
                                        isPlaying ? "Pause" : "Play",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    if (isPlaying) ...[
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Playing audio...",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed:
                                          subState
                                              is AssignmentSubmissionInProgress
                                          ? null
                                          : () {
                                              context
                                                  .read<
                                                    AssignmentSubmissionCubit
                                                  >()
                                                  .voiceAssignmentSubmission(
                                                    assignment!.id,
                                                    recordedFilePath!,
                                                  );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(
                                          double.infinity,
                                          52,
                                        ),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        elevation: 5,
                                        shadowColor: Colors.blueAccent,
                                      ),
                                      child:
                                          subState
                                              is AssignmentSubmissionInProgress
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Submit Answer',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
