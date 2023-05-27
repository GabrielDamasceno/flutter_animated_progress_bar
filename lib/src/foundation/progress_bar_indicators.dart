import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter_animated_progress_bar/src/foundation/basic_types.dart';
import 'package:flutter_animated_progress_bar/src/utils/formatters.dart';

/// Base class for progress bar indicators.
/// Create a subclass of this if you would like a custom indicator.
abstract class ProgressBarIndicator {
  /// This abstract const constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ProgressBarIndicator();

  void paint(
    PaintingContext context, {
    required ProgressBarController controller,
    required Size size,
    required Offset position,
    required double thumbRadius,
    required double barHeight,
    required Duration progress,
    required Duration total,
    required TextPainter textPainter,
  });

  /// Instance of [ProgressBarIndicator] to disable indicator drawing.
  static const ProgressBarIndicator none = _NoProgressIndicator();
}

class _NoProgressIndicator extends ProgressBarIndicator {
  const _NoProgressIndicator();

  @override
  void paint(
    PaintingContext context, {
    required ProgressBarController controller,
    required Size size,
    required Offset position,
    required double thumbRadius,
    required double barHeight,
    required Duration progress,
    required Duration total,
    required TextPainter textPainter,
  }) {
    /// Do nothing;
  }
}

/// The default progress bar indicator of a [ProgressBar].
class RoundedRectangularProgressBarIndicator extends ProgressBarIndicator {
  /// Create a indicator that resembles a rounded rectangular tooltip.
  const RoundedRectangularProgressBarIndicator({
    this.padding = const EdgeInsets.all(8.0),
    this.curve = Curves.fastOutSlowIn,
    this.borderRadius = const Radius.circular(4.0),
    this.elevation = 1.0,
    this.backgroundColor = Colors.red,
    this.style,
    this.durationFormatter,
  });

  final EdgeInsets padding;
  final Curve curve;
  final Radius borderRadius;
  final double elevation;
  final Color backgroundColor;
  final TextStyle? style;
  final DurationFormatter? durationFormatter;

  @override
  void paint(
    PaintingContext context, {
    required ProgressBarController controller,
    required Size size,
    required Offset position,
    required double thumbRadius,
    required double barHeight,
    required Duration progress,
    required Duration total,
    required TextPainter textPainter,
  }) {
    const double triangleWidth = 8.0;
    const double triangleHeight = 12.0;
    const double insets = 5.0;

    final Duration thumbProgress = Duration(
      microseconds: ((position.dx / size.width) * total.inMicroseconds).round(),
    );

    textPainter
      ..text = TextSpan(
        text: durationFormatter?.call(thumbProgress) ??
            Formatters.formatDuration(thumbProgress),
        style: style ?? const TextStyle(height: 1.0),
      )
      ..textDirection = TextDirection.ltr
      ..layout();

    final double width = padding.horizontal + textPainter.width;
    final double height = padding.vertical + textPainter.height;
    final double maxHeight = max(thumbRadius * 2, barHeight);
    final double dyAnchor = position.dy - (maxHeight / 2) - insets;

    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..color = backgroundColor;

    final Offset triangleStart = Offset(
      clampDouble(
        position.dx,
        thumbRadius,
        size.width - thumbRadius,
      ),
      dyAnchor,
    );
    final Path trianglePath = Path()
      ..moveTo(triangleStart.dx, triangleStart.dy)
      ..relativeLineTo(-triangleWidth / 2, -triangleHeight)
      ..relativeLineTo(triangleWidth, 0.0)
      ..close();

    final Offset rectCenter = Offset(
      clampDouble(position.dx, width / 2, size.width - width / 2),
      dyAnchor - triangleHeight - (height / 2),
    );
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: rectCenter,
        width: width,
        height: height,
      ),
      borderRadius,
    );

    final double curvedValue = curve.transform(controller.barValue);
    final Matrix4 scaleTransformation = Matrix4.identity()
      ..translate(position.dx, dyAnchor)
      ..scale(curvedValue)
      ..translate(-position.dx, -dyAnchor);

    final Offset textCenter = rectCenter.translate(
      -textPainter.width / 2,
      -textPainter.height / 2,
    );

    final Path shadowPath = Path.combine(
      PathOperation.union,
      trianglePath,
      Path()..addRRect(rRect),
    );

    canvas.save();
    canvas.transform(scaleTransformation.storage);

    if (elevation > 0) {
      canvas.drawShadow(
        shadowPath,
        const Color(0xFF000000),
        elevation,
        true,
      );
    }

    canvas.drawPath(trianglePath, paint);
    canvas.drawRRect(rRect, paint);
    textPainter.paint(canvas, textCenter);
    canvas.restore();
  }
}

