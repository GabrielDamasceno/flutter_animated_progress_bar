import 'package:animated_progress_bar/animated_progress_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Duration barAnimationDuration = Duration(milliseconds: 200);
  const Duration thumbAnimationDuration = Duration(milliseconds: 100);
  const Duration waitingDuration = Duration(seconds: 2);
  final List<double> fractions = [0.0, 0.25, 0.50, 0.75, 1.0];

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestWidgetsFlutterBinding.instance
      ..resetEpoch()
      ..platformDispatcher.onBeginFrame = null
      ..platformDispatcher.onDrawFrame = null;
  });

  group('ProgressBarController.forward():', () {
    test('Should expand, wait and than collapse progress bar.', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.forward();

      /// Expanding bar
      for (final fraction in fractions) {
        final int microseconds = (barAnimationDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, moreOrLessEquals(fraction));
        expect(controller.thumbValue, 0.0);
      }

      /// Waiting
      for (final fraction in fractions) {
        final int microseconds = barAnimationDuration.inMicroseconds +
            (waitingDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, moreOrLessEquals(1.0));
        expect(controller.thumbValue, 0.0);
      }

      /// Collapsing bar
      for (final fraction in fractions) {
        final int microseconds = barAnimationDuration.inMicroseconds +
            waitingDuration.inMicroseconds +
            (barAnimationDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, moreOrLessEquals(1.0 - fraction));
        expect(controller.thumbValue, 0.0);
      }

      controller.dispose();
    });

    test(
      'If already animating, should start a new animation from relative value with remaining duration',
      () {
        final ProgressBarController controller = ProgressBarController(
          barAnimationDuration: barAnimationDuration,
          thumbAnimationDuration: thumbAnimationDuration,
          waitingDuration: waitingDuration,
          vsync: const TestVSync(),
        );

        controller.barValue = 1.0;
        tick(Duration.zero);

        controller.collapseBar();
        tick(Duration.zero);
        tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.75).round()));
        expect(controller.barValue, moreOrLessEquals(0.25));
        expect(controller.thumbValue, 0.0);

        controller.forward();
        tick(Duration.zero);
        tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.75).round()));
        expect(controller.barValue, moreOrLessEquals(1.0));
        expect(controller.thumbValue, 0.0);

        tick(Duration(microseconds: (barAnimationDuration.inMicroseconds).round()));
        expect(controller.barValue, moreOrLessEquals(1.0));
        expect(controller.thumbValue, 0.0);

        controller.dispose();
      },
    );

    test('Should throw an error if called with a disposed controller', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.dispose();
      tick(Duration.zero);

      expect(controller.forward, throwsAssertionError);
    });
  });

  group('ProgressBarController.expandBar():', () {
    test('Should increase barValue accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandBar();

      for (final fraction in fractions) {
        final int microseconds = (barAnimationDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, moreOrLessEquals(fraction));
        expect(controller.thumbValue, 0.0);
      }

      controller.dispose();
    });

    test(
        'If already animating, should start a new animation from relative value with remaining duration',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.barValue = 1.0;
      tick(Duration.zero);

      controller.collapseBar();
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.25).round()));

      controller.expandBar();
      tick(Duration.zero);
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.25).round()));
      expect(controller.barValue, moreOrLessEquals(1.0));
      expect(controller.thumbValue, 0.0);

      controller.dispose();
    });

    test('If value is not at target, should throw an error if called with a disposed controller',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.dispose();
      tick(Duration.zero);

      expect(controller.expandBar, throwsAssertionError);
    });

    test('Do not animate if already at target', () {
      int notifications = 0;
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      )..addListener(() {
          notifications += 1;
        });

      /// Setting this value here will trigger one notification
      controller.barValue = 1.0;
      tick(Duration.zero);

      controller.expandBar();

      expect(controller.barValue, equals(1.0));
      expect(notifications, equals(1));

      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.50).round()));
      expect(controller.barValue, equals(1.0));
      expect(notifications, equals(1));

      controller.dispose();
    });
  });

  group('ProgressBarController.collapseBar():', () {
    test('Should decrease barValue accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.barValue = 1.0;
      tick(Duration.zero);

      controller.collapseBar();

      for (final fraction in fractions) {
        final int microseconds = (barAnimationDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, moreOrLessEquals(1 - fraction));
        expect(controller.thumbValue, 0.0);
      }

      controller.dispose();
    });

    test(
        'If already animating, should start a new animation from relative value with remaining duration',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandBar();
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.75).round()));

      controller.collapseBar();
      tick(Duration.zero);
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.75).round()));
      expect(controller.barValue, moreOrLessEquals(0.0));
      expect(controller.thumbValue, 0.0);

      controller.dispose();
    });

    test('If value is not at target, should throw an error if called with a disposed controller',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );
      controller.barValue = 1.0;
      controller.dispose();
      tick(Duration.zero);

      expect(controller.collapseBar, throwsAssertionError);
    });

    test('Do not animate if already at target', () {
      int notifications = 0;
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      )..addListener(() {
          notifications += 1;
        });

      controller.collapseBar();

      expect(controller.barValue, equals(0.0));
      expect(notifications, equals(0));

      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.50).round()));
      expect(controller.barValue, equals(0.0));
      expect(notifications, equals(0));

      controller.dispose();
    });
  });

  group('ProgressBarController.expandThumb():', () {
    test('Should increase thumbValue accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandThumb();

      for (final fraction in fractions) {
        final int microseconds = (thumbAnimationDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, 0.0);
        expect(controller.thumbValue, moreOrLessEquals(fraction));
      }

      controller.dispose();
    });

    test(
        'If already animating, should start a new animation from relative value with remaining duration',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.thumbValue = 1.0;
      tick(Duration.zero);

      controller.collapseThumb();
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.55).round()));

      controller.expandThumb();
      tick(Duration.zero);
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.55).round()));
      expect(controller.barValue, 0.0);
      expect(controller.thumbValue, moreOrLessEquals(1.0));

      controller.dispose();
    });

    test('If value is not at target, should throw an error if called with a disposed controller',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.dispose();
      tick(Duration.zero);

      expect(controller.expandThumb, throwsAssertionError);
    });

    test('Do not animate if already at target', () {
      int notifications = 0;
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      )..addListener(() {
          notifications += 1;
        });

      /// Setting this value here will trigger one notification
      controller.thumbValue = 1.0;
      tick(Duration.zero);

      controller.expandThumb();

      expect(controller.thumbValue, equals(1.0));
      expect(notifications, equals(1));

      tick(Duration(microseconds: (thumbAnimationDuration.inMicroseconds * 0.50).round()));
      expect(controller.thumbValue, equals(1.0));
      expect(notifications, equals(1));

      controller.dispose();
    });
  });

  group('ProgressBarController.collapseThumb():', () {
    test('Should decrease thumbValue accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.thumbValue = 1.0;
      tick(Duration.zero);

      controller.collapseThumb();

      for (final fraction in fractions) {
        final int microseconds = (thumbAnimationDuration.inMicroseconds * fraction).round();
        tick(Duration(microseconds: microseconds));
        expect(controller.barValue, 0.0);
        expect(controller.thumbValue, moreOrLessEquals(1 - fraction));
      }

      controller.dispose();
    });

    test(
        'If already animating, should start a new animation from relative value with remaining duration',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandThumb();
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.45).round()));

      controller.collapseThumb();
      tick(Duration.zero);
      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.45).round()));
      expect(controller.barValue, 0.0);
      expect(controller.thumbValue, moreOrLessEquals(0.0));

      controller.dispose();
    });

    test('If value is not at target, should throw an error if called with a disposed controller',
        () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.thumbValue = 1.0;
      controller.dispose();
      tick(Duration.zero);

      expect(controller.collapseThumb, throwsAssertionError);
    });

    test('Do not animate if already at target', () {
      int notifications = 0;
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      )..addListener(() {
          notifications += 1;
        });

      controller.collapseThumb();

      expect(controller.thumbValue, equals(0.0));
      expect(notifications, equals(0));

      tick(Duration(microseconds: (thumbAnimationDuration.inMicroseconds * 0.50).round()));
      expect(controller.thumbValue, equals(0.0));
      expect(notifications, equals(0));

      controller.dispose();
    });
  });

  group('ProgressBarController.stopBarAnimation():', () {
    test('Should stop bar animation accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandBar();
      tick(Duration.zero);

      tick(Duration(microseconds: (barAnimationDuration.inMicroseconds * 0.80).round()));
      expect(controller.barValue, moreOrLessEquals(0.80));
      expect(controller.thumbValue, 0.0);

      controller.stopBarAnimation();
      tick(Duration.zero);

      expect(controller.barValue, moreOrLessEquals(0.80));
      expect(controller.thumbValue, 0.0);

      tick(const Duration(seconds: 1));
      expect(controller.barValue, moreOrLessEquals(0.80));
      expect(controller.thumbValue, 0.0);

      controller.dispose();
    });

    test('Does nothing if called with a disposed controller', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.dispose();
      tick(Duration.zero);

      expect(controller.stopBarAnimation, isA<void>());
    });
  });

  group('ProgressBarController.stopThumbAnimation():', () {
    test('Should stop thumb animation accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandThumb();
      tick(Duration.zero);

      tick(Duration(microseconds: (thumbAnimationDuration.inMicroseconds * 0.30).round()));
      expect(controller.barValue, 0.0);
      expect(controller.thumbValue, moreOrLessEquals(0.30));

      controller.stopThumbAnimation();
      tick(Duration.zero);

      expect(controller.barValue, 0.0);
      expect(controller.thumbValue, moreOrLessEquals(0.30));

      tick(const Duration(seconds: 1));
      expect(controller.barValue, 0.0);
      expect(controller.thumbValue, moreOrLessEquals(0.30));

      controller.dispose();
    });

    test('Does nothing if called with a disposed controller', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.dispose();
      tick(Duration.zero);

      expect(controller.stopThumbAnimation, isA<void>());
    });
  });

  group('Simultaneous animation:', () {
    test('[expandBar] and [expandThumb] should update its values accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.expandBar();
      controller.expandThumb();
      tick(Duration.zero);

      tick(const Duration(milliseconds: 50));
      expect(controller.barValue, moreOrLessEquals(0.25));
      expect(controller.thumbValue, moreOrLessEquals(0.5));

      tick(const Duration(milliseconds: 100));
      expect(controller.barValue, moreOrLessEquals(0.5));
      expect(controller.thumbValue, moreOrLessEquals(1.0));

      tick(const Duration(milliseconds: 200));
      expect(controller.barValue, moreOrLessEquals(1.0));
      expect(controller.thumbValue, moreOrLessEquals(1.0));

      tick(const Duration(milliseconds: 500));
      expect(controller.barValue, moreOrLessEquals(1.0));
      expect(controller.thumbValue, moreOrLessEquals(1.0));
    });

    test('[collapseBar] and [collapseThumb] should update its values accordingly', () {
      final ProgressBarController controller = ProgressBarController(
        barAnimationDuration: barAnimationDuration,
        thumbAnimationDuration: thumbAnimationDuration,
        waitingDuration: waitingDuration,
        vsync: const TestVSync(),
      );

      controller.barValue = 1.0;
      controller.thumbValue = 1.0;
      controller.collapseBar();
      controller.collapseThumb();
      tick(Duration.zero);

      tick(const Duration(milliseconds: 50));
      expect(controller.barValue, moreOrLessEquals(0.75));
      expect(controller.thumbValue, moreOrLessEquals(0.5));

      tick(const Duration(milliseconds: 100));
      expect(controller.barValue, moreOrLessEquals(0.50));
      expect(controller.thumbValue, moreOrLessEquals(0.0));

      tick(const Duration(milliseconds: 200));
      expect(controller.barValue, moreOrLessEquals(0.0));
      expect(controller.thumbValue, moreOrLessEquals(0.0));
    });
  });
}

/// Copied from https://github.com/flutter/flutter/blob/master/packages/flutter/test/scheduler/scheduler_tester.dart
void tick(Duration duration) {
  // We don't bother running microtasks between these two calls
  // because we don't use Futures in these tests and so don't care.
  SchedulerBinding.instance.handleBeginFrame(duration);
  SchedulerBinding.instance.handleDrawFrame();
}
