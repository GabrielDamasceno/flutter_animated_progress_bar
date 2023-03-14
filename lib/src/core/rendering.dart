import 'dart:math';

import 'package:animated_progress_bar/src/core/alignment.dart';
import 'package:animated_progress_bar/src/core/controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RenderProgressBar extends RenderBox {
  final ValueChanged<Duration> onSeek;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeStart;
  final ValueChanged<Duration>? onChangeEnd;

  RenderProgressBar({
    required ProgressBarController controller,
    required Duration progress,
    Duration? buffered,
    required Duration total,
    required ProgressBarAlignment alignment,
    required double collapsedBarHeight,
    required double collapsedThumbRadius,
    required double expandedBarHeight,
    required double expandedThumbRadius,
    required Color backgroundBarColor,
    required Color expandedProgressBarColor,
    required Color expandedBufferedBarColor,
    required Color expandedThumbColor,
    required Color collapsedProgressBarColor,
    required Color collapsedBufferedBarColor,
    required Color collapsedThumbColor,
    required bool lerpColorsTransition,
    required bool showBufferedWhenCollapsed,
    required this.onSeek,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  })  : _controller = controller,
        _progress = progress,
        _buffered = buffered,
        _total = total,
        _alignment = alignment,
        _collapsedBarHeight = collapsedBarHeight,
        _collapsedThumbRadius = collapsedThumbRadius,
        _expandedBarHeight = expandedBarHeight,
        _expandedThumbRadius = expandedThumbRadius,
        _backgroundBarColor = backgroundBarColor,
        _expandedProgressBarColor = expandedProgressBarColor,
        _expandedBufferedBarColor = expandedBufferedBarColor,
        _expandedThumbColor = expandedThumbColor,
        _collapsedProgressBarColor = collapsedProgressBarColor,
        _collapsedBufferedBarColor = collapsedBufferedBarColor,
        _collapsedThumbColor = collapsedThumbColor,
        _lerpColorsTransition = lerpColorsTransition,
        _showBufferedWhenCollapsed = showBufferedWhenCollapsed {
    _horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..onStart = _onStartHorizontalRecognizer
      ..onEnd = _onEndHorizontalRecognizer
      ..onUpdate = _onUpdateHorizontalRecognizer;
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _onTapUpRecognizer;
  }

  late final HorizontalDragGestureRecognizer _horizontalDragGestureRecognizer;
  late final TapGestureRecognizer _tapGestureRecognizer;

  late bool _isDragging = false;
  late double _dxThumb = 0.0;
  late double _dyBar = 0.0;

  late ProgressBarController _controller;
  ProgressBarController get controller => _controller;
  set controller(ProgressBarController newValue) {
    if (_controller == newValue) return;

    _controller.removeListener(markNeedsLayout);
    _controller = newValue;
    _controller.addListener(markNeedsLayout);
    markNeedsLayout();
  }

  late Duration _progress;
  Duration get progress => _progress;
  set progress(Duration newValue) {
    if (_progress == newValue) return;

    _progress = newValue;
    markNeedsPaint();
  }

  late Duration? _buffered;
  Duration? get buffered => _buffered;
  set buffered(Duration? newValue) {
    if (_buffered == newValue) return;

    _buffered = newValue;
    markNeedsPaint();
  }

  late Duration _total;
  Duration get total => _total;
  set total(Duration newValue) {
    if (_total == newValue) return;

    _total = newValue;
    markNeedsPaint();
  }

  late ProgressBarAlignment _alignment;
  ProgressBarAlignment get alignment => _alignment;
  set alignment(ProgressBarAlignment newValue) {
    if (_alignment == newValue) return;

    _alignment = newValue;
    markNeedsLayout();
  }

  late double _collapsedBarHeight;
  double get collapsedBarHeight => _collapsedBarHeight;
  set collapsedBarHeight(double newValue) {
    if (_collapsedBarHeight == newValue) return;

    _collapsedBarHeight = newValue;
    markNeedsLayout();
  }

  late double _collapsedThumbRadius;
  double get collapsedThumbRadius => _collapsedThumbRadius;
  set collapsedThumbRadius(double newValue) {
    if (_collapsedThumbRadius == newValue) return;

    _collapsedThumbRadius = newValue;
    markNeedsLayout();
  }

  late double _expandedBarHeight;
  double get expandedBarHeight => _expandedBarHeight;
  set expandedBarHeight(double newValue) {
    if (_expandedBarHeight == newValue) return;

    _expandedBarHeight = newValue;
    markNeedsLayout();
  }

  late double _expandedThumbRadius;
  double get expandedThumbRadius => _expandedThumbRadius;
  set expandedThumbRadius(double newValue) {
    if (_expandedThumbRadius == newValue) return;

    _expandedThumbRadius = newValue;
    markNeedsLayout();
  }

  late Color _backgroundBarColor;
  Color get backgroundBarColor => _backgroundBarColor;
  set backgroundBarColor(Color newValue) {
    if (_backgroundBarColor == newValue) return;

    _backgroundBarColor = newValue;
    markNeedsPaint();
  }

  late Color _expandedProgressBarColor;
  Color get expandedProgressBarColor => _expandedProgressBarColor;
  set expandedProgressBarColor(Color newValue) {
    if (_expandedProgressBarColor == newValue) return;

    _expandedProgressBarColor = newValue;
    markNeedsPaint();
  }

  late Color _expandedBufferedBarColor;
  Color get expandedBufferedBarColor => _expandedBufferedBarColor;
  set expandedBufferedBarColor(Color newValue) {
    if (_expandedBufferedBarColor == newValue) return;

    _expandedBufferedBarColor = newValue;
    markNeedsPaint();
  }

  late Color _expandedThumbColor;
  Color get expandedThumbColor => _expandedThumbColor;
  set expandedThumbColor(Color newValue) {
    if (_expandedThumbColor == newValue) return;

    _expandedThumbColor = newValue;
    markNeedsPaint();
  }

  late Color _collapsedProgressBarColor;
  Color get collapsedProgressBarColor => _collapsedProgressBarColor;
  set collapsedProgressBarColor(Color newValue) {
    if (_collapsedProgressBarColor == newValue) return;

    _collapsedProgressBarColor = newValue;
    markNeedsPaint();
  }

  late Color _collapsedBufferedBarColor;
  Color get collapsedBufferedBarColor => _collapsedBufferedBarColor;
  set collapsedBufferedBarColor(Color newValue) {
    if (_collapsedBufferedBarColor == newValue) return;

    _collapsedBufferedBarColor = newValue;
    markNeedsPaint();
  }

  late Color _collapsedThumbColor;
  Color get collapsedThumbColor => _collapsedThumbColor;
  set collapsedThumbColor(Color newValue) {
    if (_collapsedThumbColor == newValue) return;

    _collapsedThumbColor = newValue;
    markNeedsPaint();
  }

  late bool _lerpColorsTransition;
  bool get lerpColorsTransition => _lerpColorsTransition;
  set lerpColorsTransition(bool newValue) {
    if (_lerpColorsTransition == newValue) return;

    _lerpColorsTransition = newValue;
    markNeedsPaint();
  }

  late bool _showBufferedWhenCollapsed;
  bool get showBufferedWhenCollapsed => _showBufferedWhenCollapsed;
  set showBufferedWhenCollapsed(bool newValue) {
    if (_showBufferedWhenCollapsed == newValue) return;

    _showBufferedWhenCollapsed = newValue;
    markNeedsPaint();
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _controller.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _controller.removeListener(markNeedsLayout);
    super.detach();
  }

  void _onStartHorizontalRecognizer(DragStartDetails details) {
    _isDragging = true;

    final double localPosition = _clampLocalPosition(details.localPosition.dx);
    _dxThumb = localPosition;

    _controller.expandBar();
    _controller.expandThumb();

    onChangeStart?.call(_positionToDuration(_dxThumb));

    markNeedsPaint();
  }

  void _onUpdateHorizontalRecognizer(DragUpdateDetails details) {
    final double localPosition = _clampLocalPosition(details.localPosition.dx);
    _dxThumb = localPosition;

    onChanged?.call(_positionToDuration(_dxThumb));

    markNeedsPaint();
  }

  void _onEndHorizontalRecognizer(DragEndDetails details) {
    _isDragging = false;
    _progress = _positionToDuration(_dxThumb);

    _controller.forward();
    _controller.collapseThumb();

    onChangeEnd?.call(_progress);
    onSeek.call(_progress);

    markNeedsPaint();
  }

  void _onTapUpRecognizer(TapUpDetails details) {
    final double localPosition = _clampLocalPosition(details.localPosition.dx);
    _progress = _positionToDuration(localPosition);

    _controller.forward();

    onChanged?.call(_progress);
    onSeek.call(_progress);

    markNeedsPaint();
  }

  double _clampLocalPosition(double localPosition) {
    return clampDouble(localPosition, 0.0, size.width);
  }

  @override
  bool get sizedByParent => true;

  @override
  bool get isRepaintBoundary => true;

  late double _effectiveThumbRadius;
  late double _effectiveBarHeight;

  static const double _minPreferredHeight = 24.0;

  // This value is the touch target, 24, multiplied by 3.
  static const double _minPreferredWidth = 72;

  @override
  double computeMinIntrinsicWidth(double height) => _minPreferredWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _minPreferredWidth;

  @override
  double computeMinIntrinsicHeight(double width) => _minPreferredHeight;

  @override
  double computeMaxIntrinsicHeight(double width) => _minPreferredHeight;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerDownEvent) {
      _horizontalDragGestureRecognizer.addPointer(event);
      _tapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void performLayout() {
    _computeEffectiveSizes();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final Size desiredSize = _computeDesiredSize();
    return constraints.constrain(desiredSize);
  }

  void _computeEffectiveSizes() {
    final double thumbDelta = (_expandedThumbRadius - _collapsedThumbRadius).abs();
    final double barDelta = (_expandedBarHeight - _collapsedBarHeight).abs();
    _effectiveThumbRadius =
        (_collapsedThumbRadius * _controller.barValue) + (thumbDelta * _controller.thumbValue);
    _effectiveBarHeight = (barDelta * _controller.barValue) + collapsedBarHeight;
  }

  Size _computeDesiredSize() {
    final double thumbDiameter = _expandedThumbRadius * 2;
    final double maxHeight = max(_expandedBarHeight, thumbDiameter);

    return Size(
      (constraints.hasBoundedWidth) ? constraints.maxWidth : _minPreferredWidth,
      max(maxHeight, _minPreferredHeight),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _dyBar = _computeDyBar();

    final Paint backgroundBarPaint = Paint()..color = backgroundBarColor;

    final Paint bufferedBarPaint = Paint()
      ..color = _transformColor(
        _expandedBufferedBarColor,
        _collapsedBufferedBarColor,
        _controller.barValue,
      );

    final Paint progressBarPaint = Paint()
      ..color = _transformColor(
        _expandedProgressBarColor,
        _collapsedProgressBarColor,
        _controller.barValue,
      );

    final Paint thumbPaint = Paint()
      ..color = _transformColor(
        _expandedThumbColor,
        _collapsedThumbColor,
        _controller.thumbValue,
      );

    final RRect backgroundRRect = _barRRect(width: size.width);
    final RRect progressRRect = _barRRect(width: _durationToPosition(_progress, _total));

    late final RRect bufferedRRect;

    if (_buffered != null) {
      if (!showBufferedWhenCollapsed && _controller.barValue == 0.0) {
        bufferedRRect = RRect.zero;
      } else {
        bufferedRRect = _barRRect(width: _durationToPosition(_buffered!, _total));
      }
    } else {
      bufferedRRect = RRect.zero;
    }

    context.canvas
      ..drawRRect(backgroundRRect, backgroundBarPaint)
      ..drawRRect(bufferedRRect, bufferedBarPaint)
      ..drawRRect(progressRRect, progressBarPaint)
      ..drawPath(_thumbPath(), thumbPaint);
  }

  RRect _barRRect({required double width}) {
    final Rect rect = Rect.fromLTWH(0.0, _dyBar, width, _effectiveBarHeight);
    final Radius radius = Radius.circular(_effectiveThumbRadius);
    late final double dx;

    if (_isDragging) {
      dx = _dxThumb;
    } else {
      dx = _durationToPosition(progress, total);
    }

    if ((dx - _effectiveThumbRadius) <= 0) {
      return RRect.fromRectAndCorners(rect, topLeft: radius, bottomLeft: radius);
    } else if ((dx + _effectiveThumbRadius) >= size.width) {
      return RRect.fromRectAndCorners(rect, topRight: radius, bottomRight: radius);
    }

    return RRect.fromRectAndCorners(rect);
  }

  Path _thumbPath() {
    final double dy = _dyBar + _effectiveBarHeight / 2;
    final double dxCampled = clampDouble(
      (_isDragging) ? _dxThumb : _durationToPosition(_progress, total),
      _effectiveThumbRadius,
      size.width - _effectiveThumbRadius,
    );

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(dxCampled, dy),
          radius: _effectiveThumbRadius,
        ),
      );
  }

  Color _transformColor(Color expanded, Color collapsed, double value) {
    late final double t;

    if (lerpColorsTransition) {
      t = value;
    } else {
      if (value > 0.0) {
        t = 1.0;
      } else {
        t = 0.0;
      }
    }

    return Color.lerp(collapsed, expanded, t) ?? expanded;
  }

  double _computeDyBar() {
    late final double dy;
    final double thumbDiameter = _effectiveThumbRadius * 2;

    switch (_alignment) {
      case ProgressBarAlignment.center:
        dy = (size.height / 2) - (_effectiveBarHeight / 2);
        break;
      case ProgressBarAlignment.bottom:
        if (thumbDiameter > _effectiveBarHeight) {
          dy =
              size.height - _effectiveBarHeight - (_effectiveThumbRadius - _effectiveBarHeight / 2);
        } else {
          dy = size.height - _effectiveBarHeight;
        }
        break;
      default:
        dy = (size.height / 2) - (_effectiveBarHeight / 2);
    }

    return dy;
  }

  double _durationToPosition(Duration progress, Duration total) {
    final double value = progress.inMicroseconds / total.inMicroseconds;
    return clampDouble(value * size.width, 0.0, size.width);
  }

  Duration _positionToDuration(double position) {
    return Duration(microseconds: ((position / size.width) * _total.inMicroseconds).round());
  }

  @override
  void dispose() {
    _horizontalDragGestureRecognizer.dispose();
    _tapGestureRecognizer.dispose();

    super.dispose();
  }
}
