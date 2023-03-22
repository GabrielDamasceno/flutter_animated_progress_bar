import 'package:example/ui/audio_example.dart';
import 'package:example/ui/playground.dart';
import 'package:example/ui/simple_example.dart';
import 'package:example/ui/video_example.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => SimpleExample.route(context),
              child: const Text('Simple Example'),
            ),
            ElevatedButton(
              onPressed: () => AudioExample.route(context),
              child: const Text('Audio Example'),
            ),
            ElevatedButton(
              onPressed: () => VideoExample.route(context),
              child: const Text('Video Example'),
            ),
            ElevatedButton(
              onPressed: () => Playground.route(context),
              child: const Text('Playground'),
            ),
          ],
        ),
      ),
    );
  }
}
