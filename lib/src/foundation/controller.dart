import 'package:animated_progress_bar/src/foundation/simulations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ProgressBarController extends ChangeNotifier {
  final Duration barAnimationDuration;
  final Duration thumbAnimationDuration;
  final Duration waitingDuration;

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

  late final Ticker _thumbTicker;
  late final Ticker _barTicker;

  Simulation? _barSimulation;
  Simulation? _thumbSimulation;

  late double _barValue;
  double get barValue => _barValue;
  set barValue(double newValue) {
    assert(newValue >= 0 && newValue <= 1);
    if (_barValue == newValue) return;

    stopBarAnimation();
    _barValue = newValue;
    notifyListeners();
  }

  late double _thumbValue;
  double get thumbValue => _thumbValue;
  set thumbValue(double newValue) {
    assert(newValue >= 0 && newValue <= 1);
    if (_thumbValue == newValue) return;

    stopThumbAnimation();
    _thumbValue = newValue;
    notifyListeners();
  }

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
      onDone: () => stopBarAnimation(),
    );
  }

  void _onThumbTick(Duration elapsed) {
    _onTick(
      elapsed: elapsed,
      simulation: _thumbSimulation,
      onValueUpdate: (value) => _thumbValue = value,
      onDone: () => stopThumbAnimation(),
    );
  }

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

  Duration _computeSimulationDuration(double begin, double end, double value, Duration duration) {
    final double range = end - begin;
    final double remainingFraction = range.isFinite ? (end - value) / range : 1.0;
    return duration * remainingFraction.abs();
  }

  void stopBarAnimation({bool canceled = false}) {
    _barTicker.stop(canceled: canceled);
    _barSimulation = null;
  }

  void stopThumbAnimation({bool canceled = false}) {
    _thumbTicker.stop(canceled: canceled);
    _thumbSimulation = null;
  }

  @override
  void dispose() {
    _barSimulation = null;
    _thumbSimulation = null;

    _thumbTicker.dispose();
    _barTicker.dispose();

    super.dispose();
  }

  @override
  String toString() {
    return 'ProgressBarController -> '
        'barAnimationDuration: ${barAnimationDuration.inMilliseconds}ms '
        'thumbAnimationDuration: ${thumbAnimationDuration.inMilliseconds}ms '
        'waitingDuration: ${waitingDuration.inMilliseconds}ms';
  }
}
