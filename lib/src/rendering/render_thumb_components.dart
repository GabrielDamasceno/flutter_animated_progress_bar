import 'package:flutter/rendering.dart';
import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter_animated_progress_bar/src/widgets/progress_bar.dart';

class RenderThumbComponents extends RenderBox {
  RenderThumbComponents({
    required ProgressBarController controller,
    required ProgressBarState progressBarState,
  })  : _controller = controller,
        _progressBarState = progressBarState;

  late ProgressBarController _controller;
  ProgressBarController get controller => _controller;
  set controller(ProgressBarController newValue) {
    if (_controller == newValue) return;

    if (attached) _controller.removeListener(_controllerListener);
    _controller = newValue;
    if (attached) _controller.addListener(_controllerListener);
    markNeedsLayout();
  }

  late ProgressBarState _progressBarState;
  ProgressBarState get progressBarState => _progressBarState;
  set progressBarState(ProgressBarState newValue) {
    if (_progressBarState == newValue) return;

    if (attached) {
      _progressBarState.positionNotifier.removeListener(markNeedsPaint);
    }
    _progressBarState = newValue;
    if (attached) {
      _progressBarState.positionNotifier.addListener(markNeedsPaint);
    }
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller.addListener(_controllerListener);
    _progressBarState.positionNotifier.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _controller.removeListener(_controllerListener);
    _progressBarState.positionNotifier.removeListener(markNeedsPaint);
    super.detach();
  }

  void _controllerListener() {
    if (_controller.barValue == 0.0) {
      _progressBarState.overlayEntry?.remove();
      _progressBarState.overlayEntry = null;
    }
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _progressBarState.paintThumbComponents?.call(context, offset);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.smallest;
}
