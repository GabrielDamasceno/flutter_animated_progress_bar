import 'dart:async';

import 'package:animated_progress_bar/animated_progress_bar.dart';
import 'package:example/extensions/formatted_time.dart';
import 'package:example/models/position_data.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class VideoExample extends StatefulWidget {
  const VideoExample({super.key});

  @override
  State<VideoExample> createState() => _VideoExampleState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VideoExample(),
      ),
    );
  }
}

class _VideoExampleState extends State<VideoExample> with TickerProviderStateMixin {
  late final ProgressBarController _progressBarController;
  late final VideoPlayerController _videoPlayerController;

  late bool _showControls;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _progressBarController = ProgressBarController(vsync: this);
    _videoPlayerController = VideoPlayerController.network(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    );
    _videoPlayerController.initialize();

    _showControls = true;
    _initializeTimer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _progressBarController.dispose();

    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video example')),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: Listener(
          onPointerUp: (event) {
            setState(() => _showControls = true);
            _initializeTimer();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayer(_videoPlayerController),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: (_showControls)
                    ? Align(
                        child: IconButton(
                          iconSize: 40.0,
                          onPressed: () {
                            setState(() {
                              _videoPlayerController.value.isPlaying
                                  ? _videoPlayerController.pause()
                                  : _videoPlayerController.play();
                            });
                          },
                          icon: Icon(
                            _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: (_showControls)
                      ? ValueListenableBuilder(
                          valueListenable: _videoPlayerController,
                          builder: (context, value, child) {
                            final PositionData positionData = PositionData(
                              value.position,
                              value.buffered.lastOrNull?.end ?? Duration.zero,
                              value.duration,
                            );
                            final Duration progress = positionData.position;
                            final Duration buffered = positionData.bufferedPosition;
                            final Duration total = positionData.duration;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(progress.formatToTime()),
                                      Text(total.formatToTime())
                                    ],
                                  ),
                                ),
                                ProgressBar(
                                  controller: _progressBarController,
                                  progress: progress,
                                  buffered: buffered,
                                  total: total,
                                  alignment: ProgressBarAlignment.bottom,
                                  onSeek: _videoPlayerController.seekTo,
                                ),
                              ],
                            );
                          },
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeTimer() {
    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 4), () {
      setState(() => _showControls = false);
    });
  }
}
