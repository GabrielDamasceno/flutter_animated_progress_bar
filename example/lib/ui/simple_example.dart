import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter/material.dart';

class SimpleExample extends StatefulWidget {
  const SimpleExample({super.key});

  @override
  State<SimpleExample> createState() => _SimpleExampleState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SimpleExample(),
      ),
    );
  }
}

class _SimpleExampleState extends State<SimpleExample>
    with TickerProviderStateMixin {
  late final ProgressBarController _controller;


  @override
  void initState() {
    super.initState();
    _controller = ProgressBarController(
      vsync: this,
      thumbAnimationDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple example')),
      body: Center(
        child: ProgressBar(
          controller: _controller,
          progress: const Duration(seconds: 30),
          buffered: const Duration(seconds: 45),
          total: const Duration(minutes: 1),
          collapsedBarHeight: 6.0,
          expandedBarHeight: 12.0,
          collapsedThumbRadius: 10.0,
          expandedThumbRadius: 14.0,
          thumbGlowRadius: 32.0,
          onSeek: (value) {},
        ),
      ),
    );
  }
}
