import 'package:flutter/material.dart';
import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter_animated_progress_bar/src/rendering/render_thumb_components.dart';
import 'package:flutter_animated_progress_bar/src/widgets/progress_bar.dart';

class RenderThumbComponentsWidget extends LeafRenderObjectWidget {
  const RenderThumbComponentsWidget({
    super.key,
    required this.controller,
    required this.progressBarState,
  });

  final ProgressBarController controller;
  final ProgressBarState progressBarState;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderThumbComponents(
      controller: controller,
      progressBarState: progressBarState,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderThumbComponents renderObject,
  ) {
    renderObject
      ..controller = controller
      ..progressBarState = progressBarState;
  }
}
