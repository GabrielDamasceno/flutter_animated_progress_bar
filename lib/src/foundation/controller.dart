import 'package:flutter_animated_progress_bar/src/foundation/simulations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

/// A controller for [ProgressBar] animation.
///
/// This class lets you:
///
/// * Animate bar with [expandBar] and [collapseBar].
/// * Animate thumb with [expandThumb] and [collapseThumb].
/// * Stop an animation with [stopBarAnimation] and [stopThumbAnimation].
/// * Set the bar or thumb animation to a specific [value].
///
/// By default, a [ProgressBarController] linearly produces values that range
/// from 0.0 to 1.0, during a given duration.
///
/// ## Ticker providers
///
/// Similar to [AnimationController], a [ProgressBarController] needs a [TickerProvider],
/// which is configured using the `vsync` argument on the constructor. Since there are two animations
/// (bar and thumb) that are animated independently, the controller uses two [Ticker]s.
/// Because of that the client must use [TickerProviderStateMixin] to implement the
/// [TickerProvider] interface if [ProgressBarController] is being created from a [State].
///
/// ## Life cycle
///
/// A [ProgressBarController] should be [dispose]d when it is no longer needed.
/// When used with a [StatefulWidget], it is common for a [ProgressBarController] to be created
/// in the [State.initState] method and then disposed in the [State.dispose] method.
///
/// ## Using [Future]s with [ProgressBarController]
///
/// The methods that start animations return a [TickerFuture] object which
/// completes when the animation completes successfully.
///
/// Here is a stateful `Foo` widget. Its [State] uses the
/// [TickerProviderStateMixin] to implement the necessary
/// [TickerProvider], creating its controller in the [State.initState] method
/// and disposing of it in the [State.dispose] method.
///
/// ```dart
/// class Foo extends StatefulWidget {
///   const Foo({ super.key });
///
///   @override
///   State<Foo> createState() => _FooState();
/// }
///
/// class _FooState extends State<Foo> with TickerProviderStateMixin {
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
///     return Container(); // ...
///   }
/// }
/// ```

class ProgressBarController extends ChangeNotifier {
  /// Creates a [ProgressBarController].
  ///
  /// * `vsync` is the [TickerProvider] for the current context. It is required and must not be null.
  ///
  /// * [barAnimationDuration] is the length of time this bar animation should last.
  ///
  /// * [thumbAnimationDuration] is the length of time this thumb animation should last.
  ///
  /// * [waitingDuration] is the length of time this bar animation should remain expanded before collapse.
  /// This takes effect when the user stops dragging, the bar animation will "wait" and then collapse
  /// if there are no more gesture interactions. Used by [forward] method.
  ProgressBarController({
    required TickerProvider vsync,
    this.barAnimationDuration = const Duration(milliseconds: 200),
    this.thumbAnimationDuration = const Duration(milliseconds: 100),
    this.waitingDuration = const Duration(seconds: 2),
  }) {
    _thumbTicker = vsync.createTicker(_onThumbTick);
    _barTicker = vsync.createTicker(_onBarTick);
    _barValue = 0.0;
    _thumbValue = 0.0;
  }

  /// The length of time this bar animation should last.
  ///
  /// For example, if [expandBar] is called when [barValue] is equal to 0.0, the bar will expand towards
  /// 1.0 for the length of this time. If [barValue] is greater than 0.0, the behavior will be the same,
  /// but for a fraction of this time relative to remaining value. The logic is the same for [collapseBar].
  final Duration barAnimationDuration;

  /// The length of time this thumb animation should last.
  ///
  /// For example, if [expandThumb] is called when [thumbValue] is equal to 0.0, the thumb will expand towards
  /// 1.0 for the length of this time. If [thumbValue] is greater than 0.0, the behavior will be the same,
  /// but for a fraction of this time relative to remaining value. The logic is the same for [collapseThumb].
  final Duration thumbAnimationDuration;

  /// The length of time this bar animation should remain expanded before collapse.
  final Duration waitingDuration;

  /// The current bar value of the animation.
  ///
  /// Setting this value notifies all the listeners that the value changed.
  ///
  /// Setting this value also stops the bar animation if it is currently running.
  double get barValue => _barValue;
  late double _barValue;

  /// Stops the bar animation and sets the current bar value of the animation.
  ///
  /// The new value is clamped in the range of 0.0 and 1.0.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  set barValue(double value) {
    final double newValue = clampDouble(value, 0.0, 1.0);
    if (_barValue == newValue) return;

