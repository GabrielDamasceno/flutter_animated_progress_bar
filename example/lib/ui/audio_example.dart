import 'package:animated_progress_bar/animated_progress_bar.dart';
import 'package:example/extensions/formatted_time.dart';
import 'package:example/models/position_data.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioExample extends StatefulWidget {
  const AudioExample({super.key});

  @override
  State<AudioExample> createState() => _AudioExampleState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AudioExample(),
      ),
    );
  }
}

class _AudioExampleState extends State<AudioExample> with TickerProviderStateMixin {
  late final AudioPlayer _player;
  late final ProgressBarController _progressBarController;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setUrl('https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3');
    _progressBarController = ProgressBarController(vsync: this);
  }

  @override
  void dispose() {
    _player.dispose();
    _progressBarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio example')),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final PlayerState? playerState = snapshot.data;
                final ProcessingState? processingState = playerState?.processingState;
                final bool? playing = playerState?.playing;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 32.0,
                    height: 32.0,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 32.0,
                    onPressed: _player.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    iconSize: 32.0,
                    onPressed: _player.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 32.0,
                    onPressed: () => _player.seek(Duration.zero),
                  );
                }
              },
            ),
            const SizedBox(height: 10.0),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final PositionData? positionData = snapshot.data;
                final Duration progress = positionData?.position ?? Duration.zero;
                final Duration buffered = positionData?.bufferedPosition ?? Duration.zero;
                final Duration total = positionData?.duration ?? Duration.zero;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProgressBar(
                      controller: _progressBarController,
                      progress: progress,
                      buffered: buffered,
                      total: total,
                      onSeek: _player.seek,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(progress.formatToTime()),
                          Text(total.formatToTime()),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, bufferedPosition, duration ?? Duration.zero));
}
