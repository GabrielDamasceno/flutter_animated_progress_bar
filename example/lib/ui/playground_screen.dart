// ignore_for_file: unused_element

import 'package:animated_progress_bar/animated_progress_bar.dart';
import 'package:flutter/material.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PlaygroundScreen(),
      ),
    );
  }
}

class _PlaygroundScreenState extends State<PlaygroundScreen> with TickerProviderStateMixin {
  late final ProgressBarController _controller;

  late Duration _progress;
  late Duration _buffered;
  late Duration _total;

  late bool _showBounds;
  late bool _lerpColors;
  late bool _showBufferedWhenCollapsed;

  late ProgressBarAlignment _alignment;

  late final Color _backgroundBarColor;
  late final Color _collapsedProgressBarColor;
  late final Color _collapsedBufferedBarColor;
  late final Color _collapsedThumbColor;
  late final Color _expandedProgressBarColor;
  late final Color _expandedBufferedBarColor;
  late final Color _expandedThumbColor;

  @override
  void initState() {
    super.initState();

    _controller = ProgressBarController(vsync: this);

    _progress = Duration.zero;
    _buffered = Duration.zero;
    _total = const Duration(minutes: 1);

    _showBounds = true;
    _lerpColors = true;
    _showBufferedWhenCollapsed = true;

    _alignment = ProgressBarAlignment.center;

    _backgroundBarColor = Colors.grey;
    _collapsedProgressBarColor = Colors.red;
    _collapsedBufferedBarColor = Colors.blue;
    _collapsedThumbColor = Colors.white;
    _expandedProgressBarColor = Colors.pink;
    _expandedBufferedBarColor = Colors.green;
    _expandedThumbColor = Colors.teal;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Duration(label: 'Progress', duration: _progress),
                  _Duration(label: 'Buffered', duration: _buffered),
                  _Duration(label: 'Total', duration: _total),
                ],
              ),
              const SizedBox(width: 20.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Duration(label: 'Expansion', duration: _controller.expansionDuration),
                  _Duration(label: 'Hold', duration: _controller.holdDuration),
                  _Duration(label: 'Thumb', duration: _controller.thumbDuration),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Color(label: 'Background bar', color: _backgroundBarColor),
                  _Color(label: 'Collapsed progress bar', color: _collapsedProgressBarColor),
                  _Color(label: 'Collapsed buffered bar', color: _collapsedBufferedBarColor),
                  _Color(label: 'Collapsed thumb', color: _collapsedThumbColor),
                ],
              ),
              const SizedBox(width: 20.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Color(label: 'Expanded progress bar', color: _expandedProgressBarColor),
                  _Color(label: 'Expanded buffered bar', color: _expandedBufferedBarColor),
                  _Color(label: 'Expanded thumb', color: _expandedThumbColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Container(
              decoration: (_showBounds)
                  ? BoxDecoration(
                      border: Border.all(color: Colors.red),
                    )
                  : null,
              child: ProgressBar(
                controller: _controller,
                progress: _progress,
                buffered: _buffered,
                total: _total,
                alignment: _alignment,
                lerpColorsTransition: _lerpColors,
                showBufferedWhenCollapsed: _showBufferedWhenCollapsed,
                backgroundBarColor: _backgroundBarColor,
                collapsedProgressBarColor: _collapsedProgressBarColor,
                collapsedBufferedBarColor: _collapsedBufferedBarColor,
                collapsedThumbColor: _collapsedThumbColor,
                expandedProgressBarColor: _expandedProgressBarColor,
                expandedBufferedBarColor: _expandedBufferedBarColor,
                expandedThumbColor: _expandedThumbColor,
                onSeek: (value) => setState(() => _progress = value),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Alignment:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10.0),
              DropdownButton(
                value: _alignment,
                items: ProgressBarAlignment.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (value) => setState(() => _alignment = value!),
              ),
            ],
          ),
          _Tile(
            label: 'Show bounds',
            value: _showBounds,
            onChanged: (value) => setState(() => _showBounds = !_showBounds),
          ),
          _Tile(
            label: 'Lerp colors',
            value: _lerpColors,
            onChanged: (value) => setState(() => _lerpColors = !_lerpColors),
          ),
          _Tile(
            label: 'Show buffered when collapsed',
            value: _showBufferedWhenCollapsed,
            onChanged: (value) => setState(
              () => _showBufferedWhenCollapsed = !_showBufferedWhenCollapsed,
            ),
          ),
          _ValueTracker(
            label: 'Progress',
            value: _progress.inMicroseconds / _total.inMicroseconds,
            onChanged: (value) {
              setState(
                () => _progress = Duration(microseconds: (value * _total.inMicroseconds).round()),
              );
            },
          ),
          _ValueTracker(
            label: 'Buffered',
            value: _buffered.inMicroseconds / _total.inMicroseconds,
            onChanged: (value) {
              setState(
                () => _buffered = Duration(microseconds: (value * _total.inMicroseconds).round()),
              );
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

class _Duration extends StatelessWidget {
  final String label;
  final Duration duration;

  const _Duration({
    super.key,
    required this.label,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: '${duration.inMilliseconds} ms',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class _Color extends StatelessWidget {
  final String label;
  final Color color;

  const _Color({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            width: 20.0,
            height: 20.0,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _Tile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
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
      child: SizedBox(
        width: 150.0,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(label),
        ),
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
