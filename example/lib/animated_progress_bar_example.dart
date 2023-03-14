import 'package:example/ui/home_screen.dart';
import 'package:flutter/material.dart';

class AnimatedProgressBarExample extends StatelessWidget {
  const AnimatedProgressBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