    stopBarAnimation();
    _barValue = newValue;
    notifyListeners();
  }

  /// The current thumb value of the animation.
  ///
  /// Setting this value notifies all the listeners that the value changed.
  ///
  /// Setting this value also stops the thumb animation if it is currently running.
  double get thumbValue => _thumbValue;
  late double _thumbValue;

  /// Stops the thumb animation and sets the current thumb value of the animation.
  ///
  /// The new value is clamped in the range of 0.0 and 1.0.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  set thumbValue(double value) {
    final double newValue = clampDouble(value, 0.0, 1.0);
    if (_thumbValue == newValue) return;

    stopThumbAnimation();
    _thumbValue = newValue;
    notifyListeners();
  }

  late final Ticker _thumbTicker;
  late final Ticker _barTicker;

  Simulation? _barSimulation;
  Simulation? _thumbSimulation;

  void _onTick({
    required Duration elapsed,
    required Simulation? simulation,
    required void Function(double value) onValueUpdate,
    required VoidCallback onDone,
  }) {
    if (simulation == null) return;

    final double elapsedInMicroseconds = elapsed.inMicroseconds.toDouble();
    onValueUpdate.call(simulation.x(elapsedInMicroseconds));

    if (simulation.isDone(elapsedInMicroseconds)) {
      onDone.call();
    }

    notifyListeners();
  }

  void _onBarTick(Duration elapsed) {
    _onTick(
      elapsed: elapsed,
      simulation: _barSimulation,
      onValueUpdate: (value) => _barValue = value,
      onDone: () => stopBarAnimation(canceled: false),
    );
  }

  void _onThumbTick(Duration elapsed) {
    _onTick(
      elapsed: elapsed,
      simulation: _thumbSimulation,
      onValueUpdate: (value) => _thumbValue = value,
      onDone: () => stopThumbAnimation(canceled: false),
    );
  }

  /// Starts running this bar animation. It will expand, wait and then collapse bar.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture forward() {
    stopBarAnimation();

    _barSimulation = CombinedSimulation(
      simulations: [
        InterpolationSimulation(
          begin: _barValue,
          end: 1.0,
          totalDuration: _computeSimulationDuration(0.0, 1.0, _barValue, barAnimationDuration),
        ),
        InterpolationSimulation(
          begin: 1.0,
          end: 1.0,
          totalDuration: waitingDuration,
        ),
        InterpolationSimulation(
          begin: 1.0,
          end: 0.0,
          totalDuration: barAnimationDuration,
        ),
      ],
    );

    return _barTicker.start();
  }

  /// Starts running this bar animation towards `1.0`, expanding the bar.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture expandBar() {
    const double begin = 0.0;
    const double end = 1.0;

    stopBarAnimation();
    if (_barValue == end) return TickerFuture.complete();

    _barSimulation = InterpolationSimulation(
      begin: _barValue,
      end: end,
      totalDuration: _computeSimulationDuration(begin, end, _barValue, barAnimationDuration),
    );

    return _barTicker.start();
  }

  /// Starts running this bar animation towards `0.0`, collapsing the bar.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture collapseBar() {
    const double begin = 1.0;
    const double end = 0.0;

    stopBarAnimation();
    if (_barValue == end) return TickerFuture.complete();

    _barSimulation = InterpolationSimulation(
      begin: _barValue,
      end: end,
      totalDuration: _computeSimulationDuration(begin, end, _barValue, barAnimationDuration),
    );

    return _barTicker.start();
  }

  /// Starts running this thumb animation towards `1.0`, expanding the thumb.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture expandThumb() {
    const double begin = 0.0;
    const double end = 1.0;

    stopThumbAnimation();
    if (_thumbValue == end) return TickerFuture.complete();

    _thumbSimulation = InterpolationSimulation(
      begin: _thumbValue,
      end: end,
      totalDuration: _computeSimulationDuration(begin, end, _thumbValue, thumbAnimationDuration),
    );

    return _thumbTicker.start();
  }

  /// Starts running this thumb animation towards `0.0`, collapsing the thumb.
  ///
  /// Returns a [TickerFuture] that completes when the animation is complete.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  TickerFuture collapseThumb() {
    const double begin = 1.0;
    const double end = 0.0;

    stopThumbAnimation();
    if (_thumbValue == end) return TickerFuture.complete();

    _thumbSimulation = InterpolationSimulation(
      begin: _thumbValue,
      end: end,
      totalDuration: _computeSimulationDuration(begin, end, _thumbValue, thumbAnimationDuration),
    );

    return _thumbTicker.start();
  }

  /// Stops running this bar animation.
  ///
  /// This does not trigger any notifications. The animation stops in its
  /// current state.
  ///
  /// By default, the most recently returned [TickerFuture] is marked as having
  /// been canceled, meaning the future never completes and its
  /// [TickerFuture.orCancel] derivative future completes with a [TickerCanceled]
  /// error. By passing the `canceled` argument with the value false, this is
  /// reversed, and the futures complete successfully.
  void stopBarAnimation({bool canceled = true}) {
    _barTicker.stop(canceled: canceled);
    _barSimulation = null;
  }

  /// Stops running this thumb animation.
  ///
  /// This does not trigger any notifications. The animation stops in its
  /// current state.
  ///
  /// By default, the most recently returned [TickerFuture] is marked as having
  /// been canceled, meaning the future never completes and its
  /// [TickerFuture.orCancel] derivative future completes with a [TickerCanceled]
  /// error. By passing the `canceled` argument with the value false, this is
  /// reversed, and the futures complete successfully.
  void stopThumbAnimation({bool canceled = true}) {
    _thumbTicker.stop(canceled: canceled);
    _thumbSimulation = null;
  }

  /// Release the resources used by this object. The object is no longer usable
  /// after this method is called.
  ///
  /// The most recently returned [TickerFuture], if any, is marked as having been
  /// canceled, meaning the future never completes and its [TickerFuture.orCancel]
  /// derivative future completes with a [TickerCanceled] error.
  @override
  void dispose() {
    _barSimulation = null;
    _thumbSimulation = null;

    _thumbTicker.dispose();
    _barTicker.dispose();

    super.dispose();
  }

  Duration _computeSimulationDuration(double begin, double end, double value, Duration duration) {
    final double range = end - begin;
    final double remainingFraction = range.isFinite ? (end - value) / range : 1.0;
    return duration * remainingFraction.abs();
  }

  @override
  String toString() {
    return 'ProgressBarController -> '
        'barAnimationDuration: ${barAnimationDuration.inMilliseconds}ms '
        'thumbAnimationDuration: ${thumbAnimationDuration.inMilliseconds}ms '
        'waitingDuration: ${waitingDuration.inMilliseconds}ms';
  }
}
