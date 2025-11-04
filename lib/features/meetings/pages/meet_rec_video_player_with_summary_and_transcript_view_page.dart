// lib/features/meetings/pages/meet_rec_video_player_with_summary_and_transcript_view_page.dart

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:lyceumai/models/call_rec_model.dart';
import 'package:lyceumai/features/meetings/widgets/tab_text_view_for_transcript_or_summary.dart';

class MeetRecVideoPlayerWithSummaryAndTranscriptViewPage
    extends StatefulWidget {
  final CallRecModel recording;
  const MeetRecVideoPlayerWithSummaryAndTranscriptViewPage({
    super.key,
    required this.recording,
  });

  @override
  State<MeetRecVideoPlayerWithSummaryAndTranscriptViewPage> createState() =>
      _MeetRecVideoPlayerWithSummaryAndTranscriptViewPageState();
}

class _MeetRecVideoPlayerWithSummaryAndTranscriptViewPageState
    extends State<MeetRecVideoPlayerWithSummaryAndTranscriptViewPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.recording.url),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      looping: false,
      autoPlay: false,
      showControls: true,
      autoInitialize: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
      videoPlayerController: _videoPlayerController,
      playbackSpeeds: [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0],
      customControls: const CupertinoControls(
        backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
        iconColor: Colors.white,
      ),
      cupertinoProgressColors: ChewieProgressColors(
        playedColor: Colors.redAccent,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.redAccent[100]!,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            'Error: $errorMessage',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Meet Rec Player: ${widget.recording.sessionId}"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isInitialized && _chewieController != null
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  )
                : AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(124, 124, 124, 0.702),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: const TabBar(
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.blueGrey,
                          tabs: [
                            Tab(text: 'Transcript'),
                            Tab(text: 'Summary'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            TabTextViewForTranscriptOrSummary(
                              type: "transcript",
                              text: widget.recording.transcript,
                            ),
                            TabTextViewForTranscriptOrSummary(
                              type: "summary",
                              text: widget.recording.summary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