/// A indicator that resembles a circular tooltip.
class CircularProgressBarIndicator extends ProgressBarIndicator {
  /// Create a indicator that resembles a circular tooltip.
  const CircularProgressBarIndicator({
    this.padding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.curve = Curves.fastOutSlowIn,
    this.elevation = 1.0,
    this.backgroundColor = Colors.red,
    this.style,
    this.durationFormatter,
  });

  final EdgeInsets padding;
  final Curve curve;
  final double elevation;
  final Color backgroundColor;
  final TextStyle? style;
  final DurationFormatter? durationFormatter;

  @override
  void paint(
    PaintingContext context, {
    required ProgressBarController controller,
    required Size size,
    required Offset position,
    required double thumbRadius,
    required double barHeight,
    required Duration progress,
    required Duration total,
    required TextPainter textPainter,
  }) {
    const double insets = 5.0;

    final Duration thumbProgress = Duration(
      microseconds: ((position.dx / size.width) * total.inMicroseconds).round(),
    );

    textPainter
      ..text = TextSpan(
        text: durationFormatter?.call(thumbProgress) ??
            Formatters.formatDuration(thumbProgress),
        style: style ?? const TextStyle(fontSize: 12.0, height: 1.0),
      )
      ..textDirection = TextDirection.ltr
      ..layout();

    final double radius = (padding.horizontal + textPainter.width) / 2;
    final double maxHeight = max(thumbRadius * 2, barHeight);
    final double dyAnchor = position.dy - (maxHeight / 2) - insets;
    final double neckHeight = radius;
    final double neckWidth = radius * 0.8;

    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..color = backgroundColor;

    final Offset neckStart = Offset(
      clampDouble(
        position.dx,
        thumbRadius,
        size.width - thumbRadius,
      ),
      dyAnchor,
    );

    double leftDelta = 0.0;
    double rightDelta = 0.0;
    final double maxShift = max(thumbRadius, radius);

    if (position.dx <= maxShift) {
      leftDelta = maxShift - position.dx;
    } else if ((size.width - position.dx) <= maxShift) {
      rightDelta = maxShift - (size.width - position.dx);
    }

    final Path neckPath = Path()
      ..moveTo(neckStart.dx, neckStart.dy)
      ..relativeQuadraticBezierTo(
        0.0,
        -(neckHeight + leftDelta) / 2,
        -neckWidth / 2,
        -neckHeight - leftDelta,
      )
      ..relativeLineTo(
        neckWidth,
        leftDelta - rightDelta,
      )
      ..relativeQuadraticBezierTo(
        -neckWidth / 2,
        (neckHeight + rightDelta) / 2,
        -neckWidth / 2,
        neckHeight + rightDelta,
      );

    final Offset ovalCenter = Offset(
      clampDouble(position.dx, radius, size.width - radius),
      dyAnchor - neckHeight - radius + (neckHeight * 0.2),
    );

    final Path ovalPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: ovalCenter,
          radius: radius,
        ),
      );

    final double curvedValue = curve.transform(controller.barValue);
    final Matrix4 scaleTransformation = Matrix4.identity()
      ..translate(position.dx, dyAnchor)
      ..scale(curvedValue)
      ..translate(-position.dx, -dyAnchor);

    final Offset textCenter = ovalCenter.translate(
      -textPainter.width / 2,
      -textPainter.height / 2,
    );

    final Path shadowPath = Path.combine(
      PathOperation.union,
      neckPath,
      ovalPath,
    );

    canvas.save();
    canvas.transform(scaleTransformation.storage);

    if (elevation > 0) {
      canvas.drawShadow(
        shadowPath,
        const Color(0xFF000000),
        elevation,
        true,
      );
    }

    canvas.drawPath(neckPath, paint);
    canvas.drawPath(ovalPath, paint);
    textPainter.paint(canvas, textCenter);
    canvas.restore();
  }
}
