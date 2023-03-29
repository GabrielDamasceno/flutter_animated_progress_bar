// ignore_for_file: unused_element

import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter/material.dart';

class AlignmentExample extends StatefulWidget {
  const AlignmentExample({super.key});

  @override
  State<AlignmentExample> createState() => _AlignmentExampleState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AlignmentExample(),
      ),
    );
  }
}

class _AlignmentExampleState extends State<AlignmentExample>
    with TickerProviderStateMixin {
  late final ProgressBarController _controller1;
  late final ProgressBarController _controller2;

  @override
  void initState() {
    super.initState();

    _controller1 = ProgressBarController(vsync: this);
    _controller2 = ProgressBarController(vsync: this);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alignment example')),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        children: [
          _Demo(
            label: 'Aligned to the center',
            controller: _controller1,
            alignment: ProgressBarAlignment.center,
          ),
          const SizedBox(height: 20.0),
          _Demo(
            label: 'Aligned to the bottom',
            controller: _controller2,
            alignment: ProgressBarAlignment.bottom,
          ),
        ],
      ),
    );
  }
}

class _Demo extends StatelessWidget {
  final String label;
  final ProgressBarController controller;
  final ProgressBarAlignment alignment;

  const _Demo({
    super.key,
    required this.label,
    required this.controller,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Placeholder(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ProgressBar(
                  controller: controller,
                  alignment: alignment,
                  expandedBarHeight: 12.0,
                  collapsedThumbRadius: 10.0,
                  expandedThumbRadius: 14.0,
                  thumbGlowRadius: 30.0,
                  progress: const Duration(seconds: 30),
                  buffered: const Duration(seconds: 45),
                  total: const Duration(minutes: 1),
                  onSeek: (value) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
