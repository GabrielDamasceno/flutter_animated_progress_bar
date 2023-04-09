// ignore_for_file: unused_element

import 'package:example/ui/playground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';

class ControllerPlayground extends StatefulWidget {
  const ControllerPlayground({super.key});

  @override
  State<ControllerPlayground> createState() => _ControllerPlaygroundState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ControllerPlayground(),
      ),
    );
  }
}

class _ControllerPlaygroundState extends State<ControllerPlayground>
    with TickerProviderStateMixin {
  late final ProgressBarController _controller;

  late Duration _progress;
  late Duration _buffered;
  late Duration _total;

  @override
  void initState() {
    super.initState();

    _controller = ProgressBarController(vsync: this);

    _progress = Duration.zero;
    _buffered = Duration.zero;
    _total = const Duration(minutes: 1);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controller Playground')),
      body: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlaygroundDuration(
                label: 'Bar duration',
                duration: _controller.barAnimationDuration,
              ),
              PlaygroundDuration(
                label: 'Thumb duration',
                duration: _controller.thumbAnimationDuration,
              ),
              PlaygroundDuration(
                label: 'Waiting duration',
                duration: _controller.waitingDuration,
              ),
            ],
          ),
          _ValueTracker(
            label: 'Progress',
            value: _progress.inMicroseconds / _total.inMicroseconds,
            onChanged: (value) {
              setState(
                () => _progress = Duration(
                    microseconds: (value * _total.inMicroseconds).round()),
              );
            },
          ),
          _ValueTracker(
            label: 'Buffered',
            value: _buffered.inMicroseconds / _total.inMicroseconds,
            onChanged: (value) {
              setState(() {
                _buffered = Duration(
                  microseconds: (value * _total.inMicroseconds).round(),
                );
              });
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _ValueTracker(
                label: 'Bar Animation',
                value: _controller.barValue,
                onChanged: (value) => _controller.barValue = value,
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _ValueTracker(
                label: 'Thumb Animation',
                value: _controller.thumbValue,
                onChanged: (value) => _controller.thumbValue = value,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ProgressBar(
              controller: _controller,
              progress: _progress,
              buffered: _buffered,
              total: _total,
              expandedBarHeight: 10.0,
              onSeek: (value) => setState(() => _progress = value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Button(
                    label: 'Forward',
                    onPressed: () => _controller.forward(),
                  ),
                  _Button(
                    label: 'Expand bar',
                    onPressed: () => _controller.expandBar(),
                  ),
                  _Button(
                    label: 'Collapse bar',
                    onPressed: () => _controller.collapseBar(),
                  ),
                ],
              ),
              Column(
                children: [
                  _Button(
                    label: 'Expand thumb',
                    onPressed: () => _controller.expandThumb(),
                  ),
                  _Button(
                    label: 'Collapse thumb',
                    onPressed: () => _controller.collapseThumb(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueTracker extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _ValueTracker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Slider(value: value, onChanged: onChanged),
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '$label:\n',
              style: const TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: value.toStringAsFixed(4),
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final Future<void> Function() onPressed;

  const _Button({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          width: 150.0,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
