import 'package:flutter_animated_progress_bar/src/foundation/basic_types.dart';
import 'package:flutter_animated_progress_bar/src/foundation/controller.dart';
import 'package:flutter_animated_progress_bar/src/foundation/enums.dart';
import 'package:flutter_animated_progress_bar/src/rendering/render_progress_bar.dart';
import 'package:flutter/material.dart';

/// An animated progress bar widget designed to be used with audio or video.
///
/// The key terms for the [ProgressBar] are:
///
/// * "thumb", which is a circle shape that slides horizontally when the user drags it.
/// * "bar", which is the line that thumb slides along.
/// * "collapsed", which means the smallest size defined.
/// * "expanded", which means the biggest size defined.
///
/// By default, a [ProgressBar] will be as wide as possible, centered vertically.
///
/// Here is a simple example using the [ProgressBar] widget:
///
///  ```dart
/// class Example extends StatefulWidget {
///   const Example({super.key});
///
///   @override
///   State<Example> createState() => _ExampleState();
/// }
///
/// class _ExampleState extends State<Example> with TickerProviderStateMixin {
///   late final ProgressBarController _controller;
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = ProgressBarController(vsync: this);
///   }
///
///   @override
///   void dispose() {
///     _controller.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ProgressBar(
///       controller: _controller,
///       progress: const Duration(seconds: 30),
///       buffered: const Duration(seconds: 35),
///       total: const Duration(minutes: 1),
///       onSeek: (value) {
///         print('$value');
///       },
///     );
///   }
/// }
///  ```
class ProgressBar extends LeafRenderObjectWidget {
  /// Creates a [ProgressBar].
  ///
  /// * [controller] is responsible for performing the animations. It is required and must not be null.
  ///
  /// * [progress] is the length of time of the current progress. It is required and must not be null.
  ///
  /// * [total] is the total length of time. It is required and must not be null.
  ///
  /// * [onSeek] is the callback that can be used to seek. It is called when the user taps or
  /// at the end of a drag. It is required and must not be null.
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
    this.expandedProgressBarColor,
    this.expandedBufferedBarColor,
    this.expandedThumbColor,
    this.lerpColorsTransition = true,
    this.showBufferedWhenCollapsed = true,
    required this.onSeek,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticsFormatter,
  })  : assert(expandedBarHeight >= collapsedBarHeight),
        assert(expandedThumbRadius >= collapsedThumbRadius);

  /// The controller that is responsible for driving the animations.
  ///
  /// It will animate the transition from collapsed to expanded state and vice versa.
  final ProgressBarController controller;

  /// The last elapsed time that represents the current progress of the media.
  ///
  /// Should not be greater than the [total] time.
  final Duration progress;

  /// The last elapsed time that represents the buffered progress of the media.
  ///
  /// Should not be greater than the [total] time.
  ///
  /// Defaults to `null`.
  final Duration? buffered;

  /// The total duration of the media.
  final Duration total;

  /// The alignment of [ProgressBar] relative to it's total size.
  ///
  /// This will have a direct impact on how the progress bar will be animated.
  /// To see how the animation will behave, take a look at
  /// this [example](https://github.com/GabrielDamasceno/flutter_animated_progress_bar/blob/master/doc/alignment_demo.gif).
  ///
  /// Defaults to `ProgressBarAlignment.center`.
  final ProgressBarAlignment alignment;

  /// The shape of the bars at the left and right edges.
  ///
  /// Defaults to `BarCapShape.square`.
  final BarCapShape barCapShape;

  /// The smallest size of this bar.
  ///
  /// Defaults to `5.0`.
  final double collapsedBarHeight;

  /// The smallest size of this thumb.
  ///
  /// Note that thumb is entirely dependent on the state of the bar.
  /// Only when the bar is fully expanded, the thumb will reach its collapsed size.
  ///
  /// Defaults to `8.0`.
  final double collapsedThumbRadius;

  /// The greatest size of this bar.
  ///
  /// Defaults to `7.0`.
  final double expandedBarHeight;

  /// The greatest size of this thumb.
  ///
  /// Note that thumb is entirely dependent on the state of the bar.
  /// Only when the bar is fully expanded, the thumb will reach its expanded size.
  ///
  /// By default, when the user starts dragging the thumb it will expand its size.
  /// When stops dragging, it will return to its collapsed state.
  ///
  /// Defaults to `10.0`.
  final double expandedThumbRadius;

  /// The overlay drawn around the thumb.
  ///
  /// To disable this glow effect, set this value to `0.0`.
  ///
  /// Defaults to `25.0`.
  final double thumbGlowRadius;

  /// The color of the overlay drawn around the thumb. This is typically a semi-transparent color.
  final Color thumbGlowColor;

  /// The color of the bar in background.
  final Color backgroundBarColor;

  /// The color of the collapsed progress bar.
  final Color collapsedProgressBarColor;

  /// The color of the collapsed buffered bar.
  final Color collapsedBufferedBarColor;

  /// The color of the collapsed thumb.
  final Color collapsedThumbColor;

  /// The color of the expanded progress bar.
  ///
  /// If `null`, defaults to [collapsedProgressBarColor].
  final Color? expandedProgressBarColor;

  /// The color of the expanded buffered bar.
  ///
  /// If `null`, defaults to [collapsedBufferedBarColor].
  final Color? expandedBufferedBarColor;

  /// The color of the expanded thumb.
  ///
  /// If `null`, defaults to [collapsedThumbColor].
  final Color? expandedThumbColor;

  /// Whether colors should be linearly interpolated when transitioning
  /// from collapsed to expanded state and vice versa.
  ///
  /// Defaults to `true`.
  final bool lerpColorsTransition;

  /// Whether the buffered bar should be shown when collapsed.
  ///
  /// Defaults to `true`.
  final bool showBufferedWhenCollapsed;

  /// A callback that is called when the user taps or stops dragging.
  ///
  /// This value can be safely used to seek the media content.
  final ValueChanged<Duration> onSeek;

  /// A callback that is called when the user drags the thumb.
  ///
  /// This will be called repeatedly as the thumb position changes.
  ///
  /// Defaults to `null`.
  final ValueChanged<Duration>? onChanged;

  /// A callback that is called when the user starts dragging the thumb.
  ///
  /// Defaults to `null`.
  final ValueChanged<Duration>? onChangeStart;

  /// A callback that is called when the user stops dragging the thumb.
  ///
  /// Defaults to `null`.
  final ValueChanged<Duration>? onChangeEnd;

  /// The callback used to create a semantic value from a progress duration.
  ///
  /// Defaults to formatting values as a percentage.
  ///
  /// This is used by accessibility frameworks like TalkBack on Android to inform users what the
  /// currently selected value is with more context.
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
      expandedProgressBarColor: expandedProgressBarColor ?? collapsedProgressBarColor,
      expandedBufferedBarColor: expandedBufferedBarColor ?? collapsedBufferedBarColor,
      expandedThumbColor: expandedThumbColor ?? collapsedThumbColor,
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
      ..expandedProgressBarColor = expandedProgressBarColor ?? collapsedProgressBarColor
      ..expandedBufferedBarColor = expandedBufferedBarColor ?? collapsedBufferedBarColor
      ..expandedThumbColor = expandedThumbColor ?? collapsedThumbColor
      ..lerpColorsTransition = lerpColorsTransition
      ..showBufferedWhenCollapsed = showBufferedWhenCollapsed
      ..semanticsFormatter = semanticsFormatter;
  }
}
