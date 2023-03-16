import 'package:animated_progress_bar/src/foundation/basic_types.dart';
import 'package:animated_progress_bar/src/foundation/controller.dart';
import 'package:animated_progress_bar/src/foundation/enums.dart';
import 'package:animated_progress_bar/src/rendering/render_progress_bar.dart';
import 'package:flutter/material.dart';

class ProgressBar extends LeafRenderObjectWidget {
  final ProgressBarController controller;

  final Duration progress;
  final Duration? buffered;
  final Duration total;

  final ProgressBarAlignment alignment;
  final BarCapShape barCapShape;

  final double collapsedBarHeight;
  final double collapsedThumbRadius;

  final double expandedBarHeight;
  final double expandedThumbRadius;

  final double thumbGlowRadius;
  final Color thumbGlowColor;

  final Color backgroundBarColor;

  final Color collapsedProgressBarColor;
  final Color collapsedBufferedBarColor;
  final Color collapsedThumbColor;

  final Color expandedProgressBarColor;
  final Color expandedBufferedBarColor;
  final Color expandedThumbColor;

  final bool lerpColorsTransition;
  final bool showBufferedWhenCollapsed;

  final ValueChanged<Duration> onSeek;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeStart;
  final ValueChanged<Duration>? onChangeEnd;

  final SemanticsFormatter? semanticsFormatter;

  const ProgressBar({
    super.key,
    required this.controller,
    required this.progress,
    this.buffered,
    required this.total,
    this.alignment = ProgressBarAlignment.center,
    this.barCapShape = BarCapShape.square,
    this.collapsedBarHeight = 5.0,
    this.collapsedThumbRadius = 8.0,
    this.expandedBarHeight = 7.0,
    this.expandedThumbRadius = 10.0,
    this.thumbGlowRadius = 25.0,
    this.thumbGlowColor = const Color(0x50FFFFFF),
    this.backgroundBarColor = Colors.grey,
    this.collapsedProgressBarColor = Colors.red,
    this.collapsedBufferedBarColor = const Color(0x36F44336),
    this.collapsedThumbColor = Colors.white,
    this.expandedProgressBarColor = Colors.red,
    this.expandedBufferedBarColor = const Color(0x36F44336),
    this.expandedThumbColor = Colors.white,
    this.lerpColorsTransition = true,
    this.showBufferedWhenCollapsed = true,
    required this.onSeek,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticsFormatter,
  })  : assert(total != Duration.zero),
        assert(expandedBarHeight >= collapsedBarHeight),
        assert(expandedThumbRadius >= collapsedThumbRadius);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProgressBar(
      controller: controller,
      progress: progress,
      buffered: buffered,
      total: total,
      alignment: alignment,
      barCapShape: barCapShape,
      collapsedBarHeight: collapsedBarHeight,
      collapsedThumbRadius: collapsedThumbRadius,
      expandedBarHeight: expandedBarHeight,
      expandedThumbRadius: expandedThumbRadius,
      thumbGlowRadius: thumbGlowRadius,
      thumbGlowColor: thumbGlowColor,
      backgroundBarColor: backgroundBarColor,
      collapsedProgressBarColor: collapsedProgressBarColor,
      collapsedBufferedBarColor: collapsedBufferedBarColor,
      collapsedThumbColor: collapsedThumbColor,
      expandedProgressBarColor: expandedProgressBarColor,
      expandedBufferedBarColor: expandedBufferedBarColor,
      expandedThumbColor: expandedThumbColor,
      lerpColorsTransition: lerpColorsTransition,
      showBufferedWhenCollapsed: showBufferedWhenCollapsed,
      onSeek: onSeek,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      semanticsFormatter: semanticsFormatter,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderProgressBar renderObject) {
    renderObject
      ..controller = controller
      ..progress = progress
      ..buffered = buffered
      ..total = total
      ..alignment = alignment
      ..barCapShape = barCapShape
      ..collapsedBarHeight = collapsedBarHeight
      ..collapsedThumbRadius = collapsedThumbRadius
      ..expandedBarHeight = expandedBarHeight
      ..expandedThumbRadius = expandedThumbRadius
      ..thumbGlowRadius = thumbGlowRadius
      ..thumbGlowColor = thumbGlowColor
      ..backgroundBarColor = backgroundBarColor
      ..collapsedProgressBarColor = collapsedProgressBarColor
      ..collapsedBufferedBarColor = collapsedBufferedBarColor
      ..collapsedThumbColor = collapsedThumbColor
      ..expandedProgressBarColor = expandedProgressBarColor
      ..expandedBufferedBarColor = expandedBufferedBarColor
      ..expandedThumbColor = expandedThumbColor
      ..lerpColorsTransition = lerpColorsTransition
      ..showBufferedWhenCollapsed = showBufferedWhenCollapsed
      ..semanticsFormatter = semanticsFormatter;
  }
}
