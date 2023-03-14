import 'package:example/ui/playground_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => PlaygroundScreen.route(context),
              child: const Text('Playground'),
            ),
          ],
        ),
      ),
    );
  }
}
