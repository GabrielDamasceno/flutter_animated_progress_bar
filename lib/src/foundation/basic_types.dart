import 'package:flutter/rendering.dart';

/// Signature for a semantics callback that formats a numeric value from [ProgressBar] widget.
typedef SemanticsFormatter = String Function(double value);

typedef DurationFormatter = String Function(Duration duration);
typedef PaintThumbComponents = void Function(
  PaintingContext context,
  Offset offset,
);
