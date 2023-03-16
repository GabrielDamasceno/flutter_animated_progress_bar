import 'dart:math';

import 'package:animated_progress_bar/src/foundation/basic_types.dart';
import 'package:animated_progress_bar/src/foundation/controller.dart';
import 'package:animated_progress_bar/src/foundation/enums.dart';
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
    required BarCapShape barCapShape,
    required double collapsedBarHeight,
    required double collapsedThumbRadius,
    required double expandedBarHeight,
    required double expandedThumbRadius,
    required double thumbGlowRadius,
    required Color thumbGlowColor,
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
    SemanticsFormatter? semanticsFormatter,
  })  : _controller = controller,
        _progress = progress,
        _buffered = buffered,
        _total = total,
        _alignment = alignment,
        _barCapShape = barCapShape,
        _collapsedBarHeight = collapsedBarHeight,
        _collapsedThumbRadius = collapsedThumbRadius,
        _expandedBarHeight = expandedBarHeight,
        _expandedThumbRadius = expandedThumbRadius,
        _backgroundBarColor = backgroundBarColor,
        _expandedProgressBarColor = expandedProgressBarColor,
        _expandedBufferedBarColor = expandedBufferedBarColor,
        _expandedThumbColor = expandedThumbColor,
        _thumbGlowRadius = thumbGlowRadius,
        _thumbGlowColor = thumbGlowColor,
        _collapsedProgressBarColor = collapsedProgressBarColor,
        _collapsedBufferedBarColor = collapsedBufferedBarColor,
        _collapsedThumbColor = collapsedThumbColor,
        _lerpColorsTransition = lerpColorsTransition,
        _showBufferedWhenCollapsed = showBufferedWhenCollapsed,
        _semanticsFormatter = semanticsFormatter {
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

  late BarCapShape _barCapShape;
  BarCapShape get barCapShape => _barCapShape;
  set barCapShape(BarCapShape newValue) {
    if (_barCapShape == newValue) return;

    _barCapShape = newValue;
    markNeedsPaint();
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

  late double _thumbGlowRadius;
  double get thumbGlowRadius => _thumbGlowRadius;
  set thumbGlowRadius(double newValue) {
    if (_thumbGlowRadius == newValue) return;

    _thumbGlowRadius = newValue;
    markNeedsPaint();
  }

  late Color _thumbGlowColor;
  Color get thumbGlowColor => _thumbGlowColor;
  set thumbGlowColor(Color newValue) {
    if (_thumbGlowColor == newValue) return;

    _thumbGlowColor = newValue;
    markNeedsPaint();
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

  late SemanticsFormatter? _semanticsFormatter;
  SemanticsFormatter? get semanticsFormatter => _semanticsFormatter;
  set semanticsFormatter(SemanticsFormatter? newValue) {
    if (_semanticsFormatter == newValue) return;

    _semanticsFormatter = newValue;
    markNeedsSemanticsUpdate();
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties
      ..add(StringProperty('controller', controller.toString()))
      ..add(IntProperty('progress', _progress.inMilliseconds, unit: 'ms'))
      ..add(IntProperty('buffered', _buffered?.inMilliseconds, unit: 'ms', ifNull: 'disabled'))
      ..add(IntProperty('total', _total.inMilliseconds, unit: 'ms'))
      ..add(EnumProperty('alignment', _alignment))
      ..add(EnumProperty('barCapShape', _barCapShape))
      ..add(DoubleProperty('collapsedBarHeight', _collapsedBarHeight))
      ..add(DoubleProperty('collapsedThumbRadius', _collapsedThumbRadius))
      ..add(DoubleProperty('expandedBarHeight', _expandedBarHeight))
      ..add(DoubleProperty('expandedThumbRadius', _expandedThumbRadius))
      ..add(DoubleProperty('thumbGlowRadius', _thumbGlowRadius))
      ..add(ColorProperty('thumbGlowColor', _thumbGlowColor))
      ..add(ColorProperty('backgroundBarColor', _backgroundBarColor))
      ..add(ColorProperty('expandedProgressBarColor', _expandedProgressBarColor))
      ..add(ColorProperty('expandedBufferedBarColor', _expandedBufferedBarColor))
      ..add(ColorProperty('expandedThumbColor', _expandedThumbColor))
      ..add(ColorProperty('collapsedProgressBarColor', _collapsedProgressBarColor))
      ..add(ColorProperty('collapsedBufferedBarColor', _collapsedBufferedBarColor))
      ..add(ColorProperty('collapsedThumbColor', _collapsedThumbColor))
      ..add(DiagnosticsProperty<bool>('lerpColorsTransition', _lerpColorsTransition))
      ..add(DiagnosticsProperty<bool>('showBufferedWhenCollapsed', _showBufferedWhenCollapsed))
      ..add(
        ObjectFlagProperty<ValueChanged<Duration>>(
          'onSeek',
          onSeek,
          showName: true,
          ifPresent: 'enabled',
          ifNull: 'disabled',
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<Duration>>(
          'onChanged',
          onChanged,
          showName: true,
          ifPresent: 'enabled',
          ifNull: 'disabled',
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<Duration>>(
          'onChangeStart',
          onChangeStart,
          showName: true,
          ifPresent: 'enabled',
          ifNull: 'disabled',
        ),
      )
      ..add(
        ObjectFlagProperty<ValueChanged<Duration>>(
          'onChangeEnd',
          onChangeEnd,
          showName: true,
          ifPresent: 'enabled',
          ifNull: 'disabled',
        ),
      );
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config
      ..textDirection = TextDirection.ltr
      ..label = 'Progress bar'
      ..onIncrease = _increaseAction
      ..onDecrease = _decreaseAction;

    if (_semanticsFormatter != null) {
      config
        ..value = _semanticsFormatter!(_progressValue(_progress, _total))
        ..increasedValue = semanticsFormatter!(
          clampDouble(_progressValue(_progress, _total) + _semanticsActionUnit, 0.0, 1.0),
        )
        ..decreasedValue = semanticsFormatter!(
          clampDouble(_progressValue(_progress, _total) - _semanticsActionUnit, 0.0, 1.0),
        );
    } else {
      config
        ..value = '${(_progressValue(_progress, _total) * 100).round()}%'
        ..increasedValue =
            '${(clampDouble(_progressValue(_progress, _total) + _semanticsActionUnit, 0.0, 1.0) * 100).round()}%'
        ..decreasedValue =
            '${(clampDouble(_progressValue(_progress, _total) - _semanticsActionUnit, 0.0, 1.0) * 100).round()}%';
    }
  }

  void _increaseAction() {
    final double value = clampDouble(
      _progressValue(_progress, _total) + _semanticsActionUnit,
      0.0,
      1.0,
    );

    _progress = Duration(microseconds: (value * _total.inMicroseconds).round());

    onChanged?.call(_progress);
    onSeek.call(_progress);

    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void _decreaseAction() {
    final double value = clampDouble(
      _progressValue(_progress, _total) - _semanticsActionUnit,
      0.0,
      1.0,
    );

    _progress = Duration(microseconds: (value * _total.inMicroseconds).round());

    onChanged?.call(_progress);
    onSeek.call(_progress);

    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Matches Android implementation of material slider.
  static const double _semanticsActionUnit = 0.05;

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
    if (!_isDragging) _dxThumb = _durationToPosition(_progress, total);
    _dyBar = _computeDyBar();

    _drawBackground(context.canvas);
    _drawBuffered(context.canvas);
    _drawProgress(context.canvas);
    _drawThumb(context.canvas);
  }

  void _drawBackground(Canvas canvas) {
    final Paint backgroundBarPaint = Paint()..color = backgroundBarColor;
    final RRect backgroundRRect = _barRRect(width: size.width);

    canvas.drawRRect(backgroundRRect, backgroundBarPaint);
  }

  void _drawBuffered(Canvas canvas) {
    final Paint bufferedBarPaint = Paint()
      ..color = _transformColor(
        _expandedBufferedBarColor,
        _collapsedBufferedBarColor,
        _controller.barValue,
      );

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

    canvas.drawRRect(bufferedRRect, bufferedBarPaint);
  }

  void _drawProgress(Canvas canvas) {
    final Paint progressBarPaint = Paint()
      ..color = _transformColor(
        _expandedProgressBarColor,
        _collapsedProgressBarColor,
        _controller.barValue,
      );

    final RRect progressRRect = _barRRect(width: _durationToPosition(_progress, _total));

    canvas.drawRRect(progressRRect, progressBarPaint);
  }

  RRect _barRRect({required double width}) {
    final Rect rect = Rect.fromLTWH(0.0, _dyBar, width, _effectiveBarHeight);
    late final Radius radius;

    if (_barCapShape == BarCapShape.round) {
      radius = Radius.circular(_effectiveBarHeight / 2);
      return RRect.fromRectAndRadius(rect, radius);
    } else {
      radius = Radius.circular(_effectiveThumbRadius);
      if ((_dxThumb - _effectiveThumbRadius) <= 0) {
        return RRect.fromRectAndCorners(rect, topLeft: radius, bottomLeft: radius);
      } else if ((_dxThumb + _effectiveThumbRadius) >= size.width) {
        return RRect.fromRectAndCorners(rect, topRight: radius, bottomRight: radius);
      }
      return RRect.fromRectAndCorners(rect);
    }
  }

  void _drawThumb(Canvas canvas) {
    final Paint thumbGlowPaint = Paint()..color = _thumbGlowColor;
    final Paint thumbPaint = Paint()
      ..color = _transformColor(
        _expandedThumbColor,
        _collapsedThumbColor,
        _controller.thumbValue,
      );

    final double dy = _dyBar + _effectiveBarHeight / 2;
    final double dx = clampDouble(
      _dxThumb,
      _effectiveThumbRadius,
      size.width - _effectiveThumbRadius,
    );
    final Offset offset = Offset(dx, dy);

    if (_isDragging && _thumbGlowRadius > 0.0) {
      canvas.drawCircle(offset, _thumbGlowRadius * _controller.thumbValue, thumbGlowPaint);
    }

    canvas.drawCircle(offset, _effectiveThumbRadius, thumbPaint);
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

  double _progressValue(Duration progress, Duration total) {
    return progress.inMicroseconds / total.inMicroseconds;
  }

  double _durationToPosition(Duration progress, Duration total) {
    final double value = _progressValue(progress, total);
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
