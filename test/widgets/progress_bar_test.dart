import 'package:flutter_animated_progress_bar/flutter_animated_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_progress_bar/src/rendering/render_progress_bar.dart';
import 'package:flutter_animated_progress_bar/src/widgets/render_progress_bar_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ProgressBar exists',
    (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(
        vsync: const TestVSync(),
      );

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

  group(
    'Colors tests:',
    () {
      testWidgets(
        'Should be able to change [thumbGlowColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color color1 = Color(0x50FFFFFF);
          const Color color2 = Colors.white30;

          Color color = color1;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = color2);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      thumbGlowColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          expect(renderProgressBar.thumbGlowColor, color1);

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.thumbGlowColor, color2);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [backgroundBarColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color color1 = Colors.grey;
          const Color color2 = Colors.blueGrey;

          Color color = color1;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = color2);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      backgroundBarColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          expect(renderProgressBar.backgroundBarColor, color1);

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.backgroundBarColor, color2);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [collapsedProgressBarColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color color1 = Colors.red;
          const Color color2 = Colors.pink;

          Color color = color1;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = color2);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      collapsedProgressBarColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          expect(renderProgressBar.collapsedProgressBarColor, color1);

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.collapsedProgressBarColor, color2);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [collapsedBufferedBarColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color color1 = Color(0x36F44336);
          const Color color2 = Colors.green;

          Color color = color1;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = color2);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      collapsedBufferedBarColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          expect(renderProgressBar.collapsedBufferedBarColor, color1);

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.collapsedBufferedBarColor, color2);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [collapsedThumbColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color color1 = Colors.white;
          const Color color2 = Colors.amber;

          Color color = color1;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = color2);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      collapsedThumbColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          expect(renderProgressBar.collapsedThumbColor, color1);

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.collapsedThumbColor, color2);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [expandedProgressBarColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color collapsedProgressBarColor = Colors.redAccent;
          const Color newColor = Colors.pink;

          Color? color;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = newColor);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      collapsedProgressBarColor: collapsedProgressBarColor,
                      expandedProgressBarColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          /// If null, expect the default color
          expect(
            renderProgressBar.expandedProgressBarColor,
            collapsedProgressBarColor,
          );

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.expandedProgressBarColor, newColor);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [expandedBufferedBarColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color collapsedBufferedBarColor = Colors.greenAccent;
          const Color newColor = Colors.green;

          Color? color;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = newColor);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      collapsedBufferedBarColor: collapsedBufferedBarColor,
                      expandedBufferedBarColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          /// If null, expect the default color
          expect(
            renderProgressBar.expandedBufferedBarColor,
            collapsedBufferedBarColor,
          );

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.expandedBufferedBarColor, newColor);

          controller.dispose();
        },
      );

      testWidgets(
        'Should be able to change [expandedThumbColor] accordingly.',
        (WidgetTester tester) async {
          final ProgressBarController controller = ProgressBarController(
            vsync: const TestVSync(),
          );

          const Color collapsedThumbColor = Colors.amberAccent;
          const Color newColor = Colors.amber;

          Color? color;

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return Listener(
                    onPointerDown: (event) {
                      setState(() => color = newColor);
                    },
                    child: ProgressBar(
                      controller: controller,
                      progress: Duration.zero,
                      total: const Duration(minutes: 1),
                      collapsedThumbColor: collapsedThumbColor,
                      expandedThumbColor: color,
                      onSeek: (value) {},
                    ),
                  );
                },
              ),
            ),
          );

          final Finder finder = find.byType(RenderProgressBarWidget);
          final RenderProgressBar renderProgressBar =
              tester.renderObject<RenderProgressBar>(finder);

          /// If null, expect the default color
          expect(
            renderProgressBar.expandedThumbColor,
            collapsedThumbColor,
          );

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(renderProgressBar.expandedThumbColor, newColor);

          controller.dispose();
        },
      );
    },
  );

  testWidgets(
    'Should be able to handle total when duration == Duration.zero',
    (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(
        vsync: const TestVSync(),
      );
      Duration progress = Duration.zero;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
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
    testWidgets('Tap gesture can change its progress',
        (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(
        vsync: const TestVSync(),
      );
      Duration progress = Duration.zero;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
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

    testWidgets('Drag gesture can change its progress',
        (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(
        vsync: const TestVSync(),
      );
      Duration progress = Duration.zero;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
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
    testWidgets('onSeek, onChangeStart and onChangeEnd fire once',
        (WidgetTester tester) async {
      final ProgressBarController controller = ProgressBarController(
        vsync: const TestVSync(),
      );
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
