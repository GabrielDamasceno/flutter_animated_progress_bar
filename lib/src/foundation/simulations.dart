import 'dart:ui' show clampDouble;
import 'package:flutter/physics.dart' show Simulation, Tolerance;

/// A base class that describe a simulation that have a finite duration.
/// We expose [totalDuration] in order to handle a well-known limit.

abstract class FiniteSimulation extends Simulation {
  /// The time at which the simulation should be finished.
  int get totalDuration;
}

/// A simulation that linearly interpolates between two values given a time.
class InterpolationSimulation extends FiniteSimulation {
  /// The initial value of [x].
  final double begin;

  /// The final value of [x].
  final double end;

  /// Creates an [InterpolationSimulation] that linearly interpolates from [begin] to [end] given a time.
  InterpolationSimulation({
    required this.begin,
    required this.end,
    required Duration totalDuration,
  }) : _totalDurationInMicroseconds = totalDuration.inMicroseconds;

  late final int _totalDurationInMicroseconds;

  @override
  double x(double time) {
    final double t = clampDouble(time / _totalDurationInMicroseconds, 0.0, 1.0);

    return begin + (end - begin) * t;
  }

  @override
  double dx(double time) {
    final double epsilon = tolerance.time;
    return (x(time + epsilon) - x(time - epsilon)) / (2 * epsilon);
  }

  @override
  bool isDone(double time) {
    return time > _totalDurationInMicroseconds;
  }

  @override
  String toString() {
    return 'begin: $begin | end: $end | totalDuration: ${_totalDurationInMicroseconds / Duration.microsecondsPerSecond}';
  }

  @override
  int get totalDuration => _totalDurationInMicroseconds;
}

/// A simulation that combines other simulations.
class CombinedSimulation extends Simulation {
  /// The [FiniteSimulation]s to be combined.
  /// The order defines the sequence of simulations given the sum of all [totalDuration]s.
  final List<FiniteSimulation> simulations;

  /// Creates an [CombinedSimulation] that combines a list of [FiniteSimulation]s.
  CombinedSimulation({required this.simulations})
      : assert(simulations.isNotEmpty) {
    currentIndex = 0;
    timeOffset = 0.0;
  }

  late double timeOffset;
  late int currentIndex;

  @override
  Tolerance get tolerance => simulations[currentIndex].tolerance;

  @override
  double x(double time) {
    return _simulation(time).x(time - timeOffset);
  }

  @override
  double dx(double time) {
    return _simulation(time).dx(time - timeOffset);
  }

  @override
  bool isDone(double time) {
    return _simulation(time).isDone(time - timeOffset);
  }

  Simulation _simulation(double time) {
    if (time > (timeOffset + simulations[currentIndex].totalDuration)) {
      final int nextIndex = currentIndex + 1;

      if ((nextIndex + 1) <= simulations.length) {
        timeOffset += simulations[currentIndex].totalDuration;
        currentIndex = nextIndex;
      }
    }

    return simulations[currentIndex];
  }
}
