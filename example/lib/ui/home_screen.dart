import 'package:example/ui/audio_example.dart';
import 'package:example/ui/controller_playground.dart';
import 'package:example/ui/playground.dart';
import 'package:example/ui/alignment_example.dart';
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
              child: const Text('Simple Example'),
              onPressed: () => SimpleExample.route(context),
            ),
            ElevatedButton(
              child: const Text('Alignment Example'),
              onPressed: () => AlignmentExample.route(context),
            ),
            ElevatedButton(
              child: const Text('Audio Example'),
              onPressed: () => AudioExample.route(context),
            ),
            ElevatedButton(
              child: const Text('Video Example'),
              onPressed: () => VideoExample.route(context),
            ),
            ElevatedButton(
              child: const Text('Playground'),
              onPressed: () => Playground.route(context),
            ),
            ElevatedButton(
              child: const Text('Controller Playground'),
              onPressed: () => ControllerPlayground.route(context),
            ),
          ],
        ),
      ),
    );
  }
}
