import 'package:flutter/widgets.dart';
import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter_animated_progress_bar/src/foundation/basic_types.dart';
import 'package:flutter_animated_progress_bar/src/rendering/render_progress_bar.dart';
import 'package:flutter_animated_progress_bar/src/widgets/progress_bar.dart';

class RenderProgressBarWidget extends LeafRenderObjectWidget {
  const RenderProgressBarWidget({
    super.key,
    required this.controller,
    required this.progress,
    this.buffered,
    required this.total,
    required this.alignment,
    required this.barCapShape,
    required this.progressBarIndicator,
    required this.collapsedBarHeight,
    required this.collapsedThumbRadius,
    required this.expandedBarHeight,
    required this.expandedThumbRadius,
    required this.thumbGlowRadius,
    required this.thumbGlowColor,
    required this.backgroundBarColor,
    required this.collapsedProgressBarColor,
    required this.collapsedBufferedBarColor,
    required this.collapsedThumbColor,
    this.expandedProgressBarColor,
    this.expandedBufferedBarColor,
    this.expandedThumbColor,
    required this.lerpColorsTransition,
    required this.showBufferedWhenCollapsed,
    required this.automaticallyHandleAnimations,
    required this.progressBarState,
    required this.onSeek,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticsFormatter,
  });

  final ProgressBarController controller;
  final Duration progress;
  final Duration? buffered;
  final Duration total;
  final ProgressBarAlignment alignment;
  final BarCapShape barCapShape;
  final ProgressBarIndicator progressBarIndicator;
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
  final Color? expandedProgressBarColor;
  final Color? expandedBufferedBarColor;
  final Color? expandedThumbColor;
  final bool lerpColorsTransition;
  final bool showBufferedWhenCollapsed;
  final bool automaticallyHandleAnimations;
  final ProgressBarState progressBarState;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeStart;
  final ValueChanged<Duration>? onChangeEnd;
  final SemanticsFormatter? semanticsFormatter;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProgressBar(
      controller: controller,
      progress: progress,
      buffered: buffered,
      total: total,
      alignment: alignment,
      barCapShape: barCapShape,
      progressBarIndicator: progressBarIndicator,
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
      expandedProgressBarColor:
          expandedProgressBarColor ?? collapsedProgressBarColor,
      expandedBufferedBarColor:
          expandedBufferedBarColor ?? collapsedBufferedBarColor,
      expandedThumbColor: expandedThumbColor ?? collapsedThumbColor,
      lerpColorsTransition: lerpColorsTransition,
      showBufferedWhenCollapsed: showBufferedWhenCollapsed,
      automaticallyHandleAnimations: automaticallyHandleAnimations,
      progressBarState: progressBarState,
      onSeek: onSeek,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      semanticsFormatter: semanticsFormatter,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderProgressBar renderObject,
  ) {
    renderObject
      ..controller = controller
      ..progress = progress
      ..buffered = buffered
      ..total = total
      ..alignment = alignment
      ..barCapShape = barCapShape
      ..progressBarIndicator = progressBarIndicator
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
      ..expandedProgressBarColor =
          expandedProgressBarColor ?? collapsedProgressBarColor
      ..expandedBufferedBarColor =
          expandedBufferedBarColor ?? collapsedBufferedBarColor
      ..expandedThumbColor = expandedThumbColor ?? collapsedThumbColor
      ..lerpColorsTransition = lerpColorsTransition
      ..showBufferedWhenCollapsed = showBufferedWhenCollapsed
      ..automaticallyHandleAnimations = automaticallyHandleAnimations
      ..semanticsFormatter = semanticsFormatter;
  }
}
