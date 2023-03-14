import 'package:example/ui/audio_progress_bar_example.dart';
import 'package:example/ui/playground_screen.dart';
import 'package:example/ui/static_progress_bar_example.dart';
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
              onPressed: () => PlaygroundScreen.route(context),
              child: const Text('Playground'),
            ),
            ElevatedButton(
              onPressed: () => StaticProgressBarExample.route(context),
              child: const Text('Static Example'),
            ),
            ElevatedButton(
              onPressed: () => AudioProgressBarExample.route(context),
              child: const Text('Audio Example'),
            ),
          ],
        ),
      ),
    );
  }
}
