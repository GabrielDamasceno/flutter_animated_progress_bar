// ignore_for_file: unused_element

import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();

  static Future<void> route(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Playground(),
      ),
    );
  }
}

class _PlaygroundState extends State<Playground> with TickerProviderStateMixin {
  late final ProgressBarController _controller;

  late Duration _progress;
  late Duration _buffered;
  late Duration _total;

  late bool _showBounds;
  late bool _lerpColors;
  late bool _showBufferedWhenCollapsed;

  late ProgressBarAlignment _alignment;
  late BarCapShape _barCapShape;
  late ProgressBarIndicator _progressBarIndicator;

  late final Color _backgroundBarColor;
  late final Color _collapsedProgressBarColor;
  late final Color _collapsedBufferedBarColor;
  late final Color _collapsedThumbColor;
  late final Color _expandedProgressBarColor;
  late final Color _expandedBufferedBarColor;
  late final Color _expandedThumbColor;
  late final Color _thumbGlowColor;

  @override
  void initState() {
    super.initState();

    _controller = ProgressBarController(vsync: this);

    _progress = Duration.zero;
    _buffered = const Duration(seconds: 45);
    _total = const Duration(minutes: 1);

    _showBounds = true;
    _lerpColors = true;
    _showBufferedWhenCollapsed = false;

    _alignment = ProgressBarAlignment.center;
    _barCapShape = BarCapShape.square;
    _progressBarIndicator = const RoundedRectangularProgressBarIndicator();

    _backgroundBarColor = Colors.grey;
    _collapsedProgressBarColor = Colors.red;
    _collapsedBufferedBarColor = Colors.blue;
    _collapsedThumbColor = Colors.white;
    _expandedProgressBarColor = Colors.pink;
    _expandedBufferedBarColor = Colors.green;
    _expandedThumbColor = Colors.teal;
    _thumbGlowColor = Colors.white24;
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
                  PlaygroundDuration(label: 'Progress', duration: _progress),
                  PlaygroundDuration(label: 'Buffered', duration: _buffered),
                  PlaygroundDuration(label: 'Total', duration: _total),
                ],
              ),
              const SizedBox(width: 20.0),
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
                  _Color(
                    label: 'Collapsed progress bar',
                    color: _collapsedProgressBarColor,
                  ),
                  _Color(
                    label: 'Collapsed buffered bar',
                    color: _collapsedBufferedBarColor,
                  ),
                  _Color(label: 'Collapsed thumb', color: _collapsedThumbColor),
                ],
              ),
              const SizedBox(width: 20.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Color(
                    label: 'Expanded progress bar',
                    color: _expandedProgressBarColor,
                  ),
                  _Color(
                    label: 'Expanded buffered bar',
                    color: _expandedBufferedBarColor,
                  ),
                  _Color(
                    label: 'Expanded thumb',
                    color: _expandedThumbColor,
                  ),
                  _Color(
                    label: 'Thumb glow',
                    color: _thumbGlowColor,
                  ),
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
                expandedBarHeight: 10.0,
                alignment: _alignment,
                barCapShape: _barCapShape,
                progressBarIndicator: _progressBarIndicator,
                lerpColorsTransition: _lerpColors,
                showBufferedWhenCollapsed: _showBufferedWhenCollapsed,
                backgroundBarColor: _backgroundBarColor,
                collapsedProgressBarColor: _collapsedProgressBarColor,
                collapsedBufferedBarColor: _collapsedBufferedBarColor,
                collapsedThumbColor: _collapsedThumbColor,
                expandedProgressBarColor: _expandedProgressBarColor,
                expandedBufferedBarColor: _expandedBufferedBarColor,
                expandedThumbColor: _expandedThumbColor,
                thumbGlowColor: _thumbGlowColor,
                onSeek: (value) => setState(() => _progress = value),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Alignment:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bar cap:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10.0),
              DropdownButton(
                value: _barCapShape,
                items: BarCapShape.values
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (value) => setState(() => _barCapShape = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Indicator:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10.0),
              DropdownButton(
                value: _progressBarIndicator,
                items: const [
                  DropdownMenuItem(
                    value: ProgressBarIndicator.none,
                    child: Text('none'),
                  ),
                  DropdownMenuItem(
                    value: RoundedRectangularProgressBarIndicator(),
                    child: Text('rectangular'),
                  ),
                  DropdownMenuItem(
                    value: CircularProgressBarIndicator(),
                    child: Text('circular'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _progressBarIndicator = value!);
                },
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
        ],
      ),
    );
  }
}

class PlaygroundDuration extends StatelessWidget {
  final String label;
  final Duration duration;

  const PlaygroundDuration({
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
