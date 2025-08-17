import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController _playerController = PlayerController();

  void _initAudioPlayer() async {
    await _playerController.preparePlayer(path: widget.path);

    // Listen to player state changes
    _playerController.onPlayerStateChanged.listen((state) {
      setState(() {});
    });

    // Listen for completion and reset player
    _playerController.onCompletion.listen((_) {
      _resetPlayer();
    });
  }

  void _resetPlayer() async {
    // Stop the player and seek to beginning
    await _playerController.stopPlayer();
    await _playerController.seekTo(0);
    setState(() {});
  }

  Future<void> _playAndPause() async {
    if (_playerController.playerState.isStopped) {
      // If stopped (finished), prepare and start again
      await _playerController.preparePlayer(path: widget.path);
      await _playerController.startPlayer();
    } else if (!_playerController.playerState.isPlaying) {
      // If paused, resume playing
      await _playerController.startPlayer();
    } else {
      // If playing, pause
      await _playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           onPressed: _playAndPause,
  //           icon: Icon(
  //             _playerController.playerState.isPlaying
  //                 ? CupertinoIcons.pause_solid
  //                 : CupertinoIcons.play_arrow_solid,
  //           ),
  //         ),
  //         Expanded(
  //           child: AudioFileWaveforms(
  //             size: const Size(double.infinity, 50),
  //             playerController: _playerController,
  //             playerWaveStyle: const PlayerWaveStyle(
  //               fixedWaveColor: Color.fromRGBO(187, 63, 221, 1),
  //               liveWaveColor: Color.fromRGBO(251, 109, 169, 1),
  //               spacing: 6,
  //               showSeekLine: false,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50, // soft background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Play/Pause button inside a circle
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(187, 63, 221, 1),
                  Color.fromRGBO(251, 109, 169, 1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _playerController.playerState.isPlaying
                    ? CupertinoIcons.pause_solid
                    : CupertinoIcons.play_arrow_solid,
                color: Colors.white,
              ),
              onPressed: _playAndPause,
            ),
          ),
          const SizedBox(width: 12),
          // Waveform
          Expanded(
            child: AudioFileWaveforms(
              size: const Size(double.infinity, 50),
              playerController: _playerController,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Color.fromRGBO(187, 63, 221, 0.4),
                liveWaveColor: Color.fromRGBO(187, 63, 221, 1),
                spacing: 4,
                showSeekLine: false,
                waveCap: StrokeCap.round,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
