import 'package:flutter/rendering.dart';

/// Signature for a semantics callback that formats a numeric value from [ProgressBar] widget.
typedef SemanticsFormatter = String Function(double value);

/// Signature for a duration callback that formats a duration from [ProgressBar] widget.
typedef DurationFormatter = String Function(Duration duration);

/// Signature for a paint callback that paints thumb components from [ProgressBar] widget.
typedef PaintThumbComponents = void Function(
  PaintingContext context,
  Offset offset,
);
