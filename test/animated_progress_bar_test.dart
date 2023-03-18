import 'package:animated_progress_bar/animated_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ProgressBar exists',
    (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(vsync: const TestVSync());

      await tester.pumpWidget(
        ProgressBar(
          controller: controller,
          progress: Duration.zero,
          total: const Duration(minutes: 1),
          onSeek: (value) {},
        ),
      );

      expect(find.byType(ProgressBar), findsOneWidget);
      controller.dispose();
    },
  );

  testWidgets(
    'Should be able to handle total when duration == Duration.zero',
    (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(vsync: const TestVSync());
      Duration progress = Duration.zero;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return ProgressBar(
              controller: controller,
              progress: progress,
              total: Duration.zero,
              onSeek: (value) {
                setState(() => progress = value);
              },
            );
          },
        ),
      );

      final Finder finder = find.byType(ProgressBar);
      final Offset center = tester.getCenter(finder);
      expect(finder, findsOneWidget);

      await tester.tapAt(center);
      await tester.pump();
      expect(progress.inSeconds, equals(0));

      controller.dispose();
    },
  );

  group('Gesture tests:', () {
    testWidgets('Tap gesture can change its progress', (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(vsync: const TestVSync());
      Duration progress = Duration.zero;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return ProgressBar(
              controller: controller,
              progress: progress,
              total: const Duration(minutes: 1),
              onSeek: (value) {
                setState(() => progress = value);
              },
            );
          },
        ),
      );

      final Finder finder = find.byType(ProgressBar);
      final Offset center = tester.getCenter(finder);

      await tester.tapAt(center);
      await tester.pump();
      expect(progress.inSeconds, equals(30));

      await tester.tapAt(center.translate(center.dx * 0.5, 0.0));
      await tester.pump();
      expect(progress.inSeconds, equals(45));

      controller.dispose();
    });

    testWidgets('Drag gesture can change its progress', (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(vsync: const TestVSync());
      Duration progress = Duration.zero;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return ProgressBar(
              controller: controller,
              progress: progress,
              total: const Duration(minutes: 1),
              onSeek: (value) {
                setState(() => progress = value);
              },
            );
          },
        ),
      );

      final Finder finder = find.byType(ProgressBar);
      final Offset center = tester.getCenter(finder);
      await tester.dragFrom(Offset.zero, center);
      await tester.pump();
      expect(progress.inSeconds, equals(30));

      await tester.dragFrom(center.translate(center.dx * 0.5, 0.0), -center);
      await tester.pump();
      expect(progress.inSeconds, equals(15));

      controller.dispose();
    });
  });

  group('Callbacks tests:', () {
    testWidgets('onSeek, onChangeStart and onChangeEnd fire once', (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(vsync: const TestVSync());
      int seekfired = 0;
      int startFired = 0;
      int endFired = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
              child: Center(
                child: GestureDetector(
                  onHorizontalDragUpdate: (_) {},
                  child: ProgressBar(
                    controller: controller,
                    progress: Duration.zero,
                    total: const Duration(minutes: 1),
                    onSeek: (value) {
                      seekfired += 1;
                    },
                    onChangeStart: (value) {
                      startFired += 1;
                    },
                    onChangeEnd: (value) {
                      endFired += 1;
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder finder = find.byType(ProgressBar);
      final Offset center = tester.getCenter(finder);

      await tester.timedDrag(finder, center, const Duration(milliseconds: 100));

      expect(seekfired, equals(1));
      expect(startFired, equals(1));
      expect(endFired, equals(1));

      controller.dispose();
    });
  });
}
